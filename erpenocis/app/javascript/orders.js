
$(document).ready(function(){
  function change_project(orders) {
    
    project = $('#to_project_id :selected').text()
    try {
      options = $(orders).filter(`optgroup[label=${project}]`).html()
        $('#to_order_id').html("<option value=''></option>"+options)
        $('#to_order_id').parent().show()
    }
    catch{
      $('#to_order_id').empty()
      $('#to_order_id').parent().hide()
    }
  }
  function change_orders() {
    order = $('#order_description').text().replace(/Cantitate comandata:[0-9]+ UM/, "UM")
    order2 = $('#to_order_id :selected').text().replace(/Cantitate necesara:[0-9]+ UM/, "UM")
    if (order2!="" && order != order2){
      if (!confirm(`Atentie! Comanda de pe care muti si ce pe care muti nu sunt identice. Esti sigur ca vrei sa muti comanda de ${order} pe comanda de ${order2}`)){
        $('#to_order_id :selected').prop("selected", false)
      }
    }
  }
  function change_quantity() {
    cn = $('#to_order_id :selected').text().search(/Cantitate necesara:/)
    um = $('#to_order_id :selected').text().search(/ UM:/)
    quantity_order2 = parseInt($('#to_order_id :selected').text().slice(cn+19,um))
    quantity = $('#quantity').val()
    if (quantity>quantity_order2){
      if(!confirm(`Atentie! Esti sigur ca vrei sa muti cantitatea de ${quantity} pe comanda cu necesar de ${quantity_order2}?`)){
        $('#quantity').val(quantity_order2)
      }
    }
  }

  $('#to_order_id').parent().hide()
  orders = $('#to_order_id').html()
  $("#to_project_id").change(function(){
    change_project(orders);
  });
  $("#to_order_id").change(function(){
    change_orders();
  });
  $("#quantity").change(function(){
    change_quantity();
  });
})