defmodule Exqueue do
  use GenServer

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
    {element, new_state} = dequeue(state)

    {:noreply, element, new_state}
  end

  defp dequeue(list) when length(list) > 0 do
    [element | new_state] =
      list
      |> Enum.reverse()

    {element, Enum.reverse(new_state)}
  end

  defp dequeue(list) do
    {nil, list}
  end
end
