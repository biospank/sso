const Backoffice = {
  domain: window.location.origin,
  apiBaseUrl: function() {
    return this.domain + "/backoffice/api";
  },
  exportBaseUrl: function() {
    return this.domain + "/backoffice";
  },
  realm: "Dardy"
};

export default Backoffice;
