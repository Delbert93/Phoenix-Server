defmodule MazeGameClient do
  @moduledoc """
  Documentation for MazeGameClient.
  """
  @status_request_time_interval 200
  @round_time_interval 2000
  @name "DJB"
  @endpoint "http://localhost"

  @doc """
  Hello world.

  ## Examples

      iex> MazeGameClient.hello()
      :world

  """

  def start do
    reg_result = register()
    case reg_result do
      :ok ->
        StartingPointServer.start()
        request_status()
    end
  end



  def register do
    HTTPoison.start()
    body = Poison.encode!(%{name: @name})
    headers = [{"Content-type", "application/json"}]
    response = HTTPoison.post!(@endpoint <> "/api/register", body, headers)

    with %HTTPoison.Response{status_code: 200} <- response do
      :ok
    else
      _other -> :error
    end

  end



  def request_status(client_round \\ 0) do
    body = Poison.encode!(%{name: @name})
    headers = [{"Content-type", "application/json"}]
    response = HTTPoison.post!(@endpoint <> "/api/update", body, headers)

    response_body = Poison.decode(response.body)

    #If game is in progress, start a process that looks for the best starting point, sleep until the round is close to ending,
    #send the best starting point the process was able to find
    with %HTTPoison.Response{status_code: 200} <- response,
        {:ok, %{status: "in_progress", maze: maze, exits: exits, round_number: server_round}} <- response_body do
          if (client_round < server_round) do
            solve_round(maze, exits)
            :timer.sleep(@round_time_interval - @status_request_time_interval)
            send_answer(server_round)
            StartingPointServer.reset()
            request_status(client_round)
          else
            :timer.sleep(@status_request_time_interval)
            request_status(server_round)
          end

    else
      %HTTPoison.Response{status_code: 500} ->
        {:error, "500 response"}

      {:ok, %{status: "not_started"}} ->
        :timer.sleep(@status_request_time_interval)
        request_status()

      {:ok, %{status: "complete"}} ->
        {:ok, %{scores: scores}} = response_body
        scores

      {:error, other} ->
        {:error, other}
    end
  end

  def solve_round(maze, exits) do
    Task.start(MazeSolver, :solve, [maze, exits])
  end

  def send_answer(round) do
    starting_point = StartingPointServer.get_top_point()
    body = Poison.encode!(%{name: @name, round: round, answer: starting_point})
    headers = [{"Content-type", "application/json"}]
    HTTPoison.post!(@endpoint <> "/api/answer", body, headers)
  end

end
