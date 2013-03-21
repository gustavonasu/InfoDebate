function reloadPage() {
  var path = $('#model_path').val()
  $.get(path + '.js');
}