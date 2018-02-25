import m from 'mithril';
import _ from 'lodash';
import CustomField from '../../../models/custom_field';

const listView = {
  oninit({attrs}) {
    if(_.isEmpty(attrs.customFields))
      CustomField.list(CustomField.initialize());
    else
      CustomField.list(CustomField.initialize(attrs.customFields));
  },
  view(vnode) {
    return m('.ui very basic selectable striped table', [
      m('thead', [
        m('th', {className: 'three wide'}, 'Etichetta'),
        m('th', {className: 'three wide'}, 'Nome'),
        m('th', {className: 'three wide'}, 'Tipologia'),
        m('th', {className: 'three wide'}, 'Valore predefinito'),
        m('th', {className: 'three wide'}, 'Regola')
      ]),
      m('tbody', CustomField.list().map((field) => {
        return m('tr', {
          style: field.customizable ? 'cursor: pointer;' : 'cursor: not-allowed;',
          className: field.customizable ? '' : 'error',
          onclick() {
            if(field.customizable)
              CustomField.current(CustomField.model(field));
          }
        }, [
            m('td', field.label),
            m('td', field.name),
            m('td', _.find(CustomField.dataTypes, ["typeValue", field.data_type]).typeLabel),
            m('td', field.default),
            m('td', _.find(CustomField.ruleTypes, ["ruleValue", field.rule_type]).ruleLabel)
          ]);
        })
      )
    ]);
  }
}

export default listView;
