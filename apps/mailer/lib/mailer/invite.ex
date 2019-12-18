defmodule Mailer.Invite do
  @moduledoc false
  import Bamboo.Email

  @doc """
  Send email to user with link and
  """
  def create_invite(email, link, is_collection) do
    collaborate_on = "whiteboard"
    if is_collection do
      collaborate_on = "collection"
    end

    body = ~s(
      Hey,
      Someone invited you to collaborate on #{collaborate_on}
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

  def schedule_delivery(email), do: email |> Mailer.deliver_later()
end
