import m from 'mithril';
import _ from 'lodash';
import aceEditor from '../../../components/ace_editor';
import Organization from '../../../models/organization';

const verificationTabView = {
  view(vnode) {
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
        m("a.item active", {"data-tab": "html-verification"}, "HTML"),
        m("a.item", {"data-tab": "text-verification"}, "TESTO")
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
      ])
    ]);
  }
}

export default verificationTabView;
