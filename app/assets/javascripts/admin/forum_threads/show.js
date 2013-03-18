function reloadPage() {
  var path = $('#forum_thread_path').val()
  $.get(path + '.js');
}