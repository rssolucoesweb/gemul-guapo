<!--
	::	IMOB
	::	Data de Criação...: 15/05/2009
	::	Desenvolvedores...: Sérgio Borges - sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: Consulta os dados de usuarios cadastrados para acesso ao sistema::	Data Atualizacao..: 
	::	Motivo Atualizacao: 
-->
<html>
<head>
<link href="../../../estilo/css.css" rel="stylesheet" type="text/css">
<title>Consulta Usuários</title>
<script src="../../../js/js_funcoes_gerais.js"></script>
<script>
	function resultadoConsulta(strCPF){
		window.opener.frm.txtCPF.value=strCPF;
		window.opener.frm.submit();
		window.close();
	}
	
</script>
</head>
<body   topmargin="0" leftmargin="0">
<%
'as paginas do menu administrativo não vão validar o ano letivo
bolPaginaAnoLetivo 	= "N"
'as paginas do menu administrativo não vão validar a unidade de ensino
strValidaUnidadeEnsino = "N"
%>
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_formataCPF.asp"-->
 
<form method="POST" id="frm" action="#">
<div class="TituloFormulario" align="center">Consulta Usuários</div>
<br>

<table width="90%" align="center" class="formulario">
	<tr>
		<td>
<%  
   strCPF 		= request.form("txtCPF")
   strNome 		= request.form("txtNome")
%>
 
<table width="100%" border="0">
          <tr> 
            <td width="221">CPF</td>
            <td width="750"><input name="txtCPF" type="text" id="txtCPF" onBlur="return validaCPF(this)" onKeyPress="return formataCampo(this, 5, 14)" class="caixaTexto" size="15" maxlength="15" value="<%=formataCPFAP(strCPF)%>"></td>
          </tr>
          <tr> 
            <td width="221">Nome do usu&aacute;rio</td>
            <td width="750"><input name="txtNome" type="text" id="txtNome" class="caixaTexto" size="40" maxlength="50"  onKeyPress="return formataCampo(this, 1, 50)"  value="<%=strNome%>"></td>
          </tr>
          <tr> 
            <td colspan="2"><hr size="1" color="#CCCCCC"></td>
          </tr>
          <tr> 
            <td colspan="2">		<!--#include file="../../../includes/inc_botoes_consulta.asp"--> </td>
          </tr>
        </table>
<%
		sql = " select _u.cpf, _u.nome, _u.situacao, case when _d.codigo is null then 'Não' else 'Sim' end  as lotacao"
		sql = sql & " from SEG_usuarios _u"
		sql = sql & " inner join SEG_usuarios_acesso _a on _a.cpf_SEG_usuarios = _u.cpf"
		sql = sql & " left  join EST_DEPARTAMENTO _d on _d.codigo = _u.codDepartamento "
		sql = sql & " where _a.codEmpresa = " & session("codEmpresa") 
		sql = sql & " and _a.cpf_SEG_usuarios not in (select cpf_SEG_usuarios from SEG_usuarios_acesso_master)"
		if strCPF <> "" then
			sql = sql & " and _u.cpf = " & formataCpfBD(strCPF)
		end if
		if strNome <> "" then
			sql = sql & " and _u.nome LIKE '%" & strNome & "%' COLLATE SQL_Latin1_General_CP1_CI_AI "
		end if 
		sql=sql & " order by _u.nome"
		rs.open sql, cnn
	%>
		<br>
	  <table width = "98%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
		<TR bgcolor="#E5E5E5">
				<td width="17%" class="celula"><strong>CPF</strong></td>
				<td width="60%" class="celula"><strong>Nome </strong></td>
				<td width="10%" align="center" class="celula"><strong>Lota&ccedil;&atilde;o</strong></td>
				<td width="10%" align="center" class="celula"><strong>Situa&ccedil;&atilde;o </strong></td>
			</tr>
	<%	
			
		if rs.eof = false then
		
			while not rs.eof
				cont = cont + 1
				situacao = "Inativo"
				if trim(rs("situacao"))="A" then
					situacao = "<b>Ativo</b>"
				end if
				%>
				  <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("cpf")%>')">
					<td class="celula"><%=formataCpfAP(rs("cpf"))%></td>
					<td class="celula"><%=rs("nome")%></td>
					<td align="center" class="celula"><%=rs("lotacao")%>&nbsp;</td>
					<td align="center" class="celula"><%=situacao%></td>
				  </tr>
				  <%				
				rs.movenext
			wend
			%>
			<tr><td class="celula" colspan="5">Total Registros : <%=cont%></td></tr>
			<%
		else
			%>
			<tr><td class="celula" colspan="5" align="center"><%=session("strMensagemNaoEncontrado")%></td></tr>
			<%
		end if
	rs.close
	%>
	</table>	  

</td>
</tr>
</table>
</form>
</body>
</html>