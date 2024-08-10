import { Controller } from "@hotwired/stimulus";
import { get } from "@rails/request.js";

export default class extends Controller {
  connect() {
    console.log("sortable connected");

    this.filterValue = "";
    this.orderValue = "";
    this.dirValue = "";
  }

  static values = {};

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

    this.turboRequest(url);

    // event.currentTarget.value = "";
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

    this.turboRequest(url);
  }

  async turboRequest(url) {
    // console.log(url);

    // https://github.com/hotwired/stimulus/issues/689
    // https://fly.io/ruby-dispatch/turbostream-fetch/
    // https://github.com/rails/request.js#how-to-use
    const response = await get(url, {
      headers: {
        Accept: "text/vnd.turbo-stream.html, text/html, application/xhtml+xml",
      },
    });

    if (response.ok) {
      console.log("OK");
    } else {
      console.debug(response);
    }
  }
}
