import m from 'mithril';
import _ from 'lodash';
import stream from 'mithril/stream';
import aceEditor from '../../../components/ace_editor';
import Organization from '../../../models/organization';
import Template from '../../../models/template';

const registrationTabView = {
  oninit(vnode) {
    this.webPreview = stream("");
    this.mobilePreview = stream("");

    this.showWebPreview = () => {
      return Template.createPreview({
        subject: _.get(Organization.current(), "settings.email_template.registration.subject", undefined),
        htmlBody: _.get(Organization.current(), "settings.email_template.registration.web.html_body", undefined),
        textBody: _.get(Organization.current(), "settings.email_template.registration.web.text_body", undefined)
      }).then((response) => {
        this.webPreview(response);
      }, (response) => {
      });
    };

    this.showMobilePreview = () => {
      return Template.createPreview({
        subject: _.get(Organization.current(), "settings.email_template.registration.subject", undefined),
        htmlBody: _.get(Organization.current(), "settings.email_template.registration.mobile.html_body", undefined),
        textBody: _.get(Organization.current(), "settings.email_template.registration.mobile.text_body", undefined)
      }).then((response) => {
        this.mobilePreview(response);
      }, (response) => {
      });
    };

    this.showWebPreview();
    this.showMobilePreview();
  },
  view({state}) {
    return m(".ui tab segment active", {"data-tab": "registration"}, [
      m("form.ui form", [
        m(".field", [
          m("label", "Oggetto"),
          m("input", {
            type: "text",
            placeholder: "Oggetto della mail",
            oninput(event) {
              _.merge(
                Organization.current(),
                {settings: {email_template: {registration: {subject: event.target.value}}}}
              );
            },
            value: _.get(
              Organization.current(),
              'settings.email_template.registration.subject',
              ''
            )
          })
        ])
      ]),
      m(".ui pointing secondary device menu", {
        oncreate(_) {
          $('div[data-tab="registration"] .device.menu .item').tab();
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
            $('div[data-tab="registration"] div[data-tab="web"] .format.menu .item').tab();
          }
        }, [
          m("a.item active", {"data-tab": "web-html-registration"}, "Html"),
          m("a.item", {"data-tab": "web-text-registration"}, "Testo"),
          m("a.item", {
            "data-tab": "web-registration-preview",
            onclick(event) {
              state.showWebPreview();
            }
          }, "Anteprima")
        ]),
        m(".ui tab segment active", {"data-tab": "web-html-registration"}, [
          m("form.ui form", [
            m(".field", [
              m("label", "Body (formato html)"),
              m(aceEditor, {
                className: "html-editor",
                mode: "ace/mode/html_elixir",
                model: Organization.current(),
                value: 'settings.email_template.registration.web.html_body',
                inputHandler: (value) => {
                  _.merge(
                    Organization.current(),
                    {settings: {email_template: {registration: {web: {html_body: value}}}}}
                  );
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
                value: 'settings.email_template.registration.web.text_body',
                inputHandler: (value) => {
                  _.merge(
                    Organization.current(),
                    {settings: {email_template: {registration: {web: {text_body: value}}}}}
                  );
                }
              })
            ])
          ])
        ]),
        m(".ui tab segment", {
          "data-tab": "web-registration-preview"
        }, [
          m(".ui styled fluid accordion", {
            oncreate({dom}) {
              $(dom).accordion();
            }
          }, [
            m(".active title", [
              m("i.dropdown icon"),
              "Html"
            ]),
            m(".active content", [
              m(".ui message", [
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
              m(".ui message", [
                m("pre.preview", state.webPreview().text_body)
              ])
            ])
          ])
        ])
      ]),
      m(".ui tab segment", {"data-tab": "mobile"}, [
        m(".ui pointing secondary format menu", {
          oncreate(_) {
            $('div[data-tab="registration"] div[data-tab="mobile"] .format.menu .item').tab();
          }
        }, [
          m("a.item active", {"data-tab": "mobile-html-registration"}, "Html"),
          m("a.item", {"data-tab": "mobile-text-registration"}, "Testo"),
          m("a.item", {
            "data-tab": "mobile-registration-preview",
            onclick(event) {
              state.showMobilePreview();
            }
          }, "Anteprima")
        ]),
        m(".ui tab segment active", {"data-tab": "mobile-html-registration"}, [
          m("form.ui form", [
            m(".field", [
              m("label", "Body (formato html)"),
              m(aceEditor, {
                className: "html-editor",
                mode: "ace/mode/html_elixir",
                model: Organization.current(),
                value: 'settings.email_template.registration.mobile.html_body',
                inputHandler: (value) => {
                  _.merge(
                    Organization.current(),
                    {settings: {email_template: {registration: {mobile: {html_body: value}}}}}
                  );
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
                value: 'settings.email_template.registration.mobile.text_body',
                inputHandler: (value) => {
                  _.merge(
                    Organization.current(),
                    {settings: {email_template: {registration: {mobile: {text_body: value}}}}}
                  );
                }
              })
            ])
          ])
        ]),
        m(".ui tab segment", {
          "data-tab": "mobile-registration-preview"
        }, [
          m(".ui styled fluid accordion", {
            oncreate({dom}) {
              $(dom).accordion();
            }
          }, [
            m(".active title", [
              m("i.dropdown icon"),
              "Html"
            ]),
            m(".active content", [
              m(".ui message", [
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
              m(".ui message", [
                m("pre.preview", state.mobilePreview().text_body)
              ])
            ])
          ])
        ])
      ])
    ]);
  }
}

export default registrationTabView;
