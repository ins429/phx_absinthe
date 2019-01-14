defmodule PhxAbsinthe.Messages.Message do
  @enforce_keys [:id, :message, :channel_name, :participant]
  defstruct [:id, :message, :participant, :created_at, :channel_name]
end
