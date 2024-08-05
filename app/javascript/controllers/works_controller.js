import { Controller } from "@hotwired/stimulus";
import { get } from "@rails/request.js";

export default class extends Controller {
  connect() {
    // console.log("works connected");
  }

  static values = {
    id: String, // may be empty, don't cast to 0
  };

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

    event.currentTarget.value = "";
  }
}
