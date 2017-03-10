import m from 'mithril';

const loader = {
  view({attrs}) {
    return m('.ui inverted dimmer', {
      className: (attrs.show) ? 'active' : 'disabled'
    }, [
      m('.ui text loader', 'Loading...')
    ])
  }
}

export default loader;
