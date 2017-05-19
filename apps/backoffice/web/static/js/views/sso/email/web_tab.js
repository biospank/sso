import m from 'mithril';
import aceEditor from '../../../components/ace_editor';

const webTabView = {
  view(vnode) {
    return [
      m(".ui pointing secondary template menu", {
        oncreate(_) {
          $('div[data-tab="web"] .template.menu .item').tab();
        }
      }, [
        m("a.item active", {"data-tab": "web-registration"}, [
          "Registrazione",
          m("i.help circle outline icon", {
            "data-content": "Mail inviata all'utente all'atto della registrazione.",
            oncreate({dom}) {
              $(dom).popup();
            }
          })
        ]),
        m("a.item", {"data-tab": "web-confirm-registration"}, [
          "Verifica Utente",
          m("i.help circle outline icon", {
            "data-content": "Mail inviata all'utente alla verifica dei suoi dati.",
            oncreate({dom}) {
              $(dom).popup();
            }
          })
        ]),
        m("a.item", {"data-tab": "web-password-reset"}, [
          "Reset Password",
          m("i.help circle outline icon", {
            "data-content": "Mail inviata all'utente alla richiesta di reset della password.",
            oncreate({dom}) {
              $(dom).popup();
            }
          })
        ]),
        m("a.item", {"data-tab": "web-disclaimer"}, "Disclaimer")
      ]),
      m(".ui tab segment active", {"data-tab": "web-registration"}, [
        m("form.ui form", [
          m(".field", [
            m("label", "Oggetto"),
            m("input", {type: "text", placeholder: "Oggetto della mail"})
          ])
        ]),
        m(".ui pointing secondary registration-format menu", {
          oncreate(_) {
            $('div[data-tab="web"] .registration-format.menu .item').tab();
          }
        }, [
          m("a.item active", {"data-tab": "web-html-registration"}, "HTML"),
          m("a.item", {"data-tab": "web-text-registration"}, "TESTO")
        ]),
        m(".ui tab segment active", {"data-tab": "web-html-registration"}, [
          m("form.ui form", [
            m(".field", [
              m("label", "Body (formato html)"),
              m(aceEditor, {
                className: "html-editor",
                fontSize: "16px",
                theme: "ace/theme/twilight",
                mode: "ace/mode/html_elixir",
                initialValue: "<html><body><h2>Web registrazione html</h2></body></html>"
              })
            ]),
            m(".inline field", [
              m(".ui checkbox", [
                m("input", {
                  type: "checkbox",
                  id: "web-html-registration-include-disclaimer",
                }),
                m("label", {for: "web-html-registration-include-disclaimer", style: "cursor: pointer;"}, "Includi Disclaimer")
              ])
            ])
          ])
        ]),
        m(".ui tab segment", {"data-tab": "web-text-registration"}, [
          m("form.ui form", [
            m(".field", [
              m("label", "Body (formato testo)"),
              m(aceEditor, {
                className: "text-editor",
                fontSize: "16px",
                theme: "ace/theme/twilight",
                mode: "ace/mode/text",
                initialValue: "Web registazione testo"
              })
            ]),
            m(".inline field", [
              m(".ui checkbox", [
                m("input", {
                  type: "checkbox",
                  id: "web-text-registration-include-disclaimer",
                }),
                m("label", {for: "web-text-registration-include-disclaimer", style: "cursor: pointer;"}, "Includi Disclaimer")
              ])
            ])
          ])
        ])
      ]),
      m(".ui tab segment", {"data-tab": "web-confirm-registration"}, [
        m("form.ui form", [
          m(".field", [
            m("label", "Oggetto"),
            m("input", {type: "text", placeholder: "Oggetto della mail"})
          ])
        ]),
        m(".ui pointing secondary confirm-registration-format menu", {
          oncreate(_) {
            $('div[data-tab="web"] .confirm-registration-format.menu .item').tab();
          }
        }, [
          m("a.item active", {"data-tab": "web-html-confirm-registration"}, "HTML"),
          m("a.item", {"data-tab": "web-text-confirm-registration"}, "TESTO")
        ]),
        m(".ui tab segment active", {"data-tab": "web-html-confirm-registration"}, [
          m("form.ui form", [
            m(".field", [
              m("label", "Body (formato html)"),
              m(aceEditor, {
                className: "html-editor",
                fontSize: "16px",
                theme: "ace/theme/twilight",
                mode: "ace/mode/html_elixir",
                initialValue: "<html><body><h2>Web conferma registrazione html</h2></body></html>"
              })
            ]),
            m(".inline field", [
              m(".ui checkbox", [
                m("input", {
                  type: "checkbox",
                  id: "web-html-confirm-registration-include-disclaimer",
                }),
                m("label", {for: "web-html-confirm-registration-include-disclaimer", style: "cursor: pointer;"}, "Includi Disclaimer")
              ])
            ])
          ])
        ]),
        m(".ui tab segment", {"data-tab": "web-text-confirm-registration"}, [
          m("form.ui form", [
            m(".field", [
              m("label", "Body (formato testo)"),
              m(aceEditor, {
                className: "text-editor",
                fontSize: "16px",
                theme: "ace/theme/twilight",
                mode: "ace/mode/text",
                initialValue: "Web conferma registrazione testo"
              })
            ]),
            m(".inline field", [
              m(".ui checkbox", [
                m("input", {
                  type: "checkbox",
                  id: "web-text-confirm-registration-include-disclaimer",
                }),
                m("label", {for: "web-text-confirm-registration-include-disclaimer", style: "cursor: pointer;"}, "Includi Disclaimer")
              ])
            ])
          ])
        ])
      ]),
      m(".ui tab segment", {"data-tab": "web-password-reset"}, [
        m("form.ui form", [
          m(".field", [
            m("label", "Oggetto"),
            m("input", {type: "text", placeholder: "Oggetto della mail"})
          ])
        ]),
        m(".ui pointing secondary password-reset-format menu", {
          oncreate(_) {
            $('div[data-tab="web"] .password-reset-format.menu .item').tab();
          }
        }, [
          m("a.item active", {"data-tab": "web-html-password-reset"}, "HTML"),
          m("a.item", {"data-tab": "web-text-password-reset"}, "TESTO")
        ]),
        m(".ui tab segment active", {"data-tab": "web-html-password-reset"}, [
          m("form.ui form", [
            m(".field", [
              m("label", "Body (formato html)"),
              m(aceEditor, {
                className: "html-editor",
                fontSize: "16px",
                theme: "ace/theme/twilight",
                mode: "ace/mode/html_elixir",
                initialValue: "<html><body><h2>Web password reset html</h2></body></html>"
              })
            ]),
            m(".inline field", [
              m(".ui checkbox", [
                m("input", {
                  type: "checkbox",
                  id: "web-html-password-reset-include-disclaimer",
                }),
                m("label", {for: "web-html-password-reset-include-disclaimer", style: "cursor: pointer;"}, "Includi Disclaimer")
              ])
            ])
          ])
        ]),
        m(".ui tab segment", {"data-tab": "web-text-password-reset"}, [
          m("form.ui form", [
            m(".field", [
              m("label", "Body (formato testo)"),
              m(aceEditor, {
                className: "text-editor",
                fontSize: "16px",
                theme: "ace/theme/twilight",
                mode: "ace/mode/text",
                initialValue: "Web password reset testo"
              })
            ]),
            m(".inline field", [
              m(".ui checkbox", [
                m("input", {
                  type: "checkbox",
                  id: "web-text-password-reset-include-disclaimer",
                }),
                m("label", {for: "web-text-password-reset-include-disclaimer", style: "cursor: pointer;"}, "Includi Disclaimer")
              ])
            ])
          ])
        ])
      ]),
      m(".ui tab segment", {"data-tab": "web-disclaimer"}, [
        m(".ui pointing secondary disclaimer-format menu", {
          oncreate(_) {
            $('div[data-tab="web"] .disclaimer-format.menu .item').tab();
          }
        }, [
          m("a.item active", {"data-tab": "web-html-disclaimer"}, "HTML"),
          m("a.item", {"data-tab": "web-text-disclaimer"}, "TESTO")
        ]),
        m(".ui tab segment active", {"data-tab": "web-html-disclaimer"}, [
          m("form.ui form", [
            m(".field", [
              m("label", "Body (formato html)"),
              m(aceEditor, {
                className: "html-editor",
                fontSize: "16px",
                theme: "ace/theme/twilight",
                mode: "ace/mode/html_elixir",
                initialValue: "<html><body><h2>Web disclaimer html</h2></body></html>"
              })
            ]),
          ])
        ]),
        m(".ui tab segment", {"data-tab": "web-text-disclaimer"}, [
          m("form.ui form", [
            m(".field", [
              m("label", "Body (formato testo)"),
              m(aceEditor, {
                className: "text-editor",
                fontSize: "16px",
                theme: "ace/theme/twilight",
                mode: "ace/mode/text",
                initialValue: "Web disclaimer testo"
              })
            ])
          ])
        ])
      ])
    ];
  }
}

export default webTabView;
