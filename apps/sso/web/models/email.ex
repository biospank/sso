defmodule Sso.Email do
  use Bamboo.Phoenix, view: Sso.EmailView

  def welcome_email(user, account, link) when is_binary(link) do
    new_email
    |> from(account)
    |> to(user)
    |> subject("Sso - Registazione utente")
    |> html_body("""
        Registrazione utente #{account.organization.name}
        <br />
        <br />
        E' stata richiesta la registrazione utente tramite #{account.app_name}
        Usa il seguente link per attivare il tuo account.
        <br />
        <br />
        #{link}
        <br />
        <br />
        <small>
        Ignora questo messaggio se non hai effettuato tu questa richiesta
        </small>
      """)
  end

  def welcome_email(user, account, link) when is_nil(link) do
    new_email
    |> from(account)
    |> to(user)
    |> subject("Sso - Registazione utente")
    |> html_body("""
        Registrazione utente #{account.organization.name}
        <br />
        <br />
        E' stata richiesta la registrazione utente tramite #{account.app_name}
        Usa il seguente codice su #{account.app_name} per attivare il tuo account.
        <br />
        <br />
        Codice di attivazione: #{user.activation_code}
        <br />
        <br />
        <small>
        Ignora questo messaggio se non hai effettuato tu questa richiesta
        </small>
      """)
  end

  def dardy_new_registration_email(user, account) do
    new_email
    |> from(account)
    |> to(Application.fetch_env!(:sso, :recipient_email_notification))
    |> subject("Sso - Notifica registazione utente")
    |> html_body("""
        Registrazione utente #{account.organization.name}
        <br />
        <br />
        E' stata richiesta una registrazione utente tramite #{account.app_name} con il seguente indirizzo email:
        <br />
        <br />
        #{user.email}
        <br />
        <br />
      """)
  end

  def account_new_registration_email(user, account) do
    new_email
    |> from(Application.fetch_env!(:sso, :recipient_email_notification))
    |> to(account)
    |> subject("Sso - Notifica registazione utente")
    |> html_body("""
        Registrazione utente #{account.organization.name}
        <br />
        <br />
        E' stata richiesta una registrazione utente tramite #{account.app_name} con il seguente indirizzo email:
        <br />
        <br />
        #{user.email}
        <br />
        <br />
      """)
  end

  def password_reset_email(user, account, link) when is_binary(link) do
    new_email
    |> from(account)
    |> to(user)
    |> subject("Sso - Recupera password")
    |> html_body("""
        E' stata effettuata una richiesta di recupera password da questo account.
        <br />
        Usa il seguente link per procedere con la creazione di una nuova password.
        <br />
        <br />
        #{link}
        <br />
        <br />
        <small>
        Ignora questo messaggio se non hai effettuato tu questa richiesta
        </small>
      """)
  end

  def password_reset_email(user, account, link) when is_nil(link) do
    new_email
    |> from(account)
    |> to(user)
    |> subject("Sso - Recupera password")
    |> html_body("""
        E' stata effettuata una richiesta di recupera password da questo account.
        <br />
        Usa il seguente codice per procedere con la creazione di una nuova password.
        <br />
        <br />
        Codice cambio password: #{user.reset_code}
        <br />
        <br />
        <small>
        Ignora questo messaggio se non hai effettuato tu questa richiesta
        </small>
      """)
  end
end
