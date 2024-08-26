import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    endpoint: String,
  };
  static outlets = ["request-helper"];

  connect() {
    // console.log("homepage connected");
    // console.log("this.endpointValue", this.endpointValue);
  }

  // index.html.erb
  selectPeriod(event) {
    event.preventDefault();
    event.stopPropagation();
    // console.log("selectPeriod");

    const selection = event.currentTarget.value;
    // console.log("selection", selection);

    let url = this.endpointValue;

    if (selection) {
      url += `?period=${selection}`;
    }

    console.log(url);
    this.requestHelperOutlet.turboGet(url);
  }
}
