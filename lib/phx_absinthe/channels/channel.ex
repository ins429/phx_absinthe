defmodule PhxAbsinthe.Channels.Channel do
  use GenServer

  @enforce_keys [:id, :name]
  defstruct [:id, :name, :messages, :participants]

  @impl true
  def init(name) do
    {:ok,
     %__MODULE__{
       id: UUID.uuid1(),
       name: name
     }}
  end

  @impl true
  def handle_cast({:participant_joined, participant}, state) do
    {:reply, %{state | participants: [participant | state.participants]}}
  end

  @impl true
  def handle_cast({:receive_message, message}, state) do
    {:noreply, %{state | messages: %{state | messages: [messages | message]}}}
  end

  defp find_by_name(%__MODULE__{}) do
  end
end
