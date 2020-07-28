# frozen_string_literal: true

activate :asset_hash
activate :ogp do |ogp|
  ogp.namespaces = {
    fb: data.ogp.fb,
    # from data/ogp/fb.yml
    og: data.ogp.og
    # from data/ogp/og.yml
  }
  ogp.base_url = 'http://myshop.foo.tld'
end

activate :asset_host, host: 'https://my.assethosting.tld'
