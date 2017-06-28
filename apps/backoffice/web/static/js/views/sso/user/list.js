import m from 'mithril';
import _ from 'lodash';
import stream from 'mithril/stream';
import Pagination from '../../../components/pagination';
import Session from '../../../models/session';
import User from '../../../models/user';
import listItem from './list_item';

let paginate = ({state}) => {
  return m(new Pagination(), {
    pageInfo: _.assign(
      User.pageInfo,
      {
        xhr(params) {
          state.getAllUsers(params);
        },
        defaultParams: {
          filters: _.assign({}, User.filters)
        }
      }
    ),
    style: '.ui right floated pagination menu'
  });
}

const userList = {
  oninit(vnode) {
    this.errors = {};
    this.showLoader = vnode.attrs.showLoader;//stream(false);

    this.getAllUsers = (params) => {
      this.showLoader(true);
      return User.all(params).then(this.unwrapSuccess).then((response) => {
        User.list(response.users);
        this.showLoader(false);
      }, (response) => {
        this.errors = response.errors;
      })
    };

    this.unwrapSuccess = (response) => {
      if(response) {
        User.pageInfo = {
          totalEntries: response.total_entries,
          totalPages: response.total_pages,
          pageNumber: response.page_number
        };

        return response;
      }
    };

    this.showUsers = ({state}) => {
      if(!User.list()) {
        // this.showLoader(true);
        return m('');
      } else {
        if(_.isEmpty(User.list())) {
          return m('.ui bottom attached warning message', [
            m('i', {className: 'warning icon'}),
            'Nessun record trovato per il filtro impostato'
          ]);
        } else {
          return [
            m('.ui top attached borderless pagination menu mt-0', [
              paginate(vnode)
            ]),
            m('.ui attached segment', [
              m(".ui teal right ribbon label mt-15 p-all-side-15", [
                m("i", { class: "users icon" }),
                User.pageInfo.totalEntries
              ]),
              m('.ui divided items mt-0', [
                User.list().map((user) => {
                  return m(listItem, {
                    key: user.id,
                    user: user
                  });
                })
              ])
            ]),
            m('.ui bottom attached borderless pagination menu', [
              paginate(vnode)
            ])
          ];
        }
      }
    };

    this.getAllUsers(User.pageInfo.defaultParams || {});

  },
  view(vnode) {
    return [
      vnode.state.showUsers(vnode)
    ]
  }
}

export default userList;
