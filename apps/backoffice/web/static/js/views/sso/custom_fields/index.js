import m from 'mithril';
import _ from 'lodash';
import stream from 'mithril/stream';
import mixinLayout from '../../layout/mixin_layout';
import loader from '../../../components/loader';
import organizationChoiceView from '../shared/organization_choice';
import loadingButton from '../../../components/loading_button';
import Organization from '../../../models/organization';
import CustomField from '../../../models/custom_field';
import message from '../../../components/message';
import textField from '../../../components/text_field';
import formView from './form';
import listView from './list';

const formContent = (state) => {
  if(_.isEmpty(Organization.current())) {
    return m('.ui attached segment')
  } else {
    return m('.ui attached segment', [
      m('', JSON.stringify(CustomField.current())),
      m('', JSON.stringify(CustomField.list())),
      m(formView, {model: CustomField.model}),
      m(listView, {list: CustomField.list})
    ]);
  }
};

const content = ({state}) => {
  return [
    m('.ui top attached menu', [
      m(".left menu", [
        m(".ui left aligned item", [
          m(organizationChoiceView, {showLoader: state.showLoader}),
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
            action: state.saveCustomFields,
            disabled: _.isEmpty(Organization.current()),
            label: 'Salva',
            style: 'ui teal basic button'
          })
        ])
      ])
    ]),
    formContent(state),
    m(loader, {show: state.showLoader()})
  ];
};

const indexView = {
  oninit(vnode) {
    // CustomField.reset();
    this.showLoader = stream(false);
    this.showSuccessMessage = stream(false);
    this.showErrorMessage = stream(false);

    this.saveCustomFields = () => {
      this.showLoader(true);
      return Organization.update().then((response) => {
        this.showLoader(false);
        vnode.state.showSuccessMessage(true);
      }, (response) => {
        vnode.state.showErrorMessage(true);
      });
    };
  },
  view: mixinLayout(content)
}

export default indexView;
