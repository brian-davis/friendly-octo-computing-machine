import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "newProducerList",
    "appendedProducerForm",
    "persistedProducerForm",
    "subForm",
  ];

  connect() {
    // console.log("works connected");
  }

  // as multiple new associated Producer sub-forms can be added dynamically,
  // appended to the same list as sub-forms for already persisted associations (edit)
  // ensure that they all get unique index values so nothing is overwriting anything
  // else in the params collection.
  rebaseAssociationForms() {
    console.log("rebaseAssociationForms()");
    for (let i = 0; i < this.subFormTargets.length; i++) {
      let currentSubForm = this.subFormTargets[i];
      // console.log(i);
      // console.log(currentSubForm);
      let label = currentSubForm.querySelector("label");
      // console.log(label);

      let labelFor = label.getAttribute("for");
      // console.log(labelFor);
      let newLabelFor = labelFor.replace(/[0-9]/g, String(i));
      // console.log(newLabelFor);
      label.setAttribute("for", newLabelFor);

      let input = currentSubForm.querySelector("input");
      // console.log(input);

      let inputName = input.getAttribute("name");
      // console.log(inputName);
      let newInputName = inputName.replace(/[0-9]/g, String(i));
      // console.log(newInputName);
      input.setAttribute("name", newInputName);

      let inputId = input.getAttribute("id");
      let newInputId = inputId.replace(/[0-9]/g, String(i));
      // console.log(newInputId);
      input.setAttribute("id", newInputId);
    }
  }

  appendedProducerFormTargetConnected() {
    // TODO
    // console.log("appendedProducerFormTargetConnected()");
    this.rebaseAssociationForms();
  }

  appendedProducerFormTargetDisconnected() {
    // TODO
    // console.log("appendedProducerFormTargetdisonnected()");
    this.rebaseAssociationForms();
  }
}
