defmodule LinkExtractor do
  use Application

  def inject( message ) do
    :poolboy.transaction(:link_extractor_pool, fn( worker ) ->
        LinkExtractor.Worker.handle_message( worker, message )
    end)
  end

  def get_links do
    Agent.get(:collector, &(&1))
  end

  def handle_link(link) do
    :poolboy.transaction(:link_extractor_link_handler_pool, fn(worker) ->
      LinkExtractor.LinkHandler.handle_link(worker, link)
    end)
  end

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    link_handler_pool_options = [
      name: {:local, :link_extractor_link_handler_pool},
      worker_module: LinkExtractor.LinkHandler,
      size: 5,
      max_overflow: 10
    ]

    pool_options = [
      name: {:local, :link_extractor_pool}, 
      worker_module: LinkExtractor.Worker,
      size: 5, 
      max_overflow: 10
    ]

    children = [
      :poolboy.child_spec(:link_extractor_pool, pool_options, []),
      :poolboy.child_spec(:link_extractor_link_handler_pool, link_handler_pool_options, []),
      worker(Agent, [fn -> [] end, [name: :collector]])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LinkExtractor.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
