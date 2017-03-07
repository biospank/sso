import m from 'mithril';
import stream from 'mithril/stream';
import mixinLayout from '../layout/mixin_layout';
import textField from '../../components/text_field';
import feedbackButton from '../../components/feedback_button';
import Session from '../../models/session';

const content = ({state}) => {
  return [
    m('.ui raised padded segment', [
      m('h3.ui teal header', 'Accedi al backoffice'),
      m('.ui teal segment', [
        m('form.ui form error', [
          m(textField, {
            type: 'text',
            name: 'username',
            id: 'username',
            placeholder: 'Nome utente',
            icon: 'user',
            oninput: m.withAttr("value", state.model.username),
            error: state.errors()['username']
          }),
          m(textField, {
            type: 'password',
            name: 'password',
            id: 'password',
            placeholder: 'Password',
            icon: 'lock',
            oninput: m.withAttr("value", state.model.password),
            error: state.errors()['password']
          }),
          m('.inline field', [
            m('.ui checkbox', [
              m('input[type=checkbox]', {
                id: 'keep-signed',
                onclick: m.withAttr("checked", state.model.remember_me),
                checked: state.model.remember_me()
              }),
              m('label[for=keep-signed]', 'Ricordami per una settimana')
            ])
          ]),
          m(feedbackButton, {
            action: state.createSession,
            label: 'Login',
            feedbackLabel: 'Authenticating...',
            style: 'ui fluid teal submit button'
          })
        ])
      ])
    ])
  ]
}


const signIn = {
  oninit(vnode) {
    vnode.state.model = Session.model;
    vnode.state.errors = stream({});

    vnode.state.createSession = () => {
      // return new Promise(function(resolve, reject) {
      //   setTimeout(function() {
      //     resolve("hello")
      //   }, 1000)
      // })

      return Session.create().then((data) => {
        m.route.set("/dashboard");
      }, (e) => {
        vnode.state.errors(JSON.parse(e.message).errors);
      })
    }
  },
  view: mixinLayout(content, 'login')
}

export default signIn;
