import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    id: String, // may be empty, don't cast to 0, _form.html
    tags: Array
  };
  static outlets = ["request-helper"];
  static targets = ["producerSubForm", "tagSubform"];

  connect() {
    // console.log("works connected");
  }

  _setCurrentProducerIds(value) {
    // memoize
    if (!this.currentProducerIds) {
      this.currentProducerIds = []
    }

    if (value) {
      this.currentProducerIds.push(value)
    }
  }

  _unsetCurrentProducerIds(value) {  
    if (value) {
      this.currentProducerIds = this.currentProducerIds.filter(e => e !== value)
    }
  }

  producerSubFormTargetConnected(element) {
    // console.log("producerSubFormConnect", element);
    const newId = element.dataset.producerId;
    if (newId) {
      this._setCurrentProducerIds(Number(newId));
    }
  }

  producerSubFormTargetDisconnected(element) {
    // console.log("producerSubFormDisonnect", element);
    const newId = element.dataset.producerId;
    if (newId) {
      this._unsetCurrentProducerIds(Number(newId));
    }
  }

  _setCurrentTags(value) {
    // memoize
    if (!this.currentTags) {
      this.currentTags = [];
    }

    if (value) {
      this.currentTags.push(value)
    }
    // console.log(this.currentTags);
  }

  _unsetCurrentTags(value) {  
    if (value) {
      this.currentTags = this.currentTags.filter(e => e !== value)
    }
    // console.log(this.currentTags);
  }

  tagSubFormTargetConnected(element) {
    // console.log("tagSubFormConnect", element);
    const newTag = element.dataset.tag;

    if (newTag) {
      this._setCurrentTags(newTag);
    }
  }

  tagSubFormTargetDisconnected(element) {
    // console.log("tagSubFormDisonnect", element);
    const newTag = element.dataset.tag;
    if (newTag) {
      this._unsetCurrentTags(newTag);
    }
  }

  // _form.html.erb
  selectProducer(event) {
    event.preventDefault();
    event.stopPropagation();

    const newId = event.currentTarget.value;
    let url = "/works/select_producer";
    if (this.currentProducerIds && this.currentProducerIds.includes(Number(newId))) {
      // no-op
    } else {
      url += `?producer_id=${newId}`;
      if (this.idValue != "") {
        url += `&work_id=${this.idValue}`;
      }
      const successful = this.requestHelperOutlet.turboGet(url);
      if (successful) {
        // console.log("successful")
      }
    }
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
    const newTag = event.currentTarget.value
    // console.log(newTag);
    if (this.currentTags && this.currentTags.includes(newTag)) {
      // no-op
    } else {
      url += `?tag=${newTag}`;
      if (this.idValue != "") {
        url += `&work_id=${this.idValue}`;
      }
      this.requestHelperOutlet.turboGet(url);
    }
    event.currentTarget.value = "";
  }

  // _form.html.erb
  selectParent(event) {
    event.preventDefault();
    event.stopPropagation();

    // console.log("selectParent", event.currentTarget.value);
    let url = "/works/select_parent";
    url += `?parent_id=${event.currentTarget.value}`;
    this.requestHelperOutlet.turboGet(url);
    event.currentTarget.value = "";
  }
}
