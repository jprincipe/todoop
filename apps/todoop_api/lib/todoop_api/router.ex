defmodule TodoopApi.Router do
  use TodoopApi, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :authenticated do
    plug(TodoopApi.Plug.Auth)
  end

  scope "/v1", TodoopApi do
    pipe_through(:api)

    post("/register", UserController, :create)
    post("/login", SessionController, :create)
  end

  scope "/v1", TodoopApi do
    pipe_through([:api, :authenticated])

    get("/me", UserController, :show)

    resources("/board", BoardController, except: [:new, :edit])
    resources("/tasks", TaskController, only: [:create, :update, :delete])
  end
end
