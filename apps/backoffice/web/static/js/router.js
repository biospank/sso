import m from 'mithril';
import signIn from './views/signin/sign_in';
import changePassword from './views/password/change_password';
import dashboard from './views/dashboard/dashboard';
import userView from './views/sso/user/view';
import userDetails from './views/sso/user/details';
import changeUserPassword from './views/sso/user/change_password';
import changeUserEmail from './views/sso/user/change_email';
import credentialsStep from './views/sso/credentials/credentials_step';
import organizationStep from './views/sso/credentials/organization_step';
import companyStep from './views/sso/credentials/company_step';
import Session from './models/session';
import templateView from './views/sso/email/template';
import indexView from './views/sso/custom_fields/index';

export default m.route(document.getElementById('app'), "/", {
  // Login routing
  "/": {
    onmatch() {
      if(Session.isExpired())
        m.route.set("/signin");
      else
        return userView;
    }
  },
  "/signin": signIn,
  "/password/change": {
    onmatch() {
      if(Session.isExpired())
        m.route.set("/signin");
      else
        return changePassword;
    }
  },
  "/sso/users": {
    onmatch() {
      if(Session.isExpired())
        m.route.set("/signin");
      else
        return userView;
    }
  },
  "/sso/user/:id": {
    onmatch() {
      if(Session.isExpired())
        m.route.set("/signin");
      else
        return userDetails;
    }
  },
  "/sso/user/:id/password/change": {
    onmatch() {
      if(Session.isExpired())
        m.route.set("/signin");
      else
        return changeUserPassword;
    }
  },
  "/sso/user/:id/email/change": {
    onmatch() {
      if(Session.isExpired())
        m.route.set("/signin");
      else
        return changeUserEmail;
    }
  },
  "/account": {
    onmatch() {
      if(Session.isExpired())
        m.route.set("/signin");
      else
        return organizationStep;
    }
  },
  "/account/company": {
    onmatch() {
      if(Session.isExpired())
        m.route.set("/signin");
      else
        return companyStep;
    }
  },
  "/account/credentials": {
    onmatch() {
      if(Session.isExpired())
        m.route.set("/signin");
      else
        return credentialsStep;
    }
  },
  "/sso/template": {
    onmatch() {
      if(Session.isExpired())
        m.route.set("/signin");
      else
        return templateView;
    }
  },
  "/sso/custom-fields": {
    onmatch() {
      if(Session.isExpired())
        m.route.set("/signin");
      else
        return indexView;
    }
  }
});
