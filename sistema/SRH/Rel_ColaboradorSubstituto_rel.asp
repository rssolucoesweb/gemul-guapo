<%
if request("exportar") = "" then
	Response.Buffer = false
end if
Server.ScriptTimeOut = 9999

paginaatual = request.ServerVariables("SCRIPT_NAME")
nomeDocSalvo = "relatorioColaboradorSubstituto"

dim intPagina

strTituloRelatorio  		= "Colaborador Substituto"

intCodFuncao 	   		 	= TRIM(Request("cmbFuncao"))
intCodEmpresaUsuario 	    = TRIM(Request("cmdEmpresaUsuario"))
intCodTurno 	   		 	= TRIM(Request("cmbTurnoRH"))
if intCodEmpresaUsuario = "" then intCodEmpresaUsuario = "0"
if intCodTurno = "" then intCodTurno = "0"	
if intCodFuncao = "" then intCodFuncao = "0"	
intAnoLetivo 				= Trim(Request("txtAnoLetivo"))
strAnoCab 					= intAnoLetivo
strDataLancamento=request("txtDataInicial")
strDataLancamentoFinal=request("txtDataFinal")
if strDataLancamento<>"" then strTituloRelatorio = strTituloRelatorio & "<br>Período: " & formatadataAP(strDataLancamento) & " a " & FormatadataAP(strDataLancamentoFinal)

strSituacao						= Trim(Request("cmbSituacao"))

strExportarWord 	= paginaatual & "?exportar=w&cmbFuncao=" & intCodFuncao & "&cmdEmpresaUsuario=" & intCodEmpresaUsuario & "&cmbTurnoRH=" & intCodTurno & "&txtAnoLetivo=" & intAnoLetivo & "&txtDataInicial=" & strDataLancamento & "&txtDataFinal=" & strDataLancamentoFinal	& "&cmbSituacao=" & strSituacao 
strExportarExcel 	= paginaatual & "?exportar=e&cmbFuncao=" & intCodFuncao & "&cmdEmpresaUsuario=" & intCodEmpresaUsuario & "&cmbTurnoRH=" & intCodTurno & "&txtAnoLetivo=" & intAnoLetivo & "&txtDataInicial=" & strDataLancamento & "&txtDataFinal=" & strDataLancamentoFinal	& "&cmbSituacao=" & strSituacao
%>
<html>
<head>
<title><%=session("Titulo")%> - Alunos Por Turma</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%	if request("exportar") = "" then %>
    <link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
	<script src="../../js/js_funcoes_gerais.js"></script>
	<script src="../../js/js_barra_movel.js"></script>
<%	end if %>
</head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%
if request("exportar") = "" then 
    %><!--#include file="../../includes/inc_Botoes_relatorio_word_excel.asp"--><%
end if
%>
<%	if request("exportar") = "" then %>
<!--#include file="../../includes/inc_aguarde.asp"-->
<%	end if 
%>
	
