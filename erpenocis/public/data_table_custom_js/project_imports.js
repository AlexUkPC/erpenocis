$(document).ready(function(){
  $("#exampleProjectTable").DataTable({
    dom: 'B',
    buttons: [
      { extend: 'excelHtml5', 
        text: '<i class="far fa-file-excel"></i> &nbsp;Descarca model',
        className: 'btn-success text-light btn-sm',
        sheetName: "Proiecte",
        title: "Rand gol",
        filename: "Exemplu tabel import proiecte"
      }
    ],
  });
});