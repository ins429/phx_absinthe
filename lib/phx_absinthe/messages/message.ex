defmodule PhxAbsinthe.Messages.Message do
  @enforce_keys [:id, :message, :channel_name, :participant_id]
  defstruct [:id, :message, :participant_id, :created_at, :channel_name]
end
