defmodule WorkerTest do 
  use ExUnit.Case

  alias LinkExtractor.Link 

  @message """
  Orion, 
  This is a message that came it.. today. LOL check this out http://www.orionengleton.com Its your new website.
  """
  @expected_link %Link{url: "http://www.orionengleton.com", title: "Learning to Dream in Color and Code. | Orion Engleton - Web Developer specializing in Ruby, AngularJS and" }

  test "extract_links" do 
    assert LinkExtractor.Worker.extract_links(@message) == [@expected_link]
  end

  test "status 301" do 
    
  end

end