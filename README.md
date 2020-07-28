# Middleman-OGP

`middleman-ogp` is an extension for the [Middleman] static site generator that adds OpenGraph Protocol support.

## Configuration

### In your `config.rb`

```ruby
activate :ogp do |ogp|
  #
  # register namespace with default options
  #
  ogp.namespaces = {
    fb: data.ogp.fb,
    og:
      # from data/ogp/fb.yml
      data
        .ogp
        .og
  }
  # from data/ogp/og.yml

  ogp.base_url = 'http://mysite.tld'
end
```

### In your project's root directory

Create `data/ogp/fb.yml` and `data/ogp/og.yml` files.

Example:

```yaml
image:
  "": path/to/fbimage.png
  type: image/png
  width: 400
  height: 300
locale:
  "": en_us
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
    description: "This is my fixture Middleman site."
    image:
      "": path/to/fbimage.png
      type: image/png
      width: 400
      height: 300
    locale:
      "": en_us
      alternate:
        - ja_jp
        - zh_tw
  fb:
    description: "This is my fixture Middleman site."
    image:
      "": path/to/fbimage.png
      type: image/png
      width: 400
      height: 300
---

# Hello

This is the **content**
```

## Blog Support

`middleman-ogp` supports adding [article] properties like `article:published_time`, `article:tag` automatically for [middleman-blog] articles.

Set `ogp.blog` to `true` in your configuration. (Defaults to `false`)

```ruby
activate :ogp do |ogp|
  #
  # register namespace with default options
  #
  ogp.namespaces = {
    fb: data.ogp.fb,
    og:
      # from data/ogp/fb.yml
      data
        .ogp
        .og
  }
  # from data/ogp/og.yml

  ogp.blog = true
  ogp.base_url = 'http://mysite.tld'
end
```

## Build & Dependency Status

[![Gem Version](https://badge.fury.io/rb/middleman-ogp.png)][gem]
[![Run tests](https://github.com/ngs/middleman-ogp/workflows/Run%20tests/badge.svg)][ghaction]

## License

Copyright (c) 2014-2020 [Atsushi Nagase]. MIT Licensed, see [LICENSE] for details.

[middleman]: http://middlemanapp.com
[middleman-blog]: https://github.com/middleman/middleman-blog
[gem]: https://rubygems.org/gems/middleman-ogp
[ghaction]: https://github.com/ngs/middleman-ogp/actions?query=workflow%3A%22Run+tests%22
[license]: https://github.com/ngs/middleman-ogp/blob/master/LICENSE.md
[atsushi nagase]: http://ngs.io/
[article]: http://ogp.me/#type_article
