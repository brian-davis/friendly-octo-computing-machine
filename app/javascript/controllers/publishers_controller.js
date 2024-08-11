import { Controller } from "@hotwired/stimulus";
import { get } from "@rails/request.js";

export default class extends Controller {
  connect() {
    // console.log("publishers connected");
  }

  static outlets = ["request-helper"];

  // index.html.erb
  selectOrder(event) {
    event.preventDefault();
    event.stopPropagation();

    // console.log("selectOrder");

    const selection = event.currentTarget.value;
    const [order_param, dir_param] = selection.split("-");

    let url = "/publishers";
    url += `?order=${order_param}`;
    url += `&dir=${dir_param}`;

    this.requestHelperOutlet.turboGet(url);

    event.currentTarget.value = "";
  }
}
