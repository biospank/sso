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
        m("a.item active", {"data-tab": "web"}, "Web"),
        m("a.item", {"data-tab": "mobile"}, "Mobile")
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
