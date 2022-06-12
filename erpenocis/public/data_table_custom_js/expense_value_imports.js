$(document).ready(function(){
  let date = new Date().toISOString()
  $("#exampleExpenseValuesTable").DataTable({
    dom: 'B',
    buttons: [
      { extend: 'excelHtml5', 
        text: '<i class="far fa-file-excel"></i> &nbsp;Descarca model',
        className: 'btn-success text-light btn-sm',
        sheetName: "Cheltuieli",
        title: "Anul pentru care se importa: " + date.slice(0, 4),
        filename: "Exemplu tabel import sume cheltuieli"
      }
    ],
  });
});