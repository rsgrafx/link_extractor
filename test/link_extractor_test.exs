defmodule LinkExtractorTest do
  use ExUnit.Case

  alias LinkExtractor.Link

  # User sends an email 
  @message """
  Orion, 
  This is a message that came it.. http://blap today. LOL check this out http://github.com/rsgrafx/link_extractor Its your new website. but I 
  http://github.com/rsgrafx/link_extractor_web fournd https://foo  then I worked on http://github.com/rsgrafx/Spina awesome http://github.com/rsgrafx/negative-captcha 
  ok then but http://github.com/rsgrafx/ig-citysearch https://boom 
  """

  @expected_links [  %Link{ title: "rsgrafx/link_extractor · GitHub",
                            url: "http://github.com/rsgrafx/link_extractor" },
                    %Link{ title: "rsgrafx/link_extractor_web · GitHub", 
                            url: "http://github.com/rsgrafx/link_extractor_web"}, 
                    %Link{ title: "rsgrafx/Spina · GitHub",
                            url: "http://github.com/rsgrafx/Spina" },
                    %Link{ title: "rsgrafx/negative-captcha · GitHub",
                            url: "http://github.com/rsgrafx/negative-captcha" },
                    %Link{ title: "rsgrafx/ig-citysearch · GitHub",
                            url: "http://github.com/rsgrafx/ig-citysearch" }]

  @expected_link %Link{url: "http://www.orionengleton.com", title: "Learning to Dream in Color and Code. | Orion Engleton - Web Developer specializing in Ruby, AngularJS and" }

  test "When parsing the email body we expect to store url" do

    LinkExtractor.inject(@message)
    :timer.sleep(3000)
    assert Enum.sort(LinkExtractor.get_links, &(&1 > &2)) == Enum.sort(@expected_links, &(&1 > &2))

  end
end
