import m from 'mithril';
import _ from 'lodash';
import aceEditor from '../../../components/ace_editor';
import Organization from '../../../models/organization';

const passwordResetTabView = {
  view(vnode) {
    return m(".ui tab segment", {"data-tab": "password-reset"}, [
      m("form.ui form", [
        m(".field", [
          m("label", "Oggetto"),
          m("input", {
            type: "text",
            placeholder: "Oggetto della mail",
            oninput(event) {
              Organization.current().settings.email_template.password_reset.subject = event.target.value
            },
            value: _.get(
              Organization.current(),
              'settings.email_template.password_reset.subject',
              ''
            )
          })
        ])
      ]),
      m(".ui pointing secondary device menu", {
        oncreate(_) {
          $('div[data-tab="password-reset"] .device.menu .item').tab();
        }
      }, [
        m("a.item active", {"data-tab": "web"}, [
          "Web",
          m("i.help circle outline icon", {
            "data-content": "Template mail specifico per flussi web. ",
            oncreate({dom}) {
              $(dom).popup();
            }
          })
        ]),
        m("a.item", {"data-tab": "mobile"}, [
          "Mobile",
          m("i.help circle outline icon", {
            "data-content": "Template mail specifico per flussi mobile.",
            oncreate({dom}) {
              $(dom).popup();
            }
          })
        ])
      ]),
      m(".ui tab segment active", {"data-tab": "web"}, [
        m(".ui pointing secondary web format menu", {
          oncreate(_) {
            $('div[data-tab="password-reset"] div[data-tab="web"] .format.menu .item').tab();
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
                value: 'settings.email_template.password_reset.web.html_body',
                inputHandler: (value) => {
                  Organization.current().settings.email_template.password_reset.web.html_body = value
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
                value: 'settings.email_template.password_reset.web.text_body',
                inputHandler: (value) => {
                  Organization.current().settings.email_template.password_reset.web.text_body = value
                }
              })
            ])
          ])
        ])
      ]),
      m(".ui tab segment", {"data-tab": "mobile"}, [
        m(".ui pointing secondary format menu", {
          oncreate(_) {
            $('div[data-tab="password-reset"] div[data-tab="mobile"] .format.menu .item').tab();
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
                value: 'settings.email_template.password_reset.mobile.html_body',
                inputHandler: (value) => {
                  Organization.current().settings.email_template.password_reset.mobile.html_body = value
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
                value: 'settings.email_template.password_reset.mobile.text_body',
                inputHandler: (value) => {
                  Organization.current().settings.email_template.password_reset.mobile.text_body = value
                }
              })
            ])
          ])
        ])
      ])
    ]);
  }
}

export default passwordResetTabView;
