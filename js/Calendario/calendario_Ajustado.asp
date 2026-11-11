<html lang="Pt">
<head>
  <meta charset="utf-8" />
  <title>jQuery UI Datepicker - Format date</title>
  <link rel="stylesheet" href="jquery-ui.css" />
  <script src="jquery-1.9.1.js"></script>
  <script src="jquery-ui.js"></script>
  <link rel="stylesheet" href="/resources/demos/style.css" />
  <script>
  $(function() {
    $( "#txtDataInicial" ).datepicker();
    $( "#format" ).change(function() {
      $( "#txtDataFinal" ).datepicker( "option", "dateFormat", $( this ).val() );
    });
  });
  $(function() {
    $( "#txtDataFinal" ).datepicker();
    $( "#format" ).change(function() {
      $( "#txtDataFinal" ).datepicker( "option", "dateFormat", $( this ).val() );
    });
  });
  $(function() {
    $( "#txtData" ).datepicker();
    $( "#format" ).change(function() {
      $( "#txtData" ).datepicker( "option", "dateFormat", $( this ).val() );
    });
  });
  </script>
</head>

<body>

 

<p>Date: <input type="text" id="datepicker" size="10" /></p>
<p>Date: <input type="text" id="txtDataFinal" size="10" /></p>

 

</body>

</html>

