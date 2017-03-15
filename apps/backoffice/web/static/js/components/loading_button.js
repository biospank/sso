import m from 'mithril';

const loadingButton = {
  oninit({attrs, state}) {
    state.style = attrs.style;

    state.actionWithFeedback = (event) => {
      event.preventDefault();

      state.style = attrs.style + ' loading disabled';

      attrs.action({background: true}).then(() => {
        state.style = attrs.style;
        m.redraw();
      });
    }

  },
  view(vnode) {
    vnode.state.label = vnode.attrs.label;
    vnode.state.disabled = vnode.attrs.disabled || false;

    return m('button', {
              disabled: vnode.state.disabled,
              className: vnode.state.style + (vnode.state.disabled ? ' disabled' : ''),
              onclick: vnode.state.actionWithFeedback
            }, [vnode.state.label, vnode.children]);
  }
};

export default loadingButton;
