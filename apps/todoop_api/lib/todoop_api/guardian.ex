defmodule TodoopApi.Guardian do
  use Guardian, otp_app: :todoop_api

  alias TodoopData.Accounts

  def subject_for_token(user, _claims), do: {:ok, to_string(user.id)}

  def resource_from_claims(claims), do: {:ok, Accounts.get_user(claims["sub"])}
end
