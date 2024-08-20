import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    // console.log("confirmable connected");
  }

  // Use this to add a confirmation dialog on method: :delete buttons,
  // which have Turbo disabled (for HTML format redirects).
  // It is impossible to specify a confirm option in the button_to while
  // also specifying turbo: false
  confirm(event) {
    // console.log("confirm");

    const confirmed = confirm("Are you sure?");
    if (!confirmed) {
      event.preventDefault();
      event.stopPropagation();
    }
  }
}
