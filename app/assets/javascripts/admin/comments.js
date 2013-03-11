function reloadItemList() {
  var form = $('.searchForm');
  var action = form.attr('action');
  if(action !== undefined) {
    var formdata = form.serialize();
    $.get(action + '.js', formdata);
  }
}