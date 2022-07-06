import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
  static targets = ['form', 'status', 'sidebar', 'min_capacity', 'max_capacity', 'capacity_error']

  search() {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      this.statusTarget.textContent = 'Updating...'
      Turbo.navigator.submitForm(this.formTarget)
      this.sidebarTarget.classList.toggle('-translate-x-full')
    }, 600)
  }

  clearFilters() {
    var url = window.location.pathname
    Turbo.visit(url)
  }
}
