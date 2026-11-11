<html lang="en">

<head>

  <meta charset="utf-8" />

  <title>jQuery UI Datepicker - Format date</title>

  <link rel="stylesheet" href="http://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css" />

  <script src="http://code.jquery.com/jquery-1.9.1.js"></script>

  <script src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>

  <link rel="stylesheet" href="/resources/demos/style.css" />

  <script>

  $(function() {

    $( "#datepicker" ).datepicker();

    $( "#format" ).change(function() {

      $( "#datepicker" ).datepicker( "option", "dateFormat", $( this ).val() );

    });

  });

  </script>

</head>

<body>

 

<p>Date: <input type="text" id="datepicker" size="30" /></p>

 

<p>Format options:<br />

  <select id="format">

    <option value="mm/dd/yy">Default - mm/dd/yy</option>

    <option value="yy-mm-dd">ISO 8601 - yy-mm-dd</option>

    <option value="d M, y">Short - d M, y</option>

    <option value="d MM, y">Medium - d MM, y</option>

    <option value="DD, d MM, yy">Full - DD, d MM, yy</option>

    <option value="'day' d 'of' MM 'in the year' yy">With text - 'day' d 'of' MM 'in the year' yy</option>

  </select>

</p>

 

 

</body>

</html>

