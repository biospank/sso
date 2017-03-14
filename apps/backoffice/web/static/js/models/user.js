import m from 'mithril';
import stream from 'mithril/stream';
import _ from 'lodash';
import Backoffice from '../backoffice';
import Session from './session';

const User = {
  url: '/user',
  filters: {
    name: stream(""),
    email: stream("")
  },
  list: stream(undefined),
  pageInfo: {},
  all(params) {
    return m.request({
      method: "GET",
      url: Backoffice.apiBaseUrl() +
        this.url + "?" + m.buildQueryString(params),
      config: function(xhr) {
        xhr.setRequestHeader("accept", "application/json");
        xhr.setRequestHeader("Authorization", `${Backoffice.realm} ${Session.token()}`)
      }
    });
  },
  toggle(user) {
    let action = '';

    if(user.active)
      action = 'deactivate';
    else
      action = 'activate';

    return m.request({
      method: "PUT",
      url: `${Backoffice.apiBaseUrl()}${this.url}/${user.id}/${action}`,
      config: function(xhr) {
        xhr.setRequestHeader("accept", "application/json");
        xhr.setRequestHeader("Authorization", `${Backoffice.realm} ${Session.token()}`)
      }
    });
  },
  auth(user) {
    return m.request({
      method: "PUT",
      url: `${Backoffice.apiBaseUrl()}${this.url}/${user.id}/authorize`,
      config: function(xhr) {
        xhr.setRequestHeader("accept", "application/json");
        xhr.setRequestHeader("Authorization", `${Backoffice.realm} ${Session.token()}`)
      }
    });
  }
};

export default User;
