import m from 'mithril';
import _ from 'lodash';
import stream from 'mithril/stream';

const AccountWidzard = {
  model: {
    orgId: stream(-1),
    orgName: stream(""),
    orgLabel: stream("Nessuna di queste"),
    orgEmail: stream(""),
    accountName: stream(""),
    accountEmail: stream("")
  }
};

export default AccountWidzard;
