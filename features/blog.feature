Feature: Middleman Blog support

  Scenario: Non article page
    Given the Server is running at "test-blog"
    When I go to "/"
    Then I should see '<meta content="website" property="og:type" />'

  Scenario: article page
    Given the Server is running at "test-blog"
    When I go to "/2014/04/12/my-test.html"
    Then I should see '<meta content="article" property="og:type" />'
    Then I should see '<meta content="2014-04-12T04:00:00Z" property="article:published_time" />'
    Then I should see '<meta content="ruby" property="article:tag" />'
    Then I should see '<meta content="middleman" property="article:tag" />'
    Then I should see '<meta content="blog" property="article:tag" />'


