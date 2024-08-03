import { Controller } from "@hotwired/stimulus";
import { get } from "@rails/request.js";

export default class extends Controller {
  static targets = ["subForm"];
  static values = {
    id: String, // may be empty, don't cast to 0
  };

  connect() {
    // console.log("works connected");
    // console.log(this.idValue === "");
    // console.log(this.subFormTargets);
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
        console.log("input", input);
        const inputName = input.getAttribute("name");
        console.log(inputName);
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
    dismissableForm.remove(); // subFormTargetDisconnected
  }

  selectProducer(event) {
    // console.log("selectProducer", event.currentTarget.value);
    let url = "/works/select_producer";
    url += `?producer_id=${event.currentTarget.value}`;

    if (this.idValue != "") {
      url += `&work_id=${this.idValue}`;
    }

    // https://github.com/hotwired/stimulus/issues/689
    // https://fly.io/ruby-dispatch/turbostream-fetch/
    get(url, {
      headers: {
        Accept: "text/vnd.turbo-stream.html, text/html, application/xhtml+xml",
      },
    });
  }
}
