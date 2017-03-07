import m from 'mithril';

const userFilters = {
  view() {
    return m(".ui form segment mb-40", [
      m(".five fields mb-0", [
        m(".field", [
          m("input", { type: "text", placeholder: "Filtra per Nome" })
        ]),
        m(".field", [
          m("input", { type: "email", placeholder: "Filtra per Email" })
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
          m("button", { class: "ui submit teal button" }, "Filtra")
        ])
      ])
    ]);
  }
}

export default userFilters;
