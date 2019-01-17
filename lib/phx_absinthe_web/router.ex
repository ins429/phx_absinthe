defmodule PhxAbsintheWeb.Router do
  use PhxAbsintheWeb, :router

  pipeline :persist_session do
    plug Guardian.Plug.Pipeline,
      module: PhxAbsinthe.Guardian,
      error_handler: PhxAbsinthe.Guardian.ErrorHandler

    plug Guardian.Plug.VerifyHeader
    plug Guardian.Plug.LoadResource, allow_blank: true
    plug :upsert_session
  end

  scope "/" do
    pipe_through [
      :persist_session,
      PhxAbsintheWeb.Plug.GraphQL
    ]

    forward "/graphql", Absinthe.Plug,
      schema: PhxAbsintheWeb.Schema,
      json_codec: Phoenix.json_library()
  end

  scope "/" do
    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: PhxAbsintheWeb.Schema,
      json_codec: Phoenix.json_library()
  end

  def upsert_session(conn, _) do
    Guardian.Plug.current_resource(conn)
    |> case do
      nil ->
        {:ok, id} = PhxAbsinthe.Participants.create()
        {:ok, token, full_claims} = PhxAbsinthe.Guardian.encode_and_sign(id)

        key = Guardian.Plug.Pipeline.fetch_key(conn, [])

        conn
        |> Guardian.Plug.put_current_token(token, key: key)
        |> Guardian.Plug.put_current_claims(full_claims, key: key)
        |> Guardian.Plug.LoadResource.call([])

      _ ->
        conn
    end
  end
end
