defmodule Backoffice.EmailPreviewController do
  use Backoffice.Web, :controller

  alias Bamboo.SentEmail
  alias Sso.Crypto

  def create(conn, %{"subject" => subject, "html_body" => html_body, "text_body" => text_body}) do
    pushed_email =
      Sso.Email.preview(
        account: account_preview(),
        user: user_preview(),
        subject: subject,
        html_body: html_body,
        text_body: text_body,
        link: "http://mysite.com/registration?code=#{Crypto.random_string(32)}"
      ) |> SentEmail.push

    conn
    |> put_status(:created)
    |> render(Backoffice.EmailPreView, "create.json", %{email: pushed_email})
  end

  # def show(conn, %{"id" => email_id}) do
  #   case SentEmail.get(email_id) do
  #     nil ->
  #       conn
  #       |> send_resp(404, "<h1>Email not found</h1>")
  #     email ->
  #       conn
  #       |> send_resp(:ok, email.html_body)
  #   end
  # end

  defp account_preview() do
    %Sso.Account{
      app_name: "AccountPreview",
      ref_email: "account.preview@dardy.com",
      access_key: "skkIInbIIhikIOJ",
      secret_key: "jsdjBuGHUGBGuHUBubNJbuBJBjHjNBBJbnjBNJ",
      secret_hash: Comeonin.Bcrypt.hashpwsalt("jsdjBuGHUGBGuHUBubNJbuBJBjHjNBBJbnjBNJ"),
      active: true
    }
  end

  defp user_preview() do
    %Sso.User{
      email: "mario.rossi@example.com",
      profile: %Sso.Profile{
        first_name: "Mario",
        last_name: "Rossi",
        fiscal_code: "mrarss21s50h501z",
        date_of_birth: "1981-02-12",
        place_of_birth: "Roma",
        phone_number: "062277266",
        profession: "Pediatra",
        specialization: "Pediatria",
        board_member: "Medici",
        board_number: "3773662882",
        province_board: "Roma",
        employment: "Medico generico",
        sso_privacy_consent: true,
        privacy_consent: false,
        province_enployment: "Roma"
      }
    }
  end
end
