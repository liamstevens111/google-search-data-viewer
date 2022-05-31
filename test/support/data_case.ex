defmodule GoogleSearchDataViewer.DataCase do
  @moduledoc """
  This module defines the setup for tests requiring
  access to the application's data layer.

  You may define functions here to be used as helpers in
  your tests.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use GoogleSearchDataViewer.DataCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  alias Ecto.Adapters.SQL.Sandbox

  using do
    quote do
      use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

      use Mimic

      alias GoogleSearchDataViewer.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import GoogleSearchDataViewer.DataCase
      import GoogleSearchDataViewer.Factory
    end
  end

  setup tags do
    HTTPoison.start()

    ExVCR.Config.cassette_library_dir(
      "test/support/fixtures/vcr_cassettes/",
      "test/support/fixtures/vcr_cassettes/custom"
    )

    pid = Sandbox.start_owner!(GoogleSearchDataViewer.Repo, shared: not tags[:async])
    on_exit(fn -> Sandbox.stop_owner(pid) end)
    :ok
  end

  @doc """
  A helper that transforms changeset errors into a map of messages.

      assert {:error, changeset} = Accounts.create_user(%{password: "short"})
      assert "password is too short" in errors_on(changeset).password
      assert %{password: ["password is too short"]} = errors_on(changeset)

  """
  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end
end
