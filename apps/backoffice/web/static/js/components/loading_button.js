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
  view({attrs, state}) {
    state.label = attrs.label;
    state.disabled = attrs.disabled || false;

    return m('button', {
              disabled: state.disabled,
              className: state.style + (state.disabled ? ' disabled' : ''),
              onclick: state.actionWithFeedback
            }, state.label);
  }
};

export default loadingButton;
