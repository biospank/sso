import m from 'mithril';

const userList = {
  view() {
    return m('.ui segments list users', [
      m('.item ui segment p-all-side-10 user__item', [
        m("a", { href: "", config: m.route, class: "user__item-avatar" }, [
          m('img.ui avatar mini image', {src: "/images/user.png"}),
          m("span", { class: "user__item-name" }, "Lena")
        ]),
        m(".right floated", [
          m("button", { class: "ui animated teal basic button", tabindex: "0" }, [
            m(".visible content", "Non autorizzato"),
            m(".hidden content", "Autorizza")
          ]),
          m("button", { class: "ui animated teal basic button", tabindex: "0" }, [
            m(".visible content", "Attivo"),
            m(".hidden content", "Disattiva")
          ])
        ])
      ]),
      m('.item ui segment p-all-side-10 user__item', [
        m("a", { href: "", config: m.route, class: "user__item-avatar" }, [
          m('img.ui avatar mini image', {src: "/images/user.png"}),
          m('span', { class: "user__item-name" }, 'Lena')
        ]),
        m('.right floated', [
          m("button", { class: "ui animated teal basic button", tabindex: "0" }, [
            m(".visible content", "Non autorizzato"),
            m(".hidden content", "Autorizza")
          ]),
          m("button", { class: "ui animated teal basic button", tabindex: "0" }, [
            m(".visible content", "Attivo"),
            m(".hidden content", "Disattiva")
          ])
        ])
      ]),
      m('.item ui segment p-all-side-10 user__item', [
        m("a", { href: "", config: m.route, class: "user__item-avatar" }, [
          m('img.ui avatar mini image', {src: "/images/user.png"}),
          m('span', { class: "user__item-name" }, 'Lena')
        ]),
        m('.right floated', [
          m("button", { class: "ui animated teal basic button", tabindex: "0" }, [
            m(".visible content", "Non autorizzato"),
            m(".hidden content", "Autorizza")
          ]),
          m("button", { class: "ui animated teal basic button", tabindex: "0" }, [
            m(".visible content", "Attivo"),
            m(".hidden content", "Disattiva")
          ])
        ])
      ]),
      m('.item ui segment p-all-side-10 user__item', [
        m("a", { href: "", config: m.route, class: "user__item-avatar" }, [
          m('img.ui avatar mini image', {src: "/images/user.png"}),
          m('span', { class: "user__item-name" }, 'Lena')
        ]),
        m('.right floated', [
          m("button", { class: "ui animated teal basic button", tabindex: "0" }, [
            m(".visible content", "Non autorizzato"),
            m(".hidden content", "Autorizza")
          ]),
          m("button", { class: "ui animated teal basic button", tabindex: "0" }, [
            m(".visible content", "Attivo"),
            m(".hidden content", "Disattiva")
          ])
        ])
      ])
    ]);
  }
}

export default userList;
