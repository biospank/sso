defmodule Sso.Email do
  use Bamboo.Phoenix, view: Sso.EmailView

  def welcome_email(user, account, link) when is_binary(link) do
    new_email
    |> from(account)
    |> to(user)
    |> subject("#{account.app_name} - Richiesta registrazione")
    |> html_body("""
        Gentile #{user.profile.first_name} #{user.profile.last_name}
        <br />
        è stata richiesta la registrazione al sito #{account.app_name}.
        <br />
        <br />
        Per completare l'iscrizione e attivare il suo account segua questo link:
        <br />
        <br />
        #{link}
        <br />
        <br />
        Le ricordiamo che l'iscrizione è temporanea ed entro <strong>24</strong> ore riceverà una mail
        di conferma del suo nuovo account. Una volta ricevuta la mail di conferma
        potrà accedere a tutti i servizi realizzati da Takeda Italia S.p.A. che supportano
        questo servizio, utilizzando sempre le stesse credenziali.
        <br />
        <br />
        Per eventuali informazioni o chiarimenti contatti il nostro servizio di <a href="mailto:customercare@itakacloud.com">customercare</a>
        <br />
        <br />
        <small>
        Ignori questo messaggio se non ha effettuato questa richiesta
        </small>
        <br />
        <br />
        Cordiali saluti
        <br />
        Takeda Italia S.p.A.
        <br />
        <br />
        #{disclaimer(account)}
      """)
  end

  def welcome_email(user, account, link) when is_nil(link) do
    new_email
    |> from(account)
    |> to(user)
    |> subject("#{account.app_name} - Richiesta registrazione")
    |> html_body("""
        Gentile #{user.profile.first_name} #{user.profile.last_name}
        <br />
        E' stata richiesta la registrazione al #{account.app_name}.
        <br />
        <br />
        Per completare l'iscrizione inserisca il seguente codice di attivazione nell'app #{account.app_name}
        <br />
        <br />
        #{user.activation_code}
        <br />
        <br />
        Le ricordiamo che l'iscrizione è temporanea ed entro <strong>24</strong> ore riceverà una mail
        di conferma del suo nuovo account. Una volta ricevuta la mail di conferma
        potrà accedere a tutti i servizi realizzati da Takeda Italia S.p.A. che supportano
        questo servizio, utilizzando sempre le stesse credenziali.
        <br />
        <br />
        Per eventuali informazioni o chiarimenti contatti il nostro servizio di <a href="mailto:customercare@itakacloud.com">customercare</a>
        <br />
        <br />
        <small>
        Ignori questo messaggio se non ha effettuato questa richiesta
        </small>
        <br />
        <br />
        Cordiali saluti
        <br />
        Takeda Italia S.p.A.
        <br />
        <br />
        #{disclaimer(account)}
      """)
  end

  def dardy_new_registration_email(user, account) do
    new_email
    |> from(account)
    |> to(Application.fetch_env!(:sso, :recipient_email_notification))
    |> subject("#{account.app_name} - Notifica registazione utente")
    |> html_body("""
        <br />
        <br />
        Nome agenzia - #{account.organization.name}
        Nome utente - #{user.profile.first_name} #{user.profile.last_name}
        Nome app - #{account.app_name}
        Email - #{user.email}
        <br />
        <br />
      """)
  end

  def account_new_registration_email(user, account) do
    new_email
    |> from(Application.fetch_env!(:sso, :recipient_email_notification))
    |> to(account)
    |> subject("#{account.app_name} - Notifica registazione utente")
    |> html_body("""
        Spettabile #{account.organization.name}
        <br />
        <br />
        Si è registrato un nuovo utente:
        <br />
        <br />
        Nome utente - #{user.profile.first_name} #{user.profile.last_name}
        Nome app - #{account.app_name}
        Email - #{user.email}
        <br />
        <br />
      """)
  end

  def password_reset_email(user, account, link) when is_binary(link) do
    new_email
    |> from(account)
    |> to(user)
    |> subject("#{account.app_name} - Recupera password")
    |> html_body("""
        E' stata effettuata una richiesta di recupero password per il suo account.
        Per procedere alla creazione di una nuova password segua questo link:
        <br />
        <br />
        #{link}
        <br />
        <br />
        Per eventuali informazioni o chiarimenti contatti il nostro servizio di
        <a href="mailto:customercare@itakacloud.com">customercare</a>
        <br />
        <br />
        <small>
        Ignori questo messaggio se non ha effettuato questa richiesta
        </small>
        <br />
        <br />
        Cordiali saluti
        Takeda Italia Spa
        <br />
        <br />
        #{disclaimer(account)}
      """)
  end

  def password_reset_email(user, account, link) when is_nil(link) do
    new_email
    |> from(account)
    |> to(user)
    |> subject("#{account.app_name} - Recupera password")
    |> html_body("""
        E' stata effettuata una richiesta di recupero password per il suo account.
        Per procedere alla creazione di una nuova password inserisca il seguente
        codice di attivazione nell'app #{account.app_name}:
        <br />
        <br />
        #{user.reset_code}
        <br />
        <br />
        Per eventuali informazioni o chiarimenti contatti il nostro servizio di
        <a href="mailto:customercare@itakacloud.com">customercare</a>
        <br />
        <br />
        <small>
        Ignori questo messaggio se non ha effettuato questa richiesta
        </small>
        <br />
        <br />
        Cordiali saluti
        Takeda Italia Spa
        <br />
        <br />
        #{disclaimer(account)}
      """)
  end

  def courtesy_email(user, account) do
    new_email
    |> from(account)
    |> to(user)
    |> subject("#{account.app_name} - Conferma registrazione")
    |> html_body("""
        Gentile #{user.profile.first_name} #{user.profile.last_name}
        <br />
        La sua registrazione a #{account.app_name} è confermata.
        <br />
        <br />
        Le ricordiamo che adesso potrà accedere a tutti i servizi realizzati da
        Takeda Italia S.p.A. che supportano questo servizio, utilizzando sempre le
        stesse credenziali.
        <br />
        <br />
        Per eventuali informazioni o chiarimenti contatti il nostro servizio di
        <a href="mailto:customercare@itakacloud.com">customercare</a>
        <br />
        <br />
        <small>
        Ignori questo messaggio se non ha effettuato questa richiesta
        </small>
        <br />
        <br />
        Cordiali saluti
        <br />
        Takeda Italia S.p.A.
        <br />
        <br />
        #{disclaimer(account)}
      """)
  end

  defp disclaimer(account) do
    """
      <small>
        <strong>SSO Takeda</strong>
      </small>
      <br />
      <br />
      <small>
        SSO Takeda è un sistema di autenticazione centralizzato per web e mobile
        realizzato in esclusiva per Takeda Italia S.p.A.
      </small>
      <br />
      <br />
      <small>
        Il sistema ha lo scopo di consentire la registrazione dei medici e operatori
        sanitari ai progetti digital promossi da Takeda (app/siti) e consentire
        la loro autenticazione come operatori professionali.
      </small>
      <br />
      <br />
      <small>
        La gestione del riconoscimento dell'operatore della salute e la trasmissione
        e archiviazione delle relative chiavi di accesso e dei dati personali del professionista
        della salute avviene mediante la piattaforma SSO Takeda nel rispetto dei requisiti
        richiesti da:
        - Il Ministero della Salute (Circolare Min. San. - Dipartimento Valutazione Farmaci
        e Farmacovigilanza n° 800.I/15/1267 del 22 marzo 2000)
        - Codice della Privacy (D.Lgs 30/06/2003 n. 196) sulla tutela dei dati personali
      </small>
      <br />
      <br />
    """
  end
end
