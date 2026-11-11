<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<html>
<head>
<title><%=session("Titulo")%> - Faltas</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_Botoes_relatorio.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<!--#include file="../includes/inc_sqlCodigoEmpresaUsuario.asp"-->
<!--#include file="../includes/inc_CompartilharDadosCadastrais.asp"-->
<br>
<%
	dim intPagina
	dim strInfoTurma
	strAno	 					= Trim(Request("txtAno"))
	intSemestre 				=  Session("strSemestre")
	intCodModulacaoReferencia	= Trim(Request.Form("cmbModulacaoReferencia"))
	
	if intCodModulacaoReferencia <> "" then
		
		sql = "SELECT Codigo, AnoReferencia, MesReferencia, SemestreReferencia, Data_Inicial, Data_Final"
		sql = sql & " FROM SRH_MODULACAO_REFERENCIA"
		sql = sql & " where Codigo = " & intCodModulacaoReferencia
		rs.open sql, cnn
		if not rs.eof then 
			strMesReferencia =  ucase(monthname(rs("MesReferencia")))
		end if
		rs.close
	
	end if
	
	strTituloRelatorio  		= "Rela&ccedil;&atilde;o de Frequ�ncia Mensal <br>"
	strTituloRelatorio  		= strTituloRelatorio & "Ref.: " & strMesReferencia & "/" & year(date)

	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
	  <tr bgcolor="#CCCCCC">
        <td width="4%" height="15" class="celula"><strong>Matricula </strong></td>
	    <td width="27%" class="celula"><strong>Nome</strong></td>
	    <td width="6%" class="celula"><strong>Hr Normal</strong></td>
	  	<td width="5%" class="celula"><strong>Turno</strong></td>
		<td width="9%" class="celula"><strong>S&eacute;rie/Fun&ccedil;&atilde;o</strong></td>
		<td width="5%" class="celula"><strong>Per&iacute;odo</strong></td>
		<td width="3%" align="center" class="celula"><strong>Data Falta</strong></td>
		<td width="3%" align="center" class="celula"><strong>Faltas</strong></td>
		<td width="4%" align="center" class="celula"><strong>Lic. Mat</strong></td>
		<td width="5%" align="center" class="celula"><strong>Lic. M&eacute;dica</strong></td>
		<td width="25%" class="celula"><strong>Obs</strong></td>
	  </tr>
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	mostraCabecalho
	cont = 0
	contColaboradorEmpresa = 0
	intQtdeRegistroPorPagina = 0
	
	sql = "SELECT C.Codigo, C.codFuncional, C.Nome, C.carga_horario_contratada, T.Desc_Turno, R.Descricao as Regencia, R.Regencia as Percentual, F.Desc_Funcao, C.CodCategoria "
	sql = sql & " FROM SRH_COLABORADOR C "
	sql = sql & " left Join SRH_TURNO T on T.Cod_Turno = C.CodTurno"
	sql = sql & " left Join SRH_REGENCIACOLABORADOR  R on R.Codigo = C.Cod_Regencia"
	sql = sql & " left Join SRH_FUNCAOCOLABORADOR  F on F.Cod_funcao = C.Codfuncao"
	sql = sql & " Where C.codLotacao = " & session("codEmpresa")
	sql = sql & " AND C.Situacao = 'A'"
	'sql = sql & " AND C.codigo = 991"
	sql = sql & " Order By C.Nome, T.Desc_Turno, Regencia"
	rs.open sql, cnn
	if not rs.eof then 
	
	   While not rs.eof 
	   		
			intQtdeFalta = ""
			intQtdeFaltaLicenca = 0
			strJustificativa_abono = ""
			
			intCodCategoria = rs("CodCategoria")
			
			strFaltas = ""
			strMaternidade = ""
			strMedica = ""
			strPremio = ""
			strJustificativa_abono = ""
	
			' Conta as faltas
			sql = " Select numero_falta, Cod_JustificativaFaltas, justificativa, situacao, datafalta, datalancamento, datalancamentoFinal "
			sql = sql & " FROM SRH_COLABORADOR_FREQUENCIA  "
			sql = sql & " Where Cod_empresa = " & Session("CodEmpresa") 
			sql = sql & " And CodReferencia  = " & intCodModulacaoReferencia
			sql = sql & " And cod_colaborador  = " & rs("Codigo")
			rsAux.open sql, cnn
				
			IF rsAux.EOF = false THEN
				
				 While not rsAux.eof 
				 
				 	strFaltas = ""
					strMaternidade = ""
					strMedica = ""
					strPremio = ""
					strJustificativa_abono = ""
					
				 	intQtdeFalta = intQtdeFalta + trim(rsAux("numero_falta"))
					strJustificativa_abono = rsAux("justificativa")
					intCodTipoFalta = rsAux("Cod_JustificativaFaltas")
					
					' Faltas
					if intCodTipoFalta = 1 then
						strFaltas = "SIM"
					end if
				
					if intCodTipoFalta = 2 then
						strMaternidade = "SIM"
					end if
					
					if intCodTipoFalta = 3 then
						strMedica = "SIM"
					end if
					
					if intCodTipoFalta = 4 then
						strPremio = "SIM"
					end if
					
					if trim(rsAux("situacao")) = "S" then 
						intQtdeFalta = intQtdeFalta - intQtdeFalta
						intQtdeFaltaLicenca = intQtdeFaltaLicenca + 1
					end if
					
					
					%> 
					<tr>
						<td class="celula">&nbsp;<%=rs("codFuncional")%></td>
						<td class="celula">&nbsp;<%=rs("Nome")%></td>
						<td class="celula">&nbsp;<%=rs("carga_horario_contratada")%></td>
						<td  class="celula">&nbsp;<%=rs("Desc_Turno")%> &nbsp;</td>	
						<% if intCodCategoria = "1" then 
						
						%>		
							<td  class="celula">&nbsp;<%=rs("Regencia")%> - <%=rs("Percentual")%>% &nbsp;</td>
						<% else %>		
							<td  class="celula">&nbsp;<%=rs("Desc_Funcao")%> &nbsp;</td>
						<% end if %>
						<td align="center"  class="celula"><%=formatadataAP(rsAux("DataLancamento"))%>&nbsp;a&nbsp;<%=formatadataAP(rsAux("DataLancamentoFinal"))%></td>
						<td align="center"  class="celula"><%=formatadataAP(rsAux("datafalta"))%>&nbsp;</td>
						<td align="center"  class="celula"><%=rsAux("numero_falta")%>&nbsp;</td>
						<td align="center"  class="celula"><%=strMaternidade%>&nbsp;</td>
						<td align="center"  class="celula"><%=strMedica%>&nbsp;</td>
						<td  class="celula">&nbsp;</td>
					</tr> 
						<%
					
					rsAux.movenext
					
				wend
			
				if trim(intQtdeFalta) = 0 then intQtdeFalta = ""
			
			end if
			rsAux.close
  		    	
			'quantidade de registros da página
			if intQtdeRegistroPorPagina >= 50 then
				 intPagina = intPagina + 1
				 intQtdeRegistroPorPagina = 1
				 fimTabela
				%>
				<pre></pre>				
				<%			
				mostraCabecalho
			end if	
			cont = cont + 1
			contColaboradorEmpresa = contColaboradorEmpresa + 1
			intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
			rs.movenext
		wend
		contPeriodo = contPeriodo + 1
	else
		%>
		  <tr>
			<td colspan="11" class="celula" align="center">&nbsp;</td>
	  </tr>
		<%
	end if
	rs.close
%>
<tr>
  <td colspan="11" class="celula"><strong>Quantidade.:</strong><%=contColaboradorEmpresa%></td>
</tr>
</table>
<br>
<script>
	aguarde.style.display="none";
</script>
</body>
</html>
