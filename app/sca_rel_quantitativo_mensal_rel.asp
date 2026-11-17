<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
SESSION.Timeout = 1200
Server.ScriptTimeout = 1200
%>
<html>
<head>
<title>GEMUL - Quantitativos</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet" href="css_rel/Estilo_Impressao.css">
<script src="js/js_funcoes_gerais.js"></script>
<script src="js_app/js_barra_movel.js"></script>
<body>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="includes/inc_Botoes_relatorio.asp"-->
<!--#include file="includes/inc_aguarde.asp"-->
<br>
<%

	dim intPagina
	dim i, campo, totalLinha
	
	if Trim(Request("txtAnoLetivo")) <> "" then
	   strAnoLetivo 			= Trim(Request("txtAnoLetivo"))
	else
	   strAnoLetivo = session("strAnoLetivo")   
	end if   

	intCodEmpresaGrupo		    = Trim(Request.Form("cmbEmpresaGrupo"))

	intSemestre 				= Trim(Request.Form("cmbSemestre"))
	intCodSituacaoAluno			= Trim(Request.Form("cmbSituacaoAluno"))
	strTipoCurso				= Trim(Request.Form("cmbTipoCurso"))

	strMes		 			= Trim(Request("cmbMes"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	if intSemestre = "" then 	intSemestre  = session("strSemestre")
	intCodTurno				= Trim(Request.Form("cmbTurnoRH"))
	
	sql = "SELECT COD_TURNO, DESC_TURNO"
	sql = sql & " FROM SRH_TURNO"
	SQL = SQL & " WHERE cod_turno = " & intCodTurno
	rs.open sql, cnn
	if NOT rs.eof then
		strDescTurno = rs("DESC_TURNO")
	else
		strDescTurno = ""
	end if
	rs.close

	sql = "SELECT DESC_SITUACAOALUNO"
	sql = sql & " FROM SCA_SITUACAOALUNO where COD_SITUACAOALUNO = " & intCodSituacaoAluno
	rs.open sql, cnn
	if NOT rs.eof then
		situacaoAluno = rs("DESC_SITUACAOALUNO")
	end if
	rs.close
	
	strTituloRelatorio  	= "QUANTITAVOS DE ALUNOS MENSAL<br><strong>" & strTipoCurso & " - " & strAnoLetivo & "<br>" & situacaoAluno 
	
	if strDescTurno<>"" then 
		strTituloRelatorio = strTituloRelatorio & " - " & strDescTurno
	end if
	
	strTituloRelatorio = strTituloRelatorio & "</strong>"
	
	
	mostraCabecalho
	intPagina = 1
		 
	cont = 0
	
	sql = "exec [dbo].[SP_SCA_QuantAlunoPorPeriodoMensal] " & session("codGrupo") & "," & strAnoLetivo & "," & strMes & ",'" &strTipoCurso& "'," & intCodSituacaoAluno & "," & intCodEmpresaGrupo & "," & intCodTurno
	'response.write sql
	rs.open sql, cnn
	if not rs.eof then
		
		
		Response.Write "<tr class='celula' bgcolor='#DDDDDD'>"

		'Coluna fixa
		Response.Write "<td class='celula'><b>Unidade</b></td>"

		for i = 0 to rs.Fields.Count - 1

			campo = rs.Fields(i).Name

			if campo <> "ordem" and campo <> "cod_empresa" and campo <> "empresa" and campo <> "TOTAL_GERAL" then
				Response.Write "<td align='center' class='celula'><b>" & campo & "</b></td>"
			end if

		next

		Response.Write "<td class='celula' align='right'><strong>TOTAL</strong></td>"

		Response.Write "</tr>"
		
		While not rs.eof	
		
			cont = cont + 1

			Response.Write "<tr " & corLinha & ">"

			'Empresa
			Response.Write "<td class='celula'>" & rs("empresa") & "</td>"

			'Percorre campos dinâmicos (periodos)
			
			totalLinha = 0

			for i = 0 to rs.Fields.Count - 1

				campo = rs.Fields(i).Name

				if campo <> "ordem" and campo <> "cod_empresa" and campo <> "empresa" and campo <> "TOTAL_GERAL" then

					if isnull(rs.Fields(i).Value) then
						Response.Write "<td class='celula'>&nbsp</td>"
					else
						Response.Write "<td class='celula' align='center'>" & rs.Fields(i).Value & "</td>"
						totalLinha = totalLinha + rs.Fields(i).Value
					end if

				end if

			next

			'Coluna TOTAL_GERAL (do SQL)
			if isnull(rs("TOTAL_GERAL")) then
				Response.Write "<td class='celula'>&nbsp</td>"
			else
				Response.Write "<td class='celula' align='center'><strong>" & rs("TOTAL_GERAL") & "</strong></td>"
			end if

			Response.Write "</tr>"
			
			rs.movenext
		wend
	else
		
		%>
		  <tr>
			<td colspan="7" class="<%=strclasse%>" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
		  </tr>
		<%
	end if
	rs.close	
	
	sub mostraCabecalho()
		%>
		<!--#include file="includes/inc_cabecalhoRelatorio.asp"-->
		<br>
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
		  <%
		  if strSubTitulo <> "" then
			 %>
			 <tr bgcolor="#CCCCCC">
			 <td colspan="4" class="<%=strclasse%>"><div align="center"><%=strSubTitulo%></div></td>
			 </tr>
			 <%
		  end if	
	 
	end Sub
	

%>
</table>
</body>
<script>
	aguarde.style.display="none";
</script>
</html>
