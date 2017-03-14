import m from 'mithril';

const menuStep = {
  view({attrs}) {
    return m(".ui three top attached steps", [
      m(".step", { class: ( attrs.active === 1 ? "active" : "" ) }, [
        m("i", { class: "sitemap icon teal" }),
        m(".content", [
          m(".title", "Organizzazione"),
          m(".description", "Scegli o crea una nuova Unità Organizzativa")
        ])
      ]),
      m(".step", { class: ( attrs.active === 2 ? "active" : "" ) }, [
        m("i", { class: "users icon teal" }),
        m(".content", [
          m(".title", "Agenzia"),
          m(".description", "Crea una nuova Agenzia")
        ])
      ]),
      m(".step", { class: ( attrs.active === 3 ? "active" : "" ) }, [
        m("i", { class: "privacy icon teal" }),
        m(".content", [
          m(".title", "Credenziali"),
          m(".description", "Conferma le credenziali")
        ])
      ])
    ])
  }
}

export default menuStep;
