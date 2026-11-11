<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
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
<!--include file="../../includes/inc_Botoes_relatorio.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<!--#include file="../includes/inc_sqlCodigoEmpresaUsuario.asp"-->
<br>
<%
	dim intPagina
		
	intCodGrupo					= session("CodGrupo")
	strTituloRelatorio  		= "Usuários"
	intCodOrdem 				= request.Form("cmbOrdem")

	sub mostraCabecalho()
		%>
		<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
		<br>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
<tr bgcolor="#CCCCCC">
                <td width="41%" height="19" class="celula"><strong>Nome Usuario</strong></td>
                <td width="24%" class="celula"><strong>Login</strong></td>
                <td width="35%" class="celula"><strong>Unidade </strong></td>
  </tr>
		<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	mostraCabecalho
	cont = 0
	
	sql = " SELECT C.Codigo, C.cod_empresa, C.nome, E.RAZAOSOCIAL, us.USUA_CODG "
	sql = sql & " FROM SRH_COLABORADOR C"
	sql = sql & " INNER JOIN SEG_EMPRESA E ON e.CODIGO = c.cod_empresa"
	sql = sql & " INNER JOIN SEG_USUARIOS_SISTEMA US ON US.USUA_CODG = C.codigo_SEG_USUARIOS_SISTEMA"
	sql = sql & " WHERE E.COD_GRUPO = " & intCodGrupo

	if intCodOrdem = 1 then
		sql = sql & " ORDER BY C.nome "
	end if
	
	if intCodOrdem = 2 then
		sql = sql & " ORDER BY us.USUA_CODG "
	end if
	
	if intCodOrdem = 3 then
		sql = sql & " ORDER BY RAZAOSOCIAL "
	end if
	
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
                <td class="celula"><%=rs("nome")%>&nbsp;</td>
                <td class="celula"><%=rs("USUA_CODG")%>&nbsp;</td>
                <td class="celula"><%=rs("RAZAOSOCIAL")%>&nbsp;&nbsp;&nbsp;</td>
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
			<td colspan="4" class="celula">Quantidade Execuções: <%=cont%></td>
		  </tr>
		 <%
		else
		%>
		  <tr>
			<td height="12" colspan="4" align="center" class="celula"><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
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