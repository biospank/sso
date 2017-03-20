import m from 'mithril';
import Session from '../../models/session';
import AccountWidzard from '../../models/account_widzard';

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
          m("a", { class: "header item", href: '/', oncreate: m.route.link }, [
            m("img", { src: '/images/logo.png', class: "logo ui", width: "100" })
          ]),
          m('a.item teal', {
            className: (m.route.get() === '/') ? 'active' : '',
            href: "/",
            oncreate: m.route.link
          }, 'Dashboard'),
          m(".ui simple dropdown link item", [
            m("span", { class: "text" }, "Single Sign On"),
            m("i", { class: "dropdown icon" }),
            m(".menu", [
              m("a.item teal", {
                className: (m.route.get() === '/sso/users') ? 'active' : '',
                href: "/sso/users",
                oncreate: m.route.link
              }, "Utenti"),
              m("a", {
                onclick() {
                  AccountWidzard.resetModel()
                  m.route.set('/account')
                },
                // href: "/account",
                // oncreate: m.route.link,
                class: "item"
              }, "Account")
            ])
          ]),
          m('.right menu', [
            m(".ui simple dropdown link item p-all-side-15", {
              config: function(element, isInit, context) {
                if(!isInit)
                  $(".ui.dropdown").dropdown("show");
              }
            }, [
              m(".text", [
                m("img", { src: "/images/user.png", class: "ui medium circular image" })
              ]),
              m("i", { class: "dropdown icon" }),
              m(".menu", [
                // m(".header", "Profilo"),
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
