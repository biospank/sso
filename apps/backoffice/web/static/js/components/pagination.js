import m from 'mithril';
import _ from 'lodash';

const Pagination = () => {
  return {
    maxNumberOfPages() {
      return 5;
    },
    paginatedChunks() {
      return _.chunk(_.range(1, this.pageInfo.totalPages), this.maxNumberOfPages());
    },
    paginatedRange() {
      if(this.pageInfo.totalPages <= this.maxNumberOfPages()) {
        return _.range(
          1,
          this.pageInfo.totalPages + 1
        );
      } else if((this.pageInfo.totalPages > this.maxNumberOfPages()) &&
        (this.pageInfo.pageNumber > (this.pageInfo.totalPages - this.maxNumberOfPages()))) {
        return _.range(
          (this.pageInfo.totalPages - this.maxNumberOfPages()) + 1,
          this.pageInfo.totalPages + 1
        );
      } else {
        return _.find(
          this.paginatedChunks(), (chunk) => {
            return _.includes(chunk, this.pageInfo.pageNumber)
          }
        );
      }
    },
    renderStartEllipsis() {
      let diff = this.pageInfo.totalPages - this.maxNumberOfPages();

      if(((diff > 0) && (this.pageInfo.pageNumber > diff)) ||
        ((diff > 0) && (this.pageInfo.pageNumber > this.maxNumberOfPages())))
        return [
          m(new PaginationLink(), {
            action: (event) => {
              event.preventDefault();
              this.pageInfo.xhr(this.paramsFor(1));
            },
            idx: 1,
            currentPage: this.pageInfo.pageNumber
          }),
          m('.icon item', [
            m('i.teal ellipsis horizontal icon')
          ])
        ];
      else
        return m("")
    },
    renderEndEllipsis() {
      if(this.pageInfo.totalPages > this.maxNumberOfPages()) {
        if(this.pageInfo.pageNumber <= (this.pageInfo.totalPages - this.maxNumberOfPages())) {
          return [
            m('.icon item', [
              m('i.teal ellipsis horizontal icon')
            ]),
            m(new PaginationLink(), {
              action: (event) => {
                event.preventDefault();
                this.pageInfo.xhr(this.paramsFor(this.pageInfo.totalPages));
              },
              idx: this.pageInfo.totalPages,
              currentPage: this.pageInfo.pageNumber
            })
          ]
        }
      }
    },
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
                this.pageInfo.xhr(this.paramsFor(1));
              else
                void(0);
            },
            className: this.prevAvailable() ? 'active' : 'disabled'
          }, [
            m('i.left teal angle double icon')
          ]),
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
            m('i.left teal angle icon')
          ]),
          this.renderStartEllipsis()
        ).concat(
          _.map(this.paginatedRange(), (idx) => {
            return m(new PaginationLink(), {
              key: idx,
              action: (event) => {
                event.preventDefault();
                this.pageInfo.xhr(this.paramsFor(idx));
              },
              idx: idx,
              currentPage: this.pageInfo.pageNumber
            });
          })
        ).concat(
          this.renderEndEllipsis(),
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
            m('i.right teal angle icon')
          ]),
          m('a.icon item', {
            href: '#',
            onclick: (event) => {
              event.preventDefault();
              if(this.nextAvailable())
                this.pageInfo.xhr(this.paramsFor(this.pageInfo.totalPages));
              else
                void(0);
            },
            className: this.nextAvailable() ? 'active' : 'disabled'
          }, [
            m('i.right teal angle double icon')
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

      if(this.currentPage === this.idx) {
        return m(".item teal", {
          className: (this.currentPage === this.idx) ? "active" : "",
        }, this.idx);
      } else {
        return m("a.item", {
          className: (this.currentPage === this.idx) ? "active" : "",
          href: "#",
          onclick: this.action
        }, this.idx);
      }
    }
  };
}

export default Pagination;
