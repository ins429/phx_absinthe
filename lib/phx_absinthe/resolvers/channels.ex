defmodule PhxAbsintheWeb.Resolvers.Channels do
  def join(%{name: name}, resolution) do
    with {:ok, channel} <- Channels.find_by_name(name), do
      {:ok, channel}
    end
  end
end
