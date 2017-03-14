import m from 'mithril';
import User from '../../../models/user';
import loadingButton from '../../../components/loading_button';

const listItem = {
  oninit({attrs}) {
    this.user = attrs.user;

    this.toggleUser = () => {
      return User.toggle(this.user).then((response) => {
        this.user = response.user;
      }, (response) => {})
    }
  },
  view(vnode) {
    return m('.item', [
      m('.ui image', [
        m('img.ui avatar mini image', {src: "/images/user.png"})
      ]),
      m('.content', [
        m('a.header', `${this.user.profile.first_name} ${this.user.profile.last_name}`),
        m('.meta', this.user.profile.profession),
        m('.description', this.user.profile.specialization),
        m('.extra', [
          m('.ui label', [
            m('i.slack icon'),
            this.user.profile.board_member
          ]),
          m('.ui label', [
            m('i.call icon'),
            this.user.profile.phone_number
          ])
        ]),
        m('.extra', [
          m("button", { className: "ui right floated animated teal basic button", tabindex: "0" }, [
            m(".visible content", "Non autorizzato"),
            m(".hidden content", "Autorizza")
          ]),
          m(loadingButton, {
            action: this.toggleUser,
            label: (this.user.active ? 'Disattiva' : 'Attiva'),
            style: 'ui right floated teal basic button'
          })
        ])
      ])
    ]);
  }
}

export default listItem;