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
        class: "active step",
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
      m("button", { class: "ui right labeled teal icon button" }, [
        m("i", { class: "right arrow icon" }),
        "Avanti"
      ])
    ])
  ]
}

const credentialsStep = {
  view: mixinLayout(content)
}

export default credentialsStep;
