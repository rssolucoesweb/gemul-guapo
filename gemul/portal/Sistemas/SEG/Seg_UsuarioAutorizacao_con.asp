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

<table width="100%" align="center" class="formulario" bgcolor="#FFFFFF">
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
	'if strCPF <>"" or strNome<>"" then
		sql = " select distinct SEG_usuarios.cpf, SEG_usuarios.nome"
		sql = sql & " from SEG_usuarios"
		if session("strUsuarioMaster") = "" then
			sql = sql & " inner join SEG_usuarios_acesso on SEG_usuarios_acesso.cpf_SEG_usuarios = SEG_usuarios.cpf"
			sql = sql & " inner join SEG_empresa on SEG_empresa.codigo = SEG_usuarios_acesso.codEmpresa"
		end if
		sql = sql & " Where 1=1 "
		if session("strUsuarioMaster") = "" then
			sql = sql & " and SEG_usuarios.cpf not in (select cpf_SEG_usuarios from SEG_usuarios_acesso_master)"
			sql = sql & " and SEG_empresa.codGrupo in (" &session("codGrupo")& ")"
		end if
		if strCPF <> "" then
			sql = sql & " and cpf = " & formataCpfBD(strCPF)
		end if
		if strNome <> "" then
			sql = sql & " and nome LIKE '%" & strNome & "%'"
		end if 
		sql=sql & " order by nome"
		rs.open sql, cnn
	%>
		<br>
	  <table width = "100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
		<TR bgcolor="#E5E5E5">
				<td width="21%" class="celula"><strong>CPF</strong></td>
				<td width="60%" class="celula"><strong>Nome </strong></td>
				<td width="19%" class="celula"><strong>Unidade de Acesso</strong></td>
			</tr>
	<%	
			
		if rs.eof = false then
		
			while not rs.eof
				cont = cont + 1
				strCpfBD = formataCpfBD(rs("cpf"))
				%>
				  <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("cpf")%>')">
					<td class="celula">&nbsp;<%=formataCpfAP(rs("cpf"))%></td>
					<td class="celula">&nbsp;<%=ucase(rs("nome"))%></td>
					<td class="celula"><!--#include file="../../../includes/inc_UnidadeAcesso.asp"-->&nbsp;</td>
				  </tr>
				  <%				
				rs.movenext
			wend
			%>
			<tr><td class="celula" colspan="4">Total Registros : <%=cont%></td></tr>
			<%
		else
			%>
			<tr><td class="celula" colspan="4" align="center"><%=session("strMensagemNaoEncontrado")%></td></tr>
			<%
		end if
	rs.close
	%>
	</table>	  
	<%
'end if
%>

</td>
</tr>
</table>
</form>
</body>
</html>