import m from 'mithril';
import aceEditor from '../../../components/ace_editor';

const deviceContextView = {
  view(vnode) {
    return [
      m(".ui pointing secondary web menu", {
        oncreate(_) {
          $('.web.menu .item').tab();
        }
      }, [
        m("a.item active", {"data-tab": "web"}, "Web"),
        m("a.item", {"data-tab": "mobile"}, "Mobile")
      ]),
      m(".ui tab segment active", {"data-tab": "web"}, [
        m(".ui pointing secondary template menu", {
          oncreate(_) {
            $('div[data-tab="web"] .template.menu .item').tab();
          }
        }, [
          m("a.item active", {"data-tab": "web-registration"}, "Registrazione"),
          m("a.item", {"data-tab": "web-confirm-registration"}, "Conferma Registrazione")
        ]),
        m(".ui tab segment active", {"data-tab": "web-registration"}, [
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
                  initialValue: "<html><body><h2>Web registrazione html</h2></body></html>"
                })
              ]),
              m(".inline field", [
                m(".ui checkbox", [
                  m("input", {
                    type: "checkbox",
                    id: "html-registration-web-include-disclaimer",
                  }),
                  m("label", {for: "html-registration-web-include-disclaimer", style: "cursor: pointer;"}, "Includi Disclaimer")
                ])
              ])
            ])
          ]),
          m(".ui tab segment", {"data-tab": "web-text-registration"}, [
            m("form.ui form", [
              m(".field", [
                m("label", "Oggetto"),
                m("input", {type: "text", placeholder: "Oggetto della mail"})
              ]),
              m(".field", [
                m("label", "Body (formato testo)"),
                m(aceEditor, {
                  className: "html-editor",
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
                    id: "text-registration-web-include-disclaimer",
                  }),
                  m("label", {for: "text-registration-web-include-disclaimer", style: "cursor: pointer;"}, "Includi Disclaimer")
                ])
              ])
            ])
          ])
        ]),
        m(".ui tab segment", {"data-tab": "web-confirm-registration"}, [
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
                  initialValue: "<html><body><h2>Web conferma registrazione html</h2></body></html>"
                })
              ]),
              m(".inline field", [
                m(".ui checkbox", [
                  m("input", {
                    type: "checkbox",
                    id: "web-confirm-registration-include-disclaimer",
                  }),
                  m("label", {for: "web-registration-include-disclaimer", style: "cursor: pointer;"}, "Includi Disclaimer")
                ])
              ])
            ])
          ]),
          m(".ui tab segment", {"data-tab": "web-text-confirm-registration"}, [
            m("form.ui form", [
              m(".field", [
                m("label", "Oggetto"),
                m("input", {type: "text", placeholder: "Oggetto della mail"})
              ]),
              m(".field", [
                m("label", "Body (formato testo)"),
                m(aceEditor, {
                  className: "html-editor",
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
                    id: "web-confirm-registration-include-disclaimer",
                  }),
                  m("label", {for: "web-confirm-registration-include-disclaimer", style: "cursor: pointer;"}, "Includi Disclaimer")
                ])
              ])
            ])
          ])
        ])
      ]),
      m(".ui tab segment", {"data-tab": "mobile"}, [
        m(".ui pointing secondary template menu", {
          oncreate(_) {
            $('div[data-tab="mobile"] .template.menu .item').tab();
          }
        }, [
          m("a.item active", {"data-tab": "mobile-registration"}, "Registrazione"),
          m("a.item", {"data-tab": "mobile-confirm-registration"}, "Conferma Registrazione")
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
                    id: "html-registration-mobile-include-disclaimer",
                  }),
                  m("label", {for: "html-registration-mobile-include-disclaimer", style: "cursor: pointer;"}, "Includi Disclaimer")
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
                  className: "html-editor",
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
                    id: "text-registration-mobile-include-disclaimer",
                  }),
                  m("label", {for: "text-registration-mobile-include-disclaimer", style: "cursor: pointer;"}, "Includi Disclaimer")
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
                    id: "mobile-confirm-registration-include-disclaimer",
                  }),
                  m("label", {for: "mobile-registration-include-disclaimer", style: "cursor: pointer;"}, "Includi Disclaimer")
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
                  className: "html-editor",
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
                    id: "mobile-confirm-registration-include-disclaimer",
                  }),
                  m("label", {for: "mobile-confirm-registration-include-disclaimer", style: "cursor: pointer;"}, "Includi Disclaimer")
                ])
              ])
            ])
          ])
        ])
      ])
    ];
  }
}

export default deviceContextView;
