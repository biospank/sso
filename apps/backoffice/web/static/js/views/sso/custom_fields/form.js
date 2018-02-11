import m from 'mithril';
import _ from 'lodash';
import stream from 'mithril/stream';
import CustomField from '../../../models/custom_field';

const formView = {
  oninit(vnode) {
    this.errors = stream({});
    // this.model = vnode.attrs.model();
    CustomField.current(vnode.attrs.model());

    this.addCustomField = () => {
      CustomField.list().push(CustomField.current());
      // this.model = vnode.attrs.model();
      CustomField.current(vnode.attrs.model());
    };
  },
  view({state}) {
    return m('.ui form error', [
      m('.fields', [
        m(".required field", {className: state.errors()["name"] ? "error" : ""}, [
          m("label", "Nome campo"),
          m("input", {
            autofocus: true,
            type: "text",
            name: "cfName",
            oninput: m.withAttr("value", CustomField.current().name),
            value: CustomField.current().name(),
            placeholder: "Nome campo"
          }),
          m(".ui basic error pointing prompt label transition ", {
            className: (state.errors()["name"] ? "visible" : "hidden")
          }, m('p', state.errors()["name"]))
        ]),
        m('.field', [
          m("label", "Tipologia"),
          m(".ui selection dropdown", {
            oncreate(vnode) {
              $('.ui.dropdown').dropdown();
            }
          }, [
            m("input", {
              type: "hidden",
              name: "name",
              value: CustomField.current().data_type(),
              onchange: m.withAttr("value", CustomField.current().data_type)
            }),
            m("i", { class: "dropdown icon" }),
            m(".text", CustomField.current().data_type() || CustomField.dataTypes[0].typeLabel),
            m(".menu", [
              CustomField.dataTypes.map((dataType) => {
                return m('.item', {
                  "data-value": dataType.typeValue,
                  className: (dataType.typeValue === CustomField.current().data_type() ? "active selected" : "")
                }, dataType.typeLabel);
              })
            ])
          ])
        ]),
        m('.field', [
          m("label", "Regola"),
          m(".ui selection dropdown", {
            oncreate(vnode) {
              $('.ui.dropdown').dropdown();
            }
          }, [
            m("input", {
              type: "hidden",
              name: "name",
              value: CustomField.current().rule_type(),
              onchange: m.withAttr("value", CustomField.current().rule_type)
            }),
            m("i", { class: "dropdown icon" }),
            m(".text", CustomField.current().rule_type() || CustomField.requiredRules[0].ruleLabel),
            m(".menu", [
              CustomField.requiredRules.map((ruleType) => {
                return m('.item', {
                  "data-value": ruleType.ruleValue,
                  className: (ruleType.ruleValue === CustomField.current().rule_type() ? "active selected" : "")
                }, ruleType.ruleLabel);
              })
            ])
          ])
        ]),
        m('.field', [
          m('label', 'vaffa'),
          m('.ui primary labeled icon button', {
            onclick() {
              console.log('adding..')
              state.addCustomField();
            }
          }, [
            m('i', {className: 'user icon'}),
            'Add Field'
          ])
        ])
      ])
    ])
  }
}

export default formView;