<br>
<%

	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table align="center" width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
	    <td height="19" colspan="4" align="center" class="celulaFonte9"><strong>Colaborador - Substituto</strong></td>
	    <td colspan="4" align="center" class="celulaFonte9"><strong>Colaborador - Subistituido</strong></td>
        <td colspan="2" align="center" class="celulaFonte9"><strong>Data</strong></td>
        <td width="1%" rowspan="2" align="center" class="celulaFonte9"><strong>Qtde. Dias</strong></td>
        <td width="10%" rowspan="2" align="center" class="celulaFonte9"><strong>Tipo</strong></td>
      </tr>
	  <tr bgcolor="#CCCCCC">
		<td width="15%" height="18" class="celulaFonte9"><strong>Unidade</strong></td>
		<td width="1%" class="celulaFonte9"><strong>Matr.</strong></td>
		<td width="15%" class="celulaFonte9"><strong>Nome</strong></td>
		<td width="8%" class="celulaFonte9"><strong>Fun&ccedil;&atilde;o</strong></td>
		<td width="15%" class="celulaFonte9"><strong>Unidade</strong></td>
	    <td width="1%" class="celulaFonte9"><strong>Matr.</strong></td>
	    <td width="15%" class="celulaFonte9"><strong>Nome</strong></td>
	    <td width="10%" class="celulaFonte9"><strong>Fun&ccedil;&atilde;o</strong></td>
	    <td width="3%" align="center" class="celulaFonte9"><strong>Inicial</strong></td>
	    <td width="3%" align="center" class="celulaFonte9"><strong>Final</strong></td>
      </tr>
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	mostraCabecalho
	intQtdeRegistroPorPagina = 0  
	
	sql = " Select CB.Cod_Empresa, CB.Cod_Grupo, C.CodFuncional, CB.CodEmpresaSubstituto, CB.CodColaboradorSubstituto, C.nome as NomeSubstituto,"
	sql = sql & " EmpSubstituto.RAZAOSOCIAL as EmpresaSubstituto,  "
	sql = sql & " CB.CodEmpresaSubstituido, CB.CodColaboradorSubstituido, isnull(CSS.nome,'DEFICIT') as NomeSubstituido,"
	sql = sql & " EmpSubstituido.RAZAOSOCIAL as EmpresaSubstituido,"
	sql = sql & " CB.DataInicial, CB.DataFinal, CB.Situacao, "
	sql = sql & " FuncaoSubstituto.Desc_Funcao as FuncaoSubstituto, "
	sql = sql & " FuncaoSubstituido.Desc_Funcao as FuncaoSubstituido,"
	sql = sql & " CSS.CodFuncional as SUB_CodSubstituido, J.DESCRICAO AS TIPO"
	sql = sql & " from SRH_COLABORADOR_SUBSTITUTO CB"
	sql = sql & " Inner join SRH_COLABORADOR C on C.codigo = CB.CodColaboradorSubstituto "
	sql = sql & " Inner join SRH_COLABORADOR CSS on CSS.codigo = CB.CodColaboradorSubstituido	"	
	sql = sql & " left join SEG_EMPRESA EmpSubstituto on EmpSubstituto.CODIGO = CB.CodEmpresaSubstituto "
	sql = sql & " left join SEG_EMPRESA EmpSubstituido on EmpSubstituido.CODIGO = CB.CodEmpresaSubstituido "
	sql = sql & " Inner join SRH_FUNCAOCOLABORADOR FuncaoSubstituto on FuncaoSubstituto.Cod_Funcao = C.codFuncao "
	sql = sql & " Inner join SRH_FUNCAOCOLABORADOR FuncaoSubstituido  on FuncaoSubstituido.Cod_Funcao = CSS.codFuncao "
	sql = sql & " left join SRH_TURNO TU on TU.cod_Turno = C.Codturno "
	sql = sql & " left join SRH_COLABORADOR_FREQUENCIA F on F.CODIGO = CB.Cod_Lancamento_Falta "
	sql = sql & " left join SRH_JUSTIFICATIVAFALTAS J on J.CODIGO = f.Cod_JustificativaFaltas "
	
	sql = sql & " Where CB.COD_GRUPO = " & session("codgrupo")
	if intAnoLetivo <> "" then
		sql = sql & " And year(CB.DataInicial) = " & intAnoLetivo
	end if
	
	if intCodEmpresaUsuario <> "0" then
		sql = sql & " and CB.CodEmpresaSubstituto = " & intCodEmpresaUsuario
	end if		
	
	if intCodFuncao <> "0" then
		sql = sql & " and C.codFuncao = " & intCodFuncao
	end if		
	
	if intCodTurno <> "0" then
		sql = sql & " and C.Codturno = " & intCodTurno
	end if	
	if strSituacao <> "0" then
		sql = sql & " and CB.Situacao = '" & strSituacao & "'"
	end if	
	
	'sql = sql & " and convert(datetime,convert(varchar, CS.DATAINICIAL , 103),103) >= convert(datetime, '" & strDataInicialModulacao & "',103) "
	'sql = sql & " and convert(datetime,convert(varchar, CS.DATAFINAL, 103),103) <= convert(datetime, '" & strDataFinalModulacao & "',103) "
	IF strDataLancamento<>"" AND strDataLancamentoFinal<>"" THEN
	sql = sql & " and (convert(datetime, '" & strDataLancamento & "',103) between convert(datetime,convert(varchar, CB.DATAINICIAL , 103),103) AND convert(datetime,convert(varchar, CB.DATAFINAL, 103),103)"
	sql = sql & " OR convert(datetime, '" & strDataLancamentoFinal & "',103) between convert(datetime,convert(varchar, CB.DATAFINAL , 103),103) AND convert(datetime,convert(varchar, CB.DATAFINAL, 103),103))"
	END IF
	sql = sql & " order by EmpresaSubstituto, NomeSubstituto, DataInicial, DataFinal"
	rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof
			strDataI = rs("DataInicial")
			strDataF = rs("DataFinal")
			if strDataLancamento<>"" and strDataLancamentoFinal<>"" then
				if DateValue(strDataLancamento)>=DateValue(rs("DataInicial")) 		then strDataI=strDataLancamento
				if DateValue(strDataLancamentoFinal)<=DateValue(rs("DataFinal")) 	then strDataF=strDataLancamentoFinal
			end if
			diferenca_dias = DateDiff("d",strDataI,strDataF)
			%>
			<tr> 
			  <td align="left" class="celulaFonte9"><%=replace(replace(replace(rs("EmpresaSubstituto"),"ESCOLA MUNICIPAL","EM"),"PROFESSOR","PROF"),"MUNICIPAL DE EDUCAÇÃO PROFISSIONAL","M.E.F.")%></td>
			  <td align="left" class="celulaFonte9"><%=Ucase(rs("CodFuncional"))%>&nbsp;</td>
			  <td align="left" class="celulaFonte9"><%=Ucase(rs("NomeSubstituto"))%></td>
			  <td align="left" class="celulaFonte9"><%=replace(replace(replace(replace(replace(replace(replace(replace(Ucase(rs("FuncaoSubstituto")),"REGENTE","REG"),"PROFESSOR","PROF"),"COORDENADOR","COO"),"ASSISTENTE","ASS"),"INFANTIL","INF"),"EDUCACIONAL","ED"),"INFORMÁTICA","INF"),"LÍNGUA PORTUGUESA","L.PORT")%></td>
			  <td align="left" class="celulaFonte9"><%=replace(replace(replace(rs("EmpresaSubstituido"),"ESCOLA MUNICIPAL","EM"),"PROFESSOR","PROF"),"MUNICIPAL DE EDUCAÇÃO PROFISSIONAL","M.E.F.")%></td>
			  <td align="left" class="celulaFonte9"><%=Ucase(rs("SUB_CodSubstituido"))%></td>
			  <td align="left" class="celulaFonte9"><%=Ucase(rs("NomeSubstituido"))%></td>
			  <td align="left" class="celulaFonte9"><%=replace(replace(replace(replace(replace(replace(replace(replace(Ucase(rs("FuncaoSubstituido")),"REGENTE","REG"),"PROFESSOR","PROF"),"COORDENADOR","COO"),"ASSISTENTE","ASS"),"INFANTIL","INF"),"EDUCACIONAL","ED"),"INFORMÁTICA","INF"),"LÍNGUA PORTUGUESA","L.PORT")%></td>
			  <td align="center" class="celulaFonte9"><%=Ucase(rs("DataInicial"))%>&nbsp;</td>
			  <td align="center" class="celulaFonte9"><%=formatadataAP(rs("DataFinal"))%>&nbsp;</td>
			  <td align="center" class="celulaFonte9">&nbsp;<%=cInt(diferenca_dias)+1%></td>
			  <td align="center" class="celulaFonte9">&nbsp;<%=Ucase(rs("Tipo"))%></td>
		    </tr>
			<%			
			'quantidade de registros da p�gina
			if intQtdeRegistroPorPagina = 27 and request("exportar") = "" then
				 intPagina = intPagina + 1
				 intQtdeRegistroPorPagina = 1
				 fimTabela
				%>
				<pre></pre>				
				<%			
				mostraCabecalho
			end if	
			intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
			rs.movenext
		wend
	else
		%>
		  <tr>
			<td colspan="16" class="celulaFonte9" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
		  </tr>
		<%
	end if
	rs.close
%>
</table>
<%
	if request("exportar") = "w" then 
		Response.ContentType = "application/vnd.ms-word"
        Response.AddHeader "content-disposition","attachment;filename="&nomeDocSalvo&".doc"
	elseif request("exportar") = "e" then 
		Response.ContentType = "application/vnd.ms-excel"
        Response.AddHeader "content-disposition","attachment;filename="&nomeDocSalvo&".xls"
	end if
%>
<script>
	aguarde.style.display="none";
</script>
</body>
</html>
