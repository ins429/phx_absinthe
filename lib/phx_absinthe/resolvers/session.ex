defmodule PhxAbsinthe.Resolvers.Session do
  def get_session(args, %{context: context} = _resolution) do
    {:ok, context.viewer.id}
  end
end
