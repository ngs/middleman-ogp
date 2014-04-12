Feature: OpenGraph Protocol Tags with the "ogp_tags" helper method

  Scenario: Without page data
    Given the Server is running at "test-app"
    When I go to "/"
    Then I should see '<meta content="This is my fixture Middleman site for Facebook." property="fb:description" />'
    Then I should see '<meta content="http://mydomain.tld/path/to/fb-site-image.png" property="fb:image" />'
    Then I should see '<meta content="https://secure.mydomain.tld/path/to/fb-site-image.png" property="fb:image:secure_url" />'
    Then I should see '<meta content="image/png" property="fb:image:type" />'
    Then I should see '<meta content="400" property="fb:image:width" />'
    Then I should see '<meta content="300" property="fb:image:height" />'
    Then I should see '<meta content="This is my fixture Middleman site for OpenGraph." property="og:description" />'
    Then I should see '<meta content="http://mydomain.tld/path/to/og-site-image.png" property="og:image" />'
    Then I should see '<meta content="https://secure.mydomain.tld/path/to/og-site-image.png" property="og:image:secure_url" />'
    Then I should see '<meta content="image/png" property="og:image:type" />'
    Then I should see '<meta content="400" property="og:image:width" />'
    Then I should see '<meta content="300" property="og:image:height" />'
    Then I should see '<meta content="en_us" property="og:locale" />'
    Then I should see '<meta content="ja_jp" property="og:locale:alternate" />'
    Then I should see '<meta content="zh_tw" property="og:locale:alternate" />'
    Then I should see '<meta content="http://myshop.foo.tld/" property="og:url" />'
    Then I should see '<meta content="My Title" property="og:title" />'

  Scenario: With page data
    Given the Server is running at "test-app"
    When I go to "/page.html"
    Then I should see '<meta content="This is my fixture Middleman article for Facebook." property="fb:description" />'
    Then I should see '<meta content="http://mydomain.tld/path/to/fb-article-image.png" property="fb:image" />'
    Then I should see '<meta content="https://secure.mydomain.tld/path/to/fb-article-image.png" property="fb:image:secure_url" />'
    Then I should see '<meta content="image/png" property="fb:image:type" />'
    Then I should see '<meta content="400" property="fb:image:width" />'
    Then I should see '<meta content="300" property="fb:image:height" />'
    Then I should see '<meta content="This is my fixture Middleman article for OpenGraph." property="og:description" />'
    Then I should see '<meta content="http://mydomain.tld/path/to/og-article-image.png" property="og:image" />'
    Then I should see '<meta content="https://secure.mydomain.tld/path/to/og-article-image.png" property="og:image:secure_url" />'
    Then I should see '<meta content="image/png" property="og:image:type" />'
    Then I should see '<meta content="400" property="og:image:width" />'
    Then I should see '<meta content="300" property="og:image:height" />'
    Then I should see '<meta content="en_us" property="og:locale" />'
    Then I should see '<meta content="ja_jp" property="og:locale:alternate" />'
    Then I should see '<meta content="zh_tw" property="og:locale:alternate" />'
    Then I should see '<meta content="http://myshop.foo.tld/page.html" property="og:url" />'
    Then I should see '<meta content="Fixture page" property="og:title" />'
