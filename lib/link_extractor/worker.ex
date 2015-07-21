defmodule LinkExtractor.Worker do
  use GenServer

  alias LinkExtractor.LinkHandler, as: Handler
  alias LinkExtractor.Link
  alias LinkExtractor.Coordinator

  @url_regex ~r(https?://[^ $\n]*)

  def start_link(_options) do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  def init(_options) do 
    {:ok, []}
  end

  def handle_message( server, message ) do 
    GenServer.call( server, { :handle_message, message } )
  end

  def extract_links(message) do 
    Regex.scan(@url_regex, message) 
    |> Enum.map( &hd/1 )
    |> Enum.map(  &( check_valid(&1) ) )
    |> Enum.filter( fn(x) -> x != nil end)
  end

  defp check_valid(url) do 
    case HTTPoison.get(url) do 
      {:ok, _ }   -> %Link{url: url}
      {:error, _} -> nil
    end
  end

  def handle_call({:handle_message, message}, _from, state) do
    links = extract_links(message)
    coord_pid = spawn( Coordinator, :loop, [[], Enum.count( links )])

    links |> Enum.map( fn link -> 
      worker_pid = spawn(LinkExtractor, :handle_link, [link])
      send( worker_pid, { coord_pid, link } )
    end )

    # |> Enum.map(fn link ->
    #   spawn(LinkExtractor, :handle_link, [link])
    # end)

    {:reply, :ok, state}
  end

end