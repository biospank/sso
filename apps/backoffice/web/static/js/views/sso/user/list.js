import m from 'mithril';
import _ from 'lodash';
import stream from 'mithril/stream';
import Pagination from '../../../components/pagination';
import loader from '../../../components/loader';
import Session from '../../../models/session';
import User from '../../../models/user';
import listItem from './list_item';

let paginate = ({state}) => {
  return m(new Pagination(), {
    pageInfo: _.assign(
      state.pageInfo,
      {
        xhr(params) {
          state.getUsers(params);
        },
        defaultParams: {
          filter: state.filter()
        }
      }
    ),
    style: '.ui right floated pagination menu'
  });
}

const userList = {
  oninit(vnode) {
    this.users = stream(undefined);
    this.errors = {};
    this.filter = stream("");
    this.pageInfo = {};
    this.showLoader = stream(false);

    if(Session.isExpired()) {
      m.route.set("/signin");
    }

    this.getUsers = (params) => {
      this.showLoader(true);
      return User.all(params).then(this.unwrapSuccess).then((users) => {
        this.users(users);
        this.showLoader(false);
      }, function(response) {
        this.errors = response.errors;
      })
    };

    this.unwrapSuccess = (response) => {
      if(response) {
        this.pageInfo = {
          totalEntries: response.total_entries,
          totalPages: response.total_pages,
          pageNumber: response.page_number
        };

        return response.users;
      }
    };

    this.showUsers = ({state}) => {
      if(!this.users()) {
        this.showLoader(true);
        return m('');
      } else {
        if(_.isEmpty(this.users())) {
           //return m(recordNotFound);
        } else {
          return m('.ui link divided items', [
            this.users().map((user) => {
              return m(listItem, {user: user});
            })
          ])
        }
      }
    };

    this.getUsers(this.pageInfo.defaultParams || {});

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
      ]),
      m(loader, {show: this.showLoader()})
    ]
  }
}

export default userList;
