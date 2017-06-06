defmodule Backoffice.EmailPreView do
  use Backoffice.Web, :view

  def render("create.json", %{email: email}) do
    %{
      subject: email.subject,
      html_body: email.html_body,
      text_body: email.text_body # String.replace(email.text_body, "\n", "<br>")
    }
  end
end
