import m from 'mithril';

const mixinLayout = (content, layout) => {
  const layouts = {
    login(content) {
      return [
        m('.ui three column centered grid container', [
          m('.column', [
            content
          ])
        ])
      ]
    },
    standard(content) {
      return [
        m("main", { className: "main-container" }, [
          content
        ])
      ]
    }
  };

  return (vnode) => {
    return layouts[(layout || "standard")](content(vnode));
  };
};

export default mixinLayout;
