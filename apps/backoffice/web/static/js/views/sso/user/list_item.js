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

    this.authUser = () => {
      return User.auth(this.user).then((response) => {
        this.user = response.user;
      }, (response) => {})
    }
  },
  view(vnode) {
    return m(".item", {
      // href: "/sso/user/1",
      // oncreate: m.route.link
    }, [
      m('.ui image', [
        m('img.ui avatar mini image', {src: "/images/user.png"})
      ]),
      m('.content', [
        m("h3", { class: "header mtb-10 text-teal weight-bold" }, `${this.user.profile.first_name} ${this.user.profile.last_name}`),
        m("p", { class: "meta" }, this.user.profile.profession),
        m("p", { class: "description" }, this.user.profile.specialization),
        m('.extra', [
          m("label", { class: "ui label" }, [
            m('i.at icon'),
            this.user.email
          ]),
          m("label", { class: "ui label" }, [
            m('i.call icon'),
            this.user.profile.phone_number
          ])
        ]),
        m('.extra', [
          m(loadingButton, {
            action: this.authUser,
            label: (this.user.status === 'verified' ? 'Autorizzato' : 'Autorizza'),
            style: 'ui right floated teal basic button',
            disabled: (this.user.status === 'verified' ? true : false)
          }),
          m(loadingButton, {
            action: this.toggleUser,
            label: (this.user.active ? 'Disattiva' : 'Attiva'),
            style: 'ui right floated teal basic button'
          }),
          m("a", {
            class: "ui right floated teal basic button",
            href: `/sso/user/${this.user.id}`,
            oncreate: m.route.link
          }, "Dettaglio")
        ])
      ])
    ]);
  }
}

export default listItem;
