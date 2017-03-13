import m from 'mithril';
import mixinLayout from '../../layout/mixin_layout';

const content = () => {
  return [
    m(".ui steps", [
      m("a", {
        href: "/account",
        oncreate: m.route.link,
        class: "active step"
      }, [
        m("i", { class: "truck icon" }),
        m(".content", [
          m(".title", "Title"),
          m(".description", "Organizzazione")
        ])
      ]),
      m("a", {
        class: "step",
        href: "/account/company",
        oncreate: m.route.link
      }, [
        m("i", { class: "truck icon" }),
        m(".content", [
          m(".title", "Title"),
          m(".description", "Agenzia")
        ])
      ]),
      m("a", {
        class: "step",
        href: "/account/credentials",
        oncreate: m.route.link
      }, [
        m("i", { class: "truck icon" }),
        m(".content", [
          m(".title", "Title"),
          m(".description", "Credenziali")
        ])
      ])
    ]),
    m(".ui center aligned bottom attached segment p-all-side-50 segment", [
      m("h2", { class: "ui icon header teal mb-20" }, [
        m("i", { class: "circular sitemap icon" }),
        "Scegli Organizzazione"
      ]),
      m(".ui fluid selection dropdown mb-30", {
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
      ]),
      m(".ui horizontal divider mtb-50", "oppure"),
      m("h2", { class: "mt-0" }, "Creane una nuova"),
      m(".ui two column centered grid", [
        m(".column", [
          m(".field", [
            m(".ui input fluid mb-30", [
              m("input", { type: "text", name: "organization", value: "", placeholder: "Inserisci nome Organizzazione" })
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
  ]
}

const organizationStep = {
  view: mixinLayout(content)
}

export default organizationStep;
