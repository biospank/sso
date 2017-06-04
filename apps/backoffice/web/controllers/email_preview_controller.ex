defmodule Backoffice.EmailPreviewController do
  use Backoffice.Web, :controller

  def create(conn, %{"subject" => subject, "html_body" => html_body, "text_body" => text_body}) do
    compiled_email = Sso.Email.preview(
        account: Sso.Account.preview(),
        user: Sso.User.preview(),
        subject: subject,
        html_body: html_body,
        text_body: text_body,
        link: "http://mysite.com/registration?code=#{Sso.User.preview() |> Map.get(:activation_code)}"
      )

    conn
    |> put_status(:created)
    |> render(Backoffice.EmailPreView, "create.json", %{email: compiled_email})
  end
end
