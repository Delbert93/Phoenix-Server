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

end
