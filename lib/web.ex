defmodule Web do
  use Plug.Router

  plug :match
  plug :dispatch

  def child_spec(_) do
    Plug.Adapters.Cowboy.child_spec(scheme: :http,
                                    options: [port: 4000],
                                    plug: __MODULE__)
  end

  get "/" do
    send_resp(conn, 200, "Hello World!")
  end

  #Ammon
  post "/register" do
    {:ok, params, _plug_conn = %Plug.Conn{}} = Plug.Conn.read_body(conn)
    %{"name" => name} = Poison.decode!(params)
    ContestantsTable.add_contestant(name)
    |> case do
      nil -> send_resp(conn, 500, "#{name} is already a part of the game!")
      _ -> send_resp(conn, 200, "#{name} was added to the game!")
    end
  end

  #DJ
  post "/status" do
    status = GameStatusGenServer.get_status()
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(status))
  end



  #Matt/McKinnin
  post "/answer" do
    {:ok, body_json, _conn = %Plug.Conn{}} = Plug.Conn.read_body(conn)
    %{"starting point" => value} = Poison.decode!(body_json)

    name = elem(value, 0)
    all_names = ContestantsTable.get_contestants()
    check_name(value, name, all_names)

    round = elem(value, 1)
    check_round(value, round)

    answer = elem(value, 2)
    ContestantsTable.score_anser(name, round, answer)
  end

  def check_name(_value, name, []) do
    send_resp(_value, 500, "Your name was not found.")
  end

  def check_name(value, name, [first | rest]) do
    case name do
      nil ->
        send_resp(value, 500, "You must have a name")
      first ->
        {:ok}
      _Notname ->
        check_name(value, name, rest)
    end
  end

  def check_round(value, round) do
    current_round = GameStatusGenServer.get_status()
    case round do
      current_round ->
        {:ok}
      _not ->
        send_resp(value, 500, "Not current round")
    end
  end

end
