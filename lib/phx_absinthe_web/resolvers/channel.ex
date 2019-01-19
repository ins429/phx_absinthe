defmodule PhxAbsintheWeb.Resolvers.Channel do
  alias PhxAbsinthe.Channels
  alias PhxAbsinthe.Channels.Channel

  def join(%{channel_name: channel_name}, %{context: %{viewer: participant}}) do
    {:ok, Channels.join(channel_name, participant)}
  end

  def get(%{channel_name: channel_name}, %{context: %{viewer: participant}}) do
    {:ok, Channels.get(channel_name)}
  end

  def send_message(%{channel_name: channel_name, message: message}, %{
        context: %{viewer: participant}
      }) do
    {:ok,
     Channels.create_message(channel_name, %{
       message: message,
       participant_id: participant.id
     })}
  end
end
