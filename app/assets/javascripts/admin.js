
function setup_expander() {
  $('div.item-text').expander({
                       slicePoint: 1000,
                       expandSpeed: 100,
                       expandText: 'Veja Mais',
                       userCollapse: false
                     });
}

function setup_reload_page() {
  $("a[data-reload='true']").bind("ajax:complete", function(event) {
     reloadPage()
  });
}

$(function() {
  setup_expander()
  setup_reload_page()
});

$(document).ajaxSuccess(function() {
  setup_expander()
  setup_reload_page()
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
