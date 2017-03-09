import m from 'mithril';
import _ from 'lodash';
import Backoffice from '../backoffice';
import Session from './session';

const User = {
  url: '/users',
  all: function(params, args) {
    return m.request({
      method: "GET",
      url: Backoffice.apiBaseUrl() +
        this.url + "?" + m.buildQueryString(params),
      config: function(xhr) {
        xhr.setRequestHeader("accept", "application/json");
        xhr.setRequestHeader("Authorization", `${Backoffice.realm} ${Session.token()}`)
      }
    });
  }
};

export default User;
