import { Controller } from "@hotwired/stimulus";

// Handle combinatory sort/search/filter functionality on index views.
export default class extends Controller {
  static values = {
    endpoint: String,
  };
  static targets = ["search"];
  static outlets = ["request-helper"];

  connect() {
    // console.log("sortable connected");
    this.filterValue = "";
    this.orderValue = "";
    this.dirValue = "";
    this.searchValue = "";
  }

  // index.html.erb
  selectOrder(event) {
    event.preventDefault();
    event.stopPropagation();
    // console.log("selectOrder");

    const selection = event.currentTarget.value;
    let [order_param, dir_param] = selection.split("-");
    this.orderValue = order_param;
    this.dirValue = dir_param;

    let url = this.endpointValue;

    if (this.orderValue) {
      url += `?order=${this.orderValue}`;
    }

    if (this.orderValue && this.dirValue) {
      url += `&dir=${this.dirValue}`;
    }

    if (this.filterValue) {
      url += `&tag=${this.filterValue}`;
    }

    if (this.searchValue) {
      url += `&search_term=${this.searchValue}`;
    }

    // event.currentTarget.value = "";

    // Started GET "/works?order=title&dir=desc" for ::1 at 2024-08-13 16:11:02 -0700
    // Processing by WorksController#index as TURBO_STREAM
    // Parameters: {"order"=>"title", "dir"=>"desc"}
    this.requestHelperOutlet.turboGet(url);
  }

  decorateTagClick(event) {
    event.preventDefault();
    event.stopPropagation();

    // console.log("decorateTagClick", event.currentTarget);
    this.filterValue = event.currentTarget.dataset.filterValue;

    const targetLink = event.currentTarget.closest("a");
    // console.log(targetLink);

    // http://localhost:3000/works?tag=Classics
    let url = targetLink.href; // or this.endpointValue

    if (this.orderValue) {
      url += `&order=${this.orderValue}`;
    }

    if (this.orderValue && this.dirValue) {
      url += `&dir=${this.dirValue}`;
    }

    if (this.searchValue) {
      url += `&search_term=${this.searchValue}`;
    }

    this.requestHelperOutlet.turboGet(url);
  }

  search(event) {
    event.preventDefault();
    event.stopPropagation();

    // console.log("search", event.currentTarget);

    this.searchValue = this.searchTarget.value;

    let url = this.endpointValue;

    url += `?search_term=${this.searchValue}`; // blank OK

    if (this.filterValue) {
      url += `&tag=${this.filterValue}`;
    }

    if (this.orderValue) {
      url += `&order=${this.orderValue}`;
    }

    if (this.orderValue && this.dirValue) {
      url += `&dir=${this.dirValue}`;
    }

    // console.log("url", url);

    // this.searchTarget.value = "";
    this.requestHelperOutlet.turboGet(url);
  }
}
