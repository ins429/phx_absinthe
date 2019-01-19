defmodule PhxAbsintheWeb.Resolvers.Message do
  alias PhxAbsinthe.Channels.Channel
  alias PhxAbsinthe.Messages.Message
  alias PhxAbsinthe.Participants

  def for_channel(%Channel{messages: messages}, _, _) do
    {:ok, messages}
  end

  def get_participant(%Message{participant_id: participant_id}, _, _) do
    {:ok, Participants.get(participant_id)}
  end
end
