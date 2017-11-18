defmodule Sso.Email do
  use Bamboo.Phoenix, view: Sso.EmailView

  def welcome_template(user, account, link) when is_binary(link) do
    bindings = [user: user, account: account, link: link]

    with {:ok, subject_content} <- account.organization.settings
                                    |> lookup_content_for(["email_template", "registration", "subject"])
                                    |> compile(bindings),
         {:ok, html_body_content} <- account.organization.settings
                                      |> lookup_content_for(["email_template", "registration", "web", "html_body"])
                                      |> compile(bindings),
         {:ok, text_body_content} <- account.organization.settings
                                      |> lookup_content_for(["email_template", "registration", "web", "text_body"])
                                      |> compile(bindings)
    do
      email = new_email
        |> from(account)
        |> to(user)
        |> subject(subject_content)
        |> html_body(html_body_content)
        |> text_body(text_body_content)

      {:ok, email}
    else
      {:error, message} ->
        {:error, message}
    end
  end

  def welcome_template(user, account, link) when is_nil(link) do
    bindings = [user: user, account: account]

    with {:ok, subject_content} <- account.organization.settings
                                    |> lookup_content_for(["email_template", "registration", "subject"])
                                    |> compile(bindings),
         {:ok, html_body_content} <- account.organization.settings
                                      |> lookup_content_for(["email_template", "registration", "mobile", "html_body"])
                                      |> compile(bindings),
         {:ok, text_body_content} <- account.organization.settings
                                      |> lookup_content_for(["email_template", "registration", "mobile", "text_body"])
                                      |> compile(bindings)
    do
      email = new_email
        |> from(account)
        |> to(user)
        |> subject(subject_content)
        |> html_body(html_body_content)
        |> text_body(text_body_content)

      {:ok, email}
    else
      {:error, message} ->
        {:error, message}
    end
  end

  def dardy_new_registration_template(user, account) do
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

  def account_new_registration_template(user, account) do
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

  def password_reset_template(user, account, link) when is_binary(link) do
    bindings = [user: user, account: account, link: link]

    with {:ok, subject_content} <- account.organization.settings
                                    |> lookup_content_for(["email_template", "password_reset", "subject"])
                                    |> compile(bindings),
         {:ok, html_body_content} <- account.organization.settings
                                      |> lookup_content_for(["email_template", "password_reset", "web", "html_body"])
                                      |> compile(bindings),
         {:ok, text_body_content} <- account.organization.settings
                                      |> lookup_content_for(["email_template", "password_reset", "web", "text_body"])
                                      |> compile(bindings)
    do
      email = new_email
        |> from(account)
        |> to(user)
        |> subject(subject_content)
        |> html_body(html_body_content)
        |> text_body(text_body_content)

      {:ok, email}
    else
      {:error, message} ->
        {:error, message}
    end
  end

  def password_reset_template(user, account, link) when is_nil(link) do
    bindings = [user: user, account: account]

    with {:ok, subject_content} <- account.organization.settings
                                    |> lookup_content_for(["email_template", "password_reset", "subject"])
                                    |> compile(bindings),
         {:ok, html_body_content} <- account.organization.settings
                                      |> lookup_content_for(["email_template", "password_reset", "mobile", "html_body"])
                                      |> compile(bindings),
         {:ok, text_body_content} <- account.organization.settings
                                      |> lookup_content_for(["email_template", "password_reset", "mobile", "text_body"])
                                      |> compile(bindings)
    do
      email = new_email
        |> from(account)
        |> to(user)
        |> subject(subject_content)
        |> html_body(html_body_content)
        |> text_body(text_body_content)

      {:ok, email}
    else
      {:error, message} ->
        {:error, message}
    end
  end

  def email_address_change_template(recipient, user, account, link) when is_binary(link) do
    bindings = [user: user, account: account, link: link]

    with {:ok, subject_content} <- account.organization.settings
                                    |> lookup_content_for(["email_template", "email_change", "subject"])
                                    |> compile(bindings),
         {:ok, html_body_content} <- account.organization.settings
                                      |> lookup_content_for(["email_template", "email_change", "web", "html_body"])
                                      |> compile(bindings),
         {:ok, text_body_content} <- account.organization.settings
                                      |> lookup_content_for(["email_template", "email_change", "web", "text_body"])
                                      |> compile(bindings)
    do
      email = new_email
        |> from(account)
        |> to(recipient)
        |> subject(subject_content)
        |> html_body(html_body_content)
        |> text_body(text_body_content)

      {:ok, email}
    else
      {:error, message} ->
        {:error, message}
    end
  end

  def email_address_change_template(recipient, user, account, link) when is_nil(link) do
    bindings = [user: user, account: account]

    with {:ok, subject_content} <- account.organization.settings
                                    |> lookup_content_for(["email_template", "email_change", "subject"])
                                    |> compile(bindings),
         {:ok, html_body_content} <- account.organization.settings
                                      |> lookup_content_for(["email_template", "email_change", "mobile", "html_body"])
                                      |> compile(bindings),
         {:ok, text_body_content} <- account.organization.settings
                                      |> lookup_content_for(["email_template", "email_change", "mobile", "text_body"])
                                      |> compile(bindings)
    do
      email = new_email
        |> from(account)
        |> to(recipient)
        |> subject(subject_content)
        |> html_body(html_body_content)
        |> text_body(text_body_content)

      {:ok, email}
    else
      {:error, message} ->
        {:error, message}
    end
  end

  def courtesy_template(user, account) do
    bindings = [user: user, account: account]

    with {:ok, subject_content} <- account.organization.settings
                                    |> lookup_content_for(["email_template", "verification", "subject"])
                                    |> compile(bindings),
         {:ok, html_body_content} <- account.organization.settings
                                      |> lookup_content_for(["email_template", "verification", "html_body"])
                                      |> compile(bindings),
         {:ok, text_body_content} <- account.organization.settings
                                      |> lookup_content_for(["email_template", "verification", "text_body"])
                                      |> compile(bindings)
    do
      email = new_email
        |> from(account)
        |> to(user)
        |> subject(subject_content)
        |> html_body(html_body_content)
        |> text_body(text_body_content)

      {:ok, email}
    else
      {:error, message} ->
        {:error, message}
    end
  end

  def reminder_template(user, account, link) when is_binary(link) do
    bindings = [user: user, account: account, link: link]

    with {:ok, subject_content} <- account.organization.settings
                                    |> lookup_content_for(["email_template", "reminder", "subject"])
                                    |> compile(bindings),
         {:ok, html_body_content} <- account.organization.settings
                                      |> lookup_content_for(["email_template", "reminder", "web", "html_body"])
                                      |> compile(bindings),
         {:ok, text_body_content} <- account.organization.settings
                                      |> lookup_content_for(["email_template", "reminder", "web", "text_body"])
                                      |> compile(bindings)
    do
      email = new_email
        |> from(account)
        |> to(user)
        |> subject(subject_content)
        |> html_body(html_body_content)
        |> text_body(text_body_content)

      {:ok, email}
    else
      {:error, message} ->
        {:error, message}
    end
  end

  # actually mobile reminder is not used (see activation reminder)
  def reminder_template(user, account, link)  when is_nil(link) do
    bindings = [user: user, account: account]

    with {:ok, subject_content} <- account.organization.settings
                                    |> lookup_content_for(["email_template", "reminder", "subject"])
                                    |> compile(bindings),
         {:ok, html_body_content} <- account.organization.settings
                                      |> lookup_content_for(["email_template", "reminder", "mobile", "html_body"])
                                      |> compile(bindings),
         {:ok, text_body_content} <- account.organization.settings
                                      |> lookup_content_for(["email_template", "reminder", "mobile", "text_body"])
                                      |> compile(bindings)
    do
      email = new_email
        |> from(account)
        |> to(user)
        |> subject(subject_content)
        |> html_body(html_body_content)
        |> text_body(text_body_content)

      {:ok, email}
    else
      {:error, message} ->
        {:error, message}
    end
  end

  def preview(params)  do
    bindings = [
      user: params[:user],
      account: params[:account],
      link: params[:link]
    ]

    compiled_subject = compile(params[:subject], bindings)

    compiled_html_body = compile(params[:html_body], bindings)

    compiled_text_body = compile(params[:text_body], bindings)

    with {:ok, subject_content} <- compiled_subject,
         {:ok, html_body_content} <- compiled_html_body,
         {:ok, text_body_content} <- compiled_text_body
    do
      email = new_email
        |> from(params[:account])
        |> to(params[:user])
        |> subject(subject_content)
        |> html_body(html_body_content)
        |> text_body(text_body_content)

      {:ok, email}
    else
      {:error, _} ->
        email = new_email
          |> from(params[:account])
          |> to(params[:user])
          |> subject(elem(compiled_subject, 1))
          |> html_body(elem(compiled_html_body, 1))
          |> text_body(elem(compiled_text_body, 1))

        {:error, email}
    end
  end

  defp lookup_content_for(map, path) do
    map |> get_in(path) || "No content found for #{Enum.join(path, ".")}"
  end

  defp compile(content, bindings) do
    try do
      {:ok, EEx.eval_string(content, bindings)}
    rescue
      e in CompileError ->
        {:error, "Errore di compilazione: #{e.description}"}
      e in KeyError ->
        {:error, "Errore di compilazione: chiave `#{e.key}` non trovata"}
    end
  end
end
