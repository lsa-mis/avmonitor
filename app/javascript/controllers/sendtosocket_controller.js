import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["wl_mic_volume", "source_vol"]

  changeMicVolume(event) {
    let confirmed = confirm("Are you sure?")
    if (confirmed) {
      console.log("mic")
      var volume = this.wl_mic_volumeTarget.value
      console.log(volume)
      var room_id = document.getElementById("room_id").value
      console.log(room_id)
      if (volume) {
        fetch(`/send_to_room/${room_id}?operation=mic_vol&volume=${volume}`)
      }
    }
    else {
      console.log("nothing")
      event.preventDefault()
    }
  }

  changeSourceVolume(event) {
    let confirmed = confirm("Are you sure?")
    if (confirmed) {
      console.log("source")
      var volume = this.source_volTarget.value
      console.log(volume)
      var room_id = document.getElementById("room_id").value
      console.log(room_id)
      if (volume) {
        fetch(`/send_to_room/${room_id}?operation=source_vol&volume=${volume}`)
      }
    }
    else {
      console.log("nothing")
      event.preventDefault()
    }
  }
}
