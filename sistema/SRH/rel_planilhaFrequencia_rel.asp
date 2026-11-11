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
<title><%=session("Titulo")%> - Planilha de frequencia</title>
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
	dim UNIDADE
	
	strSituacao						= Trim(Request.Form("cmbSituacao"))	
	intCodColaborador				= Trim(Request("txtCodFuncionario"))
	strAnoLetivo					= Trim(Request("txtAnoLetivo"))
	intCodEmpresaUsuario 	    	= TRIM(Request.Form("cmbEmpresaGrupo"))
	intCodModulacaoReferencia		= Trim(Request("cmbModulacaoReferencia"))
	strOpcao						= Trim(Request("cmbOpcao"))
	strDataLancamento				= Trim(Request("txtDataLancamento"))
	strDataLancamentoFinal			= Trim(Request("txtDataLancamentoFinal"))
	intTipoColaborador				= Trim(Request("cmbTipoColaborador"))
	strSituacaoCurricular			= Trim(Request("cmbSituacaoCurricular"))
	if strSituacaoCurricular = "I" then strMsnSituacaoCurricular = " - Interdisciplinar"
	if strSituacaoCurricular = "D" then strMsnSituacaoCurricular = " - Disciplinar"
	
	strTituloRelatorio  	= "PLANILHA DE FREQUENCIA " & strMsnSituacaoCurricular & "<br> Período de " & FormataDataAP(strDataLancamento) & " - " & FormataDataAP(strDataLancamentoFinal)

	sub mostraCabecalho()
		%>
		<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
		
		<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
			<tr bgcolor="#CCCCCC">
				<td rowspan="2" width="5%"  class="celula"><div align="center"><strong>Matr&iacute;cula</strong></div></td>
				<td rowspan="2" width="20%" class="celula"><div align="center"><strong>Colaborador</strong></div></td>
				<td rowspan="2" width="20%" align="center" class="celula"><strong>Função</strong></td>
				<td rowspan="2" width="20%" align="center" class="celula"><strong>Cargo</strong></td>
				<td rowspan="2" width="5%"  align="center" class="celula"><strong>FNJ/Dias</strong></td>
				<td rowspan="2" width="5%" class="celula"><div align="center"><strong>Atest./Decl.</strong></div></td>
				<td colspan="3" class="celula" align="center"><strong>Substituições/Dias</strong></td>
				<td rowspan="2" width="15%" class="celula"><div align="center"><strong>Ocorrências</strong></div></td>
			</tr>
			<tr bgcolor="#CCCCCC">
				<td class="celula" align="center"><strong>Deficit</strong></td>
				<td class="celula" align="center"><strong>Apoio</strong></td>
				<td class="celula" align="center"><strong>LM</strong></td>
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
	
	sql = " select e.razaosocial as UNIDADE, c.codFuncional, c.nome as colaborador, ca.Desc_Cargo as cargo, fu.Desc_Funcao as funcao, fu.situacao_disciplinar, 'NAO_JUSTIFICADA' as tipo, count(*) as quantidade"
	sql = sql & " from [dbo].[SRH_COLABORADOR_FALTAS_DIARIA] d"
	sql = sql & " inner join [dbo].[SRH_COLABORADOR_FALTAS] f on f.codigo = d.cod_colaborador_faltas"
	sql = sql & " inner join SRH_COLABORADOR c on c.codigo = f.cod_colaborador"
	sql = sql & " inner join SEG_EMPRESA e on e.codigo = f.cod_empresa"
	sql = sql & " left join SRH_CARGOCOLABORADOR ca on ca.Cod_Cargo = c.codCargo"
	sql = sql & " left join SRH_FUNCAOCOLABORADOR fu on fu.Cod_Funcao = c.codFuncao"
	sql = sql & " where f.CodReferencia = " & intCodModulacaoReferencia
	if intCodColaborador <> "" then
		sql = sql & " and f.cod_colaborador = " & intCodColaborador
	end if
	if strSituacaoCurricular <> "" then
		sql = sql & " and fu.situacao_disciplinar = '" & strSituacaoCurricular & "'"
	end if
	if intCodEmpresaUsuario <> "0" then
		sql = sql & " and f.cod_empresa = " & intCodEmpresaUsuario
	end if
	sql = sql & " group by e.razaosocial, c.codFuncional, c.nome, ca.Desc_Cargo, fu.Desc_Funcao, fu.situacao_disciplinar"
	sql = sql & " union"
	sql = sql & " select e.razaosocial as UNIDADE, c.codFuncional, c.nome as colaborador, ca.Desc_Cargo as cargo, fu.Desc_Funcao as funcao, fu.situacao_disciplinar, 'JUSTIFICADA' as tipo, count(*) as quantidade"
	sql = sql & " from [dbo].[SRH_COLABORADOR_FREQUENCIA_FOLHA_DIARIA] d"
	sql = sql & " inner join [dbo].[SRH_COLABORADOR_FREQUENCIA_FOLHA] f on f.codigo = d.cod_colaborador_frequencia_folha"
	sql = sql & " inner join SRH_COLABORADOR c on c.codigo = f.cod_colaborador"
	sql = sql & " inner join SEG_EMPRESA e on e.codigo = f.cod_empresa"
	sql = sql & " left join SRH_CARGOCOLABORADOR ca on ca.Cod_Cargo = c.codCargo"
	sql = sql & " left join SRH_FUNCAOCOLABORADOR fu on fu.Cod_Funcao = c.codFuncao"
	sql = sql & " where f.CodReferencia = " & intCodModulacaoReferencia
	if intCodColaborador <> "" then
		sql = sql & " and f.cod_colaborador = " & intCodColaborador
	end if
	if strSituacaoCurricular <> "" then
		sql = sql & " and fu.situacao_disciplinar = '" & strSituacaoCurricular & "'"
	end if
	if intCodEmpresaUsuario <> "0" then
		sql = sql & " and f.cod_empresa = " & intCodEmpresaUsuario
	end if
	sql = sql & " group by e.razaosocial, c.codFuncional, c.nome, ca.Desc_Cargo, fu.Desc_Funcao, fu.situacao_disciplinar"
	sql = sql & " order by 1,2"
	response.write sql
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
			
			quant_nao_justificada = ""
			quant_justificada = ""
			if rs("tipo") = "JUSTIFICADA" then
				quant_nao_justificada = rs("quantidade")
			elseif rs("tipo") = "NAO_JUSTIFICADA" then
				quant_justificada = rs("quantidade")
			end if
			
			if UNIDADE <> RS("UNIDADE") THEN
			%> 
			<tr>
                <td class="celula" colspan="10"><div align="center"><strong><%=RS("UNIDADE")%></strong><div></td>
			</tr>
		    <%	
			end if
  		    %> 
			<tr <%=strCorLinha%>>
                <td  class="celula"><div align="center">&nbsp;<%=rs("codFuncional")%></div></td>
                <td  class="celula">&nbsp;<%=strNome%></td>
				<td  align="left"  class="celula">&nbsp;<%=rs("funcao")%></td>
                <td  align="left"  class="celula">&nbsp;<%=rs("cargo")%></td>			
				<td  align="center"  class="celula">&nbsp;<%=quant_nao_justificada%></td>			
				<td  align="center"  class="celula">&nbsp;<%=quant_justificada%></td>			
				<td  align="center"  class="celula">&nbsp;</td>			
				<td  align="center"  class="celula">&nbsp;</td>			
				<td  align="center"  class="celula">&nbsp;</td>			
                <td  class="celula"><div align="left">&nbsp;</div></td>
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
			UNIDADE = RS("UNIDADE")
			rs.movenext
		wend
	else
		%>
		  <tr>
			<td colspan="10" class="celula" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
		  </tr>
		<%
	end if
	rs.close
%>
<tr>
<td colspan="10" class="celula" align="center"><div align="left">Total de Registros: <%=cont%> </div></td>
</tr>
</table>

<script>
	aguarde.style.display="none";
</script>
</body>
</html>
