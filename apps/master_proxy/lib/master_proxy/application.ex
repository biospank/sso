defmodule MasterProxy.Application do
  @moduledoc false
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    port = (System.get_env("PORT") || "3333") |> String.to_integer
    cowboy = Plug.Adapters.Cowboy.child_spec(:http, MasterProxy.Plug, [], [port: port])
    # Define workers and child supervisors to be supervised
    children = [
      # Starts a worker by calling: MasterProxy.Worker.start_link(arg1, arg2, arg3)
      # worker(MasterProxy.Worker, [arg1, arg2, arg3]),
      cowboy
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MasterProxy.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
