<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 11/05/2011 
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Relatorio de Locação e Remoção
-->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../estilo/Estilo_Impressao.css" rel="stylesheet" type="text/css">
<head>
<title><%=session("Titulo")%></title>
</head>
</head>
<body>
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_extenso.asp"-->
<!--#include file="../../includes/inc_formataData.asp"-->
<!--#include file="../../includes/inc_Botoes_relatorioPopap.asp"-->
<!--#include file="../../includes/inc_CabecalhoRelatorio.asp"-->
<script src="../../js/barraMovel.js"></script>
<script src="../../js/js_funcoes_gerais.js"></script>
<%
	intCodEmpresa				= Session("CodEmpresa")	
	intCodColaborador			= request.QueryString("CodColaborador")
	intCodLotacao				= request.QueryString("CodLotacao")
	intCodLotacaoAnterior		= request.QueryString("CodLotacaoAnterior")
	
	if intcodLotacaoAnterior <> intcodLotacao  then
		strTitulo = "REMOÇÃO"
	else
		strTitulo = "LOTAÇÃO"
	end if
	
	if intCodColaborador <> "" then
				
		' Dados Colaborador	
		sql = "SELECT  C.Nome, C.CodFuncional, C.DataLotacao, C.codLotacao, FC.desc_funcao, T.DESC_TURNO, N.DESC_FORMANOMEACAO "
		sql = sql & " FROM SRH_COLABORADOR C "
		sql = sql & " left join SRH_FUNCAOCOLABORADOR FC on FC.cod_funcao = C.codFuncao"
		sql = sql & " left join SRH_TURNO T on T.COD_TURNO = C.codTurno"
		sql = sql & " left join SRH_FORMANOMEACAOCOLABORADOR N on N.COD_FORMANOMEACAO = C.CodFormaNomeacao"
		sql = sql & " Where C.Codigo = " & intCodColaborador
		sql = sql & " And C.Cod_empresa = " & intCodEmpresa
		rsAux.open sql, cnn
		if rsAux.eof = false then
			
			strNome 				= Trim(rsAux("Nome"))
			intCodFuncional			= Trim(rsAux("CodFuncional"))
			strFuncao 	      		= TRIM(rsAux("desc_funcao"))
			strTurno				= TRIM(rsAux("DESC_TURNO"))
			strFormaNomeacao		= TRIM(rsAux("DESC_FORMANOMEACAO"))
			strDataLotacao			= formataDataAP(TRIM(rsAux("DataLotacao")))
		end if	
		rsAux.close
		
		' Dados de Lotacao
		sql = " select RAZAOSOCIAL"
		sql = sql & " FROM SEG_EMPRESA"
		sql = sql & " WHERE CODIGO = " & intCodLotacao
		rsAux.open sql, cnn
		if rsAux.eof = false then
			strLotacao = TRIM(rsAux("RAZAOSOCIAL"))
		end if	
		rsAux.close
		
		if intCodLotacaoAnterior <> "" then 
		
			' Dados de Lotacao Anterior
			sql = " select RAZAOSOCIAL"
			sql = sql & " FROM SEG_EMPRESA"
			sql = sql & " WHERE CODIGO = " & intcodLotacaoAnterior
			rsAux.open sql, cnn
			if rsAux.eof = false then
				strLotacaoAnterior = TRIM(rsAux("RAZAOSOCIAL"))
			end if	
			rsAux.close
		
		end if
		
	end if
	%>
		<br />
		<table width="98%"  align="center"class="textoRelatorio">
		  <tr> 
			<td colspan="3" align="center" class="textoRelatorio"></td>
		  </tr>
		  <tr>
		    <td colspan="3" align="center" class="textoRelatorio">&nbsp;</td>
	      </tr>
		  <tr>
			<td colspan="3" align="center" class="textoRelatorio"><p align="center"><strong><%=strTitulo%></strong></p></td>
		  </tr>
		  <tr>
		    <td colspan="3" align="center">&nbsp;</td>
	      </tr>
		  <tr>
		    <td width="68" height="22">DA:</td>
		    <td width="893" colspan="2"><strong><%=strLotacaoAnterior%></strong></td>
	      </tr>
		  <tr>
			<td height="23">PARA: </td>
			<td colspan="2"><strong><%=strLotacao%></strong></td>
		  </tr>
		  <tr>
		    <td colspan="3" align="right" class="textoRelatorio">&nbsp;</td>
	      </tr>
		  <tr> 
			<td colspan="3" align="right" class="textoRelatorio">&nbsp;</td>
		  </tr>
		  <tr>
			<td colspan="3" class="textoRelatorio">&nbsp;</td>
		  </tr>
		  <tr>
			<td colspan="3" class="textoRelatorio"><div align="justify">
			  <p>Estamos  encaminhando o(a) senhor(a): <strong><%=strNome%></strong>, matricula funcional n&ordm; <strong><%=intCodFuncional%></strong>,  na condi&ccedil;&atilde;o de&nbsp; <strong><%=strFormaNomeacao%></strong>, para que o(a) mesmo(a) possa  exercer a fun&ccedil;&atilde;o de <strong><%=strFuncao%></strong> no  turno <strong><%=strTurno%> </strong>, a partir  do dia <%=strDataLotacao%>.</p>
			</div>			</td>
		  </tr>
		  <tr>
			<td colspan="3" class="textoRelatorio">&nbsp;</td>
		  </tr>
		  <tr>
		    <td colspan="3" class="textoRelatorio">&nbsp;</td>
	      </tr>
		  <tr>
		    <td colspan="3" class="textoRelatorio">Atenciosamente,</td>
	      </tr>
		  <tr>
		    <td colspan="3" class="textoRelatorio">&nbsp;</td>
	      </tr>
		  <tr>
		    <td colspan="3" class="textoRelatorio">&nbsp;</td>
	      </tr>
		  <tr>
		    <td colspan="3" align="center" class="textoRelatorio">Aparecida de Goi&acirc;nia, <%=day(date)%> de <%=monthname(month(date))%> de <%=year(date)%></td>
	      </tr>
		  <tr>
		    <td colspan="3" class="textoRelatorio">&nbsp;</td>
	      </tr>
		  <tr>
		    <td colspan="3" class="textoRelatorio">&nbsp;</td>
	      </tr>
		  <tr>
		    <td colspan="3" align="center" class="textoRelatorio">___________________________________</td>
	      </tr>
		  <tr>
		    <td colspan="3" align="center" class="textoRelatorio"><strong>Ass.: Respons&aacute;vel pela lota&ccedil;&atilde;o</strong></td>
	      </tr>
		  <tr>
		    <td colspan="3" align="center" class="textoRelatorio">&nbsp;</td>
	      </tr>
		  <tr>
		    <td colspan="3" align="center" class="textoRelatorio">&nbsp;</td>
	      </tr>
		  <tr>
		    <td colspan="3" align="center" class="textoRelatorio">&nbsp;</td>
	      </tr>
		  <tr>
		    <td colspan="3" align="center" class="textoRelatorio">___________________________________</td>
	      </tr>
		  <tr>
		    <td colspan="3" align="center" class="textoRelatorio"><strong>Ass.: do Servidor </strong></td>
	      </tr>
		  <tr> 
			<td colspan="3" align="center" class="textoRelatorio">&nbsp;</td>
		  </tr>
		  <tr>
		    <td colspan="3" class="textoRelatorio">&nbsp;</td>
	      </tr>
		  <tr>
		    <td colspan="3" class="textoRelatorio">&nbsp;</td>
	      </tr>
		</table>
		<pre> </pre>
</body>
</html>