import m from 'mithril';
import stream from 'mithril/stream';
import mixinLayout from '../../layout/mixin_layout';
import User from '../../../models/user';
import loadingButton from '../../../components/loading_button';

const content = ({state}) => {
  if(state.user) {
    return m('', [
      m("h2", { class: "ui teal header" }, "Cambio Password"),
      m("span", { class: "ui orange label" }, `${state.user.profile.first_name} ${state.user.profile.last_name} (${state.user.email})` ),
      m("div", { class: "ui padded segment teal" }, [
        m('form.ui form error', [
          m(".required field", {className: state.errors()["new_password"] ? "error" : ""}, [
            m("label", "Nuova password"),
            m(".ui left icon input", [
              m("input", {
                type: state.visibleChar() ? 'text' : 'password',
                name: 'new_password',
                id: 'new_password',
                placeholder: 'Nuova password',
                oninput: m.withAttr("value", User.password_change_model.new_password),
              }),
              m("i.lock icon", {className: state.errors()["new_password"] ? "red" : "teal"})
            ]),
            m(".ui basic error pointing prompt label transition ", {
              className: (state.errors()["new_password"] ? "visible" : "hidden")
            }, m('p', state.errors()["new_password"]))
          ]),
          m(".required field", {className: state.errors()["new_password_confirmation"] ? "error" : ""}, [
            m("label", "Conferma nuova password"),
            m(".ui left icon input", [
              m("input", {
                type: state.visibleChar() ? 'text' : 'password',
                name: 'new_password_confirmation',
                id: 'new_password_confirmation',
                placeholder: 'Conferma nuova password',
                oninput: m.withAttr("value", User.password_change_model.new_password_confirmation),
                error: state.errors()['new_password_confirmation']
              }),
              m("i.lock icon", {className: state.errors()["new_password_confirmation"] ? "red" : "teal"})
            ]),
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
            style: 'ui teal submit basic button'
          }),
          m("button", {
            className: "ui basic button",
            type: 'button',
            href: `/sso/user/${state.user.id}`,
            oncreate: m.route.link
          }, 'Annulla')
        ])
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
