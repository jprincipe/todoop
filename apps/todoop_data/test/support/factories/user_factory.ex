defmodule TodoopData.UserFactory do
  defmacro __using__(_opts) do
    quote do
      def user_factory do
        %TodoopData.Accounts.User{
          email: sequence(:email, &"email-#{&1}@email.com"),
          password: "password",
          password_hash: "abcdefgh"
        }
      end
    end
  end
end
