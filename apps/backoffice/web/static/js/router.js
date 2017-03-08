import m from 'mithril';
import signIn from './views/signin/sign_in';
import changePassword from './views/password/change_password';
import dashboard from './views/dashboard/dashboard';
import userView from './views/sso/user/view';
import userDetails from './views/sso/user/details';
import credentials from './views/sso/credentials/index';

export default m.route(document.getElementById('app'), "/", {
  // Login routing
  "/": dashboard,
  "/signin": signIn,
  "/password/change": changePassword,
  "/sso/users": userView,
  "/sso/user/:code": userDetails,
  "/credentials": credentials
});
