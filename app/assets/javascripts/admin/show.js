function reloadPage() {
  var path = $('#model_path').val()
  $.ajax({url: path, dataType: "script"})
}