import { Controller } from "@hotwired/stimulus";
import { get } from "@rails/request.js";

export default class extends Controller {
  connect() {
    // console.log("works connected");
  }

  static values = {
    id: String, // may be empty, don't cast to 0, _form.html
  };

  // _form.html.erb
  selectProducer(event) {
    event.preventDefault();
    event.stopPropagation();

    // console.log("selectProducer", event.currentTarget.value);
    let url = "/works/select_producer";
    url += `?producer_id=${event.currentTarget.value}`;

    if (this.idValue != "") {
      url += `&work_id=${this.idValue}`;
    }

    this.turboRequest(url);

    event.currentTarget.value = "";
  }

  // _form.html.erb
  selectPublisher(event) {
    event.preventDefault();
    event.stopPropagation();

    // console.log("selectPublisher", event.currentTarget.value);
    let url = "/works/select_publisher";
    url += `?publisher_id=${event.currentTarget.value}`;

    if (this.idValue != "") {
      url += `&work_id=${this.idValue}`;
    }

    this.turboRequest(url);

    event.currentTarget.value = "";
  }

  // _form.html.erb
  selectTag(event) {
    event.preventDefault();
    event.stopPropagation();

    // console.log("selectTag", event.currentTarget.value);
    let url = "/works/select_tag";
    url += `?tag=${event.currentTarget.value}`;

    if (this.idValue != "") {
      url += `&work_id=${this.idValue}`;
    }

    this.turboRequest(url);

    event.currentTarget.value = "";
  }

  // _form.html.erb
  selectProducer(event) {
    event.preventDefault();
    event.stopPropagation();

    // console.log("selectProducer", event.currentTarget.value);
    let url = "/works/select_producer";
    url += `?producer_id=${event.currentTarget.value}`;

    if (this.idValue != "") {
      url += `&work_id=${this.idValue}`;
    }

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
