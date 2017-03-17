import m from 'mithril';
import stream from 'mithril/stream';
import _ from 'lodash';
import Backoffice from '../backoffice';
import Session from './session';

const BoUser = {
  url: '/bouser',
  model: {
    password: stream(""),
    new_password: stream(""),
    new_password_confirmation: stream("")
  },
  changePassword() {
    return m.request({
      method: "PUT",
      url: `${Backoffice.apiBaseUrl()}${this.url}/password`,
      data: {user: this.model},
      config: function(xhr) {
        xhr.setRequestHeader("accept", "application/json");
        xhr.setRequestHeader("Authorization", `${Backoffice.realm} ${Session.token()}`)
      }
    });
  }
};

export default BoUser;
