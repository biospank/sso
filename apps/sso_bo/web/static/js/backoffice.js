const Backoffice = {
  domain: window.location.origin,
  apiBaseUrl: function() {
    return this.domain + "/sso/admin/api";
  },
  realm: "Dardy"
};

export default Backoffice;
