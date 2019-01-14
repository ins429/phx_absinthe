defmodule PhxAbsinthe.Channels do
  alias PhxAbsinthe.Channels.Channel
  alias PhxAbsinthe.Channels.ChannelGenServer

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
      start: {ChannelGenServer, :start_link, [name]}
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
    IO.puts("here wat")

    result =
      find_pid(name)
      |> GenServer.call({:create_message, raw_message})

    IO.puts("here #{inspect(result)}")
    result
  end

  def destroy(name) do
    Supervisor.terminate_child(__MODULE__, name)
    Supervisor.delete_child(__MODULE__, name)
  end

  def find(name) do
    which_children()
    |> Enum.find(&(elem(&1, 0) == name))
  end

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

  defp find_pid(name) do
    find(name)
    |> case do
      {_, id, _, _} -> id
      nil -> nil
    end
  end
end
