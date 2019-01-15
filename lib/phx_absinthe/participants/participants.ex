defmodule PhxAbsinthe.Participants do
  alias PhxAbsinthe.Participants.Participant

  use Supervisor

  def start_link() do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(_args) do
    Supervisor.init([], strategy: :one_for_one)
  end

  def which_children do
    __MODULE__
    |> Supervisor.which_children()
  end

  def all do
    which_children()
    |> Enum.map(&elem(&1, 0))
  end

  def create(name \\ "Participant") do
    id = UUID.uuid4()

    Supervisor.start_child(__MODULE__, %{
      id: id,
      start: {Participant, :start_link, [{id, name}]},
      restart: :transient
    })

    {:ok, id}
  end

  def destroy(child_id) do
    Supervisor.terminate_child(__MODULE__, child_id)
    Supervisor.delete_child(__MODULE__, child_id)
  end

  def delete_child(child_id) do
    Supervisor.delete_child(__MODULE__, child_id)
  end

  def get(id) do
    find_pid(id)
    |> case do
      nil -> nil
      pid -> GenServer.call(pid, :get)
    end
  end

  def update_name(id, name) do
    find_pid(id)
    |> case do
      nil -> {:error, :not_found}
      pid -> GenServer.cast(pid, {:set_name, name})
    end
  end

  def find(id) do
    which_children()
    |> Enum.find(&(elem(&1, 0) == id))
  end

  def touch(id) do
    find_pid(id)
    |> case do
      nil -> nil
      pid -> GenServer.call(pid, :touch)
    end
  end

  defp find_pid(id) do
    find(id)
    |> case do
      {_, id, _, _} -> id
      nil -> nil
    end
  end
end
