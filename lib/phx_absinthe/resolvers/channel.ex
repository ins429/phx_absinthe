defmodule PhxAbsinthe.Resolvers.Channel do
  alias PhxAbsinthe.Channels
  alias PhxAbsinthe.Channels.Channel

  def join(%{channel_name: channel_name}, %{context: %{viewer: participant}}) do
    {:ok, Channels.join(channel_name, participant)}
  end

  def send_message(%{channel_name: channel_name, message: message}, %{participant: _participant}) do
    Channels.create_message(channel_name, message)
  end
end
