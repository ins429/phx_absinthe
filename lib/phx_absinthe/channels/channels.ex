defmodule PhxAbsinthe.Channels.Channels do
  use GenServer

  @enforce_keys [:channels]
  defstruct [:channels]

  @impl true
  def init(name) do
    {:ok,
     %__MODULE__{
       channels: []
     }}
  end

  @impl true
  def handle_call({:find_by_name, name}, _from, state) do
    {:reply, find_by_name(state, name), state}
  end

  @impl true
  def handle_cast({:add_channel, name}, _from, state) do
    {:reply, find_by_name(state, name), state}
  end

  defp find_by_name(%__MODULE__{channels: channels}, name) do
    channels
    |> Enum.find(&(&1.name == name))
  end

  defp find_by_id(%__MODULE__{channels: channels}, id) do
    channels
    |> Enum.find(&(&1.id == id))
  end
end
