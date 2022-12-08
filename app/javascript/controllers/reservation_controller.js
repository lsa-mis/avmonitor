import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js"


export default class extends Controller {
  static targets = ["form", "day"]

  connect() {
    console.log("connect reservations")
  }
  getData(event) {
    console.log("get data")
    var day = this.dayTarget.value
    var room_id = document.getElementById("room_id").value
    console.log(room_id)
    console.log(day)

    get(`/get_room_reservations/${room_id}/${day}`, {
      responseKind: "turbo-stream"
    })
  }

}
