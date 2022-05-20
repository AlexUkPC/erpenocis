
$(document).ready(function(){
  function replaceQueryParam(param, newval, search) {
    var regex = new RegExp("([?;&])" + param + "[^&;]*[;&]?");
    var query = search.replace(regex, "$1").replace(/&$/, '');

    return (query.length > 2 ? query + "&" : "?") + (newval ? param + "=" + newval : '');
  }
  function change_tab(t) { 
    var queryParams = new URLSearchParams(window.location.search);
    switch(t.id) {
      case "issued-supplier-invoices-tab":
        queryParams.set("current_tab", "fe");
        document.getElementById('current_tab').value = "fe";
        break;
      case "to-be-payed-supplier-invoices-tab":
        queryParams.set("current_tab", "fp");
        document.getElementById('current_tab').value = "fp";
        break;
      case "payed-supplier-invoices-tab":
        queryParams.set("current_tab", "fa");
        document.getElementById('current_tab').value = "fa";
        break;
      case "unpaid-supplier-invoices-tab":
        queryParams.set("current_tab", "fr");
        document.getElementById('current_tab').value = "fr";
        break;
      default:
    } 
    history.replaceState(null, null, "?"+queryParams.toString());
  }

  $('button[data-bs-toggle="tab"]').on('click', function(){
    change_tab(this);
  });
})