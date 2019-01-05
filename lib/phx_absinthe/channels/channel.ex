defmodule PhxAbsinthe.Channels.Channel do
  use GenServer

  @enforce_keys [:id, :name]
  defstruct [:id, :name, :messages, :participants]

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl true
  def init(name) do
    {:ok,
     %__MODULE__{
       id: UUID.uuid1(),
       name: name
     }}
  end

  @impl true
  def handle_call({:show, participant}, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call({:create_message, raw_message}, state) do
    message = create_message(raw_message)

    {:noreply, message, add_message(state, message)}
  end

  @impl true
  def handle_cast({:participant_joined, participant}, state) do
    {:reply, %{state | participants: [participant | state.participants]}}
  end

  defp add_message(state, message) do
    %{
      state
      | messages: [state.messages | message]
    }
  end

  defp create_message(message) do
    %Message{
      message
      | created_at: Datetime.utc_now()
    }
  end
end
