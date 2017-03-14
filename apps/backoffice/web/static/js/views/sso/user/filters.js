import m from 'mithril';
import User from '../../../models/user';

const userFilters = {
  oninit(vnode) {
    this.errors = {};
    this.showLoader = vnode.attrs.showLoader;

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

  },
  view({state}) {
    return m(".ui form segment mb-40", [
      m(".five fields mb-0", [
        m(".field", [
          m("input", {
            oninput: m.withAttr("value", User.filters.name),
            type: "text",
            placeholder: "Filtra per Nome"
          })
        ]),
        m(".field", [
          m("input", {
            oninput: m.withAttr("value", User.filters.email),
            type: "email",
            placeholder: "Filtra per Email"
          })
        ]),
        m(".field", [
          m("select", { class: "ui dropdown" }, [
            m("option", { value: "tutti" }, "Tutti gli utenti"),
            m("option", { value: "autorizzati" }, "Utenti autorizzati"),
            m("option", { value: "non_autorizzati" }, "Utenti non autorizzati")
          ])
        ]),
        m(".field", [
          m("select", { class: "ui dropdown" }, [
            m("option", { value: "0" }, "Tutte le Agenzie"),
            m("option", { value: "1" }, "Agenzia 1"),
            m("option", { value: "2" }, "Agenzia 2"),
            m("option", { value: "3" }, "Agenzia 3"),
            m("option", { value: "4" }, "Agenzia 4"),
            m("option", { value: "5" }, "Agenzia 5")
          ])
        ]),
        m(".field", [
          m("button", {
            onclick: (event) => {
              event.preventDefault();
              this.getAllUsers({filters: User.filters});
            },
            class: "ui submit teal button"
          }, "Filtra")
        ])
      ])
    ]);
  }
}

export default userFilters;
