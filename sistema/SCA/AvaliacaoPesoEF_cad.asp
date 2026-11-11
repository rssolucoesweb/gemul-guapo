<html>
<head>
<title>Editor de Fórmula - Exame Final</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link type="text/css" rel="stylesheet" href="../../Estilo/css.css">
<script src="../../js/js_funcoes_gerais.js"></script>
</head>
<body leftmargin="0" topmargin="0" >
<%
strTipoFormula = Trim(Request.QueryString("tipoFormula"))
intCodComp     = Trim(Request.QueryString("intCodComp"))
%>
<!--#include file="formulas/inc_editorFormulaEF.asp"-->
</body>
</html>
