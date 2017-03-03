import m from 'mithril';
import Session from '../../models/session';

const mixinLayout = (content, layout) => {
  const layouts = {
    login(content) {
      return [
        m('.ui three column centered grid container', [
          m('.column', [
            content
          ])
        ])
      ]
    },
    standard(content) {
      return [
        m('.ui secondary pointing menu', [
          m('.item', [
            m('img.big', {src: '/images/phoenix.png'})
          ]),
          m('a.item teal', {
            className: (m.route.get() === '/') ? 'active' : '',
            href: "/",
            oncreate: m.route.link
          }, 'Dashboard'),
          m('a.item teal', {
            className: (m.route.get() === '/sso/users') ? 'active' : '',
            href: "/sso/users",
            oncreate: m.route.link
          }, 'Utenti'),
          m('a.item teal', 'Configurazione'),
          m('.right menu', [
            m('a.ui item teal', {
              onclick(event) {
                event.preventDefault();
                Session.reset();
                m.route.set("/signin");
              }
            }, 'Esci')
          ])
        ]),
        m('.ui container', [
          m('.ui segment', [
            content
          ])
        ])
      ]
    }
  };

  return (vnode) => {
    return layouts[(layout || "standard")](content(vnode));
  };
};

export default mixinLayout;
