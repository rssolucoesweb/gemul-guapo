<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<html>
<head>
<title><%=session("Titulo")%></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script></head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_Botoes_relatorio.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<br>
<%
	dim intPagina
	
    strTituloRelatorio  			= "Relatório Unidades"
	
	intCodTipoEmpresa				= Trim(Request("cmbTipoEmpresa"))
	if intCodTipoEmpresa = "" then intCodTipoEmpresa = "0"
	pagina							= "Rel_Unidades_con.asp"

	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
	    <td width="4%" class="celula"><strong>CNPJ</strong></td>
		<td width="15%" height="19" class="celula"><strong>Unidade</strong></td>
		<td width="10%" class="celula"><strong>Diretor(a)</strong></td>
		<td width="6%" class="celula"><strong>Email</strong></td>
		<td width="14%" class="celula"><strong>Secretário(a)</strong></td>
		<td width="7%" class="celula"><strong>Email</strong></td>
		<td width="7%" class="celula"><strong>Endereço</strong></td>
		<td width="9%" class="celula"><strong>Bairro</strong></td>
		<td width="5%" class="celula"><strong>Cep</strong></td>
		<td width="6%" class="celula"><strong>Telefone</strong></td>
		<td width="8%" align="center" class="celula"><strong>Email Unidade</strong></td>
		<td width="9%" class="celula"><strong>Contato</strong></td>
	  </tr>
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub
	intPagina = 1
	
	sql = "select cnpj, razaosocial, diretor, SECRETARIA, endereco, bairro, cep, telefone, EMAIL_DIRETORIA, email, EMAIL_FINANCEIRO as email_secretaria, email_diretoria, CONTATO from seg_empresa"
	sql = sql & " where cod_grupo="&SESSION("CODGRUPO")&" and BLOQUEIO='N'"
	if intCodTipoEmpresa <> "0" then
		sql = sql & " And CodTipoEmpresa = "  & intCodTipoEmpresa
	end if

	sql = sql & " order by RAZAOSOCIAL"

    rs.open sql, cnn
	if not rs.eof then 
	   
	   mostraCabecalho
	   
	   TotalAulas = "0"
	   cont = "0"
				
	   While not rs.eof
	   	 cont = cont + 1	
		
		
	      %>
		  <tr  bgcolor="<%=cor%>" >
            <td class="celula" align="left">&nbsp;<%=trim(rs("CNPJ"))%></td>
              <td class="celula" align="left">&nbsp;<%=trim(rs("RAZAOSOCIAL"))%></td>
              <td class="celula" align="left">&nbsp;<%=trim(rs("DIRETOR"))%></td>
              <td align="left" class="celula">&nbsp;<%=trim(rs("EMAIL_DIRETORIA"))%></td>
              <td align="left" class="celula">&nbsp;<%=trim(rs("SECRETARIA"))%></td>
              <td align="left" class="celula">&nbsp;<%=trim(rs("EMAIL_SECRETARIA"))%></td>
              <td align="left" class="celula">&nbsp;<%=trim(rs("ENDERECO"))%></td>
              <td align="left" class="celula">&nbsp;<%=trim(rs("BAIRRO"))%></td>
              <td class="celula" align="left">&nbsp;<%=trim(rs("CEP"))%></td>
              <td class="celula" align="center">&nbsp;<%=trim(rs("TELEFONE"))%></td>
              <td align="left" class="celula">&nbsp;<%=trim(rs("EMAIL"))%></td>
            <td align="left" class="celula">&nbsp;<%=trim(rs("CONTATO"))%></td>
	  	  </tr>
		  <%
	 	  'quantidade de registros da página
		  if int(intQtdeRegistroPorPagina) = int(strlpp) - 1 then
			 intPagina = intPagina + 1
			 intQtdeRegistroPorPagina = 1
			 fimTabela
			 %>
			 <pre></pre>				
		 	 <%			
			 mostraCabecalho
	 	  end if	
		 ' cont = cont + 1
		  intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
		  Total_Aulas = Total_Aulas + intTAulas
		  rs.movenext
	   wend
	   %>

	   <tr>
	   <td colspan="16" bgcolor="#CCCCCC" class="celula">Total Registros :<%=cont%></td>
      </tr>
	   <%
	else
		%>
		  <tr>
			<td height="12" colspan="16" align="center" class="celula"><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
	  </tr>
		<%
		
	end if
	rs.close
%>
</table>
<br>
<script>
	aguarde.style.display="none";
</script>
</body>
</html>
