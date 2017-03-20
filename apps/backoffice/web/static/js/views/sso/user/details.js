import m from 'mithril';
import mixinLayout from '../../layout/mixin_layout';
import User from '../../../models/user';
const content = ({state}) => {
  if(state.user) {
    return m("form", { class: "ui form segment teal p-all-side-30" }, [
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
              value: state.user.profile.date_of_birth
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
        m(".field", [
          m("label", "Numero di telefono"),
          m("input", {
            type: "text",
            readonly:"",
            name: "phone_number",
            value: state.user.profile.phone_number
          })
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
