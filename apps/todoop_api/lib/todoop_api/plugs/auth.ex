defmodule TodoopApi.Plug.Auth do
  use Guardian.Plug.Pipeline,
    otp_app: :todoop_api,
    module: TodoopApi.Guardian,
    error_handler: TodoopApi.AuthErrorHandler

  plug(Guardian.Plug.VerifyHeader, realm: "Bearer")
  plug(Guardian.Plug.EnsureAuthenticated)
  plug(Guardian.Plug.LoadResource)
end
