import m from 'mithril';
import stream from 'mithril/stream';
import mixinLayout from '../../layout/mixin_layout';
import User from '../../../models/user';
import loadingButton from '../../../components/loading_button';

const content = ({state}) => {
  if(state.user) {
    return m('', [
      m("h2", { class: "ui teal header" }, "Cambio Email"),
      m("span", { class: "ui orange label" }, `${state.user.profile.first_name} ${state.user.profile.last_name} (${state.user.email})` ),
      m("div", { class: "ui padded segment teal" }, [
        m('form.ui form error', [
          m(".required field", {className: state.errors()["new_email"] ? "error" : ""}, [
            m("label", "Nuovo indirizzo email"),
            m(".ui left icon input", [
              m("input", {
                type: 'email',
                name: 'new_email',
                id: 'new_email',
                placeholder: 'Nuova mail',
                oninput: m.withAttr("value", User.email_change_model.new_email),
              }),
              m("i.at icon", {className: state.errors()["new_email"] ? "red" : "teal"})
            ]),
            m(".ui basic error pointing prompt label transition ", {
              className: (state.errors()["new_email"] ? "visible" : "hidden")
            }, m('p', state.errors()["new_email"]))
          ]),
          m(".required field", {className: state.errors()["new_email_confirmation"] ? "error" : ""}, [
            m("label", "Conferma nuovo indirizzo email"),
            m(".ui left icon input", [
              m("input", {
                type: 'email',
                name: 'new_email_confirmation',
                id: 'new_email_confirmation',
                placeholder: 'Conferma nuova email',
                oninput: m.withAttr("value", User.email_change_model.new_email_confirmation),
              }),
              m("i.at icon", {className: state.errors()["new_email_confirmation"] ? "red" : "teal"})
            ]),
            m(".ui basic error pointing prompt label transition ", {
              className: (state.errors()["new_email_confirmation"] ? "visible" : "hidden")
            }, m('p', state.errors()["new_email_confirmation"]))
          ]),
          m(loadingButton, {
            action: state.changeEmail,
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

const changeEmail = {
  oninit({attrs}) {
    this.user = null;
    this.errors = stream({});

    this.changeEmail = () => {
      return User.changeEmail(this.user).then((data) => {
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

export default changeEmail;
