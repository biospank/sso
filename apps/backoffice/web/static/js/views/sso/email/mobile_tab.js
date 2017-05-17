import m from 'mithril';
import aceEditor from '../../../components/ace_editor';

const mobileTabView = {
  view(vnode) {
    return [
      m(".ui pointing secondary template menu", {
        oncreate(_) {
          $('div[data-tab="mobile"] .template.menu .item').tab();
        }
      }, [
        m("a.item active", {"data-tab": "mobile-registration"}, "Registrazione"),
        m("a.item", {"data-tab": "mobile-confirm-registration"}, "Conferma Registrazione"),
        m("a.item", {"data-tab": "mobile-password-reset"}, "Reset Password"),
        m("a.item", {"data-tab": "mobile-disclaimer"}, "Disclaimer")
      ]),
      m(".ui tab segment active", {"data-tab": "mobile-registration"}, [
        m(".ui pointing secondary registration-format menu", {
          oncreate(_) {
            $('div[data-tab="mobile"] .registration-format.menu .item').tab();
          }
        }, [
          m("a.item active", {"data-tab": "mobile-html-registration"}, "HTML"),
          m("a.item", {"data-tab": "mobile-text-registration"}, "TESTO")
        ]),
        m(".ui tab segment active", {"data-tab": "mobile-html-registration"}, [
          m("form.ui form", [
            m(".field", [
              m("label", "Oggetto"),
              m("input", {type: "text", placeholder: "Oggetto della mail"})
            ]),
            m(".field", [
              m("label", "Body (formato html)"),
              m(aceEditor, {
                className: "html-editor",
                fontSize: "16px",
                theme: "ace/theme/twilight",
                mode: "ace/mode/html_elixir",
                initialValue: "<html><body><h2>Mobile registrazione html</h2></body></html>"
              })
            ]),
            m(".inline field", [
              m(".ui checkbox", [
                m("input", {
                  type: "checkbox",
                  id: "mobile-html-registration-mobile-include-disclaimer",
                }),
                m("label", {for: "mobile-html-registration-mobile-include-disclaimer", style: "cursor: pointer;"}, "Includi Disclaimer")
              ])
            ])
          ])
        ]),
        m(".ui tab segment", {"data-tab": "mobile-text-registration"}, [
          m("form.ui form", [
            m(".field", [
              m("label", "Oggetto"),
              m("input", {type: "text", placeholder: "Oggetto della mail"})
            ]),
            m(".field", [
              m("label", "Body (formato testo)"),
              m(aceEditor, {
                className: "text-editor",
                fontSize: "16px",
                theme: "ace/theme/twilight",
                mode: "ace/mode/text",
                initialValue: "Mobile registrazione testo"
              })
            ]),
            m(".inline field", [
              m(".ui checkbox", [
                m("input", {
                  type: "checkbox",
                  id: "mobile-text-registration-mobile-include-disclaimer",
                }),
                m("label", {for: "mobile-text-registration-mobile-include-disclaimer", style: "cursor: pointer;"}, "Includi Disclaimer")
              ])
            ])
          ])
        ])
      ]),
      m(".ui tab segment", {"data-tab": "mobile-confirm-registration"}, [
        m(".ui pointing secondary confirm-registration-format menu", {
          oncreate(_) {
            $('div[data-tab="mobile"] .confirm-registration-format.menu .item').tab();
          }
        }, [
          m("a.item active", {"data-tab": "mobile-html-confirm-registration"}, "HTML"),
          m("a.item", {"data-tab": "mobile-text-confirm-registration"}, "TESTO")
        ]),
        m(".ui tab segment active", {"data-tab": "mobile-html-confirm-registration"}, [
          m("form.ui form", [
            m(".field", [
              m("label", "Oggetto"),
              m("input", {type: "text", placeholder: "Oggetto della mail"})
            ]),
            m(".field", [
              m("label", "Body (formato html)"),
              m(aceEditor, {
                className: "html-editor",
                fontSize: "16px",
                theme: "ace/theme/twilight",
                mode: "ace/mode/html_elixir",
                initialValue: "<html><body><h2>Mobile conferma registrazione html</h2></body></html>"
              })
            ]),
            m(".inline field", [
              m(".ui checkbox", [
                m("input", {
                  type: "checkbox",
                  id: "mobile-html-confirm-registration-include-disclaimer",
                }),
                m("label", {for: "mobile-html-confirm-registration-include-disclaimer", style: "cursor: pointer;"}, "Includi Disclaimer")
              ])
            ])
          ])
        ]),
        m(".ui tab segment", {"data-tab": "mobile-text-confirm-registration"}, [
          m("form.ui form", [
            m(".field", [
              m("label", "Oggetto"),
              m("input", {type: "text", placeholder: "Oggetto della mail"})
            ]),
            m(".field", [
              m("label", "Body (formato testo)"),
              m(aceEditor, {
                className: "text-editor",
                fontSize: "16px",
                theme: "ace/theme/twilight",
                mode: "ace/mode/text",
                initialValue: "Mobile conferma registrazione testo"
              })
            ]),
            m(".inline field", [
              m(".ui checkbox", [
                m("input", {
                  type: "checkbox",
                  id: "mobile-html-confirm-registration-include-disclaimer",
                }),
                m("label", {for: "mobile-html-confirm-registration-include-disclaimer", style: "cursor: pointer;"}, "Includi Disclaimer")
              ])
            ])
          ])
        ])
      ]),
      m(".ui tab segment", {"data-tab": "mobile-password-reset"}, [
        m(".ui pointing secondary password-reset-format menu", {
          oncreate(_) {
            $('div[data-tab="mobile"] .password-reset-format.menu .item').tab();
          }
        }, [
          m("a.item active", {"data-tab": "mobile-html-password-reset"}, "HTML"),
          m("a.item", {"data-tab": "mobile-text-password-reset"}, "TESTO")
        ]),
        m(".ui tab segment active", {"data-tab": "mobile-html-password-reset"}, [
          m("form.ui form", [
            m(".field", [
              m("label", "Oggetto"),
              m("input", {type: "text", placeholder: "Oggetto della mail"})
            ]),
            m(".field", [
              m("label", "Body (formato html)"),
              m(aceEditor, {
                className: "html-editor",
                fontSize: "16px",
                theme: "ace/theme/twilight",
                mode: "ace/mode/html_elixir",
                initialValue: "<html><body><h2>Mobile password reset html</h2></body></html>"
              })
            ]),
            m(".inline field", [
              m(".ui checkbox", [
                m("input", {
                  type: "checkbox",
                  id: "mobile-html-password-reset-include-disclaimer",
                }),
                m("label", {for: "mobile-html-password-reset-include-disclaimer", style: "cursor: pointer;"}, "Includi Disclaimer")
              ])
            ])
          ])
        ]),
        m(".ui tab segment", {"data-tab": "mobile-text-password-reset"}, [
          m("form.ui form", [
            m(".field", [
              m("label", "Oggetto"),
              m("input", {type: "text", placeholder: "Oggetto della mail"})
            ]),
            m(".field", [
              m("label", "Body (formato testo)"),
              m(aceEditor, {
                className: "text-editor",
                fontSize: "16px",
                theme: "ace/theme/twilight",
                mode: "ace/mode/text",
                initialValue: "Mobile password reset testo"
              })
            ]),
            m(".inline field", [
              m(".ui checkbox", [
                m("input", {
                  type: "checkbox",
                  id: "mobile-text-password-reset-include-disclaimer",
                }),
                m("label", {for: "mobile-text-password-reset-include-disclaimer", style: "cursor: pointer;"}, "Includi Disclaimer")
              ])
            ])
          ])
        ])
      ]),
      m(".ui tab segment", {"data-tab": "mobile-disclaimer"}, [
        m(".ui pointing secondary disclaimer-format menu", {
          oncreate(_) {
            $('div[data-tab="mobile"] .disclaimer-format.menu .item').tab();
          }
        }, [
          m("a.item active", {"data-tab": "mobile-html-disclaimer"}, "HTML"),
          m("a.item", {"data-tab": "mobile-text-disclaimer"}, "TESTO")
        ]),
        m(".ui tab segment active", {"data-tab": "mobile-html-disclaimer"}, [
          m("form.ui form", [
            m(".field", [
              m("label", "Body (formato html)"),
              m(aceEditor, {
                className: "html-editor",
                fontSize: "16px",
                theme: "ace/theme/twilight",
                mode: "ace/mode/html_elixir",
                initialValue: "<html><body><h2>Mobile disclaimer html</h2></body></html>"
              })
            ]),
          ])
        ]),
        m(".ui tab segment", {"data-tab": "mobile-text-disclaimer"}, [
          m("form.ui form", [
            m(".field", [
              m("label", "Body (formato testo)"),
              m(aceEditor, {
                className: "text-editor",
                fontSize: "16px",
                theme: "ace/theme/twilight",
                mode: "ace/mode/text",
                initialValue: "Mobile disclaimer testo"
              })
            ])
          ])
        ])
      ])
    ];
  }
}

export default mobileTabView;
