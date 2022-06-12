$(document).ready(function(){
  $("#exampleProjectCostsTable").DataTable({
    dom: 'B',
    buttons: [
      { extend: 'excelHtml5', 
        text: '<i class="far fa-file-excel"></i> &nbsp;Descarca model',
        className: 'btn-success text-light btn-sm',
        sheetName: "Costuri proiecte",
        title: "Rand gol",
        filename: "Exemplu tabel import costuri proiecte"
      }
    ],
  });
});