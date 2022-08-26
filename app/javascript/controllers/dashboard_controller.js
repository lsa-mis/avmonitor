import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
  static targets = ['refresh_button']

  refresh() {
    var url = window.location.pathname
    Turbo.visit(url)
  }

}
