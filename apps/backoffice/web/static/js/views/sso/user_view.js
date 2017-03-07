import m from 'mithril';
import mixinLayout from '../layout/mixin_layout';
import userList from './user_list';
import userFilters from './user_filters';

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
