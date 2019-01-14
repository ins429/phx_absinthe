defmodule PhxAbsinthe.Resolvers.Message do
  alias PhxAbsinthe.Channels.Channel

  def for_channel(%Channel{messages: messages}, b, c) do
    {:ok, messages}
  end
end
