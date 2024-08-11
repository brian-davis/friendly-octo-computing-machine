import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    id: String, // may be empty, don't cast to 0
  };
  static outlets = ["request-helper"];

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

    this.requestHelperOutlet.turboGet(url);

    event.currentTarget.value = "";
  }
}
