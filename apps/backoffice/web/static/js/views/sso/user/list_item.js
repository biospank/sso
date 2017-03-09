import m from 'mithril';

const listItem = {
  oninit({attrs}) {
    this.user = attrs.user;
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
          m("button", { className: "ui right floated animated teal basic button", tabindex: "0" }, [
            m(".visible content", "Attivo"),
            m(".hidden content", "Disattiva")
          ])
        ])
      ])
    ]);
    // return m('.item ui segment p-all-side-10 user__item', [
    //   m("a", {
    //       href: "",
    //       oncreate: m.route.link,
    //       class: "user__item-avatar"
    //     }, [
    //     m('img.ui avatar mini image', {src: "/images/user.png"}),
    //     m("span", { class: "user__item-name" }, "Lena")
    //   ]),
    //   m(".right floated", [
    //     m("button", { class: "ui animated teal basic button", tabindex: "0" }, [
    //       m(".visible content", "Non autorizzato"),
    //       m(".hidden content", "Autorizza")
    //     ]),
    //     m("button", { class: "ui animated teal basic button", tabindex: "0" }, [
    //       m(".visible content", "Attivo"),
    //       m(".hidden content", "Disattiva")
    //     ])
    //   ])
    // ]);
  }
}

export default listItem;
