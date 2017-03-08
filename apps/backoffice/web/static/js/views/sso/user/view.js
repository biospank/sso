import m from 'mithril';
import mixinLayout from '../../layout/mixin_layout';
import userList from './list';
import userFilters from './filters';

const content = () => {
  // return m('h3', 'User list');
  return [
    m(userFilters),
    m(userList)
  ];
};

const userView = {
  view: mixinLayout(content)
}

export default userView;
