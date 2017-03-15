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
      }, function(response) {
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
           //return m(recordNotFound);
        } else {
          return m('.ui link divided items', [
            User.list().map((user) => {
              return m(listItem, {
                key: user.id,
                user: user
              });
            })
          ])
        }
      }
    };

    this.getAllUsers(User.pageInfo.defaultParams || {});

  },
  view(vnode) {
    return [
      m('.ui top attached pagination menu', [
        paginate(vnode)
      ]),
      m('.ui attached segment', [
        vnode.state.showUsers(vnode)
      ]),
      m('.ui bottom attached pagination menu', [
        paginate(vnode)
      ])
    ]
  }
}

export default userList;
