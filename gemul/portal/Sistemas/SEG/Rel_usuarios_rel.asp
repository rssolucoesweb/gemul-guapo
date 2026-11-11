<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
strPaginaDestino = ""
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/02/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Estoque minimo
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link type="text/css" rel="stylesheet" href="../../../Estilo/Estilo_Impressao.css">
<script src="../../../js/js_funcoes_gerais.js"></script>
<script src="../../../js/js_barra_movel.js"></script>
</head>
<body>
<!--#include file="../../../includes/inc_verificaSession.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_formatadata.asp"-->
<!--#include file="../../../includes/inc_formataCPF.asp"-->
<!--#include file="../../../includes/inc_Botoes_relatorio.asp"-->
<!--#include file="../../../includes/inc_aguarde.asp"-->
<br>
<%
	session("strMensagemRelatorioNaoEncontrado") = "Nenhum registro encontrado."
	ordem = request("ordem")
	dim intPagina
	strTituloRelatorio  	= "Usuários Ativos"

	sub mostraCabecalho()
	%>
	<!--#include file="../../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="90%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
      <tr bgcolor="#E5E5E5">
        <td width="20%" align="center" class="celula"><strong>Usuário</strong></td>
        <td width="10%" align="center" class="celula"><strong>CPF</strong></td>
        <td width="10%" align="center" class="celula"><strong>Telefone</strong></td>
        <td width="15%" align="center" class="celula"><strong>Email</strong></td>
		<td width="25%" align="center" class="celula"><strong>Lotação</strong></td>
        <td width="10%" align="center" class="celula"><p><strong>Último acesso</strong></p></td>
      </tr>
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub
%>
<%
	intPagina = 1
	intQtdeRegistroPorPagina = 50
	mostraCabecalho
	cont = 0
	intQuantRegistroImpresso = 0
	
	sql = "select distinct u.cpf, u.nome, u.telefone, u.email, u.data_ultimo_acesso, d.DESCRICAO as lotacao"
	sql = sql & " from seg_usuarios u"
	sql = sql & " left join EST_DEPARTAMENTO d on d.codigo = u.codDepartamento"
	sql = sql & " where u.situacao = 'A' and (d.cod_empresa = " & session("codEmpresa")	& " or d.cod_empresa is null)"
	sql = sql & " and u.cpf not in ('88426920187','56600054115','76143139172','28292669191')"
	if ordem = "1" then
		sql = sql & " order by u.nome"
	elseif ordem = "2" then
		sql = sql & " order by d.DESCRICAO, u.nome"
	else
		sql = sql & " order by u.nome"
	end if
	rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof
			%>
                 <tr>
                    <td class="celula"><%=trim(rs("nome"))%>&nbsp;</td>
                    <td class="celula"><%=formataCPFap(trim(rs("cpf")))%>&nbsp;</td> 
                    <td class="celula" align="left"><%=trim(rs("telefone"))%>&nbsp;</td>
					<td class="celula" align="left"><%=trim(rs("email"))%>&nbsp;</td>
                    <td class="celula" align="left"><%=trim(rs("lotacao"))%>&nbsp;</td>
                    <td class="celula" align="left"><%=trim(rs("data_ultimo_acesso"))%>&nbsp;</td> 
                  </tr>
			<%
			intQuantRegistroImpresso = intQuantRegistroImpresso + 1
			'quantidade de registros da página
			if int(intQtdeRegistroPorPagina) =< int(intQuantRegistroImpresso) then
				 intPagina = intPagina + 1
				 intQuantRegistroImpresso = 0
				 fimTabela
				%>
				<pre>&nbsp;</pre>				
				<%			
				mostraCabecalho
			end if	
			cont = cont + 1
			rs.movenext
		wend
		%>
		  <tr>
			<td colspan="6" class="celula"><strong>Usuários ativos cadastrados: <%=cont%></strong></td>
		  </tr>
		 <%
	else
		%>
		  <tr>
			<td colspan="6" class="celula" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font><br><br><br><br></td>
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