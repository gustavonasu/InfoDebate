function setup_custom_reload_page() {
  $("a[data-custom-reload='true']").bind("ajax:complete", function(event) {
     entityid = $(this).attr("data-reload-entityid")
     $("#" + entityid).addClass("item_changed")
     $("#" + entityid).fadeOut(1700)
     setTimeout('reloadPage()',1700)
  });
}

$(function() {
  setup_custom_reload_page()
});

$(document).ajaxSuccess(function() {
  setup_custom_reload_page()
});