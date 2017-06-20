defmodule Mix.Tasks.NbNameFix do
  use Mix.Task

  def run(_) do
    NB.stream("lists/1794/people")
    |> Enum.map(fn person = %{"id" => id, "last_name" => last_name} ->
      IO.puts id

      ln = last_name
      |> String.replace("[", "")
      |> String.replace("]", "")
      |> String.replace("\"", "")

      {:ok, put_body_string} = Poison.encode(%{"person" => %{"last_name" => ln}})
      NB.put("people/#{id}", [body: put_body_string])
    end)
    |> IO.inspect
  end
end

# Mix.Tasks.NbNameFix.run("hi")