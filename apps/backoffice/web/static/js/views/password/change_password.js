import m from 'mithril';
import mixinLayout from '../layout/mixin_layout';
import textField from '../../components/text_field';
import feedbackButton from '../../components/feedback_button';

const content = () => {
  return [
    m(".ui two column centered grid", [
      m(".column", [
        m('.ui raised teal p-all-side-30 segment', [
          m('h3', { class: "ui teal header mb-30 weight-light" }, 'Modifica Password'),
          m('form.ui form error', [
            m(textField, {
              type: 'password',
              name: 'old_psw',
              id: 'old_psw',
              placeholder: 'Vecchia Password',
              icon: 'lock'
            }),
            m(textField, {
              type: 'password',
              name: 'new_psw',
              id: 'new_psw',
              placeholder: 'Nuova Password',
              icon: 'lock'
            }),
            m(textField, {
              type: 'password',
              name: 'psw_confermation',
              id: 'psw_confermation',
              placeholder: 'Conferma Password',
              icon: 'lock'
            }),
            m(feedbackButton, {
              label: 'Modifica',
              feedbackLabel: 'Authenticating...',
              style: 'ui fluid teal submit basic button large weight-light mt-30'
            })
          ])
        ])
      ])
    ])
  ]
};

const changePassword = {
  view: mixinLayout(content)
}

export default changePassword;
