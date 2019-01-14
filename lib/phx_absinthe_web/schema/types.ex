defmodule PhxAbsintheWeb.Schema.Types do
  alias PhxAbsinthe.Resolvers

  use Absinthe.Schema.Notation

  scalar :timestamp, name: "DateTime" do
    serialize(&Scalars.Timestamp.serialize/1)
    parse(&Scalars.Timestamp.parse/1)
  end

  object :message do
    field(:id, :integer)
    field(:message, :string)
    field(:created_at, :timestamp)
  end

  object :participant do
    field(:id, :integer)
    field(:name, :string)
    field(:created_at, :timestamp)
    field(:last_active_at, :timestamp)
  end

  object :channel do
    field(:id, :integer)
    field(:name, :string)

    field(:messages, list_of(:message))
    field(:participants, list_of(:participant))
  end
end
