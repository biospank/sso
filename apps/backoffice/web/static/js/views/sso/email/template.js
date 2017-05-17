import m from 'mithril';
import stream from 'mithril/stream';
import mixinLayout from '../../layout/mixin_layout';
import loader from '../../../components/loader';
import organizationChoiceView from './organization_choice';
import deviceTabView from './device_tab';

const content = ({state}) => {
  return [
    m('.ui top attached menu mt-0', [
      m(organizationChoiceView)
    ]),
    m('.ui attached segment', [
      m(deviceTabView, {showLoader: state.showLoader})
    ])
  ];
};

const templateView = {
  oninit(vnode) {
    this.showLoader = stream(false);
  },
  view: mixinLayout(content)
}

export default templateView;
