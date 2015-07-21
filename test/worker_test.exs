defmodule WorkerTest do 
  use ExUnit.Case

  alias LinkExtractor.Link 

  @message """
  Orion, 
  This is a message that came it.. http://blap today. LOL check this out http://github.com/rsgrafx/link_extractor Its your new website.
  """
  @expected_link %Link{ url: "http://github.com/rsgrafx/link_extractor" }

  test "extract_links" do 
    assert LinkExtractor.Worker.extract_links(@message) == [@expected_link]
  end

end