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
	if intCodColaborador = "" then intCodColaborador = "0"
	strAnoLetivo					= Trim(Request("txtAnoLetivo"))
	intCodEmpresaUsuario 	    	= TRIM(Request.Form("cmbEmpresaGrupo"))
	intCodModulacaoReferencia		= Trim(Request("cmbModulacaoReferencia"))
	strOpcao						= Trim(Request("cmbOpcao"))
	strDataLancamento				= Trim(Request("txtDataLancamento"))
	strDataLancamentoFinal			= Trim(Request("txtDataLancamentoFinal"))
	intTipoColaborador				= Trim(Request("cmbTipoColaborador"))
	strSituacaoCurricular			= Trim(Request("cmbSituacaoCurricular"))
	
	strTituloRelatorio  	= "PLANILHA DE FREQUENCIA - ADMINISTRATIVOS<br> Período de " & FormataDataAP(strDataLancamento) & " - " & FormataDataAP(strDataLancamentoFinal)

	sub mostraCabecalho()
		%>
		<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
		
		<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
			<tr bgcolor="#CCCCCC">
				<td rowspan="2" width="5%"  class="celula"><div align="center"><strong>Matr&iacute;cula</strong></div></td>
				<td rowspan="2" width="20%" class="celula"><div align="center"><strong>Colaborador</strong></div></td>
				<td rowspan="2" width="1%" align="center" class="celula"><strong>Turno</strong></td>
				<td rowspan="2" width="20%" align="center" class="celula"><strong>Função</strong></td>
				<td rowspan="2" width="20%" align="center" class="celula"><strong>Cargo</strong></td>
				<td rowspan="2" width="5%"  align="center" class="celula"><strong>Dia</strong></td>
				<td rowspan="2" width="5%"  align="center" class="celula"><strong>Falta</strong></td>
				<td rowspan="2" width="5%" class="celula"><div align="center"><strong>Atest./Decl.</strong></div></td>
				<td colspan="2" class="celula" align="center"><strong>Substituições/Dias</strong></td>
				<td rowspan="2" width="15%" class="celula"><div align="center"><strong>Ocorrências</strong></div></td>
			</tr>
			<tr bgcolor="#CCCCCC">
				<td class="celula" align="center"><strong>Deficit</strong></td>
				<td class="celula" align="center"><strong>Subst.</strong></td>
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
	
	
	sql = " execute [dbo].[SP_rel_frequencias_administrativos] " & session("codGrupo") & "," & intCodEmpresaUsuario & "," & intCodColaborador & "," & intCodModulacaoReferencia & ""
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
			
			if UNIDADE <> RS("empresa") THEN
				%> 
				<tr>
					<td class="celula" colspan="11"><div align="center"><strong><%=RS("empresa")%></strong><div></td>
				</tr>
				<%	
			end if
  		    %> 
			<tr <%=strCorLinha%>>
                <td  class="celula"><div align="center">&nbsp;<%=rs("codFuncional")%></div></td>
                <td  class="celula">&nbsp;<%=strNome%></td>
				<td  align="center"  class="celula"><%=rs("turno")%></td>
				<td  align="left"  class="celula"><%=rs("funcao")%></td>
                <td  align="left"  class="celula"><%=rs("cargo")%></td>			
				<td  align="center"  class="celula"><%if rs("dia")="0" then%>&nbsp;<%else%><%=rs("dia")%><%end if%></td>			
				<td  align="center"  class="celula"><%if rs("faltas")="0" then%>&nbsp;<%else%><%=rs("faltas")%><%end if%></td>
				<td  align="center"  class="celula">&nbsp;</td>				
				<td  align="center"  class="celula"><%if rs("deficit")="0" then%>&nbsp;<%else%><%=rs("deficit")%><%end if%></td>			
				<td  align="center"  class="celula"><%if rs("substituicao")="0" then%>&nbsp;<%else%><%=rs("substituicao")%><%end if%></td>			
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
			strNome 		= rs("nome")
			codFuncional 	= rs("codFuncional")
			UNIDADE = RS("empresa")
			rs.movenext
		wend
	else
		%>
		  <tr>
			<td colspan="11" class="celula" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
		  </tr>
		<%
	end if
	rs.close
%>
<tr>
<td colspan="11" class="celula" align="center"><div align="left">Total de Registros: <%=cont%> </div></td>
</tr>
</table>

<script>
	aguarde.style.display="none";
</script>
</body>
</html>
