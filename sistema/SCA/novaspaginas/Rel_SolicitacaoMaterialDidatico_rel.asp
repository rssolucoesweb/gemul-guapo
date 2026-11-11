<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/02/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Solicitação de material didatico
-->
<html>
<head>
<title><%=session("Titulo")%> - Grade Curricular</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script></head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_Botoes_relatorio.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<br>
<%
	dim intPagina
	dim strInfoTurma
	
	strData		 			= Trim(Request.Form("txtData"))

	strTituloRelatorio  	= "SOLICITAÇÃO DE MATERIAIS DIDÁTICO<br>" & strData & " - " & ucase(WeekDayName(WeekDay(strData)))

	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
	  <tr bgcolor="#CCCCCC">
	    <td width="13%" class="celula"><div align="center"><strong>Turma </strong></div></td>
		<td width="13%" class="celula"><div align="center"><strong>Sala </strong></div></td>
	    <td width="26%" class="celula"><div align="center"><strong>Material</strong></div></td>
	    <td width="14%" class="celula"><div align="center"><strong>Hor&aacute;rio</strong></div></td>
	    <td width="28%" height="15" class="celula"><div align="center"><strong>Professor(a)</strong></div></td>
	    <td width="19%" class="celula"><div align="center"><strong>Montador</strong></div></td>
      </tr>
	  
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	mostraCabecalho
	cont = 0
	contPeriodo = 0

	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	strSemestre 			= Trim(Request.Form("cmbSemestre"))
	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))

	if intCodCurso = "" then intCodCurso = "0"
	if strSemestre = "" then strSemestre = "0"

	sql = "select	"
	sql = sql & " 		R.data_utilizacao, R.num_sala,"
	sql = sql & " 		H.horario,"
	sql = sql & " 		C.nome,"
	sql = sql & " 		E.desc_equipamento, T.NOMETURMA"
	sql = sql & " from SCA_EQUIPAMENTO_RESERVA R"
	sql = sql & " inner JOIN SCA_EQUIPAMENTO E ON E.COD_EMPRESA= R.COD_EMPRESA AND R.COD_EQUIPAMENTO = E.COD_EQUIPAMENTO"
	sql = sql & " INNER JOIN SRH_COLABORADOR C ON C.COD_EMPRESA = R.COD_EMPRESA AND C.codigo = R.Cod_Colaborador "
	sql = sql & " INNER JOIN SCA_HORARIO H ON C.COD_EMPRESA = R.COD_EMPRESA AND H.codigo = R.Cod_horario "
	sql = sql & " INNER JOIN SCA_HORARIO_AULA HA ON C.COD_EMPRESA = R.COD_EMPRESA AND HA.codigo = R.Cod_horario_aula "
	sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_EMPRESA = R.COD_EMPRESA AND T.COD_TURMA = HA.COD_TURMA"
	sql = sql & " INNER JOIN sca_GradeCurricular g on g.cod_gradecurricular = t.cod_gradecurricular and g.cod_empresa =  t.cod_empresa"
	sql = sql & " INNER JOIN sca_periodo p on p.cod_empresa = g.cod_empresa and p.cod_periodo = g.cod_periodo"
	sql = sql & " where	R.COD_EMPRESA = " & Session("CodEmpresa")	
	sql = sql & " AND	R.data_utilizacao = '" & formatadataBD(strData) & "'"
	if strSemestre <> "0" then
		sql = sql & " AND	H.Semestre = " & strSemestre
	end if
	if strAnoLetivo <> "" then
		sql = sql & " AND	H.AnoLetivo = " & strAnoLetivo
	end if
	if intCodCurso <> "0" then
		sql = sql & " AND	p.cod_curso = " & intCodCurso
	end if
	sql = sql & " Order by H.horario, C.nome "
	rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof 
		
			%>
			  <tr >
			    <td height="35" align="center" class="celula"><%=rs("NOMETURMA")%></td>
				<td height="35" align="center" class="celula"><%=rs("num_sala")%></td>
			    <td align="left" class="celula"><%=rs("desc_equipamento")%></td>
			    <td align="left" class="celula"><%=rs("horario")%></td>
			    <td align="left" class="celula"><%=rs("NOME")%></td>
			    <td align="left" class="celula">___________________________________</td>
		      </tr>
			<%
			
			'quantidade de registros da página
			if intQtdeRegistroPorPagina = 50 then
				 intPagina = intPagina + 1
				 intQtdeRegistroPorPagina = 1
				 fimTabela
				%>
				<pre></pre>				
				<%			
				mostraCabecalho
			end if	
			cont = cont + 1
			intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
			rs.movenext
		wend
		contPeriodo = contPeriodo + 1
	else
		%>
		  <tr>
			<td colspan="5" class="celula" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
		  </tr>
		<%
	end if
	rs.close
%>
</table>
<script>
	aguarde.style.display="none";
</script>
</body>
</html>
