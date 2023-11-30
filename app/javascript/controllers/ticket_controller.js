import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="ticket"
export default class extends Controller {
  static targets = ["tickets"];

  increase() {
    this.updateValue(1);
  }

  increase5() {
    this.updateValue(5)
  }

  increase10() {
    this.updateValue(10)
  }

  increase20() {
    this.updateValue(20)
  }

  decrease() {
    this.updateValue(-1);
  }

  decrease5() {
    this.updateValue(-5)
  }

  decrease10() {
    this.updateValue(-10)
  }

  decrease20() {
    this.updateValue(-20)
  }

  updateValue(change) {
    let currentValue = parseInt(this.ticketsTarget.value, 10) || 0;
    let newValue = Math.max(currentValue + change, 1);
    this.ticketsTarget.value = newValue;
  }
}
