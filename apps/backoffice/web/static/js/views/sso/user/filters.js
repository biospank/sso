import m from 'mithril';
import _ from 'lodash';
import User from '../../../models/user';
import Account from '../../../models/account';
import Organization from '../../../models/organization';
import CustomField from '../../../models/custom_field';

const userFilters = {
  oninit(vnode) {
    this.accounts = [];
    this.organizations = [];
    this.errors = {};
    this.showLoader = vnode.attrs.showLoader;

    this.accountResponse = (response) => {
      this.accounts = _.concat([{id: "", app_name: 'Tutte le app'}], response.accounts);
    };

    this.getAllAccounts = (organization) => {
      if(organization) {
        return Account.allBy(organization).then(this.accountResponse, (response) => {})
      } else {
        return Account.all().then(this.accountResponse, (response) => {})
      }
    };

    this.getAllOrganizations = () => {
      return Organization.all().then((response) => {
        this.organizations = _.concat([{id: "", name: 'Tutte le organizzazioni'}], response.organizations);
      }, (response) => {})
    };

    this.getAllUsers = (params) => {
      this.showLoader(true);
      return User.all(params).then(this.unwrapSuccess).then((response) => {
        User.list(response.users);
        this.showLoader(false);
      }, function(response) {
        this.errors = response.errors;
      })
    };

    this.exportUsers = (params) => {
      window.location.href = User.exportUrl(params);
    };

    this.unwrapSuccess = (response) => {
      if(response) {
        User.pageInfo = {
          totalEntries: response.total_entries,
          totalPages: response.total_pages,
          pageNumber: response.page_number
        };

        return response;
      }
    };

    this.hiddenFields = (field) => {
      return _.includes(CustomField.hidden, field.name)
    };

    this.getAllAccounts();
    this.getAllOrganizations();
  },
  view({state}) {
    return m("form", { class: "ui form segment mb-40" }, [
      m(".four fields", [
        m(".field", [
          m(".ui fluid selection dropdown", {
            oncreate: function(vnode) {
              $('.ui.dropdown').dropdown();
            }
          }, [
            m("input", {
              type: "hidden",
              name: "organization",
              value: User.filters.organization(),
              onchange(event) {
                User.filters.organization(event.target.value);
                state.getAllAccounts(User.filters.organization());
              }
            }),
            m("i", { class: "dropdown icon" }),
            m(".text", User.filters.organizationLabel()),
            m(".menu", [
              state.organizations.map((organization) => {
                return m('.item', {
                  "data-value": organization.id,
                  className: (organization.id === User.filters.organization() ? "active selected" : ""),
                  onclick: (event) => {
                    User.filters.organizationLabel(event.target.outerText);
                  }
                }, organization.name);
              })
            ])
          ])
        ]),
        m(".field", [
          m(".ui fluid selection dropdown", {
            oncreate: function(vnode) {
              $('.ui.dropdown').dropdown();
            }
          }, [
            m("input", {
              type: "hidden",
              name: "account",
              value: User.filters.account(),
              onchange: m.withAttr("value", User.filters.account)
            }),
            m("i", { class: "dropdown icon" }),
            m(".text", User.filters.accountLabel()),
            m(".menu", [
              state.accounts.map((account) => {
                return m('.item', {
                  "data-value": account.id,
                  className: (account.id === User.filters.account() ? "active selected" : ""),
                  onclick: (event) => {
                    User.filters.accountLabel(event.target.outerText);
                  }
                }, account.app_name);
              })
            ])
          ])
        ]),
        m(".field", [
          m(".ui fluid selection dropdown", {
            oncreate: function(vnode) {
              $('.ui.dropdown').dropdown();
            }
          }, [
            m("input", {
              type: "hidden",
              name: "status",
              value: User.filters.status(),
              onchange: m.withAttr("value", User.filters.status)
            }),
            m("i", { class: "dropdown icon" }),
            m(".text", User.filters.statusLabel()),
            m(".menu", [
              User.filterStatuses.map((filter) => {
                return m('.item', {
                  "data-value": filter.statusValue,
                  className: (filter.statusValue === User.filters.status() ? "active selected" : ""),
                  onclick: (event) => {
                    User.filters.statusLabel(event.target.outerText);
                  }
                }, filter.statusLabel);
              })
            ])
          ])
        ]),
        m(".field", [
          m("button.ui submit teal basic button full", {
            onclick: (event) => {
              event.preventDefault();
              this.exportUsers({filters: User.filters});
            },
            className: (User.filters.organization() === "") ? "disabled" : ""
          }, [
            m("i.icon download"),
            "Esporta"
          ])
        ])
      ]),
      m(".four fields", [
        m(".field", [
          m(".ui fluid selection dropdown", {
            className: (User.filters.organization() === "") ? "disabled" : "",
            oncreate: function(vnode) {
              $('.ui.dropdown').dropdown();
            }
          }, [
            m("input", {
              type: "hidden",
              name: "field",
              value: User.filters.field(),
              onchange: m.withAttr("value", User.filters.field)
            }),
            m("i", { class: "dropdown icon" }),
            m(".text", (User.filters.organization() === "") ? "" : User.filters.fieldLabel()),
            m(".menu",
              _.reject(
                _.get(
                  _.find(
                    state.organizations,
                    ['name', User.filters.organizationLabel()]
                  ),
                  'settings.custom_fields',
                  []
                ),
                state.hiddenFields
              ).map((filter) => {
                return m('.item', {
                  "data-value": filter.name,
                  className: (filter.name === User.filters.field() ? "active selected" : ""),
                  onclick: (event) => {
                    User.filters.fieldLabel(event.target.outerText);
                  }
                }, filter.label);
              })
            )
          ])
        ]),
        m(".field", [
          m("input", {
            oninput: m.withAttr("value", User.filters.term),
            value: User.filters.term,
            type: "text",
            placeholder: "Termine di ricerca"
          })
        ]),
        m(".field", [
          m("input", {
            oninput: m.withAttr("value", User.filters.email),
            value: User.filters.email,
            type: "email",
            placeholder: "Filtra per Email"
          })
        ]),
        m(".field", [
          m("button", {
            onclick: (event) => {
              event.preventDefault();
              this.getAllUsers({filters: User.filters});
            },
            class: "ui submit teal basic button full"
          }, [
            m("i.icon search"),
            "Filtra"
          ])
        ])
      ])
    ]);
  }
}

export default userFilters;
