defmodule PhxAbsinthe.Helper do
  def is_truthy(falsy) when falsy == false or falsy == 0 or falsy == "", do: false
  def is_truthy(_), do: true
end
