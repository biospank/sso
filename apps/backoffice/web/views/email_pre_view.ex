defmodule Backoffice.EmailPreView do
  use Backoffice.Web, :view

  alias Bamboo.SentEmail

  def render("create.json", %{email: email}) do
    IO.inspect(String.replace(email.text_body, "\n", "<br>"))
    %{
      preview_id: SentEmail.get_id(email),
      subject: email.subject,
      html_body: email.html_body,
      text_body: String.replace(email.text_body, "\n", "<br>")
    }
  end
end
