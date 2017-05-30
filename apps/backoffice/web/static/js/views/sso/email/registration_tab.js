import m from 'mithril';
import _ from 'lodash';
import stream from 'mithril/stream';
import aceEditor from '../../../components/ace_editor';
import Organization from '../../../models/organization';
import Backoffice from '../../../backoffice';
import Template from '../../../models/template';
import loadingButton from '../../../components/loading_button';

const registrationTabView = {
  oninit(vnode) {
    this.loadingPreview = stream(false);
    this.previewUrl = stream("");
    this.emailPreview = stream("");

    this.showPreview = (contents) => {
      // this.loadingPreview(true);
      return Template.createPreview(contents).then((response) => {
        this.previewUrl(`${Backoffice.domain}/backoffice/email_preview/${response.preview_id}`);
        this.emailPreview(response);
        // this.loadingPreview(false);
      }, (response) => {
        // this.loadingPreview(false);
      });
    };
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
              // if(!event.target.classList.contains('active')) {
                state.showPreview({
                  subject: Organization.current().settings.email_template.registration.subject,
                  htmlBody: Organization.current().settings.email_template.registration.web.html_body,
                  textBody: Organization.current().settings.email_template.registration.web.text_body,
                });
              // }
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
          className: (state.loadingPreview() ? 'loading': ''),
          "data-tab": "web-registration-preview"
        }, [
          m(".ui icon message", [
            m(".content", [
              m(".header", [
                "Html",
                m("i.html5 icon"),
              ]),
              m("p", {
                onupdate({dom}) {
                  dom.innerHTML = state.emailPreview().html_body
                }
              })
            ])
          ]),
          m(".ui icon message", [
            m(".content", [
              m(".header", [
                "Testo",
                m("i.align left icon"),
              ]),
              m("p", {
                onupdate({dom}) {
                  dom.innerHTML = state.emailPreview().text_body
                }
              })
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
              // if(!event.target.classList.contains('active')) {
                state.showPreview({
                  subject: Organization.current().settings.email_template.registration.subject,
                  htmlBody: Organization.current().settings.email_template.registration.mobile.html_body,
                  textBody: Organization.current().settings.email_template.registration.mobile.text_body,
                });
              // }
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
          className: (state.loadingPreview() ? 'loading': ''),
          "data-tab": "mobile-registration-preview"
        }, [
          m(".ui icon message", [
            m(".content", [
              m(".header", [
                "Html",
                m("i.html5 icon"),
              ]),
              m("p", {
                onupdate({dom}) {
                  dom.innerHTML = state.emailPreview().html_body
                }
              })
            ])
          ]),
          m(".ui icon message", [
            m(".content", [
              m(".header", [
                "Testo",
                m("i.align left icon"),
              ]),

              m("p", {
                onupdate({dom}) {
                  dom.innerHTML = state.emailPreview().text_body
                }
              })
            ])
          ])
        ])
      ])
    ]);
  }
}

export default registrationTabView;
