import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["radio", "submit"];

  select(event) {
    const radio = event.target;

    // Enable submit button
    this.submitTarget.disabled = false;

    // Update hidden fields
    const form = this.submitTarget.closest("form");
    form.querySelector("#church_name").value = radio.dataset.name;
    form.querySelector("#church_address").value = radio.dataset.address;
    form.querySelector("#church_place_id").value = radio.dataset.placeId;
  }
}
