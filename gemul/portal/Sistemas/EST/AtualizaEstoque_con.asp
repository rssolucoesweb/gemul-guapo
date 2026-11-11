<!--
	::	Empresa...........: RS Soluções web - www.rssolucoesweb.com.br
    ::	Data de Criação...: 27/10/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Consulta de Entrada
	::	Data Atualizacao..: 
	::	Motivo Atualizacao: 
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../../estilo/css.css" rel="stylesheet" type="text/css">
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_formatadata.asp"-->
<script src="../../../js/js_funcoes_gerais.js"></script>
<script>
	function Consulta(){
		frm.submit();
	}

	function resultadoConsulta(intCodigoReq){
		window.opener.document.getElementById("txtCodRequisicao").value=intCodigoReq
		window.opener.document.getElementById("frm").submit();
		window.close();
	}
</script>
<%
	strNome = Request.Form("txtNome")
%>
<form method="POST" id="frm" name="frm" action="#">
  <div align="center"></div>
  <table width="100%" align="left" bgcolor="#FFFFFF" class="formulario">
    <tr>
      <td width="100%" height="85" align="center">
	  <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td  align="center"><span class="tituloPrincipal">Consulta de Atualiza<strong>&ccedil;&atilde;o</strong> de Estoque</span></td>
          </tr>
        </table>
		<br>
	    <%
		cont =0

		sql = " select codigo as codAtualizacaoEstoque, dataentrada, usuario, codSituacao "
		sql = sql & " from EST_ATUALIZACAO_ESTOQUE "
		sql = sql & " where CodEmpresa = " & session("codEmpresa")
		sql = sql & " order by dataentrada desc"
		rs.open sql, cnn
						
		if rs.eof = false then
		%>
	    <table width = "98%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
          <tr bgcolor="#E5E5E5">
            <td class="celula"><strong>Codigo</strong><strong class="TextoForm"></strong></td>
            <td width="37%" class="celula"><strong>Data da Entrada</strong></td>
            <td width="31%" class="celula"><span class="texto1"><strong>Usu&aacute;rio Inclusão</strong></span></td>
            <td width="21%" height="21" class="celula"><strong>Situa&ccedil;&atilde;o</strong></td>
          </tr>
		  <%
		 	while not rs.eof
			cont = cont + 1		
				strSituacao 		= "<font color='#FF0000'>Em Aberto</font>"
				intCodSituacao		= trim(rs("codSituacao"))
				if intCodSituacao = "2" then
					strSituacao = "<font color='#0000FF'>Atualizado</font>"
				end if
				usuarioInclusao			= UCASE(trim(Rs("usuario")))
				if isnull(usuarioInclusao) then usuarioInclusao = ""
				
				if usuarioInclusao<>"" then
					sql = "SELECT  nome "
					sql = sql & " FROM SEG_usuarios "
					sql = sql & " Where cpf = '" & usuarioInclusao & "'"
					rsAux.open sql, cnn
					if rsAux.eof = false then	
						usuarioInclusao = trim(ucase(rsAux("nome")))
						vetUsu			= split(usuarioInclusao," ")
						intPosicaoFinal	= ubound(vetUsu)
						if intPosicaoFinal>0 then
							usuarioInclusao = vetUsu(0) & " " & vetUsu(intPosicaoFinal)
						else
							usuarioInclusao = vetUsu(0)
						end if
					end if
					rsAux.close		
				end if				
			%>
          <tr  style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("codAtualizacaoEstoque")%>')"> 
            <td width="11%" class="celula"><%=rs("codAtualizacaoEstoque")%></td>
            <td class="celula"><%=rs("dataentrada")%></td>
            <td class="celula"><%=usuarioInclusao%></td>
            <td height="21" class="celula"><%=strSituacao%></td>
          </tr>
		  <%				
			rs.movenext
			wend
			%>
         	<tr> 
            	<td height="21" colspan="4" class="celula"><span class="texto">Total Registros :</span> <%=cont%></td>
        	</table>
	  	<%
		end if
		rs.close
		%>
        </td> 
    </tr>
  </table>
</form>
</body>
</html>