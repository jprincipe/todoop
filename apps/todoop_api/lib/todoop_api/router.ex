defmodule TodoopApi.Router do
  use TodoopApi, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", TodoopApi do
    pipe_through(:api)

    resources "/users", UserController, only: [:create]
  end
end
