import m from 'mithril';
import mixinLayout from '../../layout/mixin_layout';

const content = () => {
  return [
    m(".ui steps", [
      m("a", {
        href: "/account",
        oncreate: m.route.link,
        class: "step"
      }, [
        m("i", { class: "truck icon" }),
        m(".content", [
          m(".title", "Title"),
          m(".description", "Organizzazione")
        ])
      ]),
      m("a", {
        class: "active step",
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
      m("h2", { class: "mt-0" }, "Crea Agenzia"),
      m(".ui two column centered grid", [
        m(".column", [
          m(".field", [
            m(".ui input fluid mb-30", [
              m("input", { type: "text", name: "agency", value: "", placeholder: "Inserisci nome Agenzia" })
            ])
          ])
        ])
      ]),
      m("a", {
        class: "ui right labeled teal icon button",
        href: "/account/credentials",
        oncreate: m.route.link
      }, [
        m("i", { class: "right arrow icon" }),
        "Avanti"
      ])
    ])
  ]
}

const companyStep = {
  view: mixinLayout(content)
}

export default companyStep;
