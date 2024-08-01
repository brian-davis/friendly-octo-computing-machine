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
      const currentSubForm = this.subFormTargets[i];
      const label = currentSubForm.querySelector("label");
      const input = currentSubForm.querySelector("input");

      const labelFor = label.getAttribute("for");
      const newLabelFor = labelFor.replace(/[0-9]/g, String(i));
      label.setAttribute("for", newLabelFor);

      const inputName = input.getAttribute("name");
      const newInputName = inputName.replace(/[0-9]/g, String(i));
      input.setAttribute("name", newInputName);

      const inputId = input.getAttribute("id");
      const newInputId = inputId.replace(/[0-9]/g, String(i));
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

  // TODO: use hotwire
  formDismiss(event) {
    const dismissableForm = event.srcElement.closest(
      ".appendedProducerFormContainer"
    );
    dismissableForm.remove();
    this.appendFormIndex -= 1;
  }
}
