import m from 'mithril';
import _ from 'lodash';
import stream from 'mithril/stream';

const showMessage = ({attrs}) => {
  if(attrs.showMessage) {
    return m("", {
      className: `ui ${attrs.messageType} message`,
      oncreate({dom}) {
        _.delay((el) => {
          $(el).transition('fade');
          attrs.callback();
        }, 2000, dom);
      }
    }, [
      m(".header", attrs.content)
    ])
  }
}

const message = {
  view(vnode) {
    return showMessage(vnode)
  }
}

export default message;
