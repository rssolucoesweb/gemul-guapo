<%
response.Expires=0
'N�o armazena a p�gina em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLU��ES WEB - www.rssolucoesweb.com.br"
	::	Data de Cria��o...: 13/02/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Extrato de Notas
-->
<html>
<head>
<title><%=session("Titulo")%> - Grade Curricular</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script>
</head>
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
	
	strSituacao					= Trim(Request.Form("cmbSituacao"))	
	intCodColaborador				= Trim(Request("txtCodFuncionario"))
	strAnoLetivo				= Trim(Request("txtAnoLetivo"))
	intCodEmpresaUsuario 	    = TRIM(Request.Form("cmbEmpresaGrupo"))
	intCodJustificativaFaltas		= Trim(Request("cmbJustificativaFaltas"))
	intTipoColaborador				= Trim(Request("cmbTipoColaborador"))
	

	strTituloRelatorio  	= "Relatório de Faltas Abonadas"

	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
        <tr bgcolor="#CCCCCC">
            <td width="5%" class="celula"><div align="center"><strong>Matr&iacute;cula</strong></div></td>
            <td width="23%" class="celula"><div align="center"><strong>Colaborador</strong></div></td>
            <td width="8%" align="center" class="celula"><strong>Tipo</strong></td>
            <td width="8%" align="center" class="celula"><strong>Refer&ecirc;ncia</strong></td>
            <td width="14%" class="celula"><div align="center"><strong>Per&iacute;odo</strong></div></td>
            <td width="10%" class="celula"><div align="center"><strong>Tipo de Falta</strong></div></td>
            <td width="32%" class="celula"><div align="center"><strong>Justificativa</strong></div></td>
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

	sql = " select distinct j.descricao as tipo_falta, c.codFuncional, c.nome,"
	sql = sql & " CASE r.mesReferencia"
	sql = sql & " WHEN 1 THEN cast(r.AnoReferencia as varchar) + ' - Janeiro'"
	sql = sql & " WHEN 2 THEN cast(r.AnoReferencia as varchar) + ' - Fevereiro'"
	sql = sql & " WHEN 3 THEN cast(r.AnoReferencia as varchar) + ' - Mar�o'"
	sql = sql & " WHEN 4 THEN cast(r.AnoReferencia as varchar) + ' - Abril'"
	sql = sql & " WHEN 5 THEN cast(r.AnoReferencia as varchar) + ' - Maio'"
	sql = sql & " WHEN 6 THEN cast(r.AnoReferencia as varchar) + ' - Junho'"
	sql = sql & " WHEN 7 THEN cast(r.AnoReferencia as varchar) + ' - Julho'"
	sql = sql & " WHEN 8 THEN cast(r.AnoReferencia as varchar) + ' - Agosto'"
	sql = sql & " WHEN 9 THEN cast(r.AnoReferencia as varchar) + ' - Setembro'"
	sql = sql & " WHEN 10 THEN cast(r.AnoReferencia as varchar) + ' - Outubro'"
	sql = sql & " WHEN 11 THEN cast(r.AnoReferencia as varchar) + ' - Novembro'"
	sql = sql & " WHEN 12 THEN cast(r.AnoReferencia as varchar) + ' - Dezembro'"
	sql = sql & " END AS referencia, f.dataLancamento, f.dataLancamentoFinal, "
	sql = sql & " CASE f.tipo_colaborador"
	sql = sql & " WHEN 'F' THEN 'Administrativo'"
	sql = sql & " WHEN 'P' THEN 'Professor'"
	sql = sql & " WHEN '1' THEN 'Professor'"
	sql = sql & " else 'Administrativo'"
	sql = sql & " END AS 'tipo',"
	sql = sql & " f.justificativa_abono"
	sql = sql & " from SRH_COLABORADOR_FREQUENCIA f"
	sql = sql & " inner join SRH_COLABORADOR c on c.codigo = f.cod_colaborador"
	sql = sql & " inner join SRH_JUSTIFICATIVAFALTAS j on j.codigo = f.Cod_JustificativaFaltas"
	sql = sql & " inner join SRH_MODULACAO_REFERENCIA r on r.codigo = f.codReferencia"
	sql = sql & " where f.situacao = 'S'"
	if Session("NivelPermissao") <> "A" then
	   sql = sql & " and C.CodLotacao	= " & session("CodEmpresa")
	else   
		if intCodEmpresaUsuario <> "0" and intCodEmpresaUsuario <> "" then
			sql = sql & " and C.CodLotacao = " & intCodEmpresaUsuario
		end if
	end if
	sql = sql & " and f.ano_letivo = " & strAnoLetivo
	if intCodColaborador <> "" then
		sql = sql & " and f.cod_colaborador = " &intCodColaborador
	end if
	if intCodJustificativaFaltas <> "0" then
		sql = sql & " and f.Cod_JustificativaFaltas = " &intCodJustificativaFaltas
	end if
	if intTipoColaborador <> "0" then
		if intTipoColaborador = "P" then
			sql = sql & " and f.tipo_colaborador in ('P','1') "
		else
			sql = sql & " and f.tipo_colaborador = '" &intTipoColaborador & "'"
		end if
	end if
	sql = sql & " order by c.nome, f.DataLancamento, f.DataLancamentoFinal	"
	strCorLinha = "bgcolor='#EAEAEA'"
	rs.open sql, cnn
	if not rs.eof then 
	   While not rs.eof 
	   		if rs("nome")<>strNome then
				strNome = rs("nome")
			else
				strNome = ""
			end if
			
			if rs("codFuncional")<>codFuncional then
				if strCorLinha = "bgcolor='#EAEAEA'" then
					strCorLinha = " bgcolor='#FFFFFF'"
				else
					strCorLinha = "bgcolor='#EAEAEA'"
				end if
			end if
  		    %> 
			<tr <%=strCorLinha%>>
                <td class="celula"><div align="center">&nbsp;<%=rs("codFuncional")%></div></td>
                <td class="celula">&nbsp;<%=strNome%></td>
                <td align="center"  class="celula">&nbsp;<%=rs("tipo")%></td>			
                <td align="left"  class="celula">&nbsp;<%=rs("referencia")%></td>			
                <td  class="celula"><div align="center"><%=formatadataAP(rs("dataLancamento"))%>&nbsp;-&nbsp;<%=formatadataAP(rs("dataLancamentoFinal"))%></div></td>
                <td  class="celula"><div align="left"><%=rs("tipo_falta")%>&nbsp;</div></td>
                <td  class="celula"><div align="left"><%=rs("justificativa_abono")%>&nbsp;</div></td>
			</tr>
		    <%	
			'quantidade de registros da p�gina
			if intQtdeRegistroPorPagina = 50 then
				' intPagina = intPagina + 1
				 'intQtdeRegistroPorPagina = 1
				 'fimTabela
				%>
				<!--pre></pre -->				
				<%			
				'mostraCabecalho
			end if	
			cont = cont + 1
			contColaboradorEmpresa = contColaboradorEmpresa + 1
			intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
			strNome = rs("nome")
			codFuncional = rs("codFuncional")
			rs.movenext
		wend
	else
		%>
		  <tr>
			<td colspan="37" class="celula" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
		  </tr>
		<%
	end if
	rs.close
%>
<tr>
<td colspan="37" class="celula" align="center"><div align="left">Total de Registros: <%=cont%> </div></td>
</tr>
</table>

<script>
	aguarde.style.display="none";
</script>
</body>
</html>
