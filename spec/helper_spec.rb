require 'spec_helper'

describe "Middleman::OGP::Helper" do
  subject {
    Middleman::OGP::Helper.namespaces = namespaces
    Middleman::OGP::Helper.ogp_tags(options) do|name, value|
      %Q{<meta property="#{name}" content="#{value}" />}
    end
  }
  describe "default namespace and options are nil" do
    let(:namespaces) { nil }
    let(:options)    { nil }
    it { subject.should eq '' }
  end
  context "with default namespaces" do
    let(:namespaces) {
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
    }
    describe "options is nil" do
      let(:options)    { nil }
      it {
        subject.should eq <<-EOF.unindent
          <meta property="og:image" content="http://mydomain.tld/mysite.png" />
          <meta property="og:image:type" content="image/png" />
          <meta property="og:image:width" content="300" />
          <meta property="og:image:height" content="400" />
          <meta property="fb:description" content="foo" />
        EOF
      }
    end
    describe "options is presented" do
      let(:options)    {
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
      }
      it {
        subject.should eq <<-EOF.unindent
          <meta property="og:image" content="http://mydomain.tld/myarticle.png" />
          <meta property="og:image:type" content="image/png" />
          <meta property="og:image:width" content="300" />
          <meta property="og:image:height" content="400" />
          <meta property="fb:description" content="bar" />
          <meta property="music:id" content="123" />
        EOF
      }
    end
  end
end
