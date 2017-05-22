import m from 'mithril';
import _ from 'lodash';
import aceEditor from '../../../components/ace_editor';
import Organization from '../../../models/organization';

const mobileTabView = {
  view(vnode) {
    return [
      // m('p', JSON.stringify(Organization.current())),
      m(".ui pointing secondary template menu", {
        oncreate(_) {
          $('div[data-tab="mobile"] .template.menu .item').tab();
        }
      }, [
        m("a.item active", {"data-tab": "mobile-registration"}, [
          "Registrazione",
          m("i.help circle outline icon", {
            "data-content": "Mail inviata all'utente all'atto della registrazione.",
            oncreate({dom}) {
              $(dom).popup();
            }
          })
        ]),
        m("a.item", {"data-tab": "mobile-verification"}, [
          "Verifica Utente",
          m("i.help circle outline icon", {
            "data-content": "Mail inviata all'utente alla verifica dei suoi dati.",
            oncreate({dom}) {
              $(dom).popup();
            }
          })
        ]),
        m("a.item", {"data-tab": "mobile-password-reset"}, [
          "Reset Password",
          m("i.help circle outline icon", {
            "data-content": "Mail inviata all'utente alla richiesta di reset della password.",
            oncreate({dom}) {
              $(dom).popup();
            }
          })
        ]),
        m("a.item", {"data-tab": "mobile-disclaimer"}, "Disclaimer")
      ]),
      m(".ui tab segment active", {"data-tab": "mobile-registration"}, [
        m("form.ui form", [
          m(".field", [
            m("label", "Oggetto"),
            m("input", {
              type: "text",
              placeholder: "Oggetto della mail",
              oninput(event) {
                Organization.current().settings.email_template.mobile.registration.subject = event.target.value
              },
              value: _.get(
                Organization.current(),
                'settings.email_template.mobile.registration.subject',
                ''
              )
            })
          ])
        ]),
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
              m("label", "Body (formato html)"),
              m(aceEditor, {
                className: "html-editor",
                mode: "ace/mode/html_elixir",
                model: Organization.current(),
                value: 'settings.email_template.mobile.registration.html_body',
                inputHandler: (value) => {
                  Organization.current().settings.email_template.mobile.registration.html_body = value
                }
              })
            ])
          ])
        ]),
        m(".ui tab segment", {"data-tab": "mobile-text-registration"}, [
          m("form.ui form", [
            m(".field", [
              m("label", "Body (formato testo)"),
              m(aceEditor, {
                className: "text-editor",
                mode: "ace/mode/text",
                model: Organization.current(),
                value: 'settings.email_template.mobile.registration.text_body',
                inputHandler: (value) => {
                  Organization.current().settings.email_template.mobile.registration.text_body = value
                }
              })
            ])
          ])
        ]),
        m(".inline field", [
          m(".ui checkbox", [
            m("input", {
              type: "checkbox",
              id: "mobile-registration-include-disclaimer",
              onclick(event) {
                Organization.current().settings.email_template.mobile.registration.include_disclaimer = event.target.checked
              },
              checked: _.get(
                Organization.current(),
                'settings.email_template.mobile.registration.include_disclaimer',
                true
              )
            }),
            m("label", {for: "mobile-registration-include-disclaimer", style: "cursor: pointer;"}, "Includi Disclaimer")
          ])
        ])
      ]),
      m(".ui tab segment", {"data-tab": "mobile-verification"}, [
        m('.ui menu', [
          m(".right menu", [
            m(".ui item", [
              m(".ui toggle checkbox", [
                m("input", {
                  type: "checkbox",
                  id: "mobile-verification-send",
                  onclick(event) {
                    Organization.current().settings.email_template.mobile.verification.send = event.target.checked
                  },
                  checked: _.get(
                    Organization.current(),
                    'settings.email_template.mobile.verification.send',
                    true
                  )
                }),
                m("label", {for: "mobile-verification-send", style: "cursor: pointer;"}, "Attivo")
              ])
            ])
          ])
        ]),
        m("form.ui form", [
          m(".field", [
            m("label", "Oggetto"),
            m("input", {
              type: "text",
              placeholder: "Oggetto della mail",
              oninput(event) {
                Organization.current().settings.email_template.mobile.verification.subject = event.target.value
              },
              value: _.get(
                Organization.current(),
                'settings.email_template.mobile.verification.subject',
                ''
              )
            })
          ])
        ]),
        m(".ui pointing secondary verification-format menu", {
          oncreate(_) {
            $('div[data-tab="mobile"] .verification-format.menu .item').tab();
          }
        }, [
          m("a.item active", {"data-tab": "mobile-html-verification"}, "HTML"),
          m("a.item", {"data-tab": "mobile-text-verification"}, "TESTO")
        ]),
        m(".ui tab segment active", {"data-tab": "mobile-html-verification"}, [
          m("form.ui form", [
            m(".field", [
              m("label", "Body (formato html)"),
              m(aceEditor, {
                className: "html-editor",
                mode: "ace/mode/html_elixir",
                model: Organization.current(),
                value: 'settings.email_template.mobile.verification.html_body',
                inputHandler: (value) => {
                  Organization.current().settings.email_template.mobile.verification.html_body = value
                }
              })
            ])
          ])
        ]),
        m(".ui tab segment", {"data-tab": "mobile-text-verification"}, [
          m("form.ui form", [
            m(".field", [
              m("label", "Body (formato testo)"),
              m(aceEditor, {
                className: "text-editor",
                mode: "ace/mode/text",
                model: Organization.current(),
                value: 'settings.email_template.mobile.verification.text_body',
                inputHandler: (value) => {
                  Organization.current().settings.email_template.mobile.verification.text_body = value
                }
              })
            ])
          ])
        ]),
        m(".inline field", [
          m(".ui checkbox", [
            m("input", {
              type: "checkbox",
              id: "mobile-verification-include-disclaimer",
              onclick(event) {
                Organization.current().settings.email_template.mobile.verification.include_disclaimer = event.target.checked
              },
              checked: _.get(
                Organization.current(),
                'settings.email_template.mobile.verification.include_disclaimer',
                true
              )
            }),
            m("label", {for: "mobile-verification-include-disclaimer", style: "cursor: pointer;"}, "Includi Disclaimer")
          ])
        ])
      ]),
      m(".ui tab segment", {"data-tab": "mobile-password-reset"}, [
        m("form.ui form", [
          m(".field", [
            m("label", "Oggetto"),
            m("input", {
              type: "text",
              placeholder: "Oggetto della mail",
              oninput(event) {
                Organization.current().settings.email_template.mobile.password_reset.subject = event.target.value
              },
              value: _.get(
                Organization.current(),
                'settings.email_template.mobile.password_reset.subject',
                ''
              )
            })
          ])
        ]),
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
              m("label", "Body (formato html)"),
              m(aceEditor, {
                className: "html-editor",
                mode: "ace/mode/html_elixir",
                model: Organization.current(),
                value: 'settings.email_template.mobile.password_reset.html_body',
                inputHandler: (value) => {
                  Organization.current().settings.email_template.mobile.password_reset.html_body = value
                }
              })
            ])
          ])
        ]),
        m(".ui tab segment", {"data-tab": "mobile-text-password-reset"}, [
          m("form.ui form", [
            m(".field", [
              m("label", "Body (formato testo)"),
              m(aceEditor, {
                className: "text-editor",
                mode: "ace/mode/text",
                model: Organization.current(),
                value: 'settings.email_template.mobile.password_reset.text_body',
                inputHandler: (value) => {
                  Organization.current().settings.email_template.mobile.password_reset.text_body = value
                }
              })
            ])
          ])
        ]),
        m(".inline field", [
          m(".ui checkbox", [
            m("input", {
              type: "checkbox",
              id: "mobile-password-reset-include-disclaimer",
              onclick(event) {
                Organization.current().settings.email_template.mobile.password_reset.include_disclaimer = event.target.checked
              },
              checked: _.get(
                Organization.current(),
                'settings.email_template.mobile.password_reset.include_disclaimer',
                true
              )
            }),
            m("label", {for: "mobile-password-reset-include-disclaimer", style: "cursor: pointer;"}, "Includi Disclaimer")
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
                mode: "ace/mode/html_elixir",
                model: Organization.current(),
                value: 'settings.email_template.mobile.disclaimer.html_body',
                inputHandler: (value) => {
                  Organization.current().settings.email_template.mobile.disclaimer.html_body = value
                }
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
                mode: "ace/mode/text",
                model: Organization.current(),
                value: 'settings.email_template.mobile.disclaimer.text_body',
                inputHandler: (value) => {
                  Organization.current().settings.email_template.mobile.disclaimer.text_body = value
                }
              })
            ])
          ])
        ])
      ])
    ];
  }
}

export default mobileTabView;
