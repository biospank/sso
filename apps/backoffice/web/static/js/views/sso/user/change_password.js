import m from 'mithril';
import stream from 'mithril/stream';
import _ from 'lodash';
import format from 'date-fns/format';
import mixinLayout from '../../layout/mixin_layout';
import textField from '../../../components/text_field';
import User from '../../../models/user';
import loadingButton from '../../../components/loading_button';

const content = ({state}) => {
  if(state.user) {
    return m("div", { class: "ui segment teal p-all-side-30" }, [
      m('form.ui form error', [
        m(".required field", {className: state.errors()["name"] ? "error" : ""}, [
          m("label", "Nuova password"),
          m("input", {
            type: state.visibleChar() ? 'text' : 'password',
            name: 'new_password',
            id: 'new_password',
            placeholder: 'Nuova password',
            icon: 'lock',
            oninput: m.withAttr("value", User.model.new_password),
          }),
          m(".ui basic error pointing prompt label transition ", {
            className: (state.errors()["new_password"] ? "visible" : "hidden")
          }, m('p', state.errors()["new_password"]))
        ]),
        m(".required field", {className: state.errors()["name"] ? "error" : ""}, [
          m("label", "Conferma nuova password"),
          m("input", {
            type: state.visibleChar() ? 'text' : 'password',
            name: 'new_password_confirmation',
            id: 'new_password_confirmation',
            placeholder: 'Conferma nuova password',
            icon: 'lock',
            oninput: m.withAttr("value", User.model.new_password_confirmation),
            error: state.errors()['new_password_confirmation']
          }),
          m(".ui basic error pointing prompt label transition ", {
            className: (state.errors()["new_password_confirmation"] ? "visible" : "hidden")
          }, m('p', state.errors()["new_password_confirmation"]))
        ]),
        m('.field', [
          m('.ui checkbox', [
            m('input[type=checkbox]', {
              id: 'show-chars',
              onclick: m.withAttr("checked", state.visibleChar),
              checked: state.visibleChar()
            }),
            m('label[for=show-chars]', {style: 'cursor: pointer;'}, 'mostra caratteri')
          ])
        ]),
        m(loadingButton, {
          action: state.changePassword,
          label: 'Conferma',
          style: 'ui teal submit basic button large weight-light mt-30'
        }),
        m("button", {
          className: "ui teal basic button large weight-light mt-30",
          type: 'button',
          href: `/sso/user/${state.user.id}`,
          oncreate: m.route.link
        }, 'Annulla')
      ])
    ]);
  } else {
    return m('');
  }
};

const changePassword = {
  oninit({attrs}) {
    this.user = null;
    this.errors = stream({});
    this.visibleChar = stream(false);

    this.changePassword = () => {
      return User.changePassword(this.user).then((data) => {
        m.route.set(`/sso/user/${this.user.id}`);
      }, (e) => {
        this.errors(JSON.parse(e.message).errors);
      })
    };

    this.getUser = (id) => {
      return User.get(id).then((response) => {
        this.user = response.user;
      }, (response) => {});
    };

    this.getUser(attrs.id);
  },
  view: mixinLayout(content)
}

export default changePassword;
