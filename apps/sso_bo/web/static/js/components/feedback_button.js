import m from 'mithril';

const feedbackButton = {
  oninit({attrs, state}) {
    state.label = attrs.label;
    state.style = attrs.style;

    state.actionWithFeedback = (event) => {
      event.preventDefault();

      state.label = attrs.feedbackLabel;
      state.style = attrs.style + ' disabled';
      // m.redraw();

      attrs.action({background: true}).then(() => {
        state.label = attrs.label;
        state.style = attrs.style;
        m.redraw();
      });
      // , () => {
      //   state.label = attrs.label;
      //   state.style = attrs.style;
      //   m.redraw();
      // });
    }

  },
  view({attrs, state}) {
    state.disabled = attrs.disabled || false;

    return m('button', {
              disabled: state.disabled,
              className: state.style + (state.disabled ? ' disabled' : ''),
              onclick: state.actionWithFeedback
            }, state.label);
  }
};

export default feedbackButton;
