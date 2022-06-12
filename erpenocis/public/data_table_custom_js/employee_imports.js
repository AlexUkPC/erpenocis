$(document).ready(function(){
  $("#exampleEmployeesTable").DataTable({
    dom: 'B',
    buttons: [
      { extend: 'excelHtml5', 
        text: '<i class="far fa-file-excel"></i> &nbsp;Descarca model',
        className: 'btn-success text-light btn-sm',
        sheetName: "Total",
        title: "Rand gol",
        filename: "Exemplu tabel import angajati"
      }
    ],
  });
});