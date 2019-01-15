defmodule PhxAbsinthe.Resolvers.Participant do
  alias PhxAbsinthe.Channels.Channel
  alias PhxAbsinthe.Participants

  def get(_, %{context: %{viewer: viewer}}) do
    {:ok, viewer}
  end

  def set_name(%{name: name}, %{context: %{viewer: viewer}}) do
    Participants.update_name(viewer.id, name)

    {:ok, %{viewer | name: name}}
  end

  def touch(_, %{context: %{viewer: viewer}}) do
    {:ok, Participants.touch(viewer.id)}
  end

  def for_channel(%Channel{participants: participants}, b, c) do
    {:ok, participants}
  end
end
