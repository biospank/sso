import m from 'mithril';
import mixinLayout from '../../layout/mixin_layout';

const content = () => {
  return [
    // m(".ui two column centered grid", [
    //   m()
    // ])
    m(".ui three top attached steps", [
      m("a", { class: "active step" }, [
        m("i", { class: "sitemap icon" }),
        m(".content", [
          m(".title", "Organizzazione"),
          m(".description", "Seleziona l'organizzazione dal menù a tendina oppure creane una nuova")
        ])
      ]),
      m("a", { class: "step" }, [
        m("i", { class: "podcast icon" }),
        m(".content", [
          m(".title", "Agenzia"),
          m(".description", "Crea una nuova agenzia")
        ])
      ]),
      m("a", { class: "step" }, [
        m("i", { class: "privacy icon" }),
        m(".content", [
          m(".title", "Credenziali"),
          m(".description", "Di seguito le credenziali generate")
        ])
      ])
    ]),
    m(".ui attached segment", [
      m("p", "Lorem Ipsum è un testo segnaposto utilizzato nel settore della tipografia e della stampa. Lorem Ipsum è considerato il testo segnaposto standard sin dal sedicesimo secolo, quando un anonimo tipografo prese una cassetta di caratteri e li assemblò per preparare un testo campione. È sopravvissuto non solo a più di cinque secoli, ma anche al passag")
    ])
  ]
}

const credentials = {
  view: mixinLayout(content)
}

export default credentials;
