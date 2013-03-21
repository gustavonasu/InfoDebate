function reloadPage() {
  var path = $('#complaint_path').val()
  $.get(path + '.js');
}