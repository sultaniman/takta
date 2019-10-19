defmodule Auth do
  @moduledoc false
  @hash_salt Application.get_env(:auth, :password_hash_salt)
  @hash_len Application.get_env(:auth, :hashlen)
  @t_cost Application.get_env(:auth, :t_cost)
  @m_cost Application.get_env(:auth, :m_cost)

  @spec authenticate(atom | %{password_hash: any}, any) :: :ok | {:error, :invalid_credentials}
  def authenticate(user, given_pass) do
    if password_valid?(given_pass, user.password_hash) do
      :ok
    else
      {:error, :invalid_credentials}
    end
  end

  @spec password_valid?(any, <<_::64, _::_*8>>) :: boolean
  def password_valid?(password, password_hash) do
    Argon2.verify_pass(password, password_hash)
  end

  @spec hash_password(any, any) :: any
  def hash_password(password, salt \\ @hash_salt)

  def hash_password(password, salt) do
    password
    |> Argon2.Base.hash_password(
      salt,
      hashlen: @hash_len,
      t_cost: @t_cost,
      m_cost: @m_cost
    )
  end
end
