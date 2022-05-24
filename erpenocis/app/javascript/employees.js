
$(document).ready(function(){
  function change_tab(t) { 
    var queryParams = new URLSearchParams(window.location.search);
    switch(t.id) {
      case "total-tab":
        queryParams.set("current_tab", "to");
        document.getElementById('current_tab').value = "to";
        break;
      case "net-salary-tab":
        queryParams.set("current_tab", "ns");
        document.getElementById('current_tab').value = "ns";
        break;
      case "salary-tax-tab":
        queryParams.set("current_tab", "st");
        document.getElementById('current_tab').value = "st";
        break;
      case "meal-vouchers-tab":
        queryParams.set("current_tab", "mv");
        document.getElementById('current_tab').value = "mv";
        break;
      case "gift-vouchers-tab":
        queryParams.set("current_tab", "gv");
        document.getElementById('current_tab').value = "gv";
        break;
      case "overtime-tab":
        queryParams.set("current_tab", "ot");
        document.getElementById('current_tab').value = "ot";
        break;
      case "extra-salary-tab":
        queryParams.set("current_tab", "es");
        document.getElementById('current_tab').value = "es";
        break;
      default:
    } 
    history.replaceState(null, null, "?"+queryParams.toString());
  }

  $('button[data-bs-toggle="tab"]').on('click', function(){
    change_tab(this);
  });
})