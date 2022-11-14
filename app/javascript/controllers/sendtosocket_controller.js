import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["source", "wl_mic_volume", "source_vol"]

  changeDeviceOnOff() {
    let confirmed = confirm("Are you sure?")
    if (confirmed) {
      console.log("on/off")
      var power = document.getElementById("power_on_off").checked
      console.log(power)
      var room_id = document.getElementById("room_id").value
      console.log(room_id)
      var device_id = document.getElementById("device_id").value
      console.log(device_id)
      if (device_id) {
        fetch(`/send_to_room/${room_id}?operation=device_on_off&device=${device_id}&power=${power}`)
      }
    }
    else {
      console.log("nothing")
      location.reload()
    }
  }

  changeSource() {
    let confirmed = confirm("Are you sure?")
    if (confirmed) {
      console.log("here")
      var source_id = this.sourceTarget.value
      console.log(source_id)
      var room_id = document.getElementById("room_id").value
      console.log(room_id)
      if (source_id) {
        fetch(`/send_to_room/${room_id}?operation=source_int&source=${source_id}`)
      }
    }
    else {
      console.log("nothing")
      location.reload()
    }
  }


  changeMicVolume() {
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
      location.reload()
    }
  }

  changeSourceVolume() {
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
      location.reload()
    }
  }
}