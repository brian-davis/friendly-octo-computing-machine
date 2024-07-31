import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["newProducerList"];
  static values = {
    producers: String,
  };

  connect() {
    console.log("works connected");
    this.appendedForms = 0;
    console.log("this.producersValue", this.producersValue);
    this.producerOptions = this.producersValue.split(";");
    console.log(this.producerOptions);
  }

  formTemplate() {
    let template =
      '<div style="border: 1px solid #ccc; padding: 1em; width: 12em; margin-bottom:1em;"><label for="work_producers_attributes_INDEX_name">Name</label><input list="producers_autocomplete" type="text" name="work[producers_attributes][INDEX][name]" id="work_producers_attributes_INDEX_name"><datalist id="producers_autocomplete">OPTIONS</datalist><span data-action="click->works#formDismiss" style="cursor: pointer; color: red; margin: 0.5em;">remove ⓧ</span><br></div>';

    let optionTemplate = '<option value="NAME">NAME</option>';
    let newOptions = this.producerOptions.map((name) => {
      return optionTemplate.replaceAll("NAME", name);
    });

    let renderedElement = template
      .replaceAll("INDEX", this.appendedForms)
      .replaceAll("OPTIONS", newOptions);

    return renderedElement;
  }

  appendForm(event) {
    event.preventDefault();
    console.log("append form");
    let newForm = this.formTemplate();
    this.newProducerListTarget.insertAdjacentHTML("beforeend", newForm);
    this.appendedForms += 1;
  }

  formDismiss(event) {
    const dismissableTag = event.srcElement.parentElement;
    dismissableTag.remove();
    this.appendedForms -= 1;
  }
}

{
  /*

<div style="border: 1px solid #ccc; padding: 1em; width: 12em; margin-bottom:1em;">
  <%= form.fields_for :producers, @work.producers.build do |t| %>
    <%= t.label :name %>
    <%= t.text_field :name, list: "producers_autocomplete" %>
    <datalist id="producers_autocomplete">
      <%= options_for_select(@producer_options) %>
    </datalist>
    <br>
  <% end %>
</div>

*/
}
