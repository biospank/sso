import m from 'mithril';
import mixinLayout from '../../layout/mixin_layout';
import menuStep from '../../sso/credentials/menu_step';
import AccountWidzard from '../../../models/account_widzard';

const content = () => {
  return m(".account_component", [
    m(menuStep, { active: 3 }),
    m(".ui center aligned bottom attached segment p-all-side-50 segment", [
      m("h2", { class: "ui icon header teal mb-20" }, [
        m("i", { class: "circular privacy icon" }),
        `Credenziali API per '${AccountWidzard.model.accountName()}'`
      ]),
      // m("h2", { class: "mt-0 mb-20" }, "Credenziali generate"),
      m(".ui form mb-30", [
        m(".ui stackable two column centered grid", [
          m(".column", [
            m(".field mb-20", [
              m("label", { class: "" }, "Access key"),
              m(".ui input fluid", [
                m("input", {
                  type: "text",
                  name: "agency",
                  value: AccountWidzard.model.accountAccessKey(),
                  readonly: "",
                  class: "text-uppercase"
                })
              ])
            ]),
            m(".field mb-20", [
              m("label", { class: "" }, "Secret key"),
              m(".ui input fluid", [
                m("input", {
                  type: "text",
                  name: "agency",
                  value: AccountWidzard.model.accountSecretKey(),
                  readonly: "",
                  class: "text-uppercase" })
              ])
            ])
          ])
        ])
      ]),
      m("div", [
        m("a", {
          class: "ui teal basic button",
          onclick() {
            AccountWidzard.resetModel()
            m.route.set('/account')
          }
        }, [
          m("i", { class: "privacy icon" }),
          "Crea nuovo account"
        ])
      ])
    ])
  ])
}

const credentialsStep = {
  view: mixinLayout(content)
}

export default credentialsStep;
