defmodule MimicServer.Repo do
  use Ecto.Repo,
    otp_app: :mimic_server,
    adapter: Ecto.Adapters.Postgres
end
