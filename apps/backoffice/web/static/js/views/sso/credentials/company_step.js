import m from 'mithril';
import stream from 'mithril/stream';
import _ from 'lodash';
import mixinLayout from '../../layout/mixin_layout';
import menuStep from '../../sso/credentials/menu_step';
import Account from '../../../models/account';
import AccountWidzard from '../../../models/account_widzard';
import CustomField from '../../../models/custom_field'
import loadingButton from '../../../components/loading_button';

const content = ({state}) => {
  return m(".account_component", [
    m(menuStep, { active: 2 }),
    m(".ui center aligned bottom attached segment p-all-side-50 segment", [
      m("h2", { class: "ui icon header teal mb-20" }, [
        m("i", { class: "circular users icon" }),
        "Crea App"
      ]),
      m(".ui form mb-30", [
        m(".ui stackable two column centered grid", [
          m(".column", [
            m(".required field", {className: state.errors()["app_name"] ? "error" : ""}, [
              m("label", "Nome App/Sito"),
              m(".mb-20", [
                m(".ui input fluid", [
                  m("input", {
                    type: "text",
                    name: "accountName",
                    value: AccountWidzard.model.accountName(),
                    oninput: m.withAttr('value', AccountWidzard.model.accountName),
                    placeholder: "Inserisci nome App"
                  })
                ]),
                m(".ui basic error pointing prompt label transition ", {
                  className: (state.errors()["app_name"] ? "visible" : "hidden")
                }, m('p', state.errors()["app_name"]))
              ])
            ]),
            m(".field", {className: state.errors()["ref_email"] ? "error" : ""}, [
              m("label", "Email di riferimento"),
              m(".mb-20", [
                m(".ui input fluid", [
                  m("input", {
                    type: "email",
                    name: "orgEmail",
                    value: AccountWidzard.model.accountEmail(),
                    oninput: m.withAttr('value', AccountWidzard.model.accountEmail),
                    placeholder: "Inserisci email di riferimento"
                  })
                ]),
                m(".ui basic error pointing prompt label transition ", {
                  className: (state.errors()["ref_email"] ? "visible" : "hidden")
                }, m('p', state.errors()["ref_email"]))
              ])
            ])
          ])
        ])
      ]),
      // m('p', JSON.stringify(AccountWidzard.model)),
      m("div", [
        m("a", {
          class: "ui left labeled teal icon basic button mb-10",
          href: "/account",
          oncreate: m.route.link
        }, [
          m("i", { class: "left arrow icon" }),
          "Indietro"
        ]),
        m(loadingButton, {
          type: 'a',
          action: state.createAccount,
          style: 'ui positive basic button mb-10'
        }, [
          m("i", { class: "checkmark icon" }),
          "Conferma"
        ])
      ])
    ])
  ])
}

const companyStep = {
  oninit(vnode) {
    this.errors = stream({});

    this.createAccount = () => {
      this.errors({});

      if(AccountWidzard.model.orgId() === -1) {
        this.account = {
          org: {
            name: AccountWidzard.model.orgName(),
            ref_email: AccountWidzard.model.orgEmail(),
            settings: {
              custom_fields: CustomField.defaults
            }
          },
          app_name: AccountWidzard.model.accountName(),
          ref_email: AccountWidzard.model.accountEmail()
        }
      } else {
        this.account = {
          org_id: AccountWidzard.model.orgId(),
          app_name: AccountWidzard.model.accountName(),
          ref_email: AccountWidzard.model.accountEmail()
        }
      }

      return Account.create(this.account).then((response) => {
        AccountWidzard.model.accountAccessKey(response.account.access_key);
        AccountWidzard.model.accountSecretKey(response.account.secret_key);
        m.route.set("/account/credentials");
      }, (e) => {
        this.errors(JSON.parse(e.message).errors);
      })
    };

    if((AccountWidzard.model.orgId() === -1) && (_.trim(AccountWidzard.model.orgName()) === '')) {
      m.route.set("/account");
    }

  },
  view: mixinLayout(content)
}

export default companyStep;
