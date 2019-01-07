defmodule PhxAbsinthe.Messages.Message do
  @enforce_keys [:id, :name]
  defstruct [:id, :message, :created_at]
end
