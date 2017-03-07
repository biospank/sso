import m from 'mithril';

const userList = {
  view() {
    return m('.ui middle aligned divided list', [
      m('.item', [
        m('.right floated content', [
          m('.ui button', 'Verify')
        ]),
        m('img.ui avatar image', {src: "/backoffice/images/avatar2/small/lena.png"}),
        m('.content', 'Lena')
      ]),
      m('.item', [
        m('.right floated content', [
          m('.ui button', 'Verify')
        ]),
        m('img.ui avatar image', {src: "/images/avatar2/small/lindsay.png"}),
        m('.content', 'Lindsay')
      ]),
      m('.item', [
        m('.right floated content', [
          m('.ui button', 'Verify')
        ]),
        m('img.ui avatar image', {src: "/images/avatar2/small/mark.png"}),
        m('.content', 'Mark')
      ]),
      m('.item', [
        m('.right floated content', [
          m('.ui button', 'Verify')
        ]),
        m('img.ui avatar image', {src: "/images/avatar2/small/molly.png"}),
        m('.content', 'Molly')
      ])
    ]);
  }
}

export default userList;
