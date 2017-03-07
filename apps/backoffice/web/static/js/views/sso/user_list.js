import m from 'mithril';

const userList = {
  view() {
    return m('.ui segments list users', [
      m('.item ui segment p-all-side-10 user__item', [
        m("a", { href: "", config: m.route, class: "user__item-avatar" }, [
          m('img.ui avatar mini image', {src: "/images/square-image.png"}),
          m('span', { class: "user__item-name" }, 'Lena')
        ]),
        m('.right floated', [
          m("button", { class: "ui yellow basic button" }, [
            "Verifica"
          ]),
          m("button", { class: "ui red button" }, "Disattivo")
        ])
      ]),
      m('.item ui segment p-all-side-10 user__item', [
        m("a", { href: "", config: m.route, class: "user__item-avatar" }, [
          m('img.ui avatar mini image', {src: "/images/square-image.png"}),
          m('span', { class: "user__item-name" }, 'Lena')
        ]),
        m('.right floated', [
          m("button", { class: "ui basic teal button" }, [
            m("i", { class: "checkmark icon" }),
            "Verificato"
          ]),
          m("button", { class: "ui teal button" }, "Attivo")
        ])
      ]),
      m('.item ui segment p-all-side-10 user__item', [
        m("a", { href: "", config: m.route, class: "user__item-avatar" }, [
          m('img.ui avatar mini image', {src: "/images/square-image.png"}),
          m('span', { class: "user__item-name" }, 'Lena')
        ]),
        m('.right floated', [
          m("button", { class: "ui basic teal button" }, [
            m("i", { class: "checkmark icon" }),
            "Verificato"
          ]),
          m("button", { class: "ui teal button" }, "Attivo")
        ])
      ]),
      m('.item ui segment p-all-side-10 user__item', [
        m("a", { href: "", config: m.route, class: "user__item-avatar" }, [
          m('img.ui avatar mini image', {src: "/images/square-image.png"}),
          m('span', { class: "user__item-name" }, 'Lena')
        ]),
        m('.right floated', [
          m("button", { class: "ui basic yellow button" }, [
            "Verifica"
          ]),
          m("button", { class: "ui teal button" }, "Attivo")
        ])
      ])
    ]);
  }
}

export default userList;
