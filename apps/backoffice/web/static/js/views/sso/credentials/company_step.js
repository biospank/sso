import m from 'mithril';
import mixinLayout from '../../layout/mixin_layout';
import menuStep from '../../sso/credentials/menu_step';

const content = () => {
  return m(".account_component", [
    m(menuStep, { active: 2 }),
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
