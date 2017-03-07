import m from 'mithril';
import mixinLayout from '../layout/mixin_layout';

const content = () => {
  return m("form", { class: "ui form segment p-all-side-30" }, [
    m("h3", { class: "ui dividing header pb-10 mb-25 teal" }, "Dettagli utente"),
    m(".mb-50", [
      m(".field", [
        m("label", "Email"),
        m(".ui left icon input", [
          m("input", { type: "text", readonly:"", name: "email", value: "test@example.com" }),
          m("i", { class: "at icon" })
        ])
      ]),
      m(".two fields", [
        m(".field", [
          m("label", "Password"),
          m(".ui left icon input", [
            m("input", { type: "text", readonly:"", name: "password", value: "secret123" }),
            m("i", { class: "privacy icon" })
          ])
        ]),
        m(".field", [
          m("label", "Conferma password"),
          m(".ui left icon input", [
            m("input", { type: "text", readonly:"", name: "password_confirmation", value: "secret123" }),
            m("i", { class: "privacy icon" })
          ])
        ])
      ])
    ]),
    m("h3", { class: "ui dividing header pb-10 mb-25 teal" }, "Dettagli profilo"),
    m("div", [
      m(".two fields", [
        m(".field", [
          m("label", "Nome"),
          m("input", { type: "text", readonly:"", name: "first-name", value: "Ilaria" })
        ]),
        m(".field", [
          m("label", "Cognome"),
          m("input", { type: "text", readonly:"", name: "last-name", value: "Di Rosa" })
        ])
      ]),
      m(".three fields", [
        m(".field", [
          m("label", "Codice Fiscale"),
          m("input", { type: "text", readonly:"", name: "fiscal_code", value: "DRSLRI88B56F205D" })
        ]),
        m(".field", [
          m("label", "Data di nascita"),
          m("input", { type: "text", readonly:"", name: "date_of_birth", value: "1988-02-16" })
        ]),
        m(".field", [
          m("label", "Luogo di nascita"),
          m("input", { type: "text", readonly:"", name: "place_of_birth", value: "Milano" })
        ])
      ]),
      m(".field", [
        m("label", "Numero di telefono"),
        m("input", { type: "text", readonly:"", name: "phone_number", value: "+39 3474977880" })
      ]),
      m(".two fields", [
        m(".field", [
          m("label", "Professione"),
          m("input", { type: "text", readonly:"", name: "profession", value: "Dottore" })
        ]),
        m(".field", [
          m("label", "Specializzazione"),
          m("input", { type: "text", readonly:"", name: "specialization", value: "Chirurgo" })
        ])
      ]),
      m(".three fields", [
        m(".field", [
          m("label", "Iscrizione ordine"),
          m("input", { type: "text", readonly:"", name: "board_member", value: "2" })
        ]),
        m(".field", [
          m("label", "Numero iscrizione"),
          m("input", { type: "text", readonly:"", name: "board_number", value: "3" })
        ]),
        m(".field", [
          m("label", "Provincia iscrizione"),
          m("input", { type: "text", readonly:"", name: "province_board", value: "Milano" })
        ])
      ]),
      m(".two fields", [
        m(".field", [
          m("label", "Attività lavorativa"),
          m("input", { type: "text", readonly:"", name: "employment", value: "Sì" })
        ]),
        m(".field", [
          m("label", "Provincia attività lavorativa"),
          m("input", { type: "text", readonly:"", name: "province_enployment", value: "Milano" })
        ])
      ])
    ])
  ])
};

const userDetails = {
  view: mixinLayout(content)
}

export default userDetails;
