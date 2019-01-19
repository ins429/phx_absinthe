defmodule PhxAbsintheWeb.Scalars.Timestamp do
  def serialize(%DateTime{} = timestamp), do: DateTime.to_iso8601(timestamp)

  def parse(%Absinthe.Blueprint.Input.String{value: value}) do
    case DateTime.from_iso8601(value) do
      {:ok, datetime, 0} -> {:ok, datetime}
      _error -> :error
    end
  end

  def parse(%Absinthe.Blueprint.Input.Null{}) do
    {:ok, nil}
  end

  def parse(_) do
    :error
  end
end
