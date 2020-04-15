defmodule GameServerWeb.RegisterController do
  use GameServerWeb, :controller

  def index(conn, params) do
      IO.inspect(conn)
      IO.inspect(params)
      %{"player name" => name} = params
      response = %{"we got the request!" => name}
      json conn, Poison.encode!(response)
      #render(conn, "register.html")
  end

end
