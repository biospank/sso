defmodule Backoffice.EmailPreviewControllerTest do
  use Backoffice.ConnCase
  use Bamboo.Test, shared: :true

  setup %{conn: conn} do
    # to avoid ** (DBConnection.OwnershipError) cannot find ownership process for #PID<0.674.0>.
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Sso.Repo)
    Ecto.Adapters.SQL.Sandbox.mode(Sso.Repo, {:shared, self()})

    conn = put_req_header(conn, "accept", "application/json")

    {:ok, conn: conn}
  end

  describe "email preview endpoint" do
    test "requires user authentication", %{conn: conn} do
      Enum.each([
          post(conn, email_preview_path(conn, :create), %{}),
          # get(conn, email_preview_path(conn, :show, 1))
        ], fn conn ->
          assert json_response(conn, 498)["errors"] == %{
            "message" => "Richiesta autorizzazione (token non valido)"
          }
          assert conn.halted
      end)
    end
  end

  describe "email preview controller" do
    setup %{conn: conn} do
      user = insert_bo_user()
      {:ok, jwt, _} = Guardian.encode_and_sign(user)

      conn = put_req_header(conn, "authorization", "Dardy #{jwt}")

      {:ok, conn: conn, user: user}
    end

    test "create a preview", %{conn: conn} do
      post_conn = post(conn, email_preview_path(conn, :create), %{
          subject: "preview subject",
          html_body: """
            Gentile <%= user.profile.first_name %> <%= user.profile.last_name %>
          """,
          text_body: """
            Gentile <%= user.profile.first_name %> <%= user.profile.last_name %>
          """
        }
      )

      assert json_response(post_conn, 201)["preview_id"]
      assert json_response(post_conn, 201)["preview_text_body"] =~ "Gentile"
    end

    test "show a preview", %{conn: conn} do
      post_conn = post(conn, email_preview_path(conn, :create), %{
          subject: "preview subject",
          html_body: """
            Gentile <%= user.profile.first_name %> <%= user.profile.last_name %>
          """,
          text_body: """
            Gentile <%= user.profile.first_name %> <%= user.profile.last_name %>
          """
        }
      )

      conn = put_req_header(conn, "accept", "text/html")

      get_conn = get(conn, email_preview_path(conn, :show, json_response(post_conn, 201)["preview_id"]))

      assert json_response(get_conn, 200)["email"] == %Bamboo.Email{}
    end
  end
end
