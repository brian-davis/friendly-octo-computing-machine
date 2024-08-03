import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  // static targets = [];

  connect() {
    // console.log("dismissable_controller connected");
  }

  // TODO: use this instead of work_controller
  dismiss(event) {
    console.log("dismiss");
    const dismissableDiv = event.srcElement.closest(".dismissableDiv");
    dismissableDiv.remove();
  }
}
