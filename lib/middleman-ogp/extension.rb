require 'padrino-helpers'
require 'active_support'
require 'middleman-core/extensions'

module Middleman
  module OGP
    class OGPExtension < Extension
      option :namespaces,     {}, 'Default namespaces'
      option :blog,           false, 'Middleman Blog support'
      option :auto,           %w{title url description}, 'Properties to automatically fill from page data.'
      option :base_url,       nil, 'Base URL to generate permalink for og:url'
      option :image_base_url, nil, 'Base URL to generate og:image'

      def after_configuration
        Middleman::OGP::Helper.namespaces = options[:namespaces] || {}
        Middleman::OGP::Helper.blog = options[:blog]
        Middleman::OGP::Helper.auto = options[:auto]
        Middleman::OGP::Helper.base_url = options[:base_url]
        Middleman::OGP::Helper.image_base_url = options[:image_base_url]
      end

      helpers do
        def ogp_tags(&block)
          opts = current_resource.data['ogp'] || {}
          is_blog_article = Middleman::OGP::Helper.blog && respond_to?(:is_blog_article?) && is_blog_article?
          if is_blog_article
            opts.deep_merge4!({
              og: {
                type: 'article',
              },
              article: {
                published_time: current_article.date.to_time.utc.iso8601,
                tag: current_article.tags,
              }
            })
            if current_article.data.section
              opts[:article][:section] = current_article.data.section
            end
            if current_article.data.expiration_time
              opts[:article][:expiration_time] = Time.parse(current_article.data.expiration_time).utc.iso8601
            end
            if current_article.data.modified_time
              opts[:article][:modified_time] = Time.parse(current_article.data.modified_time).utc.iso8601
            end
            if current_article.data.author
              if current_article.data.author.kind_of?(Hash)
                opts[:article][:author] = {}
                [:first_name, :last_name, :username, :gender].each do | field |
                  if current_article.data.author[field]
                    opts[:article][:author][field] = current_article.data.author[field]
                  end
                end
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
          if Middleman::OGP::Helper.auto.include?('url') &&
            Middleman::OGP::Helper.base_url
            opts[:og][:url] = URI.join(Middleman::OGP::Helper.base_url, URI.encode(current_resource.url))
          end

          Middleman::OGP::Helper.ogp_tags(opts) do|name, value|
            if block_given?
              block.call name, value
            else
              concat_content tag(:meta, name: name, property: value)
            end
          end
        end
      end
    end

    module Helper
      include ::Padrino::Helpers::TagHelpers
      mattr_accessor :namespaces
      mattr_accessor :blog
      mattr_accessor :auto
      mattr_accessor :base_url
      mattr_accessor :image_base_url

      def self.ogp_tags(opts = {}, &block)
        opts ||= {}
        options = (namespaces.respond_to?(:to_h) ? namespaces.to_h : namespaces || {}).dup
        opts.stringify_keys!
        options.stringify_keys!
        options = options.deep_merge4(opts) {|k, old_value, new_value|
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
        }.symbolize_keys
        options.map{|k, v|
          og_tag([], v, k, &block)
        }.join("\n")
      end

      def self.og_tag(key, obj = nil, prefix = 'og', &block)
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
          obj.map{|k, v|
            og_tag(k.to_s.empty? ? key.dup : (key.dup << k.to_s) , v, prefix, &block)
          }.join("\n")
        when Array
          obj.map{|v|
            og_tag(key, v, prefix, &block)
          }.join("\n")
        else
          if obj.respond_to?(:value)
            value = obj.value
            if value.is_a?(Middleman::Util::EnhancedHash)
              value.map{|k,v|
                og_tag(k.to_s.empty? ? key.dup : (key.dup << k.to_s) , v, prefix, &block)
              }.join("\n")
            else
              raise 'Unknown value'
            end
          else
            name = [prefix].concat(key).join(':')
            value = obj.to_s
            if Middleman::OGP::Helper.image_base_url && name == 'og:image' && !%r{^https?://}.match(value)
              value = URI.join(Middleman::OGP::Helper.image_base_url, URI.encode(value))
            end
            block.call name, value
          end
        end
      end
    end
  end
end

class Hash

  def deep_merge4(other_hash, &block)
    dup.deep_merge4!(other_hash, &block)
  end

  def deep_merge4!(other_hash, &block)
    other_hash.each_pair do |k,v|
      tv = self[k]
      if tv.is_a?(Hash) && v.is_a?(Hash)
        self[k] = tv.deep_merge4(v, &block)
      else
        self[k] = block && tv ? block.call(k, tv, v) : v
      end
    end
    self
  end

end
