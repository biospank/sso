import m from 'mithril';
import _ from 'lodash';
import stream from 'mithril/stream';
import Backoffice from '../backoffice';
import store from 'store2';

const Session = {
  url: '/signin',
  extract(xhr, xhrOptions) {
    if(xhr.status === 201) {
      Session.token(
        _.last(
          _.split(
            xhr.getResponseHeader("Authorization"),
            " "
          )
        )
      );
      Session.expires(xhr.getResponseHeader("x-expires"));
    }

    return xhr.response;

  },
  token(value) {
    if (arguments.length)
      store.set('token', value)

    return store.get('token')
  },
  expires(value) {
    if (arguments.length)
      store.set('expires', value)

    return store.get('expires')
  },
  isValid() {
    if(_.isEmpty(this.token())) {
      return false;
    } else {
      var unixTs = _.parseInt(this.expires());

      if(_.isNaN(unixTs)) {
        return false;
      } else {
        return (unixTs*1000) > _.now();
      }
    }
  },
  isExpired() {
    return !this.isValid();
  },
  model: {
    username: stream(""),
    password: stream(""),
    remember_me: stream(true)
  },
  create(args) {
    return m.request({
      method: "POST",
      url: Backoffice.apiBaseUrl() + this.url,
      data: { user: this.model },
      config: function(xhr) {
        xhr.setRequestHeader("accept", "application/json");
        xhr.setRequestHeader("content-type", "application/json");
      },
      extract: this.extract
    });
  },
  reset() {
    this.token(null);
    this.model.username("");
    this.model.password("");
  }
};

export default Session;
