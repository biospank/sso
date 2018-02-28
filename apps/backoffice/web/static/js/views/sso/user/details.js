import m from 'mithril';
import _ from 'lodash';
import format from 'date-fns/format';
import mixinLayout from '../../layout/mixin_layout';
import User from '../../../models/user';
import CustomField from '../../../models/custom_field';
import loadingButton from '../../../components/loading_button';

const content = ({state}) => {
  if(state.user) {
    return m("div", { class: "ui form segment teal p-all-side-30" }, [
      m(loadingButton, {
        action: state.authUser,
        label: (state.user.status === 'verified' ? 'Autorizzato' : 'Autorizza'),
        style: 'ui right floated teal basic button',
        disabled: (state.user.status === 'verified' ? true : false)
      }),
      m(loadingButton, {
        action: state.toggleUser,
        label: (state.user.active ? 'Disattiva' : 'Attiva'),
        style: 'ui right floated teal basic button'
      }),
      m("button", {
        className: "ui right floated teal basic button",
        onclick() {
          m.route.set(`/sso/user/${state.user.id}/password/change`)
        }
      }, 'Cambia password'),
      m("button", {
        className: "ui right floated teal basic button",
        onclick() {
          m.route.set(`/sso/user/${state.user.id}/email/change`)
        }
      }, 'Cambia mail'),
      m("button", {
        className: "ui right floated teal basic button",
        href: '/sso/users',
        oncreate: m.route.link
      }, [
        m("i", { class: "left arrow icon" }),
        'Torna alla lista'
      ]),
      m("span", { class: "ui orange label" }, `${state.user.profile.first_name} ${state.user.profile.last_name} (${state.user.email})` ),
      m("h2", { class: "ui dividing header pb-10 mb-25 teal weight-light" }, "Dettaglio Utente"),
      m(".ui grid",
        _.map(state.removeHiddenFields(), (value, key) => {
          return m(".four wide column", [
            m(".field", [
              m("label", state.labelFor(key)),
              m("input", {
                type: "text",
                readonly:"",
                name: key,
                value: value
              })
            ])
          ]);
        })
      ),
      m("h4.ui dividing teal header", "Consensi"),
      m(".inline fields", [
        m(".field", [
          m("label", "Privacy:"),
          (state.user.profile.app_consents || []).map((consent) => {
            return m("label", { class: "ui label" }, [
              m('i.checkmark box green icon'),
              consent.app_name
            ]);
          })
        ])
        // ,
        // m(".field", [
        //   m("label", "Comunicazioni:"),
        //   (_.includes([true, "true", "1"], state.user.profile.news_consent) ? m('i.checkmark box green icon') : m('i.remove circle outline red icon')),
        // ]),
        // m(".field", [
        //   m("label", "Raccolta dati per profilazione:"),
        //   (_.includes([true, "true", "1"], state.user.profile.data_transfer_consent) ? m('i.checkmark box green icon') : m('i.remove circle outline red icon')),
        // ])
      ])
    ]);
  } else {
    return m('');
  }
};

const userDetails = {
  oninit({attrs}) {
    this.user = null;

    this.toggleUser = () => {
      return User.toggle(this.user).then((response) => {
        this.user = response.user;
      }, (response) => {})
    }

    this.authUser = () => {
      return User.auth(this.user).then((response) => {
        this.user = response.user;
      }, (response) => {})
    }

    this.getUser = (id) => {
      return User.get(id).then((response) => {
        this.user = response.user;
      }, (response) => {});
    };

    this.labelFor = (key) => {
      return _.find(
        this.user.organization.settings.custom_fields,
        ['name', key]
      ).label
    };

    this.removeHiddenFields = () => {
      let obj = _.clone(this.user.profile);

      _.forEach(CustomField.hidden, (prop) => {
        _.unset(obj, prop);
      });

      return obj;
    };

    this.getUser(attrs.id);

  },
  view: mixinLayout(content)
}

export default userDetails;
