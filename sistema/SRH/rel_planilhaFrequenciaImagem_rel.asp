<%
response.Expires=0
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLU��ES WEB - www.rssolucoesweb.com.br"
	::	Data de Cria��o...: 03/09/2020
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Extrato de Notas
-->
<html>
<head>
<title><%=session("Titulo")%> - Planilha de frequencia (imagem)</title>
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
	
	strTituloRelatorio  	= "IMAGEM DE FREQUENCIA " & strMsnSituacaoCurricular & "<br> Período de " & FormataDataAP(strDataLancamento) & " - " & FormataDataAP(strDataLancamentoFinal)

	sub mostraCabecalho()
		%>
		<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
		
		<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
			
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
	sql = " SELECT C.codFuncional, C.nome AS COLABORADOR, I.imagem, E.RAZAOSOCIAL AS UNIDADE"
	sql = sql & " FROM SRH_COLABORADOR_FREQUENCIA_FOLHA_IMAGEM I"
	sql = sql & " INNER JOIN SRH_COLABORADOR_FREQUENCIA_FOLHA F ON F.CODIGO = I.cod_colaborador_frequencia_folha"
	sql = sql & " INNER JOIN SRH_COLABORADOR C ON C.CODIGO = F.COD_COLABORADOR"
	sql = sql & " left join SRH_FUNCAOCOLABORADOR fu on fu.Cod_Funcao = f.Cod_Funcao"
	sql = sql & " left join SEG_EMPRESA E on E.CODIGO = F.COD_EMPRESA"
	sql = sql & " where F.CodReferencia = " & intCodModulacaoReferencia
	if intCodColaborador <> "" then
		sql = sql & " and f.cod_colaborador = " & intCodColaborador
	end if
	if strSituacaoCurricular <> "" then
		sql = sql & " and fu.situacao_disciplinar = '" & strSituacaoCurricular & "'"
	end if
	if intCodEmpresaUsuario <> "0" then
		sql = sql & " and f.cod_empresa = " & intCodEmpresaUsuario
	end if
	sql = sql & " order by E.RAZAOSOCIAL, C.nome"
	
	rs.open sql, cnn
	if not rs.eof then 
	   While not rs.eof 
			if UNIDADE <> RS("UNIDADE") THEN
			%> 
			<tr>
                <td class="celula"><div align="center"><strong><%=RS("UNIDADE")%></strong><div></td>
			</tr>
		    <%	
			end if
  		    %> 
			<tr>
                <td  class="celula"><div align="center"><strong><%=rs("colaborador")%></strong></div></td>
			</tr>
			<tr>
                <td  class="celula"><div align="center">&nbsp;<%=rs("imagem")%></div></td>
			</tr>
		    <%	
			
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
			<td class="celula" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
		  </tr>
		<%
	end if
	rs.close
%>
<tr>
<td class="celula" align="center"><div align="left">Total de Registros: <%=cont%> </div></td>
</tr>
</table>

<script>
	aguarde.style.display="none";
</script>
</body>
</html>
