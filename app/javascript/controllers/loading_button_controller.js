import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["button", "icon"];

  loading() {
    this.buttonTarget.disabled = true;
    this.iconTarget.classList.add("animate-spin");
  }

  reset() {
    this.buttonTarget.disabled = false;
    this.iconTarget.classList.remove("animate-spin");
  }
}
