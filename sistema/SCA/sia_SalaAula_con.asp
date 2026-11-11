<!--
	::	SIGE
	::	Data de Criação...: 10/09/2004
	::	Desenvolvedores...: Roberto Barbosa Silva - Roberto.barbosa@see.go.gov.br
	::	Objetivo Pagina...: Consulta os dados cadastrados na página sia_SalaAula_cad.asp
	::	Data Atualizacao..: 
	::	Motivo Atualizacao: 
-->
<html>
<head>
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo.css">
<title>Consulta Sala de Aulas Cadastradas</title>
<script src="../../js/js_funcoes_gerais.js"></script>
<script>
	function resultadoConsulta(intCodigo){
		
		window.opener.document.getElementById('txtHiddenCodigo').value = intCodigo;
		window.opener.document.getElementById('frm').submit();
		window.close();

	}
</script>
</head>
<body   topmargin="0" leftmargin="0">
<!--#include file="../../includes/inc_cnn.asp"-->
 
<form method="POST" id="frm" action="#">
<table width="98%" align="center" class="formulario">
	<tr>
		<td>
<%  
	paginaHelp 				= session("strCaminhoRaiz") & "../../help.asp"
	intCodigo 				= request.form("txtCodigo")
	intCodUnidEnsino		= session("strCodigoSIA")
	strNomeSala 			= request.form("txtNomeSala")
	strMensagemNaoEncontrado = session("strMensagemNaoEncontrado")
%>

<table width="100%" border="0">
          <tr> 
            <td width="87">C&oacute;digo</td>
            <td width="884"><input name="txtCodigo" type="text" id="txtCodigo" onKeyPress="return formataCampo(this, 2, 5)" class="caixaTexto" size="5" maxlength="5"> </td>
          </tr>
          <tr> 
            <td width="87">Nome da sala</td>
		        <td colspan="4"><input name="txtNomeSala" type="text" class="caixaTexto" id="txtNomeSala" size="30" maxlength="30" ></td>
          </tr>
          <tr> 
            <td colspan="2"><hr size="1" color="#CCCCCC"></td>
          </tr>
          <tr> 
          	<td colspan="2"><!--#include file="../../includes/inc_botoes_consulta.asp"--> </td>
          </tr>
        </table>
      <br>
  <table width = "98%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
          <TR bgcolor="#E5E5E5"> 
            <td width="11%" class="celula"><strong>C&oacute;digo</strong></td>
            <td width="34%" class="celula"><strong>Descri&ccedil;&atilde;o</strong></td>
            <td width="55%" class="celula"><strong>Situa&ccedil;&atilde;o</strong></td>
          </tr>				
        <%			
			sql = " SELECT SIA_ambiente_ue.codigo, SIA_ambiente_ue.codigo_sia_func_ambiente, SIA_ambiente_ue.descricao, Status.descricao as situacao"
			sql = sql & " FROM Status INNER JOIN SIA_ambiente_ue ON Status.codigo = SIA_ambiente_ue.codigo_status"
			sql = sql & " WHERE SIA_ambiente_ue.codigo<>999 AND SIA_ambiente_ue.codigo_sia_unid_ensino = " & intCodUnidEnsino  
			
			if intCodigo <> "" then
				sql = sql & " AND SIA_ambiente_ue.Codigo = " & intCodigo  
			elseIf 	strNomeSala <> "" then
				sql = sql & " AND SIA_ambiente_ue.descricao LIKE '%" & strNomeSala & "%'"	
			end if 
			sql = sql & " ORDER BY SIA_ambiente_ue.Codigo"
			rs.open sql, cnn
			'response.write sql
			'response.End()			
	if rs.eof = false then

	while not rs.eof
		cont = cont + 1		
		%>
          <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("Codigo")%>')"> 
            <td class="celula" align="center"><%=rs("Codigo")%></td>
            <td align="left" class="celula"><%=rs("descricao")%></td>
            <td align="left" class="celula"><%=rs("situacao")%></td>
          </tr>
          <%				
		rs.movenext
		wend
	else
		%>
		<tr><td class="celula" colspan="3" align="center"><strong><%=strMensagemNaoEncontrado%></strong> </td></tr>		
    <%	
	end if
rs.close
%>
			<tr><td class="celula" colspan="3">Total Registros : <%=cont%></td></tr>
		</table>	  
</td>
</tr>
</table>
</form>
</body>
</html>