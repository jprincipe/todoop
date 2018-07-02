defmodule TodoopApi.Router do
  use TodoopApi, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/v1", TodoopApi do
    pipe_through(:api)

    post "/register", UserController, :create
    post "/login", SessionController, :create
  end
end
