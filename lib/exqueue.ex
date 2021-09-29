defmodule Exqueue do
  use GenServer

  # Client
  def start_link(initial_queue) when is_list(initial_queue) do
    GenServer.start_link(__MODULE__, initial_queue)
  end

  def queue(pid, element) do
    GenServer.cast(pid, {:queue, element})
  end

  def dequeue(pid) do
    GenServer.call(pid, :dequeue)
  end

  @impl true
  def init(stack) do
    {:ok, stack}
  end

  @impl true
  # SYNC
  def handle_call({:queue, element}, _from, state) do
    {:reply, :ok, [element | state]}
  end

  @impl true
  # SYNC
  def handle_call({:dequeue}, _from, state) do
    {element, new_state} = dequeue(state)

    {:reply, element, new_state}
  end

  @impl true
  # ASYNC
  def handle_cast({:queue, element}, state) do
    {:noreply, [element, state]}
  end

  @impl true
  # ASYNC
  def handle_cast({:dequeue}, state) do
    {element, new_state} = dequeue_state(state)

    {:noreply, element, new_state}
  end

  defp dequeue_state(list) when length(list) > 0 do
    [element | new_state] =
      list
      |> Enum.reverse()

    {element, Enum.reverse(new_state)}
  end

  defp dequeue_state(list) do
    {nil, list}
  end
end
