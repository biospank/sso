import m from 'mithril';

const aceEditor = {
  view({attrs}) {
    return m("", {
      className: attrs.className,
      oncreate({dom}) {
        dom.style.fontSize = attrs.fontSize;
        let editor = ace.edit(dom);
        // ace.require('ace/ext/statusbar').init(editor);
        editor.setTheme(attrs.theme);
        editor.session.setOption("useWorker", false);
        editor.setOption("autoScrollEditorIntoView", true);
        editor.$blockScrolling = Infinity;
        editor.session.setMode(attrs.mode);
        editor.setValue(attrs.initialValue);
      }
    })
  }
}

export default aceEditor;
