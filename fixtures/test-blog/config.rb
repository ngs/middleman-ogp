# frozen_string_literal: true

activate :blog do |blog|
end

activate :ogp do |ogp|
  ogp.namespaces = {
    fb: data.ogp.fb,
    og: data.ogp.og
  }
  ogp.base_url = 'http://myblog.foo.tld/'
  ogp.blog = true
end
