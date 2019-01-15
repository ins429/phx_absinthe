defmodule PhxAbsinthe.Resolvers.Message do
  alias PhxAbsinthe.Channels.Channel
  alias PhxAbsinthe.Messages.Message
  alias PhxAbsinthe.Participants

  def for_channel(%Channel{messages: messages}, b, c) do
    {:ok, messages}
  end

  def get_participant(%Message{participant_id: participant_id}, b, c) do
    {:ok, Participants.get(participant_id)}
  end
end
