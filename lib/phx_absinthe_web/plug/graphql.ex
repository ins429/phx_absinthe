defmodule PhxAbsintheWeb.Plug.GraphQL do
  @behaviour Plug

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _) do
    conn
    |> put_private(:absinthe, %{
      context: %{
        viewer: Guardian.Plug.current_resource(conn),
        current_token: Guardian.Plug.current_token(conn)
      }
    })
  end
end
