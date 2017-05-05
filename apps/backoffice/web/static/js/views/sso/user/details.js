import m from 'mithril';
import _ from 'lodash';
import format from 'date-fns/format';
import mixinLayout from '../../layout/mixin_layout';
import User from '../../../models/user';
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
        href: '/sso/users',
        oncreate: m.route.link
      }, [
        m("i", { class: "left arrow icon" }),
        'Torna alla lista'
      ]),
      m("h3", { class: "ui dividing header pb-10 mb-25 teal weight-light" }, "Dettaglio Utente"),
      m("div", [
        m(".three fields", [
          m(".field", [
            m("label", "Email"),
            m("input", {
              type: "text",
              readonly:"",
              name: "email",
              value: state.user.email
            })
          ]),
          m(".field", [
            m("label", "Nome"),
            m("input", {
              type: "text",
              readonly:"",
              name: "first-name",
              value: state.user.profile.first_name
            })
          ]),
          m(".field", [
            m("label", "Cognome"),
            m("input", {
              type: "text",
              readonly:"",
              name: "last-name",
              value: state.user.profile.last_name
            })
          ])
        ]),
        m(".three fields", [
          m(".field", [
            m("label", "Codice Fiscale"),
            m("input", {
              type: "text",
              readonly:"",
              name: "fiscal_code",
              value: state.user.profile.fiscal_code
            })
          ]),
          m(".field", [
            m("label", "Data di nascita"),
            m("input", {
              type: "text",
              readonly:"",
              name: "date_of_birth",
              value: state.user.profile.date_of_birth //format(state.user.profile.date_of_birth, 'DD-MM-YYYY')
            })
          ]),
          m(".field", [
            m("label", "Luogo di nascita"),
            m("input", {
              type: "text",
              readonly:"",
              name: "place_of_birth",
              value: state.user.profile.place_of_birth
            })
          ])
        ]),
        m(".three fields", [
          m(".field", [
            m("label", "Numero di telefono"),
            m("input", {
              type: "text",
              readonly:"",
              name: "phone_number",
              value: state.user.profile.phone_number
            })
          ]),
          m(".field", [
            m("label", "Organizzazione"),
            m("input", {
              type: "text",
              readonly:"",
              name: "phone_number",
              value: state.user.organization.name
            })
          ]),
          m(".field", [
            m("label", "App/Sito"),
            m("input", {
              type: "text",
              readonly:"",
              name: "phone_number",
              value: state.user.account.app_name
            })
          ])
        ]),
        m(".two fields", [
          m(".field", [
            m("label", "Professione"),
            m("input", {
              type: "text",
              readonly:"",
              name: "profession",
              value: state.user.profile.profession
            })
          ]),
          m(".field", [
            m("label", "Specializzazione"),
            m("input", {
              type: "text",
              readonly:"",
              name: "specialization",
              value: state.user.profile.specialization
            })
          ])
        ]),
        m(".three fields", [
          m(".field", [
            m("label", "Iscrizione ordine"),
            m("input", {
              type: "text",
              readonly:"",
              name: "board_member",
              value: state.user.profile.board_member
            })
          ]),
          m(".field", [
            m("label", "Numero iscrizione"),
            m("input", {
              type: "text",
              readonly:"",
              name: "board_number",
              value: state.user.profile.board_number
            })
          ]),
          m(".field", [
            m("label", "Provincia iscrizione"),
            m("input", {
              type: "text",
              readonly:"",
              name: "province_board",
              value: state.user.profile.province_board
            })
          ])
        ]),
        m(".two fields", [
          m(".field", [
            m("label", "Attività lavorativa"),
            m("input", {
              type: "text",
              readonly:"",
              name: "employment",
              value: state.user.profile.employment
            })
          ]),
          m(".field", [
            m("label", "Provincia attività lavorativa"),
            m("input", {
              type: "text",
              readonly:"",
              name: "province_enployment",
              value: state.user.profile.province_enployment
            })
          ])
        ]),
        m("h4.ui dividing teal header", "Consensi"),
        m(".inline fields", [
          m(".field", [
            m("label", "Privacy:"),
            state.user.profile.app_consents.map((consent) => {
              return m("label", { class: "ui label" }, [
                m('i.checkmark box green icon'),
                consent.app_name
              ]);
            })
          ]),
          m(".field", [
            m("label", "Comunicazioni:"),
            (_.includes([true, "true", "1"], state.user.profile.news_consent) ? m('i.checkmark box green icon') : m('i.remove circle outline red icon')),
          ]),
          m(".field", [
            m("label", "Trattamento dati:"),
            (_.includes([true, "true", "1"], state.user.profile.data_transfer_consent) ? m('i.checkmark box green icon') : m('i.remove circle outline red icon')),
          ])
        ])
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

    this.getUser(attrs.id);

  },
  view: mixinLayout(content)
}

export default userDetails;
