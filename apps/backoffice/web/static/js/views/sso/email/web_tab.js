import m from 'mithril';
import _ from 'lodash';
import aceEditor from '../../../components/ace_editor';
import Organization from '../../../models/organization';

const webTabView = {
  view(vnode) {
    return [
      // m('p', JSON.stringify(Organization.current())),
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
        m("a.item", {"data-tab": "web-verification"}, [
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
        ])
      ]),
      m(".ui tab segment active", {"data-tab": "web-registration"}, [
        m("form.ui form", [
          m(".field", [
            m("label", "Oggetto"),
            m("input", {
              type: "text",
              placeholder: "Oggetto della mail",
              oninput(event) {
                Organization.current().settings.email_template.web.registration.subject = event.target.value
              },
              value: _.get(
                Organization.current(),
                'settings.email_template.web.registration.subject',
                ''
              )
            })
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
                mode: "ace/mode/html_elixir",
                model: Organization.current(),
                value: 'settings.email_template.web.registration.html_body',
                inputHandler: (value) => {
                  Organization.current().settings.email_template.web.registration.html_body = value
                }
              })
            ])
          ])
        ]),
        m(".ui tab segment", {"data-tab": "web-text-registration"}, [
          m("form.ui form", [
            m(".field", [
              m("label", "Body (formato testo)"),
              m(aceEditor, {
                className: "text-editor",
                mode: "ace/mode/text",
                model: Organization.current(),
                value: 'settings.email_template.web.registration.text_body',
                inputHandler: (value) => {
                  Organization.current().settings.email_template.web.registration.text_body = value
                }
              })
            ])
          ])
        ])
      ]),
      m(".ui tab segment", {"data-tab": "web-verification"}, [
        m('.ui menu', [
          m(".right menu", [
            m(".ui item", [
              m(".ui toggle checkbox", [
                m("input", {
                  type: "checkbox",
                  id: "web-verification-send",
                  onclick(event) {
                    Organization.current().settings.email_template.web.verification.send = event.target.checked
                  },
                  checked: _.get(
                    Organization.current(),
                    'settings.email_template.web.verification.send',
                    true
                  )
                }),
                m("label", {for: "web-verification-send", style: "cursor: pointer;"}, "Attivo")
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
                Organization.current().settings.email_template.web.verification.subject = event.target.value
              },
              value: _.get(
                Organization.current(),
                'settings.email_template.web.verification.subject',
                ''
              )
            })
          ])
        ]),
        m(".ui pointing secondary verification-format menu", {
          oncreate(_) {
            $('div[data-tab="web"] .verification-format.menu .item').tab();
          }
        }, [
          m("a.item active", {"data-tab": "web-html-verification"}, "HTML"),
          m("a.item", {"data-tab": "web-text-verification"}, "TESTO")
        ]),
        m(".ui tab segment active", {"data-tab": "web-html-verification"}, [
          m("form.ui form", [
            m(".field", [
              m("label", "Body (formato html)"),
              m(aceEditor, {
                className: "html-editor",
                mode: "ace/mode/html_elixir",
                model: Organization.current(),
                value: 'settings.email_template.web.verification.html_body',
                inputHandler: (value) => {
                  Organization.current().settings.email_template.web.verification.html_body = value
                }
              })
            ])
          ])
        ]),
        m(".ui tab segment", {"data-tab": "web-text-verification"}, [
          m("form.ui form", [
            m(".field", [
              m("label", "Body (formato testo)"),
              m(aceEditor, {
                className: "text-editor",
                mode: "ace/mode/text",
                model: Organization.current(),
                value: 'settings.email_template.web.verification.text_body',
                inputHandler: (value) => {
                  Organization.current().settings.email_template.web.verification.text_body = value
                }
              })
            ])
          ])
        ])
      ]),
      m(".ui tab segment", {"data-tab": "web-password-reset"}, [
        m("form.ui form", [
          m(".field", [
            m("label", "Oggetto"),
            m("input", {
              type: "text",
              placeholder: "Oggetto della mail",
              oninput(event) {
                Organization.current().settings.email_template.web.password_reset.subject = event.target.value
              },
              value: _.get(
                Organization.current(),
                'settings.email_template.web.password_reset.subject',
                ''
              )
            })
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
                mode: "ace/mode/html_elixir",
                model: Organization.current(),
                value: 'settings.email_template.web.password_reset.html_body',
                inputHandler: (value) => {
                  Organization.current().settings.email_template.web.password_reset.html_body = value
                }
              })
            ])
          ])
        ]),
        m(".ui tab segment", {"data-tab": "web-text-password-reset"}, [
          m("form.ui form", [
            m(".field", [
              m("label", "Body (formato testo)"),
              m(aceEditor, {
                className: "text-editor",
                mode: "ace/mode/text",
                model: Organization.current(),
                value: 'settings.email_template.web.password_reset.text_body',
                inputHandler: (value) => {
                  Organization.current().settings.email_template.web.password_reset.text_body = value
                }
              })
            ])
          ])
        ])
      ])
    ];
  }
}

export default webTabView;
