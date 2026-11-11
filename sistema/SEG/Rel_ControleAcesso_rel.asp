<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 19/06/2012
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
    ::	Desenvolvedores...: Relatorio Controle de Acesso
-->
<html>
<head>
<title><%=session("Titulo")%> - Alunos</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script>
</head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<!--#include file="../includes/inc_sqlCodigoEmpresaUsuario.asp"-->
<br>
<%
	dim intPagina
		
	intCodEmpresaUsuario	 	= request.Form("cmdEmpresaUsuario")
	intCodUsuario               = request.Form("cmbUsuario")
	strTituloRelatorio  		= "Controle de Acesso"

	sub mostraCabecalho()
		%>
		<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
		<br>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
<tr bgcolor="#CCCCCC">
                <td class="celula"><strong>Nome Usuario</strong></td>
                <td class="celula"><strong>Login</strong></td>
                <td class="celula"><strong>Situa&ccedil;&atilde;o </strong></td>
                <td class="celula"><strong>Data do &uacute;ltimo login</strong></td>
                <td class="celula"><strong>Gestor</strong></td>
        	</tr>
		<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	mostraCabecalho
	cont = 0
	
	sql = " Select US.USUA_NOME_COMPLETO, US.USUA_CODG, US.USUA_DATA_HORA_ULT_LOGON_WEB, US.Usua_Stat,"
	sql = sql & " UE.NIVEL_PERMISSAO as Gestor"
	sql = sql & "  From SEG_Usuarios_Sistema US"
	sql = sql & " inner join SEG_USUARIOS_EMPRESA UE on UE.CODIGO_SEG_USUARIOS_SISTEMA = US.USUA_CODG"
	sql = sql & " Where US.COD_EMPRESA = " & intCodEmpresaUsuario
	
	if intCodUsuario <> "0" then
		sql = sql & " And US.USUA_CODG = '" & intCodUsuario & "'"
	end if
	
	sql = sql & " Order by US.USUA_NOME_COMPLETO"
	
	rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof
		
			if trim(Gestor) = "" then
				strGestor = "Não"
			else
				strGestor = "Sim"
			end if
			%>
            <tr>
                <td class="celula"><%=rs("USUA_NOME_COMPLETO")%>&nbsp;</td>
                <td class="celula"><%=rs("USUA_CODG")%>&nbsp;</td>
                <td class="celula"><%=rs("Usua_Stat")%>&nbsp;</td>
                <td class="celula"><%=rs("USUA_DATA_HORA_ULT_LOGON_WEB")%>&nbsp;</td>
                <td class="celula"><%=strGestor%>&nbsp;</td>
            </tr>
			<%
			'quantidade de registros da página
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
			intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
			rs.movenext
		wend
		%>
          <tr bgcolor="#CCCCCC">
			<td colspan="6" class="celula">Quantidade Execuções: <%=cont%></td>
		  </tr>
		 <%
		else
		%>
		  <tr>
			<td colspan="6" class="celula" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
		  </tr>
		<%
	end if
	rs.close
%>
</table>
<script>
	aguarde.style.display="none";
</script>
</body>
</html>