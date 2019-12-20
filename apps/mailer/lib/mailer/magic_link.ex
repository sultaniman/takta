defmodule Mailer.MagicLink do
  @moduledoc false
  import Bamboo.Email
  require Logger

  @doc """
  Send magic link to requested email
  so later user can sign in using it.
  """
  def new_link(email, link) do
    Logger.info("Send login link #{link}")

    body = ~s(
      Hey,

      Please use the following link to sing in to your account

      #{link}

      Thanks.
    )

    new_email(
      to: email,
      from: Application.get_env(:mailer, :from_email),
      subject: "Login link",
      text_body: body
    )
  end

  def schedule_delivery(message), do: message |> Mailer.deliver_later()
end
