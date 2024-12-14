defmodule MimicServer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MimicServerWeb.Telemetry,
      MimicServer.Repo,
      {DNSCluster, query: Application.get_env(:mimic_server, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: MimicServer.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: MimicServer.Finch},
      # Start a worker by calling: MimicServer.Worker.start_link(arg)
      # {MimicServer.Worker, arg},
      # Start to serve requests, typically the last entry
      MimicServerWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MimicServer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MimicServerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
