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

    this.deleteCustomField = () => {
      _.remove(CustomField.list(), (field, index, array) => {
        return CustomField.current().id === field.id;
      });

      CustomField.current(vnode.attrs.model());
    };

    this.newCustomField = () => {
      CustomField.current(vnode.attrs.model());
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
                  CustomField.current().default()
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
    return m(".ui secondary segment", [
      m('.ui form error', [
        m('.five fields', [
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
                onchange(event) {
                  CustomField.current().data_type(event.target.value);

                  if(event.target.value === 'boolean')
                    CustomField.current().default('true')
                  else
                    CustomField.current().default('')
                }
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
          ])
        ]),
        m(".twelve fields", [
          m('.field', [
            m('.ui positive basic button', {
              onclick() {
                state.saveCustomField();
              }
            }, 'Salva')
          ]),
          m('.field', [
            m('.ui primary basic button', {
              onclick() {
                state.newCustomField();
              }
            }, 'Annulla')
          ]),
          m('.field', [
            m('.ui negative basic button', {
              onclick() {
                state.deleteCustomField();
              }
            }, 'Elimina')
          ])
        ])
      ])
    ])
  }
}

export default formView;
