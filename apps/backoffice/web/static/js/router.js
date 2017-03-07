import m from 'mithril';
import signIn from './views/signin/sign_in';
import dashboard from './views/dashboard/dashboard';
import userView from './views/sso/user_view';

export default m.route(document.getElementById('app'), "/", {
  // Login routing
  "/": dashboard,
  "/signin": signIn,
  "/sso/users": userView
});
