defmodule Mailer.Invite do
  @moduledoc false
  import Bamboo.Email
  require Logger

  @doc """
  Send email to user with link and
  """
  def create_invite(email, link, is_collection) do
    Logger.info("Send invite to #{email} with link #{link}")
    on_what = collaborate_on(is_collection)

    body = ~s(
      Hey,
      Someone invited you to collaborate on #{on_what}
      please follow the link below

      #{link}

      Thanks.
    )

    new_email(
      to: email,
      from: Application.get_env(:mailer, :from_email),
      subject: "Call for collaboration",
      text_body: body
    )
  end

  def schedule_delivery(invite), do: invite |> Mailer.deliver_later()

  defp collaborate_on(true), do: "whiteboard"
  defp collaborate_on(false), do: "collection"
end
