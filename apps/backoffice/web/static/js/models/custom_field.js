import m from 'mithril';
import stream from 'mithril/stream';
import _ from 'lodash';

const CustomField = {
  current: stream({}),
  model(obj) {
    if(obj) {
      return {
        id: obj.id || _.uniqueId(),
        label: stream(obj.label),
        name: stream(obj.name),
        data_type: stream(obj.data_type),
        rule_type: stream(obj.rule_type),
        default: stream(obj.default),
        customizable: obj.customizable
      };
    } else {
      return {
        id: _.uniqueId(),
        label: stream(""),
        name: stream(""),
        data_type: stream(CustomField.dataTypes[0].typeValue),
        rule_type: stream(CustomField.ruleTypes[0].ruleValue),
        default: stream(""),
        customizable: true
      };
    }
  },
  plainModel() {
    let model =  CustomField.current();

    return {
      id: model.id,
      label: model.label(),
      name: model.name(),
      data_type: model.data_type(),
      rule_type: model.rule_type(),
      default: model.default(),
      customizable: model.customizable
    }
  },
  list: stream([]),
  initialize(withThese) {
    if(withThese) {
      return withThese.map((item) => {
        return _.assign(item, {id: _.uniqueId()});
      })
    } else {
      return [
        {
          id: _.uniqueId(),
          label: 'Privacy consent',
          name: 'privacy_consent',
          data_type: 'boolean',
          rule_type: 'required',
          default: 'false',
          customizable: false
        },
        {
          id: _.uniqueId(),
          label: 'Sso privacy consent',
          name: 'sso_privacy_consent',
          data_type: 'boolean',
          rule_type: 'required',
          default: 'false',
          customizable: false
        }
      ];
    }
  },
  dataTypes: [
    {typeLabel: 'Stringa', typeValue: 'string'},
    {typeLabel: 'Booleano', typeValue: 'boolean'}
  ],
  ruleTypes: [
    {ruleLabel: 'Facoltativo', ruleValue: 'optional'},
    {ruleLabel: 'Obbligatorio', ruleValue: 'required'}
  ],
  booleanDefaults: [
    {booleanLabel: 'Vero', booleanValue: 'true'},
    {booleanLabel: 'Falso', booleanValue: 'false'}
  ],
  hidden: [
    'id',
    'privacy_consent',
    'sso_privacy_consent',
    'app_consents',
    'activation_callback_url'
  ]
};

export default CustomField;
