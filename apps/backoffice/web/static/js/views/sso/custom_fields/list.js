import m from 'mithril';
import CustomField from '../../../models/custom_field';

const listView = {
  view({attrs}) {
    return m('.ui very basic selectable table', [
      m('thead', [
        m('th', {className: 'eight wide'}, 'Nome'),
        m('th', {className: 'six wide'}, 'Tipo'),
        m('th', {className: 'six wide'}, 'Regola')
      ]),
      m('tbody', attrs.list().map((field) => {
        return m('tr', {
          style: "cursor: pointer;",
          onclick() {
            CustomField.current(field);
          }
        }, [
            m('td', field.name()),
            m('td', field.data_type()),
            m('td', field.rule_type())
          ]);
        })
      )
    ]);
  }
}

export default listView;
