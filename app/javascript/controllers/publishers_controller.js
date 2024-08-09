import { Controller } from "@hotwired/stimulus";
import { get } from "@rails/request.js";

export default class extends Controller {
  connect() {
    console.log("publishers connected");
  }

  // index.html.erb
  selectOrder(event) {
    console.log("selectOrder");

    const selection = event.currentTarget.value;
    const [order_param, dir_param] = selection.split("-");

    let url = "/publishers";
    url += `?order=${order_param}`;
    url += `&dir=${dir_param}`;

    // https://github.com/hotwired/stimulus/issues/689
    // https://fly.io/ruby-dispatch/turbostream-fetch/
    get(url, {
      headers: {
        Accept: "text/vnd.turbo-stream.html, text/html, application/xhtml+xml",
      },
    });

    event.currentTarget.value = "";
  }
}
