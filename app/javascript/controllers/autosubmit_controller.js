import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
  static targets = ['form', 'sidebar', 'min_lamp_hour', 'max_lamp_hour', 'lamp_hour_error']

  search() {
    clearTimeout(this.timeout)

    const MIN = parseInt(0)
    const MAX = parseInt(65535)

    this.timeout = setTimeout(() => {
      var min_lamp_hour = parseInt(this.min_lamp_hourTarget.value)
      var max_lamp_hour = parseInt(this.max_lamp_hourTarget.value)

      if (Number.isNaN(min_lamp_hour)) { min_lamp_hour = 0 }
      if (Number.isNaN(max_lamp_hour)) { max_lamp_hour = 0 }

      // if (min_lamp_hour != 0 && min_lamp_hour > MIN || max_lamp_hour != 0 && max_lamp_hour < MAX) {
      if (min_lamp_hour != 0 || max_lamp_hour != MAX) {

        if (min_lamp_hour < 0) {
          this.lamp_hour_errorTarget.classList.add("lamp_hour-error--display")
          this.lamp_hour_errorTarget.classList.remove("lamp_hour-error--hide")
          this.lamp_hour_errorTarget.innerText = "Min should be positive"
        }
        else if (max_lamp_hour > MAX) {
          this.lamp_hour_errorTarget.classList.add("lamp_hour-error--display")
          this.lamp_hour_errorTarget.classList.remove("lamp_hour-error--hide")
          this.lamp_hour_errorTarget.innerText = "Max should be less then " + MAX
        }
        else if (min_lamp_hour > max_lamp_hour) {
          this.lamp_hour_errorTarget.classList.add("lamp_hour-error--display")
          this.lamp_hour_errorTarget.classList.remove("lamp_hour-error--hide")
          this.lamp_hour_errorTarget.innerText = "Min should be smaller than Max"
        }
        else {
          this.lamp_hour_errorTarget.classList.add("lamp_hour-error--hide")
          this.lamp_hour_errorTarget.classList.remove("lamp_hour-error--display")
          this.lamp_hour_errorTarget.innerText = ""

          Turbo.navigator.submitForm(this.formTarget)
          this.sidebarTarget.classList.toggle('-translate-x-full')
        }
      }
      else {
        Turbo.navigator.submitForm(this.formTarget)
        this.sidebarTarget.classList.toggle('-translate-x-full')
      }
    }, 600)
  }

  clearFilters() {
    var url = window.location.pathname
    Turbo.visit(url)
  }

}
