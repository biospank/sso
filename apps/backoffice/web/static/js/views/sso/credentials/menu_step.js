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
          m(".title", "App"),
          m(".description", "Crea una nuova App")
        ])
      ]),
      m(".step", { class: ( attrs.active === 3 ? "active" : "" ) }, [
        m("i", { class: "privacy icon teal" }),
        m(".content", [
          m(".title", "Credenziali"),
          m(".description", "Usa le credenziali generate")
        ])
      ])
    ])
  }
}

export default menuStep;
