import m from 'mithril';
import _ from 'lodash';
import Organization from '../../../models/organization';

const organizationChoiceView = {
  oninit(vnode) {
    this.organizations = [];
    this.showLoader = vnode.attrs.showLoader;

    this.getAllOrganizations = () => {
      return Organization.all().then((response) => {
        this.organizations = response.organizations;
      }, (response) => {})
    };

    this.getAllOrganizations();

  },
  view({state}) {
    return m(".field", [
      m(".ui selection dropdown", {
        oncreate: function(vnode) {
          $('.ui.dropdown').dropdown();
        }
      }, [
        m("input", {
          type: "hidden",
          name: "account",
          value: Organization.choice.id(),
          onchange: m.withAttr("value", Organization.choice.id)
        }),
        m("i", { class: "dropdown icon" }),
        m(".text", Organization.choice.label()),
        m(".menu", [
          state.organizations.map((organization) => {
            return m('.item', {
              "data-value": organization.id,
              className: (organization.id === Organization.choice.id() ? "active selected" : ""),
              onclick: (event) => {
                state.showLoader(true);
                _.delay(() => {
                  Organization.choice.label(event.target.innerHTML);
                  Organization.current(
                    _.find(state.organizations, (org) => {
                      return org.id == event.target.dataset.value;
                    })
                  );
                  state.showLoader(false);
                  m.redraw();
                }, 500);
              }
            }, organization.name);
          })
        ])
      ])
    ])
  }
}

export default organizationChoiceView;
