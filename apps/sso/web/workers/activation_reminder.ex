defmodule Sso.Workers.ActivationReminder do
  use GenServer

  @trigger_hour 5

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(state) do
    if enabled? do
      schedule_work()
      {:ok, state}
    else
      :ignore
    end
  end

  def handle_info(:send_mail, state) do
    two_days_ago = {Chronos.days_ago(2), {@trigger_hour, 0, 0}}
    one_day_ago = {Chronos.days_ago(1), {@trigger_hour, 0, 0}}

    Sso.Mailer.ActivationReminder.perform(two_days_ago, one_day_ago)

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

  defp enabled?() do
    Application.get_env(:sso, __MODULE__)[:enabled]
  end
end
