defmodule WorkerTest do 
  use ExUnit.Case

  alias LinkExtractor.Link 

  @message """
  Orion, 
  This is a message that came it.. http://blap today. LOL check this out http://github.com/rsgrafx/link_extractor Its your new website. but I 
  http://github.com/rsgrafx/link_extractor_web fournd https://foo  then I worked on http://github.com/rsgrafx/Spina awesome http://github.com/rsgrafx/negative-captcha 
  ok then but http://github.com/rsgrafx/ig-citysearch https://boom 
  """
  @expected_link [%Link{ url: "http://github.com/rsgrafx/link_extractor" },
                  %Link{ url: "http://github.com/rsgrafx/link_extractor_web"}, 
                  %Link{ url: "http://github.com/rsgrafx/Spina" },
                  %Link{ url: "http://github.com/rsgrafx/negative-captcha" },
                  %Link{ url: "http://github.com/rsgrafx/ig-citysearch" }]

  test "extract_links" do 
    assert LinkExtractor.Worker.extract_links(@message) == @expected_link
  end

end