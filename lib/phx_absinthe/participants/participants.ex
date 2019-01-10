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
      start: {Participant, :start_link, [{id, name}]}
    })

    {:ok, id}
  end

  def destroy(name) do
    Supervisor.terminate_child(__MODULE__, name)
    Supervisor.delete_child(__MODULE__, name)
  end

  def get(id) do
    find_pid(id)
    |> GenServer.call(:get)
  end

  def find(id) do
    which_children()
    |> Enum.find(&(elem(&1, 0) == id))
  end

  defp find_pid(id) do
    find(id)
    |> case do
      {_, id, _, _} -> id
      nil -> nil
    end
  end
end
