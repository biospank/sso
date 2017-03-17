import m from 'mithril';
import stream from 'mithril/stream';
import mixinLayout from '../layout/mixin_layout';
import textField from '../../components/text_field';
import loadingButton from '../../components/loading_button';
import BoUser from '../../models/bo_user';
import Session from '../../models/session';

const content = ({state}) => {
  return [
    m(".ui two column centered grid", [
      m(".column", [
        m('.ui raised teal p-all-side-30 segment', [
          m('h3', { class: "ui teal header mb-30 weight-light" }, 'Modifica Password'),
          m('form.ui form error', [
            m(textField, {
              type: 'password',
              name: 'password',
              id: 'password',
              placeholder: 'Vecchia Password',
              icon: 'lock',
              oninput: m.withAttr("value", state.model.password),
              error: state.errors()['password']
            }),
            m(textField, {
              type: 'password',
              name: 'new_password',
              id: 'new_password',
              placeholder: 'Nuova Password',
              icon: 'lock',
              oninput: m.withAttr("value", state.model.new_password),
              error: state.errors()['new_password']
            }),
            m(textField, {
              type: 'password',
              name: 'new_password_confirmation',
              id: 'new_password_confirmation',
              placeholder: 'Conferma Password',
              icon: 'lock',
              oninput: m.withAttr("value", state.model.new_password_confirmation),
              error: state.errors()['new_password_confirmation']
            }),
            m(loadingButton, {
              action: state.changePassword,
              label: 'Modifica',
              style: 'ui fluid teal submit basic button large weight-light mt-30'
            }),
          ])
        ])
      ])
    ])
  ]
};

const changePassword = {
  oninit(vnode) {
    vnode.state.model = BoUser.model;
    vnode.state.errors = stream({});

    vnode.state.changePassword = () => {
      return BoUser.changePassword().then((data) => {
        Session.reset();
        m.route.set("/signin");
      }, (e) => {
        vnode.state.errors(JSON.parse(e.message).errors);
      })
    }
  },
  view: mixinLayout(content)
}

export default changePassword;
