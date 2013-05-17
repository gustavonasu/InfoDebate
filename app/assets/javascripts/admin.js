
function active_expander() {
  $('div.item-text').expander({
                       slicePoint: 1000,
                       expandSpeed: 100,
                       expandText: 'Veja Mais',
                       userCollapse: false
                     });
}

$(document).ajaxSuccess(function() {
  active_expander()
});

$(document).ajaxError(function(event, request, settings) {
  error_msg = "";
  if (request.responseText.trim() != "") {
    error_msg = $.parseJSON(request.responseText).message
  }
  if(error_msg == "") error_msg = "Erro na execução da chamada ao servidor"
  $(".fixed-error-alert > .message").html(error_msg)
  $(".fixed-error-alert").show()
  $(".fixed-error-alert").fadeOut(5000);
});

$(function() {
  active_expander()
});