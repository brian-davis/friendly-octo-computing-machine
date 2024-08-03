import { Controller } from "@hotwired/stimulus";
import { get } from "@rails/request.js";

export default class extends Controller {
  static values = {
    id: String, // may be empty, don't cast to 0
  };

  connect() {
    console.log("producers connected");
    console.log("producers idValue", this.idValue);
  }

  selectWork(event) {
    console.log("selectWork", event.currentTarget.value);
    let url = "/producers/select_work";
    url += `?work_id=${event.currentTarget.value}`;

    if (this.idValue != "") {
      url += `&producer_id=${this.idValue}`;
    }
    console.log("selectWork", url);

    // https://github.com/hotwired/stimulus/issues/689
    // https://fly.io/ruby-dispatch/turbostream-fetch/
    get(url, {
      headers: {
        Accept: "text/vnd.turbo-stream.html, text/html, application/xhtml+xml",
      },
    });
  }
}
