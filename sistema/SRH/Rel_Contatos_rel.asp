<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 03/03/2009
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: feriados
-->
<html>
<head>
<title><%=session("Titulo")%> - Alunos Por Turma</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
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
<br>
<%
	dim intPagina
	
	
	strTituloRelatorio  	= "Contatos Municipais"

	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table align="center" width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
		<td width="10%" class="celula"><div align="center"><strong>Cnpj</strong> </div></td>
		<td width="14%" class="celula"><strong>Raz&atilde;o Social</strong></td>
		<td width="12%" class="celula"><strong>Munic&iacute;pio</strong></td>
		<td width="15%" class="celula"><div align="center"><strong>Endere&ccedil;o </strong> </div></td>
	    <td width="11%" class="celula"><strong>Email</strong></td>
	    <td width="8%" class="celula"><strong>Telefone</strong></td>
	    <td width="30%" class="celula"><div align="center"><strong>Gestores Municipais</strong></div></td>
	  </tr>
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	mostraCabecalho
	intQtdeRegistroPorPagina = 0
	
	sql = "select *"
	sql = sql & " from SRH_CONTATOPREFEITURAS"
	sql = sql & " where cod_empresa = " &  session("CodEmpresa")
	sql = sql & " order by RAZAOSOCIAL "
	rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof
			%>
			<tr> 
			  <td align="left" class="celula"><strong><%=rs("CNPJ")%></strong>&nbsp;</td>
			  <td align="left" class="celula"><strong><%=Ucase(rs("RAZAOSOCIAL"))%></strong>&nbsp;</td>
			  <td align="left" class="celula"><strong><%=Ucase(rs("CIDADE"))%>-<%=Ucase(rs("UF"))%>&nbsp;</strong></td>
			  <td align="left" class="celula"><strong><%=Ucase(rs("LOGRADOURO"))%>,<%=Ucase(rs("NUMERO_ENDERECO"))%>,<%=Ucase(rs("COMP_ENDERECO"))%>&nbsp;</strong></td>
			  <td align="left" class="celula"><strong><%=Ucase(rs("CIDADE"))%>&nbsp;</strong></td>
			  <td align="left" class="celula"><strong><%=rs("TELEFONE")%>&nbsp;</strong></td>
			  <td align="left" class="celula"><strong>Prefeito:</strong>&nbsp;<%=Ucase(rs("Prefeito"))%>&nbsp;<br><strong>Telefone:</strong>&nbsp;<%=Ucase(rs("Telefone_Prefeito"))%>&nbsp;<br><strong>Email:</strong>&nbsp;<%=Ucase(rs("Email_Prefeito"))%>&nbsp;<br><br>
			  <strong>Vice:</strong>&nbsp;<%=Ucase(rs("VicePrefeito"))%>&nbsp;<br><strong>Telefone:</strong>&nbsp;<%=Ucase(rs("Telefone_VicePrefeito"))%>&nbsp;<br><strong>Email:</strong>&nbsp;<%=Ucase(rs("Email_VicePrefeito"))%>&nbsp;<br><br>
			  <strong>1ª Dama ou 1º Cavalheiro:</strong>&nbsp;<%=Ucase(rs("PrimeiraDama"))%>&nbsp;<br><strong>Telefone:</strong>&nbsp;<%=Ucase(rs("Telefone_PrimeiraDama"))%>&nbsp;<br><strong>Email:</strong>&nbsp;<%=Ucase(rs("Email_PrimeiraDama"))%>&nbsp;<br><br>
			  <strong>Secretário Administração:</strong>&nbsp;<%=Ucase(rs("SecretarioAdministracao"))%>&nbsp;<br><strong>Telefone:</strong>&nbsp;<%=Ucase(rs("Telefone_SecretarioAdm"))%>&nbsp;<br><strong>Email:</strong>&nbsp;<%=Ucase(rs("Email_SecretarioAdm"))%>&nbsp;<br><br>
			  <strong>Secretário Educação:</strong>&nbsp;<%=Ucase(rs("SecretarioEducacao"))%>&nbsp;<br><strong>Telefone:</strong>&nbsp;<%=Ucase(rs("Telefone_SecretarioEduc"))%>&nbsp;<br><strong>Email:</strong>&nbsp;<%=Ucase(rs("Email_SecretarioEduc"))%>&nbsp;<br></td>
			</tr>
			<%			
			'quantidade de registros da página
			if intQtdeRegistroPorPagina = 5 then
				 intPagina = intPagina + 1
				 intQtdeRegistroPorPagina = 1
				 fimTabela
				%>
				<pre></pre>				
				<%			
				mostraCabecalho
			end if	
			intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
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
</table>
<script>
	aguarde.style.display="none";
</script>
</body>
</html>
