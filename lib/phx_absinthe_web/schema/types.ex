defmodule PhxAbsintheWeb.Schema.Types do
  use Absinthe.Schema.Notation

  object :message do
    field(:id, :integer)
    field(:message, :string)
  end

  object :channel do
    field(:id, :integer)
    field(:name, :string)
  end
end
