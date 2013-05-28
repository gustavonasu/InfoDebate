function reloadPage() {
  var action = $('div.pagination li.active a').first().attr('href')
  if(action != undefined) {
    $.ajax({url: action, dataType: "script"})
  }
}