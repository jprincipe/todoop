# test/support/factory.ex
defmodule TodoopData.Factory do
  use ExMachina.Ecto, repo: TodoopData.Repo

  use TodoopData.ListFactory
  use TodoopData.TaskFactory
  use TodoopData.UserFactory
end
