import m from 'mithril';
import _ from 'lodash';
import stream from 'mithril/stream';

const defaultOrgLabel = "Nessuna di queste";

const AccountWidzard = {
  model: {
    orgId: stream(-1),
    orgName: stream(""),
    orgLabel: stream(defaultOrgLabel),
    orgEmail: stream(""),
    accountName: stream(""),
    accountEmail: stream("")
  },
  resetModel() {
    this.model.orgId(-1);
    this.model.orgName("");
    this.model.orgLabel(defaultOrgLabel);
    this.model.orgEmail("");
    this.model.accountName("");
    this.model.accountEmail("");
  }
};

export default AccountWidzard;
