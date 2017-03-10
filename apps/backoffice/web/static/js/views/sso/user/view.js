import m from 'mithril';
import stream from 'mithril/stream';
import mixinLayout from '../../layout/mixin_layout';
import userList from './list';
import userFilters from './filters';
import User from '../../../models/user';
import loader from '../../../components/loader';

const content = ({state}) => {
  return [
    m(userFilters, {showLoader: state.showLoader}),
    m(userList, {showLoader: state.showLoader}),
    m(loader, {show: state.showLoader()})
  ];
};

const userView = {
  oninit(vnode) {
    this.showLoader = stream(false);
  },
  view: mixinLayout(content)
}

export default userView;
