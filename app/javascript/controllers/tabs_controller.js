import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["tab", "tabContent"];
  static classes = ["tabSelected", "tabContentSelected"];

  connect() {
    // console.log("tabs_controller connected");
    // console.log(this.tabTargets);
    console.log(this.tabSelectedClass);
    console.log(this.tabContentSelectedClass);
  }

  // _form.html.erb
  selectTab(event) {
    event.preventDefault();
    event.stopPropagation();

    const selectedTab = event.srcElement;
    // console.log("selectTab", selectedTab);

    this.tabTargets.forEach((tab) => {
      tab.classList.remove(this.tabSelectedClass);
    });

    this.tabContentTargets.forEach((tab) => {
      tab.classList.remove(this.tabContentSelectedClass);
    });

    selectedTab.classList.add(this.tabSelectedClass);

    const actionTargetId = event.params.select;
    // console.log(actionTargetId);

    const actionTarget = document.querySelector("#" + actionTargetId);
    console.log(actionTarget);

    actionTarget.classList.add(this.tabContentSelectedClass);
  }
}
