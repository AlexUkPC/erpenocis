$(document).ready(function(){
  function getHeaderNames(table) {
    var header = $(table).DataTable().columns().header().toArray();
    var names = [];
    header.forEach(function(th) {
      if(th!=header[header.length]){
        names.push($(th).html());
      }
    });      
    return names;
  }
  
  function buildCols(data) {  
    var cols = '<cols>'; 
    for (i=0; i<data.length; i++) {
      colNum = i + 1;
      cols += '<col min="' + colNum + '" max="' + colNum + '" width="12" customWidth="1"/>';
    }   
    cols += '</cols>';  
    return cols;
  }
  
  function buildRow(data, rowNum, styleNum) {
    var style = styleNum ? ' s="' + styleNum + '"' : '';
    var row = '<row r="' + rowNum + '">';
    for (i=0; i<data.length; i++) {
      colNum = (i + 10).toString(36).toUpperCase();  // Convert to alpha
      var cr = colNum + rowNum;
      row += '<c t="inlineStr" r="' + cr + '"' + style + '>' +
              '<is>' +
                '<t>' + data[i] + '</t>' +
              '</is>' +
            '</c>';
    }
    row += '</row>';
    return row;
  }
  
  function getTableData(table, title) {
    var header = getHeaderNames(table);
    var table = $(table).DataTable();
    var rowNum = 1;
    var mergeCells = '';
    var ws = '';
    ws += buildCols(header);
    ws += '<sheetData>';
    if (title.length > 0) {
      ws += buildRow([title], rowNum, 51);
      rowNum++;
      mergeCol = ((header.length - 1) + 10).toString(36).toUpperCase();
      mergeCells = '<mergeCells count="1">'+
        '<mergeCell ref="A1:' + mergeCol + '1"/>' +
                  '</mergeCells>';
    }
    ws += buildRow(header, rowNum, 2);
    rowNum++;
    table.rows( {order:'applied', search:'applied'} ).every( function ( rowIdx, tableLoop, rowLoop ) {
      var data = this.data();
      let x = []
      for (const [key, value] of Object.entries(data)) {
       value["@data-order"] ? x.push(value["@data-order"]) : x.push("")
      }
      ws += buildRow(x, rowNum, '');
      rowNum++;
    } );
    ws += '</sheetData>' + mergeCells;
    return ws;
  }
  
  function setSheetName(xlsx, name) {
    if (name.length > 0) {
      var source = xlsx.xl['workbook.xml'].getElementsByTagName('sheet')[0];
      source.setAttribute('name', name);
    }
  }
  
  function addSheet(xlsx, table, title, name, sheetId) {
    var source = xlsx['[Content_Types].xml'].getElementsByTagName('Override')[sheetId-1];
    var clone = source.cloneNode(true);
    clone.setAttribute('PartName',`/xl/worksheets/sheet${sheetId}.xml`);
    xlsx['[Content_Types].xml'].getElementsByTagName('Types')[0].appendChild(clone);
    var source = xlsx.xl._rels['workbook.xml.rels'].getElementsByTagName('Relationship')[0];
    var clone = source.cloneNode(true);
    clone.setAttribute('Id',`rId${sheetId+1}`);
    clone.setAttribute('Target',`worksheets/sheet${sheetId}.xml`);
    xlsx.xl._rels['workbook.xml.rels'].getElementsByTagName('Relationships')[0].appendChild(clone);
    var source = xlsx.xl['workbook.xml'].getElementsByTagName('sheet')[0];
    var clone = source.cloneNode(true);
    clone.setAttribute('name', name);
    clone.setAttribute('sheetId', sheetId);
    clone.setAttribute('r:id',`rId${sheetId+1}`);
    xlsx.xl['workbook.xml'].getElementsByTagName('sheets')[0].appendChild(clone);
    var newSheet = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'+
      '<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:x14ac="http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac" mc:Ignorable="x14ac">'+
      getTableData(table, title) +
      '</worksheet>';
    xlsx.xl.worksheets[`sheet${sheetId}.xml`] = $.parseXML(newSheet);
  }
  let date = new Date().toISOString()
  $("#exampleEmployeeSalariesTable").DataTable({
    dom: 'B',
    buttons: [
      { extend: 'excelHtml5', 
        text: '<i class="far fa-file-excel"></i> &nbsp;Descarca model',
        className: 'btn-success text-light btn-sm',
        sheetName: "Salariu net",
        title: "Anul pentru care se importa: " + date.slice(0, 4),
        filename: "Exemplu tabel import salarii angajati",
        customize: function( xlsx ) {
          var sheet = xlsx.xl.worksheets['sheet1.xml'];
          var col = $('col', sheet);
          col.each(function () {
            $(this).attr('width', 12);
          });
          addSheet(xlsx, '#exampleEmployeeSalariesTable', "Anul pentru care se importa: " + date.slice(0, 4), 'Taxe salariu', '2');
          addSheet(xlsx, '#exampleEmployeeSalariesTable', "Anul pentru care se importa: " + date.slice(0, 4), 'Bonuri de masa', '3');
          addSheet(xlsx, '#exampleEmployeeSalariesTable', "Anul pentru care se importa: " + date.slice(0, 4), 'Bonuri cadou', '4');
          addSheet(xlsx, '#exampleEmployeeSalariesTable', "Anul pentru care se importa: " + date.slice(0, 4), 'Ore suplimentare', '5');
          addSheet(xlsx, '#exampleEmployeeSalariesTable', "Anul pentru care se importa: " + date.slice(0, 4), 'Salariu extra', '6');
        }
      }
    ],
  });
});