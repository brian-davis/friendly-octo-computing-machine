import { Controller } from "@hotwired/stimulus";

// Handle combinatory sort/search/filter functionality on index views.
export default class extends Controller {
  static values = {
    endpoint: String,
  };
  static targets = ["search", "searchButton"];
  static outlets = ["request-helper"];

  connect() {
    // console.log("sortable connected");
    this.filterValue = "";
    this.frmtValue = "";
    this.orderValue = "";
    this.dirValue = "";
    this.searchValue = "";
    this.languageValue = "";
    this.accessionValue = "";
    this.statusValue = "";
    console.log(this.searchButtonTarget);
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

    let newQuery = this._buildUrlQuery().toString();
    // console.log(newQuery);
    if (newQuery) {
      url += `?${newQuery}`;
    }

    this.requestHelperOutlet.turboGet(url);
  }

  selectFormat(event) {
    event.preventDefault();
    event.stopPropagation();
    // console.log("selectFormat");

    this.frmtValue = event.currentTarget.value;
    // console.log(this.frmtValue);

    // http://localhost:3000/works?tag=Classics
    let url = this.endpointValue; // or this.endpointValue

    let newQuery = this._buildUrlQuery().toString();
    // console.log(newQuery);
    if (newQuery) {
      url += `?${newQuery}`;
    }

    this.requestHelperOutlet.turboGet(url);
  }

  selectLanguage(event) {
    event.preventDefault();
    event.stopPropagation();
    // console.log("selectLanguage");

    this.languageValue = event.currentTarget.value;
    // console.log(this.languageValue);

    // http://localhost:3000/works?tag=Classics
    let url = this.endpointValue; // or this.endpointValue

    let newQuery = this._buildUrlQuery().toString();
    // console.log(newQuery);
    if (newQuery) {
      url += `?${newQuery}`;
    }

    this.requestHelperOutlet.turboGet(url);
  }

  selectAccession(event) {
    event.preventDefault();
    event.stopPropagation();
    // console.log("selectAccession");

    this.accessionValue = event.currentTarget.value;
    // console.log(this.accessionValue);

    // http://localhost:3000/works?accession=wishlist
    let url = this.endpointValue;

    let newQuery = this._buildUrlQuery().toString();
    // console.log(newQuery);
    if (newQuery) {
      url += `?${newQuery}`;
    }

    this.requestHelperOutlet.turboGet(url);
  }

  selectStatus(event) {
    event.preventDefault();
    event.stopPropagation();
    // console.log("selectStatus");

    this.statusValue = event.currentTarget.value;
    // console.log(this.statusValue);

    // http://localhost:3000/works?sts=read
    let url = this.endpointValue;

    let newQuery = this._buildUrlQuery().toString();
    // console.log(newQuery);
    if (newQuery) {
      url += `?${newQuery}`;
    }

    this.requestHelperOutlet.turboGet(url);
  }

  decorateTagClick(event) {
    event.preventDefault();
    event.stopPropagation();

    // console.log("decorateTagClick", event.currentTarget);
    this.filterValue = event.currentTarget.dataset.filterValue;

    const targetLink = event.currentTarget.closest("a");
    // console.log("targetLink", targetLink);

    // http://localhost:3000/works?tag=Classics
    let url = targetLink.href; // or this.endpointValue

    let newQuery = this._buildUrlQuery().toString();
    // console.log(newQuery);
    if (newQuery) {
      url += `?${newQuery}`;
    }

    this.requestHelperOutlet.turboGet(url);
  }

  search(event) {
    event.preventDefault();
    event.stopPropagation();
    // console.log("search", event.currentTarget);
    this.searchValue = this.searchTarget.value;
    let url = this.endpointValue;
    let newQuery = this._buildUrlQuery().toString();
    // console.log(newQuery);
    if (newQuery) {
      url += `?${newQuery}`;
    }
    // this.searchTarget.value = "";
    this.requestHelperOutlet.turboGet(url);
  }

  // keydown.esc
  clearSearch() {
    // console.log("clearSearch");
    // console.log(this.searchTarget.value);
    this.searchTarget.value = "";
  }

  // keydown.enter
  submitSearch() {
    // console.log("submitSearch");
    // console.log(this.searchTarget.value);
    this.searchButtonTarget.click();
  }

  _buildUrlQuery() {
    let queryData = {};
    if (this.filterValue) {
      queryData.tag = this.filterValue;
    }

    if (this.frmtValue) {
      queryData.frmt = this.frmtValue;
    }

    if (this.orderValue) {
      queryData.order = this.orderValue;
    }

    if (this.dirValue) {
      queryData.dir = this.dirValue;
    }

    if (this.searchValue) {
      queryData.search_term = this.searchValue;
    }

    if (this.languageValue) {
      queryData.lang = this.languageValue;
    }

    if (this.accessionValue) {
      queryData.accession = this.accessionValue;
    }

    if (this.statusValue) {
      // avoid "status" keyword
      queryData.sts = this.statusValue;
    }

    const searchParams = new URLSearchParams(queryData);
    return searchParams;
  }
}
