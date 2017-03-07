const Backoffice = {
  domain: window.location.origin,
  apiBaseUrl: function() {
    return this.domain + "/backoffice/api";
  },
  realm: "Dardy"
};

export default Backoffice;
