import m from 'mithril'
import signIn from "./components/signin/sign_in";

export default m.route(document.getElementById('app'), "/", {
  // Login routing
  "/": signIn

  // "/signin": signIn

});
