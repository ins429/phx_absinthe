defmodule PhxAbsinthe.GuardianSerializer do
  @behaviour Guardian.Serializer

  def for_token(participant = %Participant{}), do: {:ok, "Participant:#{participant.id}"}
  def for_token(_), do: {:error, "Unknown resource type"}

  def from_token("Participant:" <> id), do: {:ok, Participant.find(id)}
  def from_token(_), do: {:error, "Unknown resource type"}
end
