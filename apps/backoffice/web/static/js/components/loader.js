import m from 'mithril';

const loader = {
  view({attrs}) {
    return m('.ui loader', {
      className: (attrs.show) ? 'active' : 'disabled'
    })
  }
}

export default loader;
