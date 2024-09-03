import { Controller } from "@hotwired/stimulus";
import { get } from "@rails/request.js";

export default class extends Controller {
  connect() {
    // console.log("works connected");
  }

  static values = {
    id: String, // may be empty, don't cast to 0, _form.html
  };
  static outlets = ["request-helper"];

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

    this.requestHelperOutlet.turboGet(url);

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

    this.requestHelperOutlet.turboGet(url);

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

    this.requestHelperOutlet.turboGet(url);

    event.currentTarget.value = "";
  }

  // _form.html.erb
  selectParent(event) {
    event.preventDefault();
    event.stopPropagation();

    console.log("selectParent", event.currentTarget.value);
    let url = "/works/select_parent";
    url += `?parent_id=${event.currentTarget.value}`;

    this.requestHelperOutlet.turboGet(url);

    event.currentTarget.value = "";
  }
}
