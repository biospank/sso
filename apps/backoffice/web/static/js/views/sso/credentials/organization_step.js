import m from 'mithril';
import stream from 'mithril/stream';
import _ from 'lodash';
import mixinLayout from '../../layout/mixin_layout';
import menuStep from '../../sso/credentials/menu_step';
import Organization from '../../../models/organization';
import AccountWidzard from '../../../models/account_widzard';
import loadingButton from '../../../components/loading_button';

const content = ({state}) => {
  return m(".account_component", [
    m(menuStep, { active: 1 }),
    m(".ui center aligned bottom attached segment p-all-side-50 segment", [
      m("h2", { class: "ui icon header teal mb-20" }, [
        m("i", { class: "circular sitemap icon" }),
        "Scegli Organizzazione"
      ]),
      m(".ui stackable two column centered grid", [
        m(".column", [
          m(".ui fluid selection dropdown", {
            className: (state.errors()["orgId"] ? "error" : ""),
            oncreate: function(vnode) {
              $('.ui.dropdown').dropdown();
            }
          }, [
            m("input", {
              type: "hidden",
              name: "orgId",
              value: AccountWidzard.model.orgId(),
              onchange: (event) => {
                let currentValue = _.toNumber(event.target.value);

                AccountWidzard.model.orgId(currentValue);

                if(currentValue !== -1) {
                  AccountWidzard.model.orgName("");
                  AccountWidzard.model.orgEmail("");
                }
              }
            }),
            m("i", { class: "dropdown icon" }),
            m(".text", AccountWidzard.model.orgLabel),
            m(".menu", [
              state.organizations.map((org) => {
                return m('.item', {
                  "data-value": org.id,
                  className: (org.id === AccountWidzard.model.orgId() ? "active selected" : ""),
                  onclick: (event) => {
                    AccountWidzard.model.orgLabel(event.target.outerText);
                  }
                }, org.name);
              })
            ])
          ]),
          m(".ui basic error pointing prompt label transition ", {
            className: (state.errors()["orgId"] ? "visible" : "hidden")
          }, m('p', state.errors()["orgId"]))
        ])
      ]),
      // m('p', JSON.stringify(AccountWidzard.model)),
      m(".ui horizontal divider mtb-50", "oppure"),
      m("h2", { class: "mt-0 mb-30" }, "Creane una nuova"),
      m(".ui form mb-20", [
        m(".ui stackable two column centered grid", [
          m(".column", [
            m(".field", {className: state.errors()["name"] ? "error" : ""}, [
              m("label", "Nome Organizzazione"),
              m(".mb-20", [
                m(".ui input fluid", [
                  m("input", {
                    type: "text",
                    name: "orgName",
                    value: AccountWidzard.model.orgName(),
                    oninput: m.withAttr('value', AccountWidzard.model.orgName),
                    placeholder: "Inserisci nome Organizzazione",
                    readonly: (AccountWidzard.model.orgId() !== -1)
                  })
                ]),
                m(".ui basic error pointing prompt label transition ", {
                  className: (state.errors()["name"] ? "visible" : "hidden")
                }, m('p', state.errors()["name"]))
              ])
            ]),
            m(".field", {className: state.errors()["ref_email"] ? "error" : ""}, [
              m("label", "Email di riferimento"),
              m(".mb-30", [
                m(".ui input fluid ", [
                  m("input", {
                    type: "email",
                    name: "orgEmail",
                    value: AccountWidzard.model.orgEmail(),
                    oninput: m.withAttr('value', AccountWidzard.model.orgEmail),
                    placeholder: "Inserisci email di riferimento",
                    readonly: (AccountWidzard.model.orgId() !== -1)
                  })
                ]),
                m(".ui basic error pointing prompt label transition", {
                  className: (state.errors()["ref_email"] ? "visible" : "hidden")
                }, m('p', state.errors()["ref_email"]))
              ])
            ])
          ])
        ])
      ]),
      m(loadingButton, {
        action: state.validateOrganization,
        label: 'Avanti',
        style: 'ui right labeled teal icon basic button'
      }, [
        m("i", { class: "right arrow icon" })
      ])
    ])
  ])
}

const organizationStep = {
  oninit(vnode) {
    this.organizations = [];
    this.errors = stream({});

    this.getAllOrganizations = () => {
      return Organization.all().then((response) => {
        this.organizations = _.concat([{id: -1, name: 'Nessuna di queste'}], response.organizations);
      }, (response) => {})
    };

    this.validateOrganization = () => {
      this.errors({});

      if(AccountWidzard.model.orgId() === -1) {
        return Organization.validate({
          name: AccountWidzard.model.orgName(),
          ref_email: AccountWidzard.model.orgEmail()
        }).then((data) => {
          m.route.set("/account/company");
        }, (e) => {
          this.errors(JSON.parse(e.message).errors);
        })
      } else {
        return new Promise(function(resolve, reject) {
          setTimeout(function() {
            m.route.set("/account/company");
          }, 500)
        })
      }
    };

    this.getAllOrganizations();
  },
  view: mixinLayout(content)
}

export default organizationStep;
