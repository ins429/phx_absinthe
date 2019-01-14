defmodule PhxAbsinthe.Channels.ChannelGenServer do
  alias PhxAbsinthe.Messages.Message
  alias PhxAbsinthe.Channels.Channel

  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state)
  end

  @impl true
  def init(name) do
    check_health()

    {:ok,
     %Channel{
       id: UUID.uuid1(),
       name: name,
       messages: [],
       participants: []
     }}
  end

  @impl true
  def handle_call({:create_message, raw_message}, _from, state) do
    message = create_message(raw_message, state)

    {:reply, message, %{state | messages: [message | state.messages]}}
  end

  @impl true
  def handle_call({:join, participant}, _from, state) do
    new_state = %{state | participants: [participant | state.participants]}

    {:reply, new_state, new_state}
  end

  def handle_info(:health_check, state) do
    check_health()
    {:noreply, state}
  end

  def handle_info(:kill, state) do
    {:stop, :normal, state}
  end

  defp create_message(message, %{name: name}) do
    %Message{
      struct(Message, message)
      | created_at: DateTime.utc_now(),
        id: UUID.uuid4(),
        channel_name: name
    }
  end

  defp check_health do
    Process.send_after(self(), :health_check, 5 * 1000)
  end
end
