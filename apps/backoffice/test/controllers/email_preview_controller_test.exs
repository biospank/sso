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

      assert json_response(post_conn, 201)["html_body"] =~ "Mario Rossi"
      assert json_response(post_conn, 201)["text_body"] =~ "Mario Rossi"
    end

    test "html template compilation error", %{conn: conn} do
      post_conn = post(conn, email_preview_path(conn, :create), %{
          subject: "preview subject",
          html_body: """
            Gentile <%= unknown_object %>
          """,
          text_body: ""
        }
      )

      assert json_response(post_conn, 422)["errors"] == %{
        "message" => "Errore di compilazione: undefined function unknown_object/0",
        "context" => "html_body"
      }
    end

    test "text template compilation error", %{conn: conn} do
      post_conn = post(conn, email_preview_path(conn, :create), %{
          subject: "preview subject",
          html_body: "",
          text_body: """
            Gentile <%= unknown_object %>
          """
        }
      )

      assert json_response(post_conn, 422)["errors"] == %{
        "message" => "Errore di compilazione: undefined function unknown_object/0",
        "context" => "text_body"
      }
    end

    test "html template key error", %{conn: conn} do
      post_conn = post(conn, email_preview_path(conn, :create), %{
          subject: "preview subject",
          html_body: """
            Gentile <%= user.unknown_attribute %>
          """,
          text_body: ""
        }
      )

      assert json_response(post_conn, 422)["errors"] == %{
        "message" => "Errore di compilazione: chiave `unknown_attribute` non trovata",
        "context" => "html_body"
      }
    end

    test "text template key error", %{conn: conn} do
      post_conn = post(conn, email_preview_path(conn, :create), %{
          subject: "preview subject",
          html_body: "",
          text_body: """
            Gentile <%= user.unknown_attribute %>
          """
        }
      )

      assert json_response(post_conn, 422)["errors"] == %{
        "message" => "Errore di compilazione: chiave `unknown_attribute` non trovata",
        "context" => "text_body"
      }
    end
  end
end
