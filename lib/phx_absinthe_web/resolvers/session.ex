defmodule PhxAbsintheWeb.Resolvers.Session do
  def get_session(args, %{context: context} = _resolution) do
    {:ok, context.current_token}
  end
end
