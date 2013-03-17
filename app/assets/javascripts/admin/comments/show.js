function reloadPage() {
  var path = $('#comment_path').val()
  $.get(path + '.js');
}