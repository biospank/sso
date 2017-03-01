import m from 'mithril'

var mixinLayout = function(content, layout) {
  var layouts = {
    login: function(content) {
      return [
        m('', { class: 'ui middle aligned center aligned grid'}, [
          m('.login-box', [
            content
          ])
        ])
      ]
    },
    standard: function(content) {
      return [
        m("main", { class: "main-container" }, [
          content
        ])
      ]
    }
  };

  return function(ctrl) {
    return layouts[(layout || "standard")](content(ctrl));
  };
};

export default mixinLayout;
