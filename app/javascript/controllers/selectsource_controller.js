import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  changeSource(event) {
    let confirmed = confirm("Are you sure?")
    if (confirmed) {
      console.log("here")
      console.log(event.target.dataset)
      var name = event.target.dataset.selectsourceNameValue
      console.log(name)
      var id = "source_" + name.replace(" ", "_")

      var source = document.getElementById(id)
      console.log("source:")
      console.log(source)
      var source_id = source.options[source.selectedIndex].value;
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

}
