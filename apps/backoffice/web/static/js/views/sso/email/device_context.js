import m from 'mithril';
import aceEditor from '../../../components/ace_editor';

const deviceContextView = {
  view(vnode) {
    return [
      m(".ui pointing secondary device-context menu", {
        oncreate(_) {
          $('.device-context.menu .item').tab();
        }
      }, [
        m("a.item active", {"data-tab": "web"}, "Web"),
        m("a.item", {"data-tab": "mobile"}, "Mobile")
      ]),
      m(".ui tab segment active", {"data-tab": "web"}, [
        m("h4.ui header", "Template email SSO per applicazioni web"),
        m(".ui template styled accordion", {
          oncreate({dom}) {
            $(dom).accordion();
          }
        }, [
          m(".active title", [
            m("i.dropdown icon"),
            "Registrazione"
          ]),
          m(".active content", [
            m("form.ui form", [
              m(".field", [
                m("label", "Oggetto"),
                m("input", {type: "text", name: "web-registration-subject", placeholder: "Oggetto della mail"})
              ]),
              m(".field", [
                m("label", "Body (formato html)"),
                m(aceEditor, {
                  className: "html-editor",
                  fontSize: "16px",
                  theme: "ace/theme/twilight",
                  mode: "ace/mode/html_elixir",
                  initialValue: "<html><body><h2>Hello Ace!</h2></body></html>"
                })
              ]),
              m(".field", [
                m("label", "Body (formato testo)"),
                m(aceEditor, {
                  className: "html-editor",
                  fontSize: "16px",
                  theme: "ace/theme/twilight",
                  mode: "ace/mode/text",
                  initialValue: "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Eligendi non quis exercitationem culpa nesciunt nihil aut nostrum explicabo reprehenderit optio amet ab temporibus asperiores quasi cupiditate. Voluptatum ducimus voluptates voluptas?"
                })
              ]),
              m(".inline field", [
                m(".ui checkbox", [
                  m("input", {
                    type: "checkbox",
                    id: "web-registration-include-disclaimer",
                  }),
                  m("label", {for: "web-registration-include-disclaimer", style: "cursor: pointer;"}, "Includi Disclaimer")
                ])
              ])
            ])
          ]),
          m(".title", [
            m("i.dropdown icon"),
            "Conferma Registrazione"
          ]),
          m(".content", [
            m("form.ui form", [
              m(".field", [
                m("label", "Oggetto"),
                m("input", {type: "text", name: "web-registration-confirm-subject", placeholder: "Oggetto della mail"})
              ]),
              m(".field", [
                m("label", "Body (formato html)"),
                m("textarea", {name: "web-registration-confirm-body-html", placeholder: "Body in formato html"})
              ]),
              m(".field", [
                m("label", "Body (formato testo)"),
                m("textarea", {name: "web-registration-confirm-body-text", placeholder: "Body in formato testo"})
              ]),
              m(".inline field", [
                m(".ui checkbox", [
                  m("input", {
                    type: "checkbox",
                    id: "web-registration-confirm-include-disclaimer",
                  }),
                  m("label", {for: "web-registration-confirm-include-disclaimer", style: "cursor: pointer;"}, "Includi Disclaimer")
                ])
              ])
            ])
          ]),
          m(".title", [
            m("i.dropdown icon"),
            "Reset password"
          ]),
          m(".content", [
            m("form.ui form", [
              m(".field", [
                m("label", "Oggetto"),
                m("input", {type: "text", name: "web-password-reset-subject", placeholder: "Oggetto della mail"})
              ]),
              m(".field", [
                m("label", "Body (formato html)"),
                m("textarea", {name: "web-password-reset-body-html", placeholder: "Body in formato html"})
              ]),
              m(".field", [
                m("label", "Body (formato testo)"),
                m("textarea", {name: "web-password-reset-body-text", placeholder: "Body in formato testo"})
              ]),
              m(".inline field", [
                m(".ui checkbox", [
                  m("input", {
                    type: "checkbox",
                    id: "web-password-reset-include-disclaimer",
                  }),
                  m("label", {for: "web-password-reset-include-disclaimer", style: "cursor: pointer;"}, "Includi Disclaimer")
                ])
              ])
            ])
          ]),
          m(".title", [
            m("i.dropdown icon"),
            "Disclaimer"
          ]),
          m(".content", [
            m("form.ui form", [
              m(".field", [
                m("label", "Disclaimer (formato html)"),
                m("textarea", {name: "web-password-reset-disclaimer-html", placeholder: "Disclaimer in formato html"})
              ]),
              m(".field", [
                m("label", "Disclaimer (formato testo)"),
                m("textarea", {name: "web-password-reset-disclaimer-text", placeholder: "Disclaimer in formato testo"})
              ]),
            ])
          ])
        ])
      ]),
      m(".ui tab segment", {"data-tab": "mobile"}, [
        m("h4.ui header", "Template email SSO per applicazioni mobile"),
        m(".ui template styled accordion", {
          oncreate({dom}) {
            $(dom).accordion();
          }
        }, [
          m(".active title", [
            m("i.dropdown icon"),
            "Registrazione"
          ]),
          m(".active content", [
            m("form.ui form", [
              m(".field", [
                m("label", "Oggetto"),
                m("input", {type: "text", name: "mobile-registration-subject", placeholder: "Oggetto della mail"})
              ]),
              m(".field", [
                m("label", "Body (formato html)"),
                m("textarea", {name: "mobile-registration-body-html", placeholder: "Body in formato html"})
              ]),
              m(".field", [
                m("label", "Body (formato testo)"),
                m("textarea", {name: "mobile-registration-body-text", placeholder: "Body in formato testo"})
              ]),
              m(".inline field", [
                m(".ui checkbox", [
                  m("input", {
                    type: "checkbox",
                    id: "mobile-registration-include-disclaimer",
                  }),
                  m("label", {for: "mobile-registration-include-disclaimer", style: "cursor: pointer;"}, "Includi Disclaimer")
                ])
              ])
            ])
          ]),
          m(".title", [
            m("i.dropdown icon"),
            "Conferma Registrazione"
          ]),
          m(".content", [
            m("form.ui form", [
              m(".field", [
                m("label", "Oggetto"),
                m("input", {type: "text", name: "mobile-registration-confirm-subject", placeholder: "Oggetto della mail"})
              ]),
              m(".field", [
                m("label", "Body (formato html)"),
                m("textarea", {name: "mobile-registration-confirm-body-html", placeholder: "Body in formato html"})
              ]),
              m(".field", [
                m("label", "Body (formato testo)"),
                m("textarea", {name: "mobile-registration-confirm-body-text", placeholder: "Body in formato testo"})
              ]),
              m(".inline field", [
                m(".ui checkbox", [
                  m("input", {
                    type: "checkbox",
                    id: "mobile-registration-confirm-include-disclaimer",
                  }),
                  m("label", {for: "mobile-registration-confirm-include-disclaimer", style: "cursor: pointer;"}, "Includi Disclaimer")
                ])
              ])
            ])
          ]),
          m(".title", [
            m("i.dropdown icon"),
            "Reset password"
          ]),
          m(".content", [
            m("form.ui form", [
              m(".field", [
                m("label", "Oggetto"),
                m("input", {type: "text", name: "mobile-password-reset-subject", placeholder: "Oggetto della mail"})
              ]),
              m(".field", [
                m("label", "Body (formato html)"),
                m("textarea", {name: "mobile-password-reset-body-html", placeholder: "Body in formato html"})
              ]),
              m(".field", [
                m("label", "Body (formato testo)"),
                m("textarea", {name: "mobile-password-reset-body-text", placeholder: "Body in formato testo"})
              ]),
              m(".inline field", [
                m(".ui checkbox", [
                  m("input", {
                    type: "checkbox",
                    id: "mobile-password-reset-include-disclaimer",
                  }),
                  m("label", {for: "mobile-password-reset-include-disclaimer", style: "cursor: pointer;"}, "Includi Disclaimer")
                ])
              ])
            ])
          ]),
          m(".title", [
            m("i.dropdown icon"),
            "Disclaimer"
          ]),
          m(".content", [
            m("form.ui form", [
              m(".field", [
                m("label", "Disclaimer (formato html)"),
                m("textarea", {name: "mobile-password-reset-disclaimer-html", placeholder: "Disclaimer in formato html"})
              ]),
              m(".field", [
                m("label", "Disclaimer (formato testo)"),
                m("textarea", {name: "mobile-password-reset-disclaimer-text", placeholder: "Disclaimer in formato testo"})
              ]),
            ])
          ])
        ])
      ])
    ];
  }
}

export default deviceContextView;
