import m from 'mithril';
import mixinLayout from '../../layout/mixin_layout';

const content = () => {
  return m(".account_component", [
    m(".ui three top attached steps", [
      m(".step active", [
        m("i", { class: "sitemap icon teal" }),
        m(".content", [
          m(".title", "Organizzazione"),
          m(".description", "Scegli o crea una nuova Unità Organizzativa")
        ])
      ]),
      m(".step", [
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
        m("i", { class: "circular sitemap icon" }),
        "Scegli Organizzazione"
      ]),
      m(".ui stackable two column centered grid", [
        m(".column", [
          m(".ui fluid selection dropdown", {
            oncreate: function(vnode) {
              $('.ui.dropdown').dropdown();
            }
          }, [
            m("input", { type: "hidden", name: "gender" }),
            m("i", { class: "dropdown icon" }),
            m(".default text", "Default"),
            m(".menu", [
              m(".item", { "data-value": "1" }, "Item 1"),
              m(".item", { "data-value": "1" }, "Item 2"),
              m(".item", { "data-value": "1" }, "Item 3")
            ])
          ])
        ])
      ]),
      m(".ui horizontal divider mtb-50", "oppure"),
      m("h2", { class: "mt-0 mb-30" }, "Creane una nuova"),
      m(".ui form mb-20", [
        m(".ui stackable two column centered grid", [
          m(".column", [
            m(".field", [
              m("label", "Nome Organizzazione"),
              m(".ui input fluid mb-20", [
                m("input", { type: "text", name: "organization", value: "", placeholder: "Inserisci nome Organizzazione" })
              ])
            ]),
            m(".field", [
              m("label", "Email di riferimento"),
              m(".ui input fluid mb-30", [
                m("input", { type: "email", name: "email", value: "", placeholder: "Inserisci email" })
              ])
            ])
          ])
        ])
      ]),
      m("a", {
        class: "ui right labeled teal icon button",
        href: "/account/company",
        oncreate: m.route.link
       }, [
        m("i", { class: "right arrow icon" }),
        "Avanti"
      ])
    ])
  ])
}

const organizationStep = {
  view: mixinLayout(content)
}

export default organizationStep;
