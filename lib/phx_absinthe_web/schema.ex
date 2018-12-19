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

  mutation do
    field :submit_input, type: :input do
      arg(:target, non_null(:string))
      arg(:value, non_null(:string))

      resolve(fn _, %{target: target, value: value}, _ ->
        {:ok, %{target: target, value: value}}
      end)
    end
  end

  subscription do
    field :input_changed, type: :input do
      arg(:target, non_null(:string))

      config(fn args, _ ->
        {:ok, topic: args.target}
      end)

      trigger(:submit_input,
        topic: fn input ->
          input.target
        end
      )

      resolve(fn input, _, _ ->
        {:ok, input}
      end)
    end
  end
end
