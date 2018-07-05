# test/support/factory.ex
defmodule TodoopData.Factory do
  use ExMachina.Ecto, repo: TodoopData.Repo

  use TodoopData.BoardFactory
  use TodoopData.TaskFactory
  use TodoopData.UserFactory
end
