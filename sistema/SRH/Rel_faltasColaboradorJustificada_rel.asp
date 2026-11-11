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
<title><%=session("Titulo")%> - Faltas</title>
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
	
	strSituacao						= Trim(Request.Form("cmbSituacao"))	
	intCodColaborador				= Trim(Request("txtCodFuncionario"))
	strAnoLetivo					= Trim(Request("txtAnoLetivo"))
	intCodEmpresaUsuario 	    	= TRIM(Request.Form("cmbEmpresaGrupo"))
	intCodModulacaoReferencia		= Trim(Request("cmbModulacaoReferencia"))
	strOpcao						= Trim(Request("cmbOpcao"))
	strDataLancamento				= Trim(Request("txtDataLancamento"))
	strDataLancamentoFinal			= Trim(Request("txtDataLancamentoFinal"))
	intTipoColaborador				= Trim(Request("cmbTipoColaborador"))
	
	strTituloRelatorio  	= "Relatório de Faltas Justificadas <br> Período de " & FormataDataAP(strDataLancamento) & " - " & FormataDataAP(strDataLancamentoFinal)

	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
        <tr bgcolor="#CCCCCC">
            <td width="5%" class="celula"><div align="center"><strong>Matr&iacute;cula</strong></div></td>
            <td width="23%" class="celula"><div align="center"><strong>Colaborador</strong></div></td>
			<td width="20%" align="center" class="celula"><strong>Função</strong></td>
            <td width="8%" align="center" class="celula"><strong>Tipo de Falta</strong></td>
            <td width="14%" class="celula"><div align="center"><strong>Per&iacute;odo</strong></div></td>
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
	
	sql = " select c.codFuncional, c.nome as colaborador, j.Descricao as tipo, f.DataLancamento, f.DataLancamentoFinal, fu.Desc_Funcao as funcao, f.justificativa"
	sql = sql & " from SRH_COLABORADOR_Justificativa f"
	sql = sql & " inner join SRH_COLABORADOR c on c.codigo = f.cod_colaborador"
	sql = sql & " inner join SRH_JUSTIFICATIVAFALTAS j on j.Codigo = f.Cod_JustificativaFaltas"
	sql = sql & " inner join SRH_FUNCAOCOLABORADOR fu on fu.Cod_Funcao = f.cod_funcao"
	sql = sql & " where CodReferencia = " & intCodModulacaoReferencia
	if intCodEmpresaUsuario <> "0" then
		sql = sql & " and f.cod_empresa = " & intCodEmpresaUsuario
	end if
	if intCodColaborador <> "" then
		sql = sql & " and f.cod_colaborador = " & intCodColaborador
	end if

	if intTipoColaborador <> "0" then
		if intTipoColaborador = "P" then
			sql = sql & " and f.tipo_colaborador in ('P','1') "
		else
			sql = sql & " and f.tipo_colaborador = '" &intTipoColaborador & "'"
		end if
	end if
	
	sql = sql & " order by c.nome, f.DataLancamento, f.DataLancamentoFinal"
	strCorLinha = "bgcolor='#EAEAEA'"
	rs.open sql, cnn
	if not rs.eof then 
	   While not rs.eof 
	   		if rs("colaborador")<>strNome then
				strNome = rs("colaborador")
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
				<td align="left"  class="celula">&nbsp;<%=rs("funcao")%></td>
                <td align="center"  class="celula">&nbsp;<%=rs("tipo")%></td>			
                <td  class="celula"><div align="center"><%=formatadataAP(rs("dataLancamento"))%>&nbsp;-&nbsp;<%=formatadataAP(rs("dataLancamentoFinal"))%></div></td>
                <td  class="celula"><div align="left"><%=rs("justificativa")%>&nbsp;</div></td>
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
			strNome 		= rs("colaborador")
			codFuncional 	= rs("codFuncional")
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
