# frozen_string_literal: true

activate :asset_hash

activate :ogp do |ogp|
  #
  # register namespace with default options
  #
  ogp.namespaces = {
    fb: data.ogp.fb,
    # from data/ogp/fb.yml
    og: data.ogp.og
    # from data/ogp/og.yml
  }
end

set :http_prefix, 'http://myshop.foo.tld/'
