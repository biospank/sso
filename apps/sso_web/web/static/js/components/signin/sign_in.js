import m from 'mithril'
import mixinLayout from '../layout/mixin_layout'

var content = function() {
  return [
    m('h2', {class: 'ui teal header'}, [
      m('.content', 'Log in to your account')
    ]),
    m('form', {class: 'ui large form'}, [
      m('.ui stacked segment', [
        m('.field', [
          m('.ui left icon input', [
            m('i', {class: 'user icon'}),
            m('input', {
              type: 'text',
              name: 'email',
              placeholder: 'E-mail address'
            })
          ])
        ]),
        m('.field', [
          m('.ui left icon input', [
            m('i', {class: 'lock icon'}),
            m('input', {
              type: 'password',
              name: 'password',
              placeholder: 'Password'
            })
          ])
        ]),
        m('.ui fluid large teal submit button', 'Login')
      ])
    ])
  ]
}


var signIn = {
  view: mixinLayout(content, 'login')
}

export default signIn;
