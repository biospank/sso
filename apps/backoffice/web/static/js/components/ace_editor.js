import m from 'mithril';
import _ from 'lodash';

const aceEditor = {
  onupdate({attrs, dom}) {
    ace.edit(dom).setValue( _.get(attrs.model, attrs.value, ''));
  },
  view({attrs}) {
    return m("", {
      className: attrs.className,
      oncreate({dom}) {
        dom.style.fontSize = attrs.fontSize || "16px";
        let editor = ace.edit(dom);
        // ace.require('ace/ext/statusbar').init(editor);
        editor.setTheme(attrs.theme || "ace/theme/twilight");
        editor.session.setOptions({
          useWorker: false,
          tabSize: 2,
          useSoftTabs: true
        });
        editor.setOption("autoScrollEditorIntoView", true);
        editor.$blockScrolling = Infinity;
        editor.session.setMode(attrs.mode);
        editor.setValue( _.get(attrs.model, attrs.value, ''));
        editor.getSession().on('change', (e) => {
          if(attrs.inputHandler)
            attrs.inputHandler(editor.getValue());
        });
      }
    })
  }
}

export default aceEditor;
