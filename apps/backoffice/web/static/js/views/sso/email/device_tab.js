import m from 'mithril';
import webTabView from './web_tab';
import mobileTabView from './mobile_tab';

const deviceTabView = {
  view(vnode) {
    return [
      m(".ui pointing secondary web menu", {
        oncreate(_) {
          $('.web.menu .item').tab();
        }
      }, [
        m("a.item active", {"data-tab": "web"}, [
          "Web",
          m("i.help circle outline icon", {
            "data-content": "Template mail specifico per flussi web. ",
            oncreate({dom}) {
              $(dom).popup();
            }
          })
        ]),
        m("a.item", {"data-tab": "mobile"}, [
          "Mobile",
          m("i.help circle outline icon", {
            "data-content": "Template mail specifico per flussi mobile.",
            oncreate({dom}) {
              $(dom).popup();
            }
          })
        ])
      ]),
      m(".ui tab segment active", {"data-tab": "web"}, [
        m(webTabView)
      ]),
      m(".ui tab segment", {"data-tab": "mobile"}, [
        m(mobileTabView)
      ])
    ];
  }
}

export default deviceTabView;
