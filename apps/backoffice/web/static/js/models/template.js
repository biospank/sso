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
        html_body: template.htmlBody || "Anteprima formato html non disponibile",
        text_body: template.textBody || "Anteprima formato testo non disponibile"
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
