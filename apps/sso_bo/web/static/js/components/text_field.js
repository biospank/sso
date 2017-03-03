import m from 'mithril';

// const textField = (() => {
//   const showField = (attrs) => {
//     if(attrs.fieldType === "group") {
//       return m(".input-group", [
//         m("span", { className: "input-group-addon" }, [
//           m("i", { className: attrs.icon })
//         ]),
//         m(attrs.field || "input", _.assign(attrs, {
//           className: 'form-control ' + attrs.inputSize
//         }))
//       ]);
//     } else {
//       return m(attrs.field || "input", _.assign(attrs, {
//         class: 'form-control ' + attrs.inputSize
//       }));
//     }
//   }
//
//   return {
//     view: ({attrs}) => {
//       return m(".form-group", { className: attrs.error ? "has-error" : "" }, [
//         m("label", { className: attrs.labelStyles }, attrs.dataLabel ),
//         showField(attrs),
//         m("p", {
//           className: "error-label " + (attrs.error ? "show" : "hidden")
//         }, attrs.error)
//       ]);
//     }
//   }
// })();

const textField = {
  view({attrs}) {
    return [
      m('.field', {className: attrs.error ? "error" : ""}, [
        m('.ui left icon input', [
          m('i', {className: `${attrs.icon} icon`}),
          m('input', {
            type: attrs.type,
            name: attrs.name,
            placeholder: attrs.placeholder,
            oninput: attrs.oninput
          }),
        ]),
        m(".ui basic error pointing prompt label transition ", {
          className: (attrs.error ? "visible" : "hidden")
        }, m('p', attrs.error))
      ])
    ]
  }
};

export default textField;
