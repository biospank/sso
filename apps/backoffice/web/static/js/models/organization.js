import m from 'mithril';
import stream from 'mithril/stream';
import _ from 'lodash';
import Backoffice from '../backoffice';
import Session from './session';

const Organization = {
  url: '/organization',
  current: stream({}),
  choice: {
    id: stream(""),
    label: stream("")
  },
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
  validate(obj) {
    return m.request({
      method: "POST",
      data: { organization: obj },
      url: Backoffice.apiBaseUrl() + this.url,
      config: function(xhr) {
        xhr.setRequestHeader("accept", "application/json");
        xhr.setRequestHeader("Authorization", `${Backoffice.realm} ${Session.token()}`)
      }
    });
  },
  update() {
    return m.request({
      method: "PUT",
      data: { organization: this.current() },
      url: `${Backoffice.apiBaseUrl()}${this.url}/${this.current().id}`,
      config: function(xhr) {
        xhr.setRequestHeader("accept", "application/json");
        xhr.setRequestHeader("Authorization", `${Backoffice.realm} ${Session.token()}`)
      }
    });
  }
};

export default Organization;
