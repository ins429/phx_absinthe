defmodule PhxAbsintheWeb.Schema do
  use Absinthe.Schema
  import_types(PhxAbsintheWeb.Schema.Types)

  query do
    @desc "string"
    field :string, :string do
      resolve(fn _, _ ->
        {:ok, "foobar"}
      end)
    end

    @desc "object"
    field :obj, :obj do
      resolve(fn _, _ ->
        {:ok, %{id: 1, field: "obj"}}
      end)
    end
  end
end
