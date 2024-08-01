import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["newWorkList"];
  static values = {
    works: String,
    workcount: Number,
  };

  connect() {
    // console.log("producers connected");
    // console.log("this.worksValue", this.worksValue);
    this.workOptions = this.worksValue.split(";");
    // console.log(this.workOptions);
    console.log("this.workcountValue", this.workcountValue);
    if (this.workcountValue > 0) {
      this.appendFormIndex = this.workcountValue;
    } else {
      this.appendFormIndex = 0;
    }
  }

  formTemplate() {
    let template =
      '<li class="appendedWorkForm"><label for="work_works_attributes_INDEX_name">Name</label><input list="works_autocomplete" type="text" name="work[works_attributes][INDEX][name]" id="work_works_attributes_INDEX_name"><datalist id="works_autocomplete">OPTIONS</datalist><span data-action="click->works#formDismiss" style="cursor: pointer; color: red; margin: 0.5em;">remove ⓧ</span><br></li>';

    let optionTemplate = '<option value="NAME">NAME</option>';
    let newOptions = this.workOptions.map((name) => {
      return optionTemplate.replaceAll("NAME", name);
    });

    let renderedElement = template
      .replaceAll("INDEX", this.appendFormIndex)
      .replaceAll("OPTIONS", newOptions);

    return renderedElement;
  }

  appendForm(event) {
    event.preventDefault();
    // console.log("append form");
    let newForm = this.formTemplate();
    this.newWorkListTarget.insertAdjacentHTML("beforeend", newForm);
    this.appendFormIndex += 1;
  }

  formDismiss(event) {
    const dismissableForm = event.srcElement.parentElement;
    dismissableForm.remove();
    this.appendFormIndex -= 1;
  }
}

// template based on Rails form generator:
/*
<div style="border: 1px solid #ccc; padding: 1em; width: 12em; margin-bottom:1em;">
  <%= form.fields_for :works, @work.works.build do |t| %>
    <%= t.label :name %>
    <%= t.text_field :name, list: "works_autocomplete" %>
    <datalist id="works_autocomplete">
      <%= options_for_select(@work_options) %>
    </datalist>
    <br>
  <% end %>
</div>
*/
