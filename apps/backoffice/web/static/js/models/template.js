import m from 'mithril';
import Backoffice from '../backoffice';
import Session from './session';

const Template = {
  url: '/email_preview',
  createPreview(template) {
    return m.request({
      method: "POST",
      data: {
        subject: template.subject || "Oggetto mancante" ,
        html_body: template.htmlBody || "Body formato html mancante",
        text_body: template.textBody || "Body formato testo mancante"
      },
      url: Backoffice.apiBaseUrl() + this.url,
      config: function(xhr) {
        xhr.setRequestHeader("accept", "application/json");
        xhr.setRequestHeader("Authorization", `${Backoffice.realm} ${Session.token()}`)
      }
    });
  }
};

export default Template;
