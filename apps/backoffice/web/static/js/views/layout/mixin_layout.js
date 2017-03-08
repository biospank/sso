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
        m("nav", { class: "ui fixed menu" }, [
          m("a", { class: "header item" }, [
            m("img", { src: '/images/phoenix.png', class: "logo ui", width: "200" })
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
            m(".ui simple dropdown p-all-side-15", {
              config: function(element, isInit, context) {
                if(!isInit)
                  $(".ui.dropdown").dropdown("show");
              }
            }, [
              m(".text", [
                m("img", { src: "/images/user.png", class: "ui medium circular image" }),
                "Jenny Hess"
              ]),
              m("i", { class: "dropdown icon" }),
              m(".menu", [
                // m(".header", "Profilo"),
                m("a", { class: "item", "data-text": "exit" }, "Profilo"),
                m("a", {
                  href: "/password/change",
                  oncreate: m.route.link,
                  class: "item",
                  "data-text": "exit"
                }, "Cambia Password"),
                m("a", {
                  class: "item",
                  "data-text": "exit",
                  onclick(event) {
                    event.preventDefault();
                    Session.reset();
                    m.route.set("/signin");
                  }
                }, "Esci")
              ])
            ])
          ])
        ]),
        m('.ui container mt-60', [
          m('.ui pt-50', [
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
