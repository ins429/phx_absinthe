defmodule PhxAbsintheWeb.Resolvers.Avatar do
  alias PhxAbsinthe.Avatars
  alias PhxAbsinthe.Participants.Participant

  def get(%Participant{avatar_id: nil}, _, _), do: {:ok, nil}

  def get(%Participant{avatar: nil, avatar_id: avatar_id}, _, resolution) do
    {:ok, Avatars.get_by_id(avatar_id)}
  end

  def get(%Participant{avatar: avatar}, _, _), do: {:ok, avatar}
end
