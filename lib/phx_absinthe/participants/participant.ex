defmodule PhxAbsinthe.Participants.Participant do
  alias PhxAbsinthe.{
    Avatars,
    Channels,
    Channels.Channel,
    Messages.Message,
    Participants
  }

  use GenServer
  import PhxAbsinthe.Helper

  @enforce_keys [:id, :name, :created_at, :last_active_at]
  defstruct [:id, :name, :created_at, :avatar, :avatar_id, :last_active_at]

  def start_link({id, name}) do
    GenServer.start_link(__MODULE__, {id, name})
  end

  @impl true
  def init({id, name}) do
    schedule_health_check()

    {:ok,
     %__MODULE__{
       id: id,
       name: name,
       created_at: DateTime.utc_now(),
       last_active_at: DateTime.utc_now()
     }}
  end

  #
  # api
  #
  @impl true
  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call(:touch, _from, state) do
    new_state = %{state | last_active_at: now()}
    {:noreply, new_state, new_state}
  end

  @impl true
  def handle_cast({:set_name, name}, state) do
    {:noreply, %{state | name: name, last_active_at: now()}}
  end

  @impl true
  def handle_cast({:set_avatar, base64_avatar}, state) do
    avatar_id = UUID.uuid4()
    Avatars.put(avatar_id, base64_avatar)
    {:noreply, %{state | avatar_id: avatar_id, last_active_at: now()}}
  end

  #
  # health check
  #
  @impl true
  def handle_info(:health_check, state) do
    check_health(state)
    {:noreply, state}
  end

  @impl true
  def handle_info(:kill, state) do
    IO.puts("Participant##{state.id} conceals")
    {:stop, :normal, state}
  end

  def terminate(_, %__MODULE__{id: id}) do
    delete_spec_from_supervisor(id)
  end

  defp check_health(state) do
    (is_active?(state) || belongs_to_channel?(state))
    |> case do
      false ->
        send(self(), :kill)

      true ->
        schedule_health_check()
    end
  end

  @doc "whether if a participant had activity within last 5 minutes"
  @five_minutes 300
  defp is_active?(%__MODULE__{last_active_at: last_active_at} = state) do
    DateTime.utc_now()
    |> DateTime.diff(last_active_at)
    |> case do
      diff when diff > @five_minutes ->
        state

      _ ->
        false
    end
  end

  defp belongs_to_channel?(%__MODULE__{id: id}) do
    Channels.active_participant_ids()
    |> Enum.find(&(&1 == id))
    |> is_truthy()
  end

  defp belongs_to_channel?(_), do: false

  defp schedule_health_check do
    Process.send_after(self(), :health_check, 5 * 1000)
  end

  defp delete_spec_from_supervisor(id) do
    Task.start(fn ->
      Process.sleep(5000)
      Participants.delete_child(id)
    end)
  end

  #
  # utils
  #
  defp now do
    DateTime.utc_now()
  end
end
