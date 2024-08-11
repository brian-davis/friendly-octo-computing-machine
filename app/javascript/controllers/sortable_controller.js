import { Controller } from "@hotwired/stimulus";
import { get } from "@rails/request.js";

export default class extends Controller {
  static values = {};
  static outlets = ["request-helper"];

  connect() {
    // console.log("sortable connected");

    this.filterValue = "";
    this.orderValue = "";
    this.dirValue = "";
  }

  // index.html.erb
  selectOrder(event) {
    event.preventDefault();
    event.stopPropagation();
    // console.log("selectOrder");

    const selection = event.currentTarget.value;
    let [order_param, dir_param] = selection.split("-");
    this.orderValue = order_param;
    this.dirValue = dir_param;

    let url = event.currentTarget.dataset.actionUrl;

    if (this.orderValue) {
      url += `?order=${this.orderValue}`;
    }

    if (this.orderValue && this.dirValue) {
      url += `&dir=${this.dirValue}`;
    }

    if (this.filterValue) {
      url += `&tag=${this.filterValue}`;
    }
    // event.currentTarget.value = "";

    this.requestHelperOutlet.turboGet(url);
  }

  decorateTagClick(event) {
    event.preventDefault();
    event.stopPropagation();

    // console.log("decorateTagClick", event.currentTarget);
    this.filterValue = event.currentTarget.dataset.filterValue;

    const targetLink = event.currentTarget.closest("a");
    // console.log(targetLink);

    // http://localhost:3000/works?tag=Classics
    let url = targetLink.href;

    if (this.orderValue) {
      url += `&order=${this.orderValue}`;
    }

    if (this.orderValue && this.dirValue) {
      url += `&dir=${this.dirValue}`;
    }

    this.requestHelperOutlet.turboGet(url);
  }
}
