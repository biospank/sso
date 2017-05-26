defmodule Sso.Email do
  use Bamboo.Phoenix, view: Sso.EmailView

  def welcome_email(user, account, link) when is_binary(link) do
    subject_content =
      account.organization.settings
      |> lookup_content_for(["email_template", "registration", "subject"])
      |> compile([user: user, account: account, link: link])

    html_body_content =
      account.organization.settings
      |> lookup_content_for(["email_template", "registration", "web", "html_body"])
      |> compile([user: user, account: account, link: link])

    text_body_content =
      account.organization.settings
      |> lookup_content_for(["email_template", "registration", "web", "text_body"])
      |> compile([user: user, account: account, link: link])

    new_email
    |> from(account)
    |> to(user)
    |> subject(subject_content)
    |> html_body(html_body_content)
    |> text_body(text_body_content)
  end

  def welcome_email(user, account, link) when is_nil(link) do
    subject_content =
      account.organization.settings
      |> lookup_content_for(["email_template", "registration", "subject"])
      |> compile([user: user, account: account])

    html_body_content =
      account.organization.settings
      |> lookup_content_for(["email_template", "registration", "mobile", "html_body"])
      |> compile([user: user, account: account])

    text_body_content =
      account.organization.settings
      |> lookup_content_for(["email_template", "registration", "mobile", "text_body"])
      |> compile([user: user, account: account])

    new_email
    |> from(account)
    |> to(user)
    |> subject(subject_content)
    |> html_body(html_body_content)
    |> text_body(text_body_content)
  end

  def dardy_new_registration_email(user, account) do
    new_email
    |> from(account)
    |> to(Application.fetch_env!(:sso, :recipient_email_notification))
    |> subject("#{account.app_name} - Notifica registazione utente")
    |> html_body("""
        <p>
        Nome agenzia - #{account.organization.name}<br />
        Nome utente - #{user.profile.first_name} #{user.profile.last_name}<br />
        Nome app - #{account.app_name}<br />
        Email - #{user.email}
        </p>
      """)
  end

  def account_new_registration_email(user, account) do
    new_email
    |> from(Application.fetch_env!(:sso, :recipient_email_notification))
    |> to(account)
    |> subject("#{account.app_name} - Notifica registazione utente")
    |> html_body("""
        <p>
        Spettabile #{account.organization.name}
        </p>
        <p>
        Si è registrato un nuovo utente:
        </p>
        <p>
        Nome utente - #{user.profile.first_name} #{user.profile.last_name}<br />
        Nome app - #{account.app_name}<br />
        Email - #{user.email}
        </p>
      """)
  end

  def password_reset_email(user, account, link) when is_binary(link) do
    subject_content =
      account.organization.settings
      |> lookup_content_for(["email_template", "password_reset", "subject"])
      |> compile([user: user, account: account, link: link])

    html_body_content =
      account.organization.settings
      |> lookup_content_for(["email_template", "password_reset", "web", "html_body"])
      |> compile([user: user, account: account, link: link])

    text_body_content =
      account.organization.settings
      |> lookup_content_for(["email_template", "password_reset", "web", "text_body"])
      |> compile([user: user, account: account, link: link])

    new_email
    |> from(account)
    |> to(user)
    |> subject(subject_content)
    |> html_body(html_body_content)
    |> text_body(text_body_content)
  end

  def password_reset_email(user, account, link) when is_nil(link) do
    subject_content =
      account.organization.settings
      |> lookup_content_for(["email_template", "password_reset", "subject"])
      |> compile([user: user, account: account])

    html_body_content =
      account.organization.settings
      |> lookup_content_for(["email_template", "password_reset", "mobile", "html_body"])
      |> compile([user: user, account: account])

    text_body_content =
      account.organization.settings
      |> lookup_content_for(["email_template", "password_reset", "mobile", "text_body"])
      |> compile([user: user, account: account])

    new_email
    |> from(account)
    |> to(user)
    |> subject(subject_content)
    |> html_body(html_body_content)
    |> text_body(text_body_content)
  end

  def courtesy_email(user, account) do
    subject_content =
      account.organization.settings
      |> lookup_content_for(["email_template", "verification", "subject"])
      |> compile([user: user, account: account])

    html_body_content =
      account.organization.settings
      |> lookup_content_for(["email_template", "verification", "html_body"])
      |> compile([user: user, account: account])

    text_body_content =
      account.organization.settings
      |> lookup_content_for(["email_template", "verification", "text_body"])
      |> compile([user: user, account: account])

    new_email
    |> from(account)
    |> to(user)
    |> subject(subject_content)
    |> html_body(html_body_content)
    |> text_body(text_body_content)
  end

  defp lookup_content_for(map, path) do
    map |> get_in(path) || "No content found for #{Enum.join(path, ".")}"
  end

  defp compile(content, bindings) do
    EEx.eval_string(content, bindings)
  end
end
