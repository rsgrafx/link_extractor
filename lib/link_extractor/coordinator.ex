defmodule LinkExtractor.Coordinator do

  def loop(results \\ [], expected_results) do
    receive do
      # result from http call.
      {:ok, result} ->
        new_results = [result|results]
        if expected_results == Enum.count(new_results), do: send(self, :exit)
        # continue with loop.
        loop(new_results, expected_results)
      :exit -> 
        results
       _ -> loop(results, expected_results) 
    end
  end

end