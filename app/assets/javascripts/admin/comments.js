function reloadItemList() {
  var form = $('.searchForm');
  var action = form.attr('action');
  var formdata = form.serialize();
  $.get(action + '.js', formdata);
}