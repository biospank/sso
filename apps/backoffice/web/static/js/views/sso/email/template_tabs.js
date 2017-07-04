import m from 'mithril';
import _ from 'lodash';
import registrationTabView from './registration_tab';
import verificationTabView from './verification_tab';
import passwordResetTabView from './password_reset_tab';
import aceEditor from '../../../components/ace_editor';
import Organization from '../../../models/organization';

const templateTabsView = {
  view(vnode) {
    return [
      // m('p', JSON.stringify(Organization.current())),
      m(".ui pointing secondary template menu", {
        oncreate(_) {
          $('.template.menu .item').tab();
        }
      }, [
        m("a.item active", {
          "data-tab": "registration",
          onclick() {
            $('div[data-tab="registration"] .device.menu .item').tab('change tab', 'web');
          }
        }, [
          "Registrazione",
          m("i.help circle outline icon", {
            "data-content": "Mail inviata all'utente all'atto della registrazione.",
            oncreate({dom}) {
              $(dom).popup();
            }
          })
        ]),
        m("a.item", {
          "data-tab": "verification",
          onclick() {
            $('div[data-tab="verification"] .format.menu .item').tab('change tab', 'html-verification');
          }
        }, [
          "Verifica Utente",
          m("i.help circle outline icon", {
            "data-content": "Mail inviata all'utente alla verifica dei suoi dati.",
            oncreate({dom}) {
              $(dom).popup();
            }
          })
        ]),
        m("a.item", {
          "data-tab": "password-reset",
          onclick() {
            $('div[data-tab="password-reset"] .device.menu .item').tab('change tab', 'web');
          }
        }, [
          "Reset Password",
          m("i.help circle outline icon", {
            "data-content": "Mail inviata all'utente alla richiesta di reset della password.",
            oncreate({dom}) {
              $(dom).popup();
            }
          })
        ])
      ]),
      m(registrationTabView),
      m(verificationTabView),
      m(passwordResetTabView)
    ];
  }
}

export default templateTabsView;
