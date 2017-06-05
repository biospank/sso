defmodule Backoffice.EmailPreviewController do
  use Backoffice.Web, :controller

  def create(conn, %{"subject" => subject, "html_body" => html_body, "text_body" => text_body}) do
    result = Sso.Email.preview(
      account: Sso.Account.preview(),
      user: Sso.User.preview(),
      subject: subject,
      html_body: html_body,
      text_body: text_body,
      link: "http://mysite.com/registration?code=#{Sso.User.preview() |> Map.get(:activation_code)}"
    )

    case result do
      {:error, message, context} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Backoffice.ErrorView, :"422", errors: %{message: message, context: context})
      {:ok, compiled_email} ->
        conn
        |> put_status(:created)
        |> render(Backoffice.EmailPreView, "create.json", %{email: compiled_email})
    end
  end
end
