defmodule PhxAbsintheWeb.Resolvers.Participant do
  alias PhxAbsinthe.Channels.Channel
  alias PhxAbsinthe.Participants

  def get(_, %{context: %{viewer: viewer}}) do
    {:ok, viewer}
  end

  def set_name(%{name: name}, %{context: %{viewer: viewer}}) do
    Participants.update_name(viewer.id, name)

    {:ok, %{viewer | name: name}}
  end

  def set_avatar(%{avatar: avatar}, %{context: %{viewer: viewer}}) do
    Participants.update_avatar(viewer.id, avatar)

    {:ok, %{viewer | avatar: avatar}}
  end

  def touch(_, %{context: %{viewer: viewer}}) do
    {:ok, Participants.touch(viewer.id)}
  end

  def for_channel(%Channel{participant_ids: participant_ids}, b, c) do
    {:ok, Participants.find_by_ids(participant_ids)}
  end
end
