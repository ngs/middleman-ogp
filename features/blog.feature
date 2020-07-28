Feature: Middleman Blog support

  Scenario: Non article page
    Given the Server is running at "test-blog"
    When I go to "/"
    Then I should see '<meta content="website" property="og:type" />'
    Then I should see '<meta content="http://myblog.foo.tld/" property="og:url" />'
    Then I should see '<meta content="Fixture page" property="og:title" />'

  Scenario: article page
    Given the Server is running at "test-blog"
    When I go to "/2014/04/12/my-test.html"
    Then I should see '<meta content="article" property="og:type" />'
    Then I should see '<meta content="2014-04-12T04:00:00Z" property="article:published_time" />'
    Then I should see '<meta content="ruby" property="article:tag" />'
    Then I should see '<meta content="middleman" property="article:tag" />'
    Then I should see '<meta content="Test" property="article:author:first_name" />'
    Then I should see '<meta content="Author" property="article:author:last_name" />'
    Then I should see '<meta content="test_author" property="article:author:username" />'
    Then I should see '<meta content="female" property="article:author:gender" />'
    Then I should see '<meta content="Test Section" property="article:section" />'
    Then I should see '<meta content="2014-04-13T03:00:00Z" property="article:modified_time" />'
    Then I should see '<meta content="2018-04-12T04:00:00Z" property="article:expiration_time" />'
    Then I should see '<meta content="blog" property="article:tag" />'
    Then I should see '<meta content="http://myblog.foo.tld/2014/04/12/my-test.html" property="og:url" />'
    Then I should see '<meta content="http://myblog.foo.tld/images/logo/sample-d588934c.png" property="og:image" />'
    Then I should see '<meta content="Fixture page" property="og:title" />'

Scenario: multi author article page
    Given the Server is running at "test-blog"
    When I go to "2019/07/18/multi-author-test.html"
    Then I should see '<meta content="article" property="og:type" />'
    Then I should see '<meta content="Maria" property="article:author:first_name" />'
    Then I should see '<meta content="Eaton" property="article:author:last_name" />'
    Then I should see '<meta content="meaton" property="article:author:username" />'
    Then I should see '<meta content="female" property="article:author:gender" />'
    Then I should see '<meta content="Shawn" property="article:author:first_name" />'
    Then I should see '<meta content="justshawn" property="article:author:username" />'
    Then I should see '<meta content="male" property="article:author:gender" />'
    Then I should see '<meta content="http://myblog.foo.tld/2019/07/18/multi-author-test.html" property="og:url" />'
    Then I should see '<meta content="Multi author fixture page" property="og:title" />'
