import m from 'mithril';
import stream from 'mithril/stream';
import _ from 'lodash';
import Backoffice from '../backoffice';
import Session from './session';

const User = {
  url: '/user',
  filters: {
    field: stream(""),
    fieldLabel: stream(""),
    term: stream(""),
    email: stream(""),
    status: stream(""),
    statusLabel: stream(""),
    account: stream(""),
    accountLabel: stream("Tutte le app")
  },
  filterFields: [
    {fieldLabel: 'Nome', fieldValue: 'first_name'},
    {fieldLabel: 'Cognome', fieldValue: 'last_name'},
    {fieldLabel: 'Professione', fieldValue: 'profession'},
    {fieldLabel: 'Specializzazione', fieldValue: 'specialization'},
    {fieldLabel: 'Iscrizione ordine', fieldValue: 'board_number'},
    {fieldLabel: 'Attività lavorativa', fieldValue: 'employment'}
  ],
  filterStatuses: [
    {statusLabel: 'Tutti gli utenti', statusValue: ''},
    {statusLabel: 'Utenti verificati', statusValue: 'verified'},
    {statusLabel: 'Utenti non verificati', statusValue: 'unverified'}
  ],
  list: stream(undefined),
  pageInfo: {},
  all(params) {
    return m.request({
      method: "GET",
      url: Backoffice.apiBaseUrl() +
        this.url + "?" + m.buildQueryString(params),
      config: function(xhr) {
        xhr.setRequestHeader("accept", "application/json");
        xhr.setRequestHeader("Authorization", `${Backoffice.realm} ${Session.token()}`)
      }
    });
  },
  get(userId) {
    return m.request({
      method: "GET",
      url: `${Backoffice.apiBaseUrl()}${this.url}/${userId}`,
      config: function(xhr) {
        xhr.setRequestHeader("accept", "application/json");
        xhr.setRequestHeader("Authorization", `${Backoffice.realm} ${Session.token()}`)
      }
    });
  },
  toggle(user) {
    let action = '';

    if(user.active)
      action = 'deactivate';
    else
      action = 'activate';

    return m.request({
      method: "PUT",
      url: `${Backoffice.apiBaseUrl()}${this.url}/${user.id}/${action}`,
      config: function(xhr) {
        xhr.setRequestHeader("accept", "application/json");
        xhr.setRequestHeader("Authorization", `${Backoffice.realm} ${Session.token()}`)
      }
    });
  },
  auth(user) {
    return m.request({
      method: "PUT",
      url: `${Backoffice.apiBaseUrl()}${this.url}/${user.id}/authorize`,
      config: function(xhr) {
        xhr.setRequestHeader("accept", "application/json");
        xhr.setRequestHeader("Authorization", `${Backoffice.realm} ${Session.token()}`)
      }
    });
  }
};

export default User;
