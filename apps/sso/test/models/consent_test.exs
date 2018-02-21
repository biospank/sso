defmodule Sso.ConsentTest do
  use Sso.ModelCase

  @valid_attrs %{
    app_id: 1,
    app_name: "app name",
    privacy: true
  }

  describe "update app consents" do
    test "create new account consent if privacy consent == true||'true'||'1'" do
      account = %Sso.Account{id: 5, app_name: "new account"}
      app_consents = []
      Enum.each([true, "true", "1"], fn(value) ->
        result = Sso.Consent.update_app_consents(app_consents, account, %{"privacy_consent" => value})
        refute Enum.empty?(result)
      end)
    end

    test "create new account consent if account is not present" do
      account = %Sso.Account{id: 5, app_name: "new account"}
      app_consents = []
      result = Sso.Consent.update_app_consents(app_consents, account, %{"privacy_consent" => true})
      assert length(result) == 1
    end

    test "app consents does not change if the account is present" do
      account = %Sso.Account{id: 5, app_name: "new account"}
      account_consent = %{"app_id" => 5, "app_name" => "new account", "privacy" => true}
      app_consents = [account_consent]
      result = Sso.Consent.update_app_consents(app_consents, account, %{"privacy_consent" => true})
      assert length(result) == 1
    end

    test "add new account consent if the account is not present" do
      account = %Sso.Account{id: 3, app_name: "new account"}
      account_consent = %{"app_id" => 5, "app_name" => "account name", "privacy" => true}
      app_consents = [account_consent]
      result = Sso.Consent.update_app_consents(app_consents, account, %{"privacy_consent" => true})
      assert length(result) == 2
    end
  end
end
