import m from 'mithril';
import stream from 'mithril/stream';
import _ from 'lodash';
import Backoffice from '../backoffice';
import Session from './session';

const User = {
  url: '/users',
  filters: {
    name: stream(""),
    email: stream("")
  },
  list: stream(undefined),
  pageInfo: {},
  all: function(params) {
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
