# frozen_string_literal: true

activate :blog do |blog|
end

activate :ogp do |ogp|
  ogp.namespaces = {
    fb: data.ogp.fb,
    og: data.ogp.og
  }
  ogp.blog = true
end

set :http_prefix, 'http://myblog.foo.tld/'
