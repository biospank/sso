import m from 'mithril';
import _ from 'lodash';
import stream from 'mithril/stream';
import mixinLayout from '../../layout/mixin_layout';
import loader from '../../../components/loader';
import organizationChoiceView from './organization_choice';
import deviceTabView from './device_tab';
import loadingButton from '../../../components/loading_button';
import Organization from '../../../models/organization';
import message from '../../../components/message';

const content = ({state}) => {
  return [
    m('.ui top attached menu', [
      m(".left menu", [
        m(".ui left aligned item", [
          m(organizationChoiceView),
        ])
      ]),
      m(message, {
        showMessage: state.showSuccessMessage(),
        messageType: "info mini",
        content: "Salvataggio avvenuto correttamente",
        callback() {
          state.showSuccessMessage(false);
        }
      }),
      m(message, {
        showMessage: state.showErrorMessage(),
        messageType: "error mini",
        content: "Errore durante il salvataggio. Contattare il servizio tecnico.",
        callback() {
          state.showErrorMessage(false);
        }
      }),
      m(".right menu", [
        m(".ui right aligned item", [
          m(loadingButton, {
            action: state.saveTemplates,
            disabled: _.isEmpty(Organization.current()),
            label: 'Salva',
            style: 'ui teal basic button'
          })
        ])
      ])
    ]),
    _.isEmpty(Organization.current()) ?
    m('.ui attached segment')
    :
    m('.ui attached segment', [
      m(deviceTabView)
    ])
  ];
};

const templateView = {
  oninit(vnode) {
    this.showLoader = stream(false);
    this.showSuccessMessage = stream(false);
    this.showErrorMessage = stream(false);

    this.saveTemplates = () => {
      return Organization.update().then((response) => {
        vnode.state.showSuccessMessage(true);
      }, (response) => {
        vnode.state.showErrorMessage(true);
      });
    };
  },
  view: mixinLayout(content)
}

export default templateView;
