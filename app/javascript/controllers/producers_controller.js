import { Controller } from "@hotwired/stimulus";
import { get } from "@rails/request.js";

export default class extends Controller {
  static values = {
    id: String, // may be empty, don't cast to 0
  };

  connect() {
    // console.log("producers connected");
    // console.log("producers idValue", this.idValue);
  }

  // _form.html.erb
  selectWork(event) {
    event.preventDefault();
    event.stopPropagation();

    // console.log("selectWork", event.currentTarget.value);
    let url = "/producers/select_work";
    url += `?work_id=${event.currentTarget.value}`;

    if (this.idValue != "") {
      url += `&producer_id=${this.idValue}`;
    }
    // console.log("selectWork", url);

    // https://github.com/hotwired/stimulus/issues/689
    // https://fly.io/ruby-dispatch/turbostream-fetch/
    get(url, {
      headers: {
        Accept: "text/vnd.turbo-stream.html, text/html, application/xhtml+xml",
      },
    });

    event.currentTarget.value = "";
  }

  // index.html.erb
  selectOrder(event) {
    event.preventDefault();
    event.stopPropagation();

    // console.log("selectOrder");

    const selection = event.currentTarget.value;
    const [order_param, dir_param] = selection.split("-");

    let url = "/producers";
    url += `?order=${order_param}`;
    url += `&dir=${dir_param}`;

    this.turboRequest(url);

    event.currentTarget.value = "";
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
