defmodule TodoList.Client do
  def start(initial_list) do
    {:ok, list} = GenServer.start(__MODULE__, initial_list)
    list
  end

  def add(list, task) do
    GenServer.cast(list, {:add, task})
  end

  def view(list) do
    IO.puts format_for_display(list)
  end

  @doc """
  Turns list of tasks into a string which nicely display tasks to be done

  ## Example
    
    iex> list = TodoList.Client.start(["Get groceries", "Dance"]) 
    ...> TodoList.Client.format_for_display(list)
    "1. Get groceries\n  2. Dance\n  "
  """
  def format_for_display(list) do
    tasks = GenServer.call(list, :format_for_display)
    tasks_with_index = Enum.with_index(tasks)
    formatted_text = Enum.reduce(tasks_with_index, "", fn({word, index}, acc) -> acc <> (Integer.to_string(index + 1)) <> ". " <> word <> "\n" end)
    formatted_text
  end

  use GenServer

  def init(list) do
    {:ok, list}
  end

  def handle_cast({:add, task}, list) do
    list = [task|list]
    {:noreply, list}
  end

  def handle_call(:format_for_display, _from, list) do
    {:reply, list, list}
  end
end
