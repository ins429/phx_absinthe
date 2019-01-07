defmodule PhxAbsinthe.Channels.ChannelGenServer do
  alias PhxAbsinthe.Messages.Message
  alias PhxAbsinthe.Channels.Channel

  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl true
  def init(name) do
    {:ok,
     %Channel{
       id: UUID.uuid1(),
       name: name
     }}
  end

  @impl true
  def handle_call({:create_message, raw_message}, state) do
    message = create_message(raw_message)

    {:reply, message, create_message(state, message)}
  end

  @impl true
  def handle_call({:join, participant}, state) do
    new_state = %{state | participants: [participant | state.participants]}

    {:noreply, new_state, new_state}
  end

  defp create_message(state, message) do
    %{
      state
      | messages: [state.messages | message]
    }
  end

  defp create_message(message) do
    %Message{
      message
      | created_at: DateTime.utc_now()
    }
  end
end
