defmodule PhxAbsinthe.Guardian do
  use Guardian, otp_app: :phx_absinthe

  alias PhxAbsinthe.Participants
  alias PhxAbsinthe.Participants.Participant

  def subject_for_token(%Participant{id: id}, _claims) do
    {:ok, "Participant:#{id}"}
  end

  def subject_for_token(id, _claims) do
    {:ok, "Participant:#{id}"}
  end

  def subject_for_token(_, _), do: {:error, :unhandled_resource_type}

  def resource_from_claims(%{"sub" => "Participant:" <> id}) do
    case Participants.get(id) do
      nil -> {:error, :resource_not_found}
      participant -> {:ok, participant}
    end
  end

  def resource_from_claims(_), do: {:error, :unhandled_resource_type}
end
