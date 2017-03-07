import m from 'mithril';
import mixinLayout from '../layout/mixin_layout';
import Session from '../../models/session';

const content = ({state}) => {
  return m('h3', "Dashboard");
};

const dashboard = {
  oninit() {
    if(Session.isExpired())
      m.route.set("/signin")
  },
  view: mixinLayout(content)
};

export default dashboard;
