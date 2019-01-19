defmodule PhxAbsinthe.Avatars do
  use Agent

  def start_link(initial_value \\ %{}) do
    Agent.start_link(fn -> initial_value end, name: __MODULE__)
  end

  def all do
    Agent.get(__MODULE__, & &1)
  end

  def get_by_id(id) do
    Agent.get(__MODULE__, &Map.get(&1, id))
  end

  def put(id, value) do
    Agent.update(__MODULE__, fn state ->
      state
      |> Map.put(id, value)
    end)
  end
end
