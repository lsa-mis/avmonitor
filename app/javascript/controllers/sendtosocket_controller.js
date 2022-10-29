import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["wl_mic_volume", "source_vol"]

  // connect() {
  //   this.element.textContent = "Hello World!"
  // }

  changeMicVolume() {
    console.log("mic")
    var volume = this.wl_mic_volumeTarget.value
    console.log(volume)
    var room_id = document.getElementById("room_id").value
    console.log(room_id)
    if (volume) {
      fetch(`/send_to_room/${room_id}?operation=mic_vol&volume=${volume}`)
    }
  }

  changeSourceVolume() {
    console.log("source")
    var volume = this.source_volTarget.value
    console.log(volume)
    var room_id = document.getElementById("room_id").value
    console.log(room_id)
    if (volume) {
      fetch(`/send_to_room/${room_id}?operation=source_vol&volume=${volume}`)
    }
  }
}