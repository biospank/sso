import m from 'mithril';
import _ from 'lodash';
import stream from 'mithril/stream';
import aceEditor from '../../../components/ace_editor';
import Organization from '../../../models/organization';
import Template from '../../../models/template';

const passwordResetTabView = {
  oninit(vnode) {
    this.webPreview = stream("");
    this.mobilePreview = stream("");

    this.showWebPreview = () => {
      return Template.createPreview({
        subject: _.get(Organization.current(), "settings.email_template.password_reset.subject", undefined),
        htmlBody: _.get(Organization.current(), "settings.email_template.password_reset.web.html_body", undefined),
        textBody: _.get(Organization.current(), "settings.email_template.password_reset.web.text_body", undefined)
      }).then((response) => {
        this.webPreview(response);
      }, (response) => {
        this.webPreview(_.merge(response, {error: true}));
      });
    };

    this.showMobilePreview = () => {
      return Template.createPreview({
        subject: _.get(Organization.current(), "settings.email_template.password_reset.subject", undefined),
        htmlBody: _.get(Organization.current(), "settings.email_template.password_reset.mobile.html_body", undefined),
        textBody: _.get(Organization.current(), "settings.email_template.password_reset.mobile.text_body", undefined)
      }).then((response) => {
        this.mobilePreview(response);
      }, (response) => {
        this.mobilePreview(_.merge(response, {error: true}));
      });
    };

    this.showWebPreview();
    this.showMobilePreview();
  },
  view({state}) {
    return m(".ui tab segment", {"data-tab": "password-reset"}, [
      m("form.ui form", [
        m(".field", [
          m("label", "Oggetto"),
          m("input", {
            type: "text",
            placeholder: "Oggetto della mail",
            oninput(event) {
              _.merge(
                Organization.current(),
                {settings: {email_template: {password_reset: {subject: event.target.value}}}}
              );
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
          m("a.item active", {"data-tab": "web-html-password-reset"}, "Html"),
          m("a.item", {"data-tab": "web-text-password-reset"}, "Testo"),
          m("a.item", {
            "data-tab": "web-password-reset-preview",
            onclick(event) {
              state.showWebPreview();
            }
          }, "Anteprima")
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
                  _.merge(
                    Organization.current(),
                    {settings: {email_template: {password_reset: {web: {html_body: value}}}}}
                  );
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
                  _.merge(
                    Organization.current(),
                    {settings: {email_template: {password_reset: {web: {text_body: value}}}}}
                  );
                }
              })
            ])
          ])
        ]),
        m(".ui tab segment", {
          "data-tab": "web-password-reset-preview"
        }, [
          m(".ui styled fluid accordion", {
            oncreate({dom}) {
              $(dom).accordion();
            }
          }, [
            m(".title", [
              m("i.dropdown icon"),
              "Oggetto"
            ]),
            m(".content", [
              m(".ui", {
                className: (state.webPreview().error ? 'error message' : 'message')
              }, [
                m("pre.preview", state.webPreview().subject)
              ])
            ]),
            m(".active title", [
              m("i.dropdown icon"),
              "Html"
            ]),
            m(".active content", [
              m(".ui", {
                className: (state.webPreview().error ? 'error message' : 'message')
              }, [
                m("p", {
                  onupdate({dom}) {
                    dom.innerHTML = state.webPreview().html_body
                  }
                })
              ])
            ]),
            m(".title", [
              m("i.dropdown icon"),
              "Testo"
            ]),
            m(".content", [
              m(".ui", {
                className: (state.webPreview().error ? 'error message' : 'message')
              }, [
                m("pre.preview", state.webPreview().text_body)
              ])
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
          m("a.item active", {"data-tab": "mobile-html-password-reset"}, "Html"),
          m("a.item", {"data-tab": "mobile-text-password-reset"}, "Testo"),
          m("a.item", {
            "data-tab": "mobile-password-reset-preview",
            onclick(event) {
              state.showMobilePreview();
            }
          }, "Anteprima")
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
                  _.merge(
                    Organization.current(),
                    {settings: {email_template: {password_reset: {mobile: {html_body: value}}}}}
                  );
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
                  _.merge(
                    Organization.current(),
                    {settings: {email_template: {password_reset: {mobile: {text_body: value}}}}}
                  );
                }
              })
            ])
          ])
        ]),
        m(".ui tab segment", {
          "data-tab": "mobile-password-reset-preview"
        }, [
          m(".ui styled fluid accordion", {
            oncreate({dom}) {
              $(dom).accordion();
            }
          }, [
            m(".title", [
              m("i.dropdown icon"),
              "Oggetto"
            ]),
            m(".content", [
              m(".ui", {
                className: (state.mobilePreview().error ? 'error message' : 'message')
              }, [
                m("pre.preview", state.mobilePreview().subject)
              ])
            ]),
            m(".active title", [
              m("i.dropdown icon"),
              "Html"
            ]),
            m(".active content", [
              m(".ui", {
                className: (state.mobilePreview().error ? 'error message' : 'message')
              }, [
                m("p", {
                  onupdate({dom}) {
                    dom.innerHTML = state.mobilePreview().html_body
                  }
                })
              ])
            ]),
            m(".title", [
              m("i.dropdown icon"),
              "Testo"
            ]),
            m(".content", [
              m(".ui", {
                className: (state.mobilePreview().error ? 'error message' : 'message')
              }, [
                m("pre.preview", state.mobilePreview().text_body)
              ])
            ])
          ])
        ])
      ])
    ]);
  }
}

export default passwordResetTabView;
