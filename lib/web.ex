defmodule Web do
  use Plug.Router

  plug :match
  plug :dispatch
  plug Plug.Parsers, parsers: [:json], json_decoder: Poison

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

  end

  match _ do
    send_resp(conn, 404, "Not able to do! Try with another route!")
  end

end
