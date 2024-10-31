import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  debounceInterval = 500;
  static targets = ["input", "results", "address"];

  initialize() {
    this.debounce = null;
  }

  search() {
    clearTimeout(this.debounce);

    const query = this.inputTarget.value;

    if (query.length < 3) {
      this.resultsTarget.innerHTML = "";
      return;
    }

    this.debounce = setTimeout(() => {
      this.performSearch(query);
    }, this.debounceInterval);
  }

  performSearch(query) {
    const url = `/addresses/search?query=${encodeURIComponent(query)}`;

    fetch(url, {
      headers: {
        Accept: "text/vnd.turbo-stream.html",
      },
    })
      .then((response) => response.text())
      .then((html) => {
        this.resultsTarget.innerHTML = html;
      });
  }

  selectAddress(event) {
    const address = event.currentTarget
      .querySelector("[data-address-search-target='address']")
      .textContent.trim();
    this.inputTarget.value = address;
    this.resultsTarget.innerHTML = "";
  }
}
