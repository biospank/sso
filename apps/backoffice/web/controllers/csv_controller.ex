defmodule Backoffice.CsvController do
  use Backoffice.Web, :controller

  alias Sso.{User, Organization}

  def user_export(conn, params) do
    case Guardian.decode_and_verify(params["token"]) do
      { :ok, _claims } ->
        organization =
          Organization
          |> Backoffice.Repo.get!(params["filters"]["organization"])

        query_filter = case params["filters"] do
          nil ->
            User
          %{"field" => field, "term" => term, "email" => email, "status" => status, "account" => account, "organization" => organization} ->
            User
            |> User.filter_profile_by(field, term)
            |> User.filter_by(:email, email)
            |> User.filter_by_status(status)
            |> User.filter_by_account(account)
            |> User.filter_by_organization(organization)
        end

        filtered_users =
          query_filter
          |> User.order_by(:inserted_at)
          |> Ecto.Query.preload(:organization)
          |> Ecto.Query.preload(:account)
          |> Backoffice.Repo.all

        conn
        |> put_resp_content_type("text/csv")
        |> put_resp_header("content-disposition", "attachment; filename=\"export_#{Chronos.now |> Chronos.epoch_time}.csv\"")
        |> send_resp(200, Sso.UserView.csv_content(organization, filtered_users))
      { :error, _reason } ->
        conn
        |> put_status(498)
        |> render(Backoffice.ErrorView, "498.html")
    end
  end
end
