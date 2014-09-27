Middleman-OGP
=============

`middleman-ogp` is an extension for the [Middleman] static site generator that adds OpenGraph Protocol support.


Configuration
-------------

### In your `config.rb`

```ruby
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
  ogp.base_url = 'http://mysite.tld/'
end
```

### Create data files

Create `data/ogp/fb.yml` and `data/ogp/og.yml` files.

Example:

```yaml
image:
  '': http://mydomain.tld/path/to/fbimage.png
  secure_url: https://secure.mydomain.tld/path/to/fbimage.png
  type: image/png
  width: 400
  height: 300
locale:
  '': en_us
```

### In your layout

source/layout.slim

```
html
  head
    meta charset="utf-8"
    title= data.page.title
    - ogp_tags do|name, value|
      meta property=name content=value

  body
    .container
      = yield
```

### In your page source

Page data overrides default options. (deep merge).


```markdown
---
ogp:
  og:
    description: 'This is my fixture Middleman site.'
    image:
      '': http://mydomain.tld/path/to/fbimage.png
      secure_url: https://secure.mydomain.tld/path/to/fbimage.png
      type: image/png
      width: 400
      height: 300
    locale:
      '': en_us
      alternate:
        - ja_jp
        - zh_tw
  fb:
    description: 'This is my fixture Middleman site.'
    image:
      '': http://mydomain.tld/path/to/fbimage.png
      secure_url: https://secure.mydomain.tld/path/to/fbimage.png
      type: image/png
      width: 400
      height: 300
---

Hello
=====

This is the __content__
```

Blog Support
------------

`middleman-ogp` supports adding [article] properties like `article:published_time`, `article:tag` automatically for [middleman-blog] articles.

Set `ogp.blog` to `true` in your configuration. (Defaults to `false`)

```ruby
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
  ogp.blog = true
end
```


Build & Dependency Status
-------------------------

[![Gem Version](https://badge.fury.io/rb/middleman-ogp.png)][gem]
[![Build Status](https://travis-ci.org/ngs/middleman-ogp.svg?branch=master)][travis]
[![Dependency Status](https://gemnasium.com/ngs/middleman-ogp.png?travis)][gemnasium]
[![Code Quality](https://codeclimate.com/github/ngs/middleman-ogp.png)][codeclimate]

License
-------

Copyright (c) 2014 [Atsushi Nagase]. MIT Licensed, see [LICENSE] for details.

[middleman]: http://middlemanapp.com
[middleman-blog]: https://github.com/middleman/middleman-blog
[gem]: https://rubygems.org/gems/middleman-ogp
[travis]: http://travis-ci.org/ngs/middleman-ogp
[gemnasium]: https://gemnasium.com/ngs/middleman-ogp
[codeclimate]: https://codeclimate.com/github/ngs/middleman-ogp
[LICENSE]: https://github.com/ngs/middleman-ogp/blob/master/LICENSE.md
[Atsushi Nagase]: http://ngs.io/
[article]: http://ogp.me/#type_article
