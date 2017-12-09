defmodule Sso.Workers.ActivationReminder do
  use GenServer
  require Logger

  alias Sso.{User, Email, Mailer}

  @trigger_hour 5

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(state) do
    schedule_work()
    {:ok, state}
  end

  def handle_info(:send_mail, state) do
    two_days_ago = {Chronos.days_ago(2), {@trigger_hour, 0, 0}}
    one_day_ago = {Chronos.days_ago(1), {@trigger_hour, 0, 0}}

    for user <- User.pending_activations(two_days_ago, one_day_ago) do
      case get_in(user.organization.settings, ["email_template", "reminder", "active"]) do
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

    schedule_work()

    {:noreply, state}
  end

  defp schedule_work do
    seconds = seconds_from_epoch
    seconds_at_five_am = {Chronos.tomorrow, {@trigger_hour, 0, 0}} |> seconds_from_epoch
    delay = (seconds_at_five_am - seconds) * 1_000

    Process.send_after(self(), :send_mail, delay)
  end

  # defp schedule_work do
  #   Process.send_after(self(), :send_mail, 10_000)
  # end

  defp seconds_from_epoch(at \\ Chronos.now) do
    at |> Chronos.epoch_time
  end
end
