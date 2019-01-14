defmodule PhxAbsinthe.Resolvers.Participant do
  alias PhxAbsinthe.Channels.Channel

  def for_channel(%Channel{participants: participants}, b, c) do
    {:ok, participants}
  end
end
