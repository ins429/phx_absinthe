defmodule PhxAbsintheWeb.Schema do
  use Absinthe.Schema

  alias PhxAbsinthe.Resolvers

  import_types(PhxAbsintheWeb.Schema.Types)

  query do
    field :session, :string do
      resolve(&Resolvers.Session.get_session/2)
    end

    field :participant, :participant do
      resolve(&Resolvers.Participant.get/2)
    end

    field :channel, :channel do
      arg(:channel_name, non_null(:string))

      resolve(&Resolvers.Channel.get/2)
    end
  end

  mutation do
    #
    # Channel
    #

    @desc "a participant joins a channel"
    field :join_channel, :channel do
      arg(:channel_name, non_null(:string))

      resolve(&Resolvers.Channel.join/2)
    end

    @desc "a participant sends a message"
    field :send_message, :message do
      arg(:message, non_null(:string))
      arg(:channel_name, non_null(:string))

      # FIXME channel_name needs to be validated with the current participant,
      # whether the participant is in the channel

      resolve(&Resolvers.Channel.send_message/2)
    end

    #
    # Participant
    #

    @desc "sets current participant name"
    field :set_participant_name, :participant do
      arg(:name, non_null(:string))

      resolve(&Resolvers.Participant.set_name/2)
    end

    @desc "sets current participant avatar"
    field :set_participant_avatar, :participant do
      arg(:avatar, non_null(:string))

      resolve(&Resolvers.Participant.set_avatar/2)
    end

    @desc "touches participant's last_active_at"
    field :touch_participant, :participant do
      resolve(&Resolvers.Participant.touch/2)
    end
  end

  subscription do
    field :participant_updated, :message do
      arg(:participant_id, non_null(:string))

      config(fn args, _ ->
        {:ok, topic: args.participant_id}
      end)

      trigger(
        :update_avatar,
        topic: fn participant ->
          participant.id
        end
      )

      resolve(fn participant, _, _ ->
        {:ok, participant}
      end)
    end

    field :message_received, :message do
      arg(:channel_name, non_null(:string))

      config(fn args, _ ->
        {:ok, topic: args.channel_name}
      end)

      trigger(
        :send_message,
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
