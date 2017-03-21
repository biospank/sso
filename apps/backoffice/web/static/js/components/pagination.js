import m from 'mithril';
import _ from 'lodash';

const Pagination = () => {
  return {
    paramsFor(pageNumber) {
      return _.assign(this.pageInfo.defaultParams || {}, { page: pageNumber });
    },
    prevAvailable() {
      return this.pageInfo.pageNumber > 1;
    },
    nextAvailable() {
      return this.pageInfo.pageNumber < this.pageInfo.totalPages;
    },
    view({attrs}) {
      this.pageInfo = attrs.pageInfo;

      if(this.pageInfo.totalPages > 1) {
        return m('', {
          className: attrs.style
        }, [].concat(
          m('a.icon item', {
            href: '#',
            onclick: (event) => {
              event.preventDefault();
              if(this.prevAvailable())
                this.pageInfo.xhr(this.paramsFor(this.pageInfo.pageNumber - 1));
              else
                void(0);
            },
            className: this.prevAvailable() ? 'active' : 'disabled'
          }, [
            m('i.left teal chevron icon')
          ])
        ).concat(
          _.times(this.pageInfo.totalPages, (idx) => {
            return m(new PaginationLink(), {
              key: idx,
              action: (event) => {
                event.preventDefault();
                this.pageInfo.xhr(this.paramsFor(idx + 1));
              },
              idx: (idx + 1),
              currentPage: this.pageInfo.pageNumber
            });
          })
        ).concat(
          m('a.icon item', {
            href: '#',
            onclick: (event) => {
              event.preventDefault();
              if(this.nextAvailable())
                this.pageInfo.xhr(this.paramsFor(this.pageInfo.pageNumber + 1));
              else
                void(0);
            },
            className: this.nextAvailable() ? 'active' : 'disabled'
          }, [
            m('i.right teal chevron icon')
          ])
        ));
      } else {
        return m('');
      }
    }
  };
}

const PaginationLink = () => {
  return {
    view({attrs}) {
      this.action = attrs.action;
      this.idx = attrs.idx;
      this.currentPage = attrs.currentPage;

      return m("a.item", {
        className: (this.currentPage === this.idx) ? "active" : "",
        href: "#",
        onclick: this.action
      }, this.idx);
    }
  };
}

export default Pagination;
