import m from 'mithril';
import _ from 'lodash';
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

    this.orgTagView = (user) => {
      return m("label", { class: "ui label" }, [
        m('i.sitemap icon'),
        user.organization.name
      ])
    }

    this.accountTagView = (user) => {
      return m("label", { class: "ui label" }, [
        m('i.home icon'),
        user.account.app_name
      ]);
    }

    this.consentsTagView = (user) => {
      return user.profile.app_consents.map((consent) => {
        return m("label", { class: "ui label" }, [
          m('i.checkmark box green icon'),
          consent.app_name
        ]);
      })
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
        m("h3", {
          class: "header mtb-10 text-teal weight-bold"
        }, `${this.user.profile.nome || this.user.profile.first_name} ${this.user.profile.cognome || this.user.profile.last_name}`),
        m('.extra', _.concat(
          this.orgTagView(this.user),
          this.accountTagView(this.user),
          this.consentsTagView(this.user)
        )),
        m('.extra', [
          m("label", { class: "ui label" }, [
            m('i.at icon'),
            this.user.email
          ]),
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
