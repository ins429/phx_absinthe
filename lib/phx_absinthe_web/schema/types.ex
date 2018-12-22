defmodule PhxAbsintheWeb.Schema.Types do
  use Absinthe.Schema.Notation

  object :obj do
    field(:id, :id)
    field(:field, :string)
  end

  object :chat_message do
    field(:name, :string)
    field(:channel, :string)
    field(:message, :string)
  end
end
