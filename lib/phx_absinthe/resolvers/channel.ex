defmodule PhxAbsintheWeb.Resolvers.Channel do
  alias PhxAbsinthe.Channels.Channel

  def join(%{name: name}, resolution) do
    with {:ok, channel} <- Channels.join(name), do: {:ok, channel}
  end

  def send_message(%{channel_name: channel_name, message: message}, resolution) do
    with %Channel{} = channel <- Channels.find(channel_name),
         {:ok, message} <- GenServer.cast(Channels, {:create_message, message})
  end
end
