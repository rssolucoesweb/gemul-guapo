<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
SESSION.Timeout = 1200
Server.ScriptTimeout = 1200
%>
<html>
<head>
<title>Presença</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet" href="css_rel/Estilo_Impressao.css">
<script src="js/js_funcoes_gerais.js"></script>
<script src="js_app/js_barra_movel.js"></script>
</head>
<body>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="includes/inc_Botoes_relatorio.asp"-->
<!--#include file="includes/inc_aguarde.asp"-->
<br>
<%
	dim intPagina
	
	intCodGrupo				= Session("CodGrupo") 		
	strAnoLetivo			= Trim(Request.Form("txtAnoLetivo"))
	intCodRota 				= Trim(Request.Form("cmbRota"))
	listar	 				= Trim(Request.Form("listar"))
	if intCodRota <> "" then
		sql="select descricao from ste_rota"
		sql=sql & " where cod_rota = " & intCodRota
		rs.open sql, cnn
		if rs.eof = false then
			strRota = rs("descricao")
		end if
		rs.close
	end if
	strTurno				= Trim(Request.Form("cmbTurno"))
	if strTurno = "0" then strTurno = ""
	
	intCodEmpresa 			= "0"
	intCodEscolaEstadual 	= "0"
	rede 					= Trim(Request.Form("rede"))
	if rede<>"0" then
		if rede="M" then 
			intCodEmpresa 			= Trim(Request.Form("cmbEmpresa"))
			if intCodEmpresa = "0" or intCodEmpresa = "" then rede = "0"
		elseif rede="E" then 
			intCodEscolaEstadual 	= Trim(Request.Form("cmbEscolaEstadual"))
			if intCodEscolaEstadual = "0" or intCodEscolaEstadual = "" then rede = "0"
		else
			rede = "0"
		end if
	end if
	
	strDataInicial 			= FORMATADATAAP(Trim(Request.Form("txtDataLancamentoI")))
	strDataInicialBD		= FORMATADATABD(Trim(Request.Form("txtDataLancamentoI")))
	strDataFinal 			= FORMATADATAAP(Trim(Request.Form("txtDataLancamentoF")))
	strDataFinalBD			= FORMATADATABD(Trim(Request.Form("txtDataLancamentoF")))
	
	strTituloRelatorio  	= "Transporte Escolar " & strAnoLetivo & " <br> Coleta de Presença da <strong>" & strRota & "</strong>"
	if strDataInicial<>"" then
		strTituloRelatorio  	= strTituloRelatorio & "<br>Período: " & strDataInicial & " a " & strDataFinal
	end if
	'if strTurno<>"" then
	'	strTituloRelatorio  	= strTituloRelatorio & "<br>" & strTurno
	'end if
	

	intPagina = 1
	cont = 0
	
	ssql = "EXEC SP_STE_Rel_presencas "
	ssql = ssql & "   @DataInicio = '" & strDataInicialBD& "',"
	ssql = ssql & "   @DataFim = '" & strDataFinalBD & "',"
	ssql = ssql & "   @turno = '" & strTurno & "',"
	ssql = ssql & "   @filtrar = '" & listar & "',"
	ssql = ssql & "   @rede = '" & rede & "',"
	ssql = ssql & "   @codEmpresa = " & intCodEmpresa & ","
	ssql = ssql & "   @codEscolaEstadual = " & intCodEscolaEstadual & ","
	ssql = ssql & "   @codRota = " & intCodRota & ","
	ssql = ssql & "   @anoLetivo = " & strAnoLetivo & ";"
	response.write ssql
	rs.open ssql, cnn
	' Verifica se há registros
	If Not rs.EOF Then
		Dim i, totalFields, qtdeColunas
		totalFields = rs.Fields.Count
		qtdeColunas = totalFields - 4 ' Remove as 4 colunas fixas (Aluno, Rota, Turno, Escola)
		%>
		<!--#include file="includes/inc_cabecalhoRelatorio.asp"-->
		<%
		' Cabeçalho da Tabela
		Response.Write "<table width='100%' border='0' cellspacing='0' cellpadding='0' class='tabela'>"

		Response.Write "<tr bgcolor='#CCCCCC'>"
		Response.Write "  <td width='5%' align='left' class='celula' rowspan='2'><strong>Rede</strong></td>"
		Response.Write "  <td width='35%' align='left' class='celula' rowspan='2'><strong>Nome</strong></td>"
		Response.Write "  <td width='35%' align='left' class='celula' rowspan='2'><strong>Escola</strong></td>"
		Response.Write "  <td width='5%' align='left' class='celula' rowspan='2'><strong>Turno</strong></td>"
		Response.Write "  <td width='20%' align='center' colspan='" & qtdeColunas & "' class='celula'><strong>Presente</strong></td>"
		Response.Write "</tr>"

		' Sub-cabeçalho com datas (nomes das colunas dinâmicas)
		Response.Write "<tr bgcolor='#EEEEEE'>"
		For i = 5 To totalFields - 1
			Response.Write "  <td align='center' class='celula'><strong>" & day(rs.Fields(i).Name) & "</strong></td>"
		Next
		Response.Write "</tr>"
		
		mostrar = "NAO"
		
		IF listar = "C" then
			
		elseIF listar = "S" then
			
		end if
		
		' Linhas de dados
		Do Until rs.EOF
			Response.Write "<tr>"
			Response.Write "  <td style='height: 20px;'  class='celula'>" & rs("Rede") & "</td>"
			Response.Write "  <td class='celula'>" & rs("Aluno") & "</td>"
			Response.Write "  <td class='celula'>" & rs("Escola") & "</td>"
			Response.Write "  <td class='celula'>" & rs("Turno") & "</td>"
			
			For i = 5 To totalFields - 1
				Dim presente
				presente = rs.Fields(i).Value
				If IsNull(presente) or presente = "Não" or presente = "" Then presente = "—"
				if presente = "Sim" then 
					presente = "<img src='../images/check15.png' alt='Presente'>"
					mostrar = "SIM"
				end if
				Response.Write "  <td style='width: 35px;' align='center' class='celula'>" & presente & "</td>"
			Next

			Response.Write "</tr>"
			cont = cont + 1 
			rs.MoveNext
		Loop
		Response.Write "<tr style='font-weight: bold;'>"
		Response.Write "	<td  bgcolor='#CCCCCC'  class='celula' colspan='" & qtdeColunas+4 & "' class='text-left'>Quantidade total de aluno(s): " & cont & "</td>"
		Response.Write "</tr>"
		Response.Write "</table>"
	Else
		Response.Write "<p><br><br><br><br>Nenhum registro encontrado.</p>"
	End If

	' Fechar objetos
	rs.Close
%>
</table>
<script>
	aguarde.style.display="none";
</script>
</body>
</html>