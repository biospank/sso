import m from 'mithril';

const loader = {
  view() {
    return m('.ui active inverted dimmer', [
      m('.ui text loader', 'Loading...')
    ])
  }
}

export default loader;
