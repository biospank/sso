import m from 'mithril';
import signIn from './views/signin/sign_in';
import changePassword from './views/password/change_password';
import dashboard from './views/dashboard/dashboard';
import userView from './views/sso/user/view';
import userDetails from './views/sso/user/details';
import credentialsStep from './views/sso/credentials/credentials_step';
import organizationStep from './views/sso/credentials/organization_step';
import companyStep from './views/sso/credentials/company_step';

export default m.route(document.getElementById('app'), "/", {
  // Login routing
  "/": dashboard,
  "/signin": signIn,
  "/password/change": changePassword,
  "/sso/users": userView,
  "/sso/user/:id": userDetails,
  "/account": organizationStep,
  "/account/company": companyStep,
  "/account/credentials": credentialsStep
});
