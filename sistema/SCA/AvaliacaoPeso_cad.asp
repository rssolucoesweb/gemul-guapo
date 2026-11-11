<html>
<head>
<title>Editor de Fórmula</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link type="text/css" rel="stylesheet" href="../../Estilo/css.css">
<script src="../../js/js_funcoes_gerais.js"></script>
</head>
<body leftmargin="0" topmargin="0" >
<%
strTipoFormula = Trim(Request.QueryString("tipoFormula"))
intCodComp     = Trim(Request.QueryString("intCodComp"))

if UCASE(strTipoFormula) <> "ESPECIAL" THEN
%>
<!--#include file="formulas/inc_editorFormula.asp"-->
<%
ELSE
%>
<!--#include file="formulas/inc_tiposFormulasEspeciais.asp"-->
<%
END IF
%>
</body>
</html>
