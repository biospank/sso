defmodule Sso.Mailer.ActivationReminder do
  require Logger

  alias Sso.{User, Email, Mailer}

  def perform(two_days_ago, one_day_ago) do
    for user <- User.pending_activations(two_days_ago, one_day_ago) do
      case get_in(user.account.organization.settings, ["email_template", "reminder", "active"]) do
        true ->
          if user.profile.activation_callback_url do
            case Email.reminder_template(user, user.account, user.profile.activation_callback_url) do
              {:ok, email} ->
                Logger.info "sending email activation reminder for #{user.id}"
                Mailer.deliver_later(email)
              {:error, message} ->
                Logger.error message
            end
          end
        _ ->
          false
      end
    end
  end
end
