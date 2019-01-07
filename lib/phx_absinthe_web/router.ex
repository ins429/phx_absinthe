defmodule PhxAbsintheWeb.Router do
  use PhxAbsintheWeb, :router

  pipeline :session_access do
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
    plug Guardian.Plug.EnsureAuthenticated, handler: PhxAbsintheWeb.AuthController
  end

  scope "/" do
    pipe_through [
      PhxAbsintheWeb.Plug.GraphQL
    ]

    forward "/graphql", Absinthe.Plug,
      schema: PhxAbsintheWeb.Schema,
      json_codec: Phoenix.json_library()

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: PhxAbsintheWeb.Schema,
      json_codec: Phoenix.json_library()
  end
end
