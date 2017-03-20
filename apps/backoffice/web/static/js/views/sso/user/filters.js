import m from 'mithril';
import _ from 'lodash';
import User from '../../../models/user';
import Account from '../../../models/account';

const userFilters = {
  oninit(vnode) {
    this.accounts = [];
    this.errors = {};
    this.showLoader = vnode.attrs.showLoader;

    this.getAllAccounts = () => {
      return Account.all().then((response) => {
        this.accounts = _.concat([{id: "", app_name: 'Tutte le agenzie'}], response.accounts);
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

    this.getAllAccounts();

  },
  view({state}) {
    return m("form", { class: "ui form segment mb-40" }, [
      m(".five fields mb-0", [
        m(".field", [
          m(".ui selection dropdown", {
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
            m(".text", User.filters.fieldLabel()),
            m(".menu", [
              User.filterFields.map((filter) => {
                return m('.item', {
                  "data-value": filter.fieldValue,
                  className: (filter.fieldValue === User.filters.field() ? "active selected" : ""),
                  onclick: (event) => {
                    User.filters.fieldLabel(event.target.outerText);
                  }
                }, filter.fieldLabel);
              })
            ])
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
          m(".ui selection dropdown", {
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
          m("button", {
            onclick: (event) => {
              event.preventDefault();
              this.getAllUsers({filters: User.filters});
            },
            class: "ui submit teal basic button full"
          }, "Filtra")
        ])
      ])
    ]);
  }
}

export default userFilters;
