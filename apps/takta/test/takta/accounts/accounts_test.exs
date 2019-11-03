defmodule Takta.AccountsTest do
  use Takta.DataCase
  use Takta.Query
  alias Takta.Accounts

  describe "accounts 🐁 ::" do
    test "find all works as expected" do
      assert Accounts.all() |> length() > 0
    end

    test "find_by_id works as expected" do
      one = Accounts.all() |> List.first()
      assert Accounts.find_by_id(one.id)
    end

    test "find_by_email works as expected" do
      one = Accounts.all() |> List.first()
      assert Accounts.find_by_email(one.email).id
    end

    test "find_by_email returns nil if user does not exist" do
      refute Accounts.find_by_email("doctor@strange.do")
    end

    test "can create new user" do
      {:ok, user} =
        Accounts.create(%{
          email: "test-user@example.com",
          full_name: "test name",
          password: "12345678",
          is_active: true,
          is_admin: false
        })

      assert Accounts.find_by_id(user.id).id == user.id
    end

    test "can not create new user if input is not valid" do
      {:error, changeset} =
        Accounts.create(%{
          email: "test-user@example.com",
          full_name: "test name",
          is_active: true,
          is_admin: false
        })

      assert changeset.errors
    end

    test "update user works as expected" do
      user = Accounts.find_by_email("admin@example.com")
      update_params = %{full_name: "FULL BULL DULL HULL"}

      with {:ok, updated_user} <- Accounts.update(user, update_params) do
        assert updated_user.full_name == update_params[:full_name]
      end
    end

    test "can not update user if input is invalid" do
      user = Accounts.find_by_email("admin@example.com")
      update_params = %{full_name: nil, email: nil}

      with {:error, changeset} <- Accounts.update(user, update_params) do
        assert changeset.errors

        assert changeset.errors == [
                 email: {"can't be blank", [validation: :required]},
                 full_name: {"can't be blank", [validation: :required]}
               ]
      end
    end

    test "changing password works as expected" do
      {:ok, user} =
        Accounts.create(%{
          email: "change-password@example.com",
          full_name: "change password",
          password: "345678910",
          is_active: true,
          is_admin: false
        })

      {:ok, updated_user} =
        Accounts.change_password(user, %{
          password: "345678910",
          new_password: "newpassword",
          new_password_confirmation: "newpassword"
        })

      assert updated_user.password_hash == Auth.hash_password("newpassword")
    end

    test "can not change password if passwords mismatch" do
      {:ok, user} =
        Accounts.create(%{
          email: "change-password@example.com",
          full_name: "change password",
          password: "345678910",
          is_active: true,
          is_admin: false
        })

      {:error, changeset} =
        Accounts.change_password(user, %{
          password: "345678910",
          new_password: "newpassword",
          new_password_confirmation: "newpasswörd"
        })

      assert changeset.errors

      assert changeset.errors == [new_password_confirmation: {"Passwords do not match", []}]
    end

    test "can list comments for user" do
      user = Accounts.find_by_email("su@example.com")
      assert length(Accounts.find_comments(user.id)) == 4
    end
  end
end
