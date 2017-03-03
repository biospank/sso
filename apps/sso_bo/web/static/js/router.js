import m from 'mithril';
import signIn from './views/signin/sign_in';
import dashboard from './views/dashboard/dashboard';

export default m.route(document.getElementById('app'), "/", {
  // Login routing
  "/": signIn,
  "/dashboard": dashboard
});
