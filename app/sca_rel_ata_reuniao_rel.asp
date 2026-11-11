<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
SESSION.Timeout = 1200
Server.ScriptTimeout = 1200
%>
<html>
<head>
<title>GEMUL - Ata de reunião</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet" href="css_rel/Estilo_Impressao.css">
<script src="js/js_funcoes_gerais.js"></script>
<script src="js/js_barra_movel.js"></script>
</head>
<body>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="includes/inc_Botoes_relatorio.asp"-->
<!--#include file="includes/inc_aguarde.asp"-->
<!--#include file="includes/inc_cabecalhoRelatorio.asp"-->
<br>
<%
	dim intPagina

	strTituloRelatorio  	= ""

	strCod_empresa 		= Session("CodEmpresa")
	strCodAta			= Trim(Request("chkAta"))
	
	if strCodAta = "" then
		strCodAta			=	Trim(Request.form("strCodAta"))
	end if

	if trim(strCodAta) <> "" then
	
		sql = "SELECT Codigo, Cod_empresa, Cod_departamento, Assunto, descricao, data, TextoAta, AnoLetivo, Semestre"
		sql = sql & " FROM SCA_ATA"
		sql = sql & " Where Cod_empresa = " & session("codEmpresa")
		sql = sql & " And Codigo in (" & strCodAta & ")"
		sql = sql & " Order by codigo"
		rs.open sql, cnn
		
		if rs.eof = false then
			
			While not rs.eof 
			
			'dados pessoais
			strCodigo			= TRIM(rs("Codigo"))
			strAssunto 			= TRIM(rs("Assunto"))
			strDescricao 		= TRIM(rs("descricao"))
			strData				= formatadataAP(TRIM(rs("data")))
			strTextoAta			= TRIM(rs("TextoAta"))
			strAnoLetivo		= TRIM(rs("AnoLetivo"))
			intSemestre			= TRIM(rs("Semestre"))
			
			if intSemestre = 1 then
				srtSemestre = "1 Semestre"
			end if
			if intSemestre = 2 then
				srtSemestre = "2 Semestre"
			end if
			%>
			<br>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="9%" align="justify" class="texto">Assunto:</td>
			    <td width="91%" align="justify" class="texto"><%=strAssunto%></td>
		      </tr>
			  <tr>
			    <td align="justify" class="texto">Descri&ccedil;&atilde;o:</td>
			    <td align="justify" class="texto"><%=strDescricao%></td>
		      </tr>
			  <tr>
			    <td align="justify" class="texto">Data:</td>
			    <td align="justify" class="texto"><%=strData%></td>
		      </tr>
			  <tr>
			    <td align="justify" class="texto">Ano Letivo:</td>
			    <td align="justify" class="texto"><%=strAnoLetivo%></td>
		      </tr>
			  <tr>
			    <td align="justify" class="texto">Semestre:</td>
			    <td align="justify" class="texto"><%=srtSemestre%></td>
		      </tr>
			  <tr>
			    <td colspan="2" align="justify" class="texto">&nbsp;</td>
		      </tr>
			  <tr>
				<td colspan="2" align="justify" class="texto"><br><%=strTextoAta%> </td>
			  </tr>
			</table>
			<%
			rs.movenext
			if rs.eof = false then %>
            	<pre></pre>				
				<!--#include file="includes/inc_cabecalhoRelatorio.asp"-->	
			<%
			end if
			wend
		end if 
		rs.close
	end if 
	%>
	<script>
		aguarde.style.display="none";
	</script>
</body>
</html>