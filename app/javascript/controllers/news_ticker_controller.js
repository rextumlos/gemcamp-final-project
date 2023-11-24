import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="news-ticker"
export default class extends Controller {
    static targets = ["content"];

    connect() {
        this.tick();
    }

    tick() {
        if (this.hasContentTarget) {
            this.contentTarget.style.transform = `translateX(${this.contentTarget.offsetWidth}px)`;
            this.contentTarget.style.transition = "transform 10s linear";

            setTimeout(() => {
                this.contentTarget.style.transform = "translateX(-100%)";
                this.contentTarget.style.transition = "none";
            }, 10000);
        }
    }
}
