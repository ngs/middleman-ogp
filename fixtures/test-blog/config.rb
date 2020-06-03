# frozen_string_literal: true

activate :blog do |blog|
end

activate :ogp do |ogp|
  ogp.namespaces = {
    fb: data.ogp.fb,
    og: data.ogp.og
  }
  ogp.blog = true
  ogp.base_url = 'http://myblog.foo.tld/'
end

activate :asset_host, :host => 'https://my.assethosting.tld'
