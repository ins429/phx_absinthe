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
    field :send_chat_message, type: :chat_message do
      arg(:channel, non_null(:string))
      arg(:name, non_null(:string))
      arg(:message, non_null(:string))

      resolve(fn _, %{channel: channel, name: name, message: message}, _ ->
        {:ok, %{channel: channel, name: name, message: message}}
      end)
    end
  end

  subscription do
    field :chat_message_added, type: :chat_message do
      arg(:channel, non_null(:string))

      config(fn args, _ ->
        {:ok, topic: args.channel}
      end)

      trigger(:send_chat_message,
        topic: fn chat ->
          chat.channel
        end
      )

      resolve(fn chat, _, _ ->
        {:ok, chat}
      end)
    end
  end
end
