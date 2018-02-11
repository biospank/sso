import m from 'mithril';
import stream from 'mithril/stream';
import _ from 'lodash';

const CustomField = {
  current: stream({}),
  model() {
    return {
      name: stream(""),
      data_type: stream(CustomField.dataTypes[0].typeValue),
      rule_type: stream(CustomField.requiredRules[0].ruleValue)
    }
  },
  list: stream([]),
  dataTypes: [
    {typeLabel: 'Valore singolo', typeValue: 'single'},
    {typeLabel: 'Valore multiplo', typeValue: 'multiple'}
  ],
  requiredRules: [
    {ruleLabel: 'Facoltativo', ruleValue: 'optional'},
    {ruleLabel: 'Obbligatorio', ruleValue: 'required'}
  ]
};

export default CustomField;
