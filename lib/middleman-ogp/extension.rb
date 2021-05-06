# frozen_string_literal: true

require 'padrino-helpers'
require 'active_support'
require 'middleman-core/extensions'

module Middleman
  module OGP
    # Middleman::OGP::OGPExtension
    class OGPExtension < Extension
      option :namespaces,     {}, 'Default namespaces'
      option :blog,           false, 'Middleman Blog support'
      option :auto,           %w[title url description], 'Properties to automatically fill from page data.'
      option :base_url,       nil, 'Base URL to generate permalink for og:url'
      option :image_base_url, nil, 'Base URL to generate og:image'

      def after_configuration
        Middleman::OGP::Helper.namespaces = options[:namespaces] || {}
        Middleman::OGP::Helper.blog = options[:blog]
        Middleman::OGP::Helper.auto = options[:auto]
        Middleman::OGP::Helper.base_url = options[:base_url]
        Middleman::OGP::Helper.image_base_url = options[:image_base_url]
      end

      #
      helpers do # rubocop:disable Metrics/BlockLength
        def ogp_tags(&block) # rubocop:disable all
          opts = current_resource.data['ogp'] || {}
          is_blog_article = Middleman::OGP::Helper.blog && respond_to?(:is_blog_article?) && is_blog_article?
          if is_blog_article
            opts.deep_merge4!({
                                og: {
                                  type: 'article'
                                },
                                article: {
                                  published_time: current_article.date.to_time.utc.iso8601,
                                  tag: current_article.tags
                                }
                              })
            opts[:article][:section] = current_article.data.section if current_article.data.section
            if current_article.data.expiration_time
              expiration_time = if current_article.data.expiration_time.is_a? Time
                                  current_article.data.expiration_time
                                else
                                  Time.parse(current_article.data.expiration_time.to_s)
                                end
              opts[:article][:expiration_time] = expiration_time.utc.iso8601
            end
            if current_article.data.modified_time
              modified_time = if current_article.data.modified_time.is_a? Time
                                current_article.data.modified_time
                              else
                                Time.parse(current_article.data.modified_time.to_s)
                              end
              opts[:article][:modified_time] = modified_time.utc.iso8601
            end

            if current_article.data.author || current_article.data.authors
              authors = current_article.data.authors || [current_article.data.author]
              opts[:article][:author] = []
              authors.each do |author|
                next unless author.is_a?(Hash)

                opts[:article][:author] << author.to_h.symbolize_keys.slice(
                  :first_name,
                  :last_name,
                  :username,
                  :gender
                )
              end
            end
          end
          opts[:og] ||= {}
          if Middleman::OGP::Helper.auto.include?('title')
            if current_resource.data['title']
              opts[:og][:title] = current_resource.data['title']
            elsif content_for?(:title)
              opts[:og][:title] = yield_content(:title)
            end
          end
          if Middleman::OGP::Helper.auto.include?('description')
            if current_resource.data['description']
              opts[:og][:description] = current_resource.data['description']
            elsif content_for?(:description)
              opts[:og][:description] = yield_content(:description)
            end
          end
          if Middleman::OGP::Helper.auto.include?('locale') && I18n.locale
            opts[:og][:locale] = I18n.locale
          end
          if Middleman::OGP::Helper.auto.include?('url') &&
             Middleman::OGP::Helper.base_url
            opts[:og][:url] = URI.join(Middleman::OGP::Helper.base_url, current_resource.url)
          end

          Middleman::OGP::Helper.ogp_tags(opts) do |name, value|
            if block_given?
              block.call name, value
            else
              concat_content tag(:meta, name: name, property: value)
            end
          end
        end
      end
    end

    # Middleman::OGP::Helper
    module Helper
      include ::Padrino::Helpers::TagHelpers
      mattr_accessor :namespaces
      mattr_accessor :blog
      mattr_accessor :auto
      mattr_accessor :base_url
      mattr_accessor :image_base_url

      def self.ogp_tags(opts = {}, &block) # rubocop:disable Metrics/MethodLength
        opts ||= {}
        options = (namespaces.respond_to?(:to_h) ? namespaces.to_h : namespaces || {}).dup
        opts.stringify_keys!
        options.stringify_keys!
        options = options.deep_merge4(opts) do |_k, old_value, new_value|
          if old_value.is_a?(Hash)
            if new_value.is_a? Hash
              old_value.deep_merge4 new_value
            else
              old_value[''] = new_value
              old_value
            end
          else
            new_value
          end
        end.symbolize_keys
        options.map  do |k, v|
          og_tag([], v, k, &block)
        end.join("\n")
      end

      def self.og_tag(key, obj = nil, prefix = 'og', &block) # rubocop:disable Metrics/MethodLength
        case key
        when String, Symbol
          key = [key]
        when Hash
          prefix = obj if obj
          obj = key
          key = []
        end
        case obj
        when Hash
          obj.map do |k, v|
            og_tag(k.to_s.empty? ? key.dup : (key.dup << k.to_s), v, prefix, &block)
          end.join("\n")
        when Array
          obj.map do |v|
            og_tag(key, v, prefix, &block)
          end.join("\n")
        else
          if obj.respond_to?(:value)
            value = obj.value
            raise 'Unknown value' unless value.is_a?(Hash)

            value.map do |k, v|
              og_tag(k.to_s.empty? ? key.dup : (key.dup << k.to_s), v, prefix, &block)
            end.join("\n")
          else
            name = [prefix].concat(key).join(':')
            value = obj.to_s
            if Middleman::OGP::Helper.image_base_url && name == 'og:image' && !%r{^https?://}.match(value)
              value = URI.join(Middleman::OGP::Helper.image_base_url, value)
            end
            block.call name, value
          end
        end
      end
    end
  end
end

# Hash extension
class Hash
  def deep_merge4(other_hash, &block)
    dup.deep_merge4!(other_hash, &block)
  end

  def deep_merge4!(other_hash, &block)
    other_hash.each_pair do |k, v|
      tv = self[k]
      self[k] = if tv.is_a?(Hash) && v.is_a?(Hash)
                  tv.deep_merge4(v, &block)
                else
                  block && tv ? block.call(k, tv, v) : v
                end
    end
    self
  end
end
