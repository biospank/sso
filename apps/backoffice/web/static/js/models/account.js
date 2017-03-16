import m from 'mithril';
import Backoffice from '../backoffice';
import Session from './session';

const Account = {
  url: '/account',
  all() {
    return m.request({
      // background: true,
      method: "GET",
      url: Backoffice.apiBaseUrl() + this.url,
      config: function(xhr) {
        xhr.setRequestHeader("accept", "application/json");
        xhr.setRequestHeader("Authorization", `${Backoffice.realm} ${Session.token()}`)
      }
    });
  },
  create(obj) {
    return m.request({
      method: "POST",
      data: { account: obj },
      url: Backoffice.apiBaseUrl() + this.url,
      config: function(xhr) {
        xhr.setRequestHeader("accept", "application/json");
        xhr.setRequestHeader("Authorization", `${Backoffice.realm} ${Session.token()}`)
      }
    });
  }
};

export default Account;
