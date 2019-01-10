defmodule PhxAbsinthe.Participants.Participant do
  alias PhxAbsinthe.Messages.Message
  alias PhxAbsinthe.Channels.Channel

  use GenServer

  @enforce_keys [:id, :name]
  defstruct [:id, :name, :messages, :participants]

  def start_link({id, name}) do
    GenServer.start_link(__MODULE__, {id, name})
  end

  @impl true
  def init({id, name}) do
    {:ok,
     %__MODULE__{
       id: id,
       name: name
     }}
  end

  @impl true
  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end
end
