defmodule PhxAbsinthe.Channels.Channel do
  @enforce_keys [:id, :name]
  defstruct [:id, :name, messages: [], participants: []]
end
