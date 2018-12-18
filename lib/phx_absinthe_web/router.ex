defmodule PhxAbsintheWeb.Router do
  use PhxAbsintheWeb, :router

  forward "/graphql", Absinthe.Plug,
    schema: PhxAbsintheWeb.Schema,
    json_codec: Phoenix.json_library()

  forward "/graphiql", Absinthe.Plug.GraphiQL,
    schema: PhxAbsintheWeb.Schema,
    json_codec: Phoenix.json_library()
end
