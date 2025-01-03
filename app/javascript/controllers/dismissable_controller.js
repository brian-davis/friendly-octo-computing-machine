import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["subForm", "notice", "errors"];

  connect() {
    // console.log("dismissable_controller connected", this.element);
    // console.log(this.idValue === "");
    // console.log(this.subFormTargets);
  }

  disconnect() {
    // console.log("disconnect");
  }

  // as multiple new associated Producer sub-forms can be added dynamically,
  // appended to the same list as sub-forms for already persisted associations (edit)
  // ensure that they all get unique index values so nothing is overwriting anything
  // else in the params collection.
  rebaseAssociationForms() {
    // console.log("rebaseAssociationForms()");

    for (let i = 0; i < this.subFormTargets.length; i++) {
      const currentSubForm = this.subFormTargets[i];
      // console.log("currentSubForm", currentSubForm);

      let subFormInputs = currentSubForm.querySelectorAll("input, select");
      // console.log("subFormInputs", subFormInputs);

      for (let ii = 0; ii < subFormInputs.length; ii++) {
        let input = subFormInputs[ii];
        // console.log("input", input);
        const inputName = input.getAttribute("name");
        // console.log(inputName);
        const newInputName = inputName.replace(/[0-9]/g, String(i));
        input.setAttribute("name", newInputName);

        const inputId = input.getAttribute("id");
        if (inputId) {
          const newInputId = inputId.replace(/[0-9]/g, String(i));
          input.setAttribute("id", newInputId);
        }
      }
    }
  }

  subFormTargetConnected() {
    // console.log("subFormTargetConnected()");
    this.rebaseAssociationForms();
  }

  subFormTargetDisconnected() {
    // console.log("subFormTargetdisonnected()");
    this.rebaseAssociationForms();
  }

  formDismiss(event) {
    const dismissableForm = event.srcElement.closest(".subFormContainer");
    dismissableForm.remove();
  }

  dismissErrors(event) {
    // console.log("dismissErrors");
    this.errorsTarget.remove();
  }

  dismissNotice(event) {
    // console.log("dismissNotice")
    // or this.element
    this.noticeTarget.remove();
  }
}
