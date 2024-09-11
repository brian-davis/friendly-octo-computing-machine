import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    id: String, // may be empty, don't cast to 0
  };
  static outlets = ["request-helper"];
  static targets = ["workSubform"];

  connect() {
    // console.log("producers connected");
  }

  _setCurrentWorkIds(value) {
    // memoize
    if (!this.currentWorkIds) {
      this.currentWorkIds = []
    }

    if (value) {
      this.currentWorkIds.push(value)
    }
  }

  _unsetCurrentWorkIds(value) {  
    if (value) {
      this.currentWorkIds = this.currentWorkIds.filter(e => e !== value)
    }
  }

  workSubFormTargetConnected(element) {
    // console.log("wrokSubFormConnect", element);
    const newId = element.dataset.workId;
    if (newId) {
      this._setCurrentWorkIds(Number(newId));
    }
  }

  workSubFormTargetDisconnected(element) {
    // console.log("workSubFormDisonnect", element);
    const newId = element.dataset.workId;
    if (newId) {
      this._unsetCurrentWorkIds(Number(newId));
    }
  }

  // _form.html.erb
  selectWork(event) {
    event.preventDefault();
    event.stopPropagation();

    const newId = event.currentTarget.value;
    if (newId && this.currentWorkIds && this.currentWorkIds.includes(Number(newId))) {
      // no-op
    } else {
      let url = "/producers/select_work";
      url += `?work_id=${newId}`;
      if (this.idValue != "") {
        url += `&producer_id=${this.idValue}`;
      }
      this.requestHelperOutlet.turboGet(url);
    }

    event.currentTarget.value = "";
  }
}
