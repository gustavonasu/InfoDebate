
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

$(function() {
  active_expander()
});