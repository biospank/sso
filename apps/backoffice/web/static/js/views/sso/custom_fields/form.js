import m from 'mithril';
import _ from 'lodash';
import stream from 'mithril/stream';
import CustomField from '../../../models/custom_field';

const formView = {
  oninit(vnode) {
    this.errors = stream({});
    CustomField.current(vnode.attrs.model());

    this.isValid = () => {
      if(_.isEmpty(CustomField.current().label()))
        this.errors({'label': 'Non può essere vuoto'});

      return _.isEmpty(this.errors());
    };

    this.saveCustomField = () => {
      this.errors({});

      if(this.isValid()) {
        let currentField = _.find(CustomField.list(), ["id", CustomField.current().id]);

        if(currentField)
          _.assign(currentField, CustomField.plainModel());
        else
          CustomField.list().push(CustomField.plainModel());

        CustomField.current(vnode.attrs.model());
      }
    };

    this.defaultField = () => {
      if(_.isEqual(CustomField.current().data_type(), 'string')) {
        return m(".field", [
          m("label", "Valore predefinito"),
          m("input", {
            type: "text",
            name: "cfDefaultString",
            oninput: m.withAttr("value", CustomField.current().default),
            value: CustomField.current().default()
          })
        ])
      } else {
        return m('.field', [
          m("label", "Valore predefinito"),
          m(".ui selection dropdown", {
            oncreate(vnode) {
              $('.ui.dropdown').dropdown();
            }
          }, [
            m("input", {
              type: "hidden",
              name: "cfDefaultBoolean",
              value: CustomField.current().default(),
              onchange: m.withAttr("value", CustomField.current().default)
            }),
            m("i", { class: "dropdown icon" }),
            m(".text", _.find(CustomField.booleanDefaults,
                [
                  "booleanValue",
                  CustomField.current().default() || 'true'
                ]
              ).booleanLabel
            ),
            m(".menu", [
              CustomField.booleanDefaults.map((booleanType) => {
                return m('.item', {
                  "data-value": booleanType.booleanValue,
                  className: (booleanType.booleanValue === CustomField.current().default() ? "active selected" : "")
                }, booleanType.booleanLabel);
              })
            ])
          ])
        ]);
      }
    };
  },
  view({state}) {
    return m('.ui form error', [
      m('.fields', [
        m(".required field", {className: state.errors()["label"] ? "error" : ""}, [
          m("label", "Etichetta"),
          m("input", {
            autofocus: true,
            type: "text",
            name: "cfLabel",
            oninput(event) {
              CustomField.current().label(event.target.value);
              CustomField.current().name(_.snakeCase(_.deburr(event.target.value)));
            },
            value: CustomField.current().label(),
            placeholder: "Etichetta"
          }),
          m(".ui basic error pointing prompt label transition ", {
            className: (state.errors()["label"] ? "visible" : "hidden")
          }, m('p', state.errors()["label"]))
        ]),
        m(".field", [
          m("label", "Nome"),
          m("input", {
            type: "text",
            disabled: "disabled",
            name: "cfName",
            oninput: m.withAttr("value", CustomField.current().name),
            value: CustomField.current().name()
          })
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
              name: "cfType",
              value: CustomField.current().data_type(),
              onchange: m.withAttr("value", CustomField.current().data_type)
            }),
            m("i", { class: "dropdown icon" }),
            m(".text", _.find(CustomField.dataTypes,
                ["typeValue", CustomField.current().data_type()]
              ).typeLabel || CustomField.dataTypes[0].typeLabel
            ),
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
        state.defaultField(),
        m('.field', [
          m("label", "Regola"),
          m(".ui selection dropdown", {
            oncreate(vnode) {
              $('.ui.dropdown').dropdown();
            }
          }, [
            m("input", {
              type: "hidden",
              name: "cfRule",
              value: CustomField.current().rule_type(),
              onchange: m.withAttr("value", CustomField.current().rule_type)
            }),
            m("i", { class: "dropdown icon" }),
            m(".text", _.find(CustomField.ruleTypes,
                ["ruleValue", CustomField.current().rule_type()]
              ).ruleLabel || CustomField.ruleTypes[0].ruleLabel
            ),
            m(".menu", [
              CustomField.ruleTypes.map((ruleType) => {
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
              state.saveCustomField();
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
