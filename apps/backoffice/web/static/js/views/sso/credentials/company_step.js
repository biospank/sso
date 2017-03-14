import m from 'mithril';
import mixinLayout from '../../layout/mixin_layout';

const content = () => {
  return m(".account_component", [
    m(".ui three top attached steps", [
      m(".step", [
        m("i", { class: "sitemap icon teal" }),
        m(".content", [
          m(".title", "Organizzazione"),
          m(".description", "Scegli o crea una nuova Unità Organizzativa")
        ])
      ]),
      m(".step active", [
        m("i", { class: "users icon teal" }),
        m(".content", [
          m(".title", "Agenzia"),
          m(".description", "Crea una nuova Agenzia")
        ])
      ]),
      m(".step", [
        m("i", { class: "privacy icon teal" }),
        m(".content", [
          m(".title", "Credenziali"),
          m(".description", "Conferma le credenziali")
        ])
      ])
    ]),
    m(".ui center aligned bottom attached segment p-all-side-50 segment", [
      m("h2", { class: "ui icon header teal mb-20" }, [
        m("i", { class: "circular users icon" }),
        "Crea Agenzia"
      ]),
      // m("h2", { class: "mt-0 mb-20" }, "Crea Agenzia"),
      m(".ui form mb-30", [
        m(".ui stackable two column centered grid", [
          m(".column", [
            m(".field mb-20", [
              m("label", "Nome Agenzia"),
              m(".ui input fluid", [
                m("input", { type: "text", name: "agency", value: "", placeholder: "Inserisci nome Agenzia" })
              ])
            ]),
            m(".field mb-20", [
              m("label", "Email di riferimento"),
              m(".ui input fluid", [
                m("input", { type: "email", name: "email", value: "", placeholder: "Inserisci email" })
              ])
            ])
          ])
        ])
      ]),
      m("div", [
        m("a", {
          class: "ui left labeled teal icon button mb-10",
          href: "/account",
          oncreate: m.route.link
        }, [
          m("i", { class: "left arrow icon" }),
          "Indietro"
        ]),
        m("a", {
          class: "ui right labeled teal icon button mb-10",
          href: "/account/credentials",
          oncreate: m.route.link
        }, [
          m("i", { class: "right arrow icon" }),
          "Avanti"
        ])
      ])
    ])
  ])
}

const companyStep = {
  view: mixinLayout(content)
}

export default companyStep;
