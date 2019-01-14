defmodule PhxAbsintheWeb.Schema do
  use Absinthe.Schema

  alias PhxAbsinthe.Resolvers

  import_types(PhxAbsintheWeb.Schema.Types)

  query do
    field :session, :string do
      resolve(&Resolvers.Session.get_session/2)
    end
  end

  mutation do
    @desc "a participant joins a channel"
    field :join_channel, :channel do
      arg(:channel_name, non_null(:string))

      resolve(&Resolvers.Channel.join/2)
    end

    field :send_message, :message do
      arg(:message, non_null(:string))
      arg(:channel_name, non_null(:string))

      # FIXME channel_name needs to be validated with current participant,
      # whether the participant is in the channel

      resolve(&Resolvers.Channel.send_message/2)
    end
  end

  subscription do
    field :message_received, :message do
      arg(:channel_name, non_null(:string))

      config(fn args, _ ->
        {:ok, topic: args.channel_name}
      end)

      trigger(:send_message,
        topic: fn message ->
          message.channel_name
        end
      )

      resolve(fn message, _, _ ->
        {:ok, message}
      end)
    end
  end
end
