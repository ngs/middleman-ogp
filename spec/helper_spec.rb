# frozen_string_literal: true

require 'spec_helper'

describe 'Middleman::OGP::Helper' do # rubocop:disable Metrics/BlockLength
  let(:app) { Middleman::Application.new }
  subject do
    Middleman::OGP::Helper.app = app
    Middleman::OGP::Helper.namespaces = namespaces
    Middleman::OGP::Helper.ogp_tags(options) do |name, value|
      %(<meta property="#{name}" content="#{value}" />)
    end
  end
  describe 'default namespace and options are nil' do
    let(:namespaces) { nil }
    let(:options)    { nil }
    it { subject.should eq '' }
  end
  context 'with default namespaces' do # rubocop:disable Metrics/BlockLength
    let(:namespaces) do
      {
        og: {
          image: {
            '' => 'http://mydomain.tld/mysite.png',
            type: 'image/png',
            'width' => 300,
            'height' => 400
          }
        },
        fb: {
          description: 'foo'
        }
      }
    end
    describe 'options is nil' do
      let(:options) { nil }
      it {
        subject.should eq <<-HTML.unindent
          <meta property="og:image" content="http://mydomain.tld/mysite.png" />
          <meta property="og:image:type" content="image/png" />
          <meta property="og:image:width" content="300" />
          <meta property="og:image:height" content="400" />
          <meta property="fb:description" content="foo" />
        HTML
      }
    end
    describe 'options are presented' do
      let(:options) do
        {
          og: {
            image: 'http://mydomain.tld/myarticle.png'
          },
          fb: {
            description: 'bar'
          },
          music: {
            id: '123'
          }
        }
      end
      it {
        subject.should eq <<-HTML.unindent
          <meta property="og:image" content="http://mydomain.tld/myarticle.png" />
          <meta property="og:image:type" content="image/png" />
          <meta property="og:image:width" content="300" />
          <meta property="og:image:height" content="400" />
          <meta property="fb:description" content="bar" />
          <meta property="music:id" content="123" />
        HTML
      }
    end
    describe 'only additional option is presented' do
      let(:options) do
        {
          og: {
            type: 'article'
          }
        }
      end
      it {
        subject.should eq <<-HTML.unindent
          <meta property="og:image" content="http://mydomain.tld/mysite.png" />
          <meta property="og:image:type" content="image/png" />
          <meta property="og:image:width" content="300" />
          <meta property="og:image:height" content="400" />
          <meta property="og:type" content="article" />
          <meta property="fb:description" content="foo" />
        HTML
      }
    end
  end
end
