defmodule LinkExtractor.LinkHandler do

  use GenServer
  alias GenServer, as: GS
  alias LinkExtractor.Link

  def start_link(_options) do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  def handle_link(server, link) do
    GenServer.call(server, {:handle_link, link})
  end

  # --
  def init(_options) do
    {:ok, []}
  end

  def handle_call({:handle_link, link}, _from, state) do 
      process_url( link, state )
  end

  defp process_url( link, state ) do
      link_with_title = add_title( link )
      Agent.update(:collector, &([ link_with_title | &1 ]) )
      {:reply, :ok, state}
  end

  def add_title(link=%Link{url: url}) do
      title_pattern = ~r"<title>([^<]*)</title>"
      body = get_body( url )
      title = Regex.run(title_pattern, body) 
              |> Enum.at(1)
      %Link{ link | title: title  }
  end

  def get_body(url) do 
    response = HTTPoison.get(url)
    {:ok, %HTTPoison.Response{body: body}} = follow_redirects(response)
    body
  end

  # defp follow_redirects({:error, %HTTPoison.Error{id: nil, reason: :nxdomain}}) do
  #   # Agent.get(:collector, (fn -> &List.first(&1) end))
  #   nil
  # end

  defp follow_redirects(response={:ok, %HTTPoison.Response{status_code: 200}}) do 
    response
  end

  defp follow_redirects({:ok, %HTTPoison.Response{status_code: 301, headers: header_list }}) do
    {"Location", location}= List.keyfind(header_list, "Location", 0)
    response = HTTPoison.get(location)
    follow_redirects(response)
  end
  # 
end