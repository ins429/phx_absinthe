defmodule PhxAbsinthe.Channels.Channel do
  @enforce_keys [:id, :name]
  defstruct [:id, :name, messages: [], participants: []]

  def create_message(pid, raw_message) do
    GenServer.call(pid, {:create, raw_message})
  end

  def join(pid, participant) do
    GenServer.call(pid, {:join, participant})
  end
end
