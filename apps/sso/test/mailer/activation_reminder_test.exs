defmodule Sso.Mailer.ActivationReminderTest do
  use Sso.ConnCase
  use Bamboo.Test, shared: :true

  @callback_url "http://anysite.com/opt-in"
  @valid_inserted_at NaiveDateTime.from_erl!({Chronos.days_ago(2), {0, 0, 0}})

  setup %{} do
    organization = insert_organization()
    account = insert_account(organization) |> Sso.Repo.preload(:organization)
    user = insert_user(account)

    hour = Chronos.now |> Chronos.hour
    min = Chronos.now |> Chronos.min
    sec = Chronos.now |> Chronos.min

    two_days_ago = {Chronos.days_ago(2), {hour, min, sec}}
    one_day_ago = {Chronos.days_ago(1), {hour, min, sec}}

    location = @callback_url <> "?code=#{user.activation_code}"

    {:ok, user: user, account: account, organization: organization, range_from: two_days_ago, range_to: one_day_ago, location: location}
  end

  describe "perform" do
    setup %{user: user, location: location}= config do
      if config[:valid_user] do
        if config[:activation_callback_url] do
          # profile_changeset =
          #   Sso.Profile.attrs_changeset(user.profile, activation_callback_url: location)

          user_profile = put_in(user.profile, [:activation_callback_url], location)

          user
          |> Ecto.Changeset.change
          |> Ecto.Changeset.put_change(:profile, user_profile)
          |> Sso.Repo.update!

        end
      end

      :ok
    end

    @tag :valid_user
    @tag activation_callback_url: false
    test "does not send activation email reminder for inactive reminder template",
      %{user: user, account: account, organization: org, range_from: days_range_from, range_to: days_range_to, location: location} do

      # set template reminder active to false
      org_settings = update_in(org.settings, [:email_template, :reminder, :active], &(!&1))

      org
      |> Ecto.Changeset.change(settings: org_settings)
      |> Sso.Repo.update!

      Sso.Mailer.ActivationReminder.perform(days_range_from, days_range_to)

      {:ok, email} = Sso.Email.reminder_template(user, account, location)

      refute_delivered_email email

    end

    @tag :valid_user
    @tag activation_callback_url: false
    test "does not send activation email reminder for users with missing activation callback url",
      %{user: user, account: account, range_from: days_range_from, range_to: days_range_to, location: location} do

      Sso.Mailer.ActivationReminder.perform(days_range_from, days_range_to)

      {:ok, email} = Sso.Email.reminder_template(user, account, location)

      refute_delivered_email email

    end

    @tag :valid_user
    @tag activation_callback_url: false
    test "does not send activation email reminder for active user",
      %{user: user, account: account, range_from: days_range_from, range_to: days_range_to, location: location} do

      user
      |> Ecto.Changeset.change(active: true)
      |> Sso.Repo.update!

      Sso.Mailer.ActivationReminder.perform(days_range_from, days_range_to)

      {:ok, email} = Sso.Email.reminder_template(user, account, location)

      refute_delivered_email email

    end

    @tag :valid_user
    @tag :activation_callback_url
    test "does not send activation email reminder for inactive user into 24 hours range",
      %{user: user, account: account, range_from: days_range_from, range_to: days_range_to, location: location} do

      hour = Chronos.now |> Chronos.hour
      min = Chronos.now |> Chronos.min
      sec = Chronos.now |> Chronos.min

      one_day_ago = NaiveDateTime.from_erl!({Chronos.days_ago(1), {(hour + 1), min, sec}})

      user
      |> Ecto.Changeset.change(inserted_at: one_day_ago)
      |> Sso.Repo.update!

      Sso.Mailer.ActivationReminder.perform(days_range_from, days_range_to)

      {:ok, email} = Sso.Email.reminder_template(user, account, location)

      refute_delivered_email email

    end

    @tag :valid_user
    @tag :activation_callback_url
    test "does not send activation email reminder for inactive user over 48 hours range",
      %{user: user, account: account, range_from: days_range_from, range_to: days_range_to, location: location} do

      three_days_ago = NaiveDateTime.from_erl!({Chronos.days_ago(3), {0, 0, 0}})

      user
      |> Ecto.Changeset.change(inserted_at: three_days_ago)
      |> Sso.Repo.update!

      Sso.Mailer.ActivationReminder.perform(days_range_from, days_range_to)

      {:ok, email} = Sso.Email.reminder_template(user, account, location)

      refute_delivered_email email

    end

    @tag :valid_user
    @tag :activation_callback_url
    test "send activation email reminder for inactive user within 24/48 hours range",
      %{user: user, account: account, range_from: days_range_from, range_to: days_range_to, location: location} do

      hour = Chronos.now |> Chronos.hour
      min = Chronos.now |> Chronos.min
      sec = Chronos.now |> Chronos.min

      one_day_ago = NaiveDateTime.from_erl!({Chronos.days_ago(2), {hour, min, sec}})

      user
      |> Ecto.Changeset.change(inserted_at: one_day_ago)
      |> Sso.Repo.update!

      Sso.Mailer.ActivationReminder.perform(days_range_from, days_range_to)

      {:ok, email} = Sso.Email.reminder_template(user, account, location)

      assert_delivered_email email

    end
  end
end
