import m from 'mithril';
import mixinLayout from '../../layout/mixin_layout';

const content = () => {
  return [
    m(".ui steps", [
      m("a", { class: "active step" }, [
        m("i", { class: "truck icon" }),
        m(".content", [
          m(".title", "Title"),
          m(".description", "Organizzazione")
        ])
      ]),
      m("a", { class: "active step" }, [
        m("i", { class: "truck icon" }),
        m(".content", [
          m(".title", "Title"),
          m(".description", "Agenzia")
        ])
      ]),
      m("a", { class: "active step" }, [
        m("i", { class: "truck icon" }),
        m(".content", [
          m(".title", "Title"),
          m(".description", "Credenziali")
        ])
      ])
    ])
  ]
}

const credentials = {
  view: mixinLayout(content)
}

export default credentials;
