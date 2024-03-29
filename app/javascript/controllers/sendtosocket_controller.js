import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["wl_mic_volume", "source_vol"]

  changeDeviceOnOff(event) {
    let confirmed = confirm("Is the websocket closed? If yes, click OK to continue.")
    if (confirmed) {
      console.log(event)
      console.log(event.target)
      console.log(event.target.dataset)
      var name = event.target.dataset.sendtosocketNameValue
      console.log(event.target.dataset.sendtosocketNameValue)
      var id = name.replaceAll(" ", "_")
      console.log(id)
      var power = document.getElementById(id).checked
      console.log("power")
      console.log(power)
      var room_id = document.getElementById("room_id").value
      console.log(room_id)

      if (name) {
        fetch(`/send_to_room/${room_id}?operation=device_on_off&device_name=${name}&power=${power}`)
      }
    }
    else {
      console.log("nothing")
      location.reload()
    }
  }


  changeMicVolume() {
    let confirmed = confirm("Is the websocket closed? If yes, click OK to change volume.")
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
      location.reload()
    }
  }

  changeSourceVolume() {
    let confirmed = confirm("Is the websocket closed? If yes, click OK to change volume")
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
      location.reload()
    }
  }
}
