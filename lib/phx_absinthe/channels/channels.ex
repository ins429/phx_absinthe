defmodule PhxAbsinthe.Channels do
  alias PhxAbsinthe.Channels.Channel

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

  def create(name) do
    Supervisor.start_child(__MODULE__, %{
      id: name,
      start: {Channel, :start_link, [name]}
    })
    |> case do
      {:ok, pid} ->
        pid

      {:ok, pid, _} ->
        pid

      {:error, {:already_started, pid}} ->
        pid

      result ->
        IO.puts("unexpected result from Channels.create/1: #{inspect(result)}")
        result
    end
  end

  def create_message(name, raw_message) do
    find_pid(name)
    |> GenServer.call({:create_message, raw_message})
  end

  def destroy(name) do
    Supervisor.terminate_child(__MODULE__, name)
    Supervisor.delete_child(__MODULE__, name)
  end

  def delete_child(name) do
    Supervisor.delete_child(__MODULE__, name)
  end

  def find(name) do
    which_children()
    |> Enum.find(&(elem(&1, 0) == name))
  end

  def get(pid) when is_pid(pid) do
    GenServer.call(pid, :get)
  end

  def get(id) when is_binary(id) do
    find_pid(id)
    |> get()
  end

  def get(_), do: nil

  def join(pid, participant) when is_pid(pid), do: GenServer.call(pid, {:join, participant})

  def join(name, participant) when is_bitstring(name) do
    name
    |> find_pid()
    |> case do
      nil ->
        create(name)

      pid ->
        pid
    end
    |> join(participant)
  end

  def active_participant_ids do
    which_children()
    |> Enum.map(fn {_, id, _, _} -> get(id) end)
    |> Enum.map(fn %{participant_ids: participant_ids} -> participant_ids end)
    |> Enum.concat()
    |> Enum.uniq()
  end

  defp find_pid(name) do
    find(name)
    |> case do
      {_, id, _, _} -> id
      nil -> nil
    end
  end
end
