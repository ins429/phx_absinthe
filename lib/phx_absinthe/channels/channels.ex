defmodule PhxAbsinthe.Channels.Channels do
  use Supervisior

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    children = []

    Supervisor.init(children, strategy: :one_for_one)
  end

  def join(name) do
    name
    |> find()
    |> case do
      nil ->
        create(name)

      channel ->
        {:ok, channel}
    end
  end

  def find(name) do
    __MODULE__
    |> Supervisor.which_children()
    |> Enum.find(&(&1.id == name))
  end

  defp create(name) do
    Supervisor.start_child(__MODULE__, %{
      start: {Channel, :start_link},
      id: name
    })
  end
end
