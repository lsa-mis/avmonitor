import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js"

export default class extends Controller {
  static targets = ["form", "day"]

  getData(event) {
    var day = this.dayTarget.value
    var room_id = document.getElementById("room_id").value

    get(`/get_room_reservations/${room_id}/${day}`, {
      responseKind: "turbo-stream"
    })
  }

}
