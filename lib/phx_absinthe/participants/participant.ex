defmodule PhxAbsinthe.Participants.Participant do
  alias PhxAbsinthe.Participants
  alias PhxAbsinthe.Messages.Message
  alias PhxAbsinthe.Channels.Channel

  use GenServer

  @enforce_keys [:id, :name, :created_at, :last_active_at]
  defstruct [:id, :name, :created_at, :last_active_at]

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

  defp check_health(%__MODULE__{last_active_at: last_active_at}) do
    DateTime.utc_now()
    |> DateTime.diff(last_active_at)
    |> case do
      diff when diff > 300 ->
        send(self(), :kill)

      _ ->
        schedule_health_check()
    end
  end

  defp schedule_health_check do
    Process.send_after(self(), :health_check, 5 * 1000)
  end

  defp delete_spec_from_supervisor(id) do
    Task.start(fn ->
      Process.sleep(5000)
      Participants.delete_child(id)
    end)
  end

  defp now do
    DateTime.utc_now()
  end
end
