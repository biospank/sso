import m from 'mithril';
import _ from 'lodash';
import stream from 'mithril/stream';
import aceEditor from '../../../components/ace_editor';
import Organization from '../../../models/organization';
import Template from '../../../models/template';

const verificationTabView = {
  oninit(vnode) {
    this.webPreview = stream("");

    this.showPreview = () => {
      return Template.createPreview({
        subject: _.get(Organization.current(), "settings.email_template.verification.subject", undefined),
        htmlBody: _.get(Organization.current(), "settings.email_template.verification.html_body", undefined),
        textBody: _.get(Organization.current(), "settings.email_template.verification.text_body", undefined)
      }).then((response) => {
        this.webPreview(response);
      }, (response) => {
        this.webPreview({
          error: true,
          subject: this.webPreview().subject,
          html_body: ((response.errors.context === "html_body") ? response.errors.message : this.webPreview().html_body),
          text_body: ((response.errors.context === "text_body") ? response.errors.message : this.webPreview().text_body)
        });
      });
    };

    this.showPreview();
  },
  view({state}) {
    return m(".ui tab segment", {"data-tab": "verification"}, [
      m('.ui menu', [
        m(".right menu", [
          m(".ui item", [
            m(".ui toggle checkbox", [
              m("input", {
                type: "checkbox",
                id: "verification-active",
                onclick(event) {
                  _.merge(
                    Organization.current(),
                    {settings: {email_template: {verification: {active: event.target.checked}}}}
                  );
                },
                checked: _.get(
                  Organization.current(),
                  'settings.email_template.verification.active',
                  true
                )
              }),
              m("label", {for: "verification-active", style: "cursor: pointer;"}, "Attivo")
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
              _.merge(
                Organization.current(),
                {settings: {email_template: {verification: {subject: event.target.value}}}}
              );
            },
            value: _.get(
              Organization.current(),
              'settings.email_template.verification.subject',
              ''
            )
          })
        ])
      ]),
      m(".ui pointing secondary format menu", {
        oncreate(_) {
          $('div[data-tab="verification"] .format.menu .item').tab();
        }
      }, [
        m("a.item active", {"data-tab": "html-verification"}, "Html"),
        m("a.item", {"data-tab": "text-verification"}, "Testo"),
        m("a.item", {
          "data-tab": "verification-preview",
          onclick(event) {
            state.showPreview();
          }
        }, "Anteprima")
      ]),
      m(".ui tab segment active", {"data-tab": "html-verification"}, [
        m("form.ui form", [
          m(".field", [
            m("label", "Body (formato html)"),
            m(aceEditor, {
              className: "html-editor",
              mode: "ace/mode/html_elixir",
              model: Organization.current(),
              value: 'settings.email_template.verification.html_body',
              inputHandler: (value) => {
                _.merge(
                  Organization.current(),
                  {settings: {email_template: {verification: {html_body: value}}}}
                );
              }
            })
          ])
        ])
      ]),
      m(".ui tab segment", {"data-tab": "text-verification"}, [
        m("form.ui form", [
          m(".field", [
            m("label", "Body (formato testo)"),
            m(aceEditor, {
              className: "text-editor",
              mode: "ace/mode/text",
              model: Organization.current(),
              value: 'settings.email_template.verification.text_body',
              inputHandler: (value) => {
                _.merge(
                  Organization.current(),
                  {settings: {email_template: {verification: {text_body: value}}}}
                );
              }
            })
          ])
        ])
      ]),
      m(".ui tab segment", {
        "data-tab": "verification-preview"
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
    ]);
  }
}

export default verificationTabView;
