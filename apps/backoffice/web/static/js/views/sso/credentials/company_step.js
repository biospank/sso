import m from 'mithril';
import stream from 'mithril/stream';
import _ from 'lodash';
import mixinLayout from '../../layout/mixin_layout';
import menuStep from '../../sso/credentials/menu_step';
import AccountWidzard from '../../../models/account_widzard';

const content = ({state}) => {
  return m(".account_component", [
    m(menuStep, { active: 2 }),
    m(".ui center aligned bottom attached segment p-all-side-50 segment", [
      m("h2", { class: "ui icon header teal mb-20" }, [
        m("i", { class: "circular users icon" }),
        "Crea Agenzia"
      ]),
      m(".ui form mb-30", [
        m(".ui stackable two column centered grid", [
          m(".column", [
            m(".field mb-20", {className: state.errors()["accountName"] ? "error" : ""}, [
              m("label", "Nome Agenzia"),
              m(".ui input fluid", [
                m("input", {
                  type: "text",
                  name: "accountName",
                  value: AccountWidzard.model.accountName(),
                  oninput: m.withAttr('value', AccountWidzard.model.accountName),
                  placeholder: "Inserisci nome Agenzia"
                })
              ])
            ]),
            m(".ui basic error pointing prompt label transition ", {
              className: (state.errors()["accountName"] ? "visible" : "hidden")
            }, m('p', state.errors()["accountName"])),
            m(".field mb-20", {className: state.errors()["accountEmail"] ? "error" : ""}, [
              m("label", "Email di riferimento"),
              m(".ui input fluid", [
                m("input", {
                  type: "email",
                  name: "orgEmail",
                  value: AccountWidzard.model.accountEmail(),
                  oninput: m.withAttr('value', AccountWidzard.model.accountEmail),
                  placeholder: "Inserisci email di riferimento"
                })
              ])
            ]),
            m(".ui basic error pointing prompt label transition ", {
              className: (state.errors()["accountEmail"] ? "visible" : "hidden")
            }, m('p', state.errors()["accountEmail"]))
          ])
        ])
      ]),
      m('p', JSON.stringify(AccountWidzard.model)),
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
          onclick() {
            state.errors({});

            if(_.trim(AccountWidzard.model.accountName()) === "") {
              state.errors({
                "accountName": "Nome agenzia obbligatorio"
              })
            }

            if(_.trim(AccountWidzard.model.orgEmail()) === "" &&
              _.trim(AccountWidzard.model.accountEmail()) === "") {
                state.errors(_.assign(state.errors(), {
                  "accountEmail": "La mail di riferimento è obbligatoria"
                }))
            }

            if(_.isEmpty(state.errors()))
              m.route.set("/account/credentials");

          }
        }, [
          m("i", { class: "right arrow icon" }),
          "Avanti"
        ])
      ])
    ])
  ])
}

const companyStep = {
  oninit(vnode) {
    this.errors = stream({});
  },
  view: mixinLayout(content)
}

export default companyStep;
