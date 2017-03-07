import m from 'mithril';
import signIn from './views/signin/sign_in';
import dashboard from './views/dashboard/dashboard';
import userView from './views/sso/user_view';
import userDetails from './views/sso/user_details';

export default m.route(document.getElementById('app'), "/", {
  // Login routing
  "/": dashboard,
  "/signin": signIn,
  "/sso/users": userView,
  "/sso/user/:code": userDetails
});
