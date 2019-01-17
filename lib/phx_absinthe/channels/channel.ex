defmodule PhxAbsinthe.Channels.Channel do
  @enforce_keys [:id, :name]
  defstruct [:id, :name, messages: [], participant_ids: []]

  alias PhxAbsinthe.{
    Channels,
    Channels.Channel,
    Messages.Message
  }

  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state)
  end

  @impl true
  def init(name) do
    schedule_health_check()

    {:ok,
     %Channel{
       id: UUID.uuid1(),
       name: name,
       messages: [],
       participant_ids: []
     }}
  end

  @impl true
  def handle_call({:create_message, raw_message}, _from, state) do
    message = create_message(raw_message, state)

    {:reply, message, %{state | messages: [message | state.messages]}}
  end

  @impl true
  def handle_call({:join, participant}, _from, state) do
    new_state = %{state | participant_ids: [participant.id | state.participant_ids]}

    {:reply, new_state, new_state}
  end

  @impl true
  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_info(:health_check, state) do
    check_health(state)
    {:noreply, state}
  end

  @impl true
  def handle_info(:kill, state) do
    {:stop, :normal, state}
  end

  def terminate(_, %__MODULE__{id: id}) do
    delete_spec_from_supervisor(id)
  end

  defp create_message(message, %{name: name}) do
    %Message{
      struct(Message, message)
      | created_at: DateTime.utc_now(),
        id: UUID.uuid4(),
        channel_name: name
    }
  end

  defp check_health(state) do
    state
    |> has_activity_for_last()
    |> case do
      false ->
        send(self(), :kill)

      true ->
        schedule_health_check()
    end
  end

  @doc "whether if a participant had activity within last 5 minutes"
  @five_minutes 300
  defp has_activity_for_last(%__MODULE__{messages: messages}, seconds \\ @five_minutes) do
    messages
    |> Enum.any?(fn %Message{created_at: created_at} ->
      DateTime.utc_now()
      |> DateTime.diff(created_at) < seconds
    end)
  end

  defp belongs_to_channel?(_), do: false

  defp schedule_health_check do
    Process.send_after(self(), :health_check, 5 * 1000)
  end

  defp delete_spec_from_supervisor(id) do
    Task.start(fn ->
      Process.sleep(5000)
      Channels.delete_child(id)
    end)
  end
end
