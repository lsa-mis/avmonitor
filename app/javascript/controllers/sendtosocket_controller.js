import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["source"]

  changeSource() {
    console.log("here")
    var source_id = this.sourceTarget.value
    console.log(source_id)
    var room_id = document.getElementById("room_id").value
    console.log(room_id)
    if (source_id) {
      fetch(`/send_to_room/${room_id}?operation=source_int&source=${source_id}`)
    }
  }
}
