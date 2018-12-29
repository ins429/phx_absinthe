defmodule PhxAbsintheWeb.Schema do
  use Absinthe.Schema

  alias PhxAbsinthe.Resolvers

  import_types(PhxAbsintheWeb.Schema.Types)

  query do
  end

  mutation do
    @desc "a participant joins a channel"
    field :join_channel, :channel do
      arg(:name, non_null(:string))

      resolve(&Resolvers.Channels.join/3)
    end
  end

  subscription do
  end
end
