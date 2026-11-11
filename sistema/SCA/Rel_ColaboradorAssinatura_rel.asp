<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/02/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Extrato de Notas
-->
<html>
<head>
<title><%=session("Titulo")%> - Grade Curricular</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
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
<%
	dim intPagina
	dim strInfoTurma
	
	strSituacao					= Trim(Request.Form("cmbSituacao"))	
	intCodEmpresaUsuario 	    = Session("CodEmpresa")
	strTituloRelatorio  		= "Relação de Colaboradores - Assinaturas"

	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
	  <tr bgcolor="#CCCCCC">
	    <td width="5%" height="19" class="celula"><strong>Matricula </strong></td>
        <td width="32%" class="celula"><strong>Colaborador</strong></td>
	    <td width="20%" class="celula"><strong>Fun&ccedil;&atilde;o</strong></td>
		<td width="7%" class="celula"><strong>Turno</strong></td>
       
	    <td width="36%" class="celula"><strong>Assinatura</strong></td>
	  </tr>
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	mostraCabecalho
	cont = 0

	
	sql = "SELECT C.COD_EMPRESA,  C.CODLOTACAO, C.CODIGO, C.NOME, C.CodFuncional, CC.DESC_CARGO AS CARGO, FC.DESC_FUNCAO AS FUNCAO, TU.DESC_TURNO"
	sql = sql & " FROM SRH_COLABORADOR C "
	sql = sql & " LEFT JOIN SRH_CARGOCOLABORADOR CC ON CC.COD_CARGO = C.CODCARGO "
	sql = sql & " LEFT JOIN SRH_FUNCAOCOLABORADOR FC ON FC.COD_FUNCAO = C.CODFUNCAO "
	sql = sql & " LEFT JOIN SRH_TURNO TU ON TU.COD_TURNO = C.CodTurno "
	sql = sql & " WHERE C.CODLOTACAO = " & intCodEmpresaUsuario
	sql = sql & " AND C.codFormaNomeacao = 261 " 'CONCURSADO
	
	if strSituacao <> "" and strSituacao <> "0" then
       sql = sql & " AND C.SITUACAO	= '" & strSituacao & "'"
	end if 
	
   	sql = sql & " ORDER BY nome "

	rs.open sql, cnn
	if not rs.eof then 
	
	   While not rs.eof 
	       
  		    %> 
			<tr>
			<td height="29" class="celula"><div align="center">&nbsp;<%=rs("CodFuncional")%></div></td>
            <td class="celula">&nbsp;<%=rs("Nome")%></td>
			<td  class="celula">&nbsp;<%=rs("Funcao")%></td>
			<td  class="celula">&nbsp;<%=rs("DESC_TURNO")%></td>
			<td align="center"  class="celula">&nbsp;</td>
	  </tr> 
		    <%	
			'quantidade de registros da página
			if intQtdeRegistroPorPagina = 28 then
				 intPagina = intPagina + 1
				 intQtdeRegistroPorPagina = 1
				 fimTabela
				 response.write "<pre> </pre>"
				mostraCabecalho
			end if	
			cont = cont + 1
			intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
			rs.movenext
		wend
	end if
	rs.close
%>
<tr>
<td colspan="36" class="celula" align="center"><div align="left">Total de Registros: <%=cont%> </div></td>
</tr>
</table>
<script>
	aguarde.style.display="none";
</script>
</body>
</html>
