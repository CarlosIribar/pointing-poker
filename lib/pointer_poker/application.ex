defmodule PointerPoker.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      PointerPokerWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: PointerPoker.PubSub},
      # Start Finch
      {Finch, name: PointerPoker.Finch},
      # Start the Endpoint (http/https)
      PointerPokerWeb.Endpoint,
      PointerPokerWeb.Presence
      # Start a worker by calling: PointerPoker.Worker.start_link(arg)
      # {PointerPoker.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PointerPoker.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PointerPokerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
