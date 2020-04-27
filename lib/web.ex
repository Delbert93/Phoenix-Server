defmodule Web do
  use Plug.Router

  plug :match
  plug :dispatch

  def child_spec(_) do
    Plug.Adapters.Cowboy.child_spec(scheme: :http,
                                    options: [port: 4000],
                                    plug: __MODULE__)
  end


  #Ammon
  post "/register" do

  end


  #DJ
  post "/status" do

  end


  #Matt/McKinnin
  post "/answer" do

  end

end
