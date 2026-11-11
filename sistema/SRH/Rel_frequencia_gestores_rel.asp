<%
response.Expires=0
'NÃ£o armazena a pÃ¡gina em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 11/06/2012
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Relatório de Frequencia Mensal
-->
<html>
<head>
<title><%=session("Titulo")%> - Grade Curricular</title>
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
			strMesRef = rs("MesReferencia")
			strDtInicial 	 = formatadataBD(rs("Data_Inicial"))
			strDtFinal 		 = formatadataBD(rs("Data_Final"))
			strDtInicialCon 	 = formatadataAP(rs("Data_Inicial"))
			strDtFinalCon 		 = formatadataAP(rs("Data_Final"))
		end if
		rs.close
	
	end if
	
	strTituloRelatorio  		= "Frequência - Extrato Mensal <br>GESTORES<br>"
	strTituloRelatorio  		= strTituloRelatorio & "Ref.: " & strMesReferencia & "/" & strAno
	strTituloRelatorio  		= strTituloRelatorio & "<br><font size='-1'>(" & strDtInicialCon & " a " & strDtFinalCon & ")</font>"

	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
	  <tr bgcolor="#CCCCCC">
        <td width="5%" height="15" align="center" class="celula"><strong>Matrícula </strong></td>
	    <td width="27%" align="center" class="celula"><strong>Nome</strong></td>
	    <td width="3%" align="center" class="celula"><strong>Hr Normal</strong></td>
	  	<td width="4%" align="center" class="celula"><strong>Per&iacute;odo</strong></td>
		<td width="20%" align="center" class="celula"><strong>S&eacute;rie/Fun&ccedil;&atilde;o</strong></td>
		<td width="7%" align="center" class="celula"><strong>Licenças</strong></td>
		<td width="4%" align="center" class="celula"><strong>Remoção</strong></td>
		<td width="3%" align="center" class="celula"><strong>Faltas</strong></td>
		<td width="5%" align="center" class="celula"><strong>Abonadas</strong></td>
		<td width="5%" align="center" class="celula"><strong>Não Justificadas</strong></td>
		<td width="17%" align="center" class="celula"><strong>Observação</strong></td>
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
	
	sql = "SELECT	C.Codigo, C.codFuncional, C.Nome, C.carga_horario_contratada, T.Desc_Turno, F.Desc_Funcao,"
	sql = sql & " isnull((select sum(cast(numero_falta as int)) as faltas  from SRH_COLABORADOR_FREQUENCIA"
	sql = sql & " WHERE codReferencia = " & intCodModulacaoReferencia
	sql = sql & " and cod_empresa = C.codLotacao"
	sql = sql & " and cod_colaborador = C.codigo"
	sql = sql & " and Cod_JustificativaFaltas = 1),0) as faltas,"
	sql = sql & " isnull("
	sql = sql & " 		(select sum(cast(numero_falta as int)) as abonadas "
	sql = sql & " from SRH_COLABORADOR_FREQUENCIA"
	sql = sql & " WHERE codReferencia = " & intCodModulacaoReferencia
	sql = sql & " and cod_empresa = C.codLotacao"
	sql = sql & " and cod_colaborador = C.codigo"
	sql = sql & " and Cod_JustificativaFaltas = 1"
	sql = sql & " and situacao = 'S'),0"
	sql = sql & " 		) as abonadas,"
	sql = sql & " (SELECT top 1 HL.DataLotacao as remocao"
	sql = sql & " FROM SRH_LOTACAOHISTORICO HL "
	sql = sql & " WHERE month(HL.DataLotacao) = " & strMesRef
	sql = sql & " and HL.COD_COLABORADOR = C.codigo) as remocao"
	sql = sql & " FROM SRH_COLABORADOR C "
	sql = sql & " left Join SRH_TURNO T on T.Cod_Turno = C.CodTurno "
	sql = sql & " left Join SRH_REGENCIACOLABORADOR R on R.Codigo = C.Cod_Regencia "
	sql = sql & " left Join SRH_FUNCAOCOLABORADOR F on F.Cod_funcao = C.Codfuncao "
	sql = sql & " Where C.codLotacao = " & session("codEmpresa")
	sql = sql & " AND C.Situacao = 'A' " 
	sql = sql & " AND (F.DESC_FUNCAO IN ('DIRETOR(A)','SECRETÁRIO(A) GERAL','ASSISTENTE EDUCACIONAL') OR (F.DESC_FUNCAO LIKE '%COORDENADOR%'))"
	sql = sql & " AND ( f.Tipo_Funcao = 'FUNCIONARIO' or C.CodCategoria in (2,8) )"	
	sql = sql & " AND ( f.Tipo_Funcao = 'FUNCIONARIO' or C.CodCategoria in (2,8) )"	
	sql = sql & " Order By C.Nome, T.Desc_Turno, Regencia"
	rs.open sql, cnn
	if not rs.eof then 
	
	   While not rs.eof 
	   		
			strJustificativas = ""
			sql = " Select justificativa, justificativa_abono, situacao "
			sql = sql & " FROM SRH_COLABORADOR_FREQUENCIA  "
			sql = sql & " Where Cod_empresa = " & Session("CodEmpresa") 
			sql = sql & " And CodReferencia  = " & intCodModulacaoReferencia
			sql = sql & " And cod_colaborador  = " & rs("Codigo")
			sql = sql & " And (justificativa is not null or justificativa_abono is not null)"
			rsAux.open sql, cnn
			IF rsAux.EOF = false THEN
				While not rsAux.eof 
					if not isnull(rsAux("justificativa")) then strJustificativas = strJustificativas & rsAux("justificativa") & "<br>"
					if not isnull(rsAux("justificativa_abono")) then strJustificativas = strJustificativas & rsAux("justificativa_abono") & "<br>"
					rsAux.movenext
				Wend
			end if
			rsAux.close
			
			strLicenca = "---"
			sql = " select distinct f.cod_colaborador, t.Descricao as licenca"
			sql = sql & " from SRH_COLABORADOR_FREQUENCIA f"
			sql = sql & " inner join SRH_JUSTIFICATIVAFALTAS t on t.Codigo = f.Cod_JustificativaFaltas"
			sql = sql & " WHERE codReferencia = " & intCodModulacaoReferencia
			sql = sql & " and f.cod_empresa = " & Session("CodEmpresa") 
			sql = sql & " and f.Cod_JustificativaFaltas <> 1"
			sql = sql & " and f.cod_colaborador = " & rs("Codigo")
			rsAux.open sql, cnn
			IF rsAux.EOF = false THEN
				strLicenca = ""
				While not rsAux.eof 
					if not isnull(rsAux("licenca")) then strLicenca = strLicenca & rsAux("licenca") & "<br>"
					rsAux.movenext
				Wend
			end if
			rsAux.close
  		    %> 
			<tr>
			<td class="celula">&nbsp;<%=rs("codFuncional")%></td>
			<td class="celula">&nbsp;<%=rs("Nome")%></td>
			<td align="center" class="celula">&nbsp;<%=rs("carga_horario_contratada")%></td>
			<td align="center" class="celula">&nbsp;<%=left(rs("Desc_Turno"),1)%></td>
			<td  class="celula">&nbsp; <%=rs("Desc_Funcao")%>&nbsp;</td>	
			<td  class="celula" align="center"><%=strLicenca%></td>
			<td align="center"  class="celula"><%=rs("remocao")%>&nbsp;</td>
			<td align="center"  class="celula"><%=rs("faltas")%>&nbsp;</td>
			<td align="center"  class="celula"><%=rs("abonadas")%>&nbsp;</td>
            <td align="center"  class="celula"><%=rs("faltas")-rs("abonadas")%>&nbsp;</td>
            <td align="center"  class="celula"><%=strJustificativa%>&nbsp;</td>

	  </tr> 
		    <%	
			'quantidade de registros da pÃ¡gina
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
  <td colspan="11" class="celula"><strong>Quantidade:&nbsp;</strong><%=contColaboradorEmpresa%></td>
</tr>
</table>
<br>
<br>

<p align="center">____________________________________________<br>ASSINATURA DO RESPONSÁVEL PELA FOLHA</p>

<br>
<script>
	aguarde.style.display="none";
</script>
</body>
</html>
