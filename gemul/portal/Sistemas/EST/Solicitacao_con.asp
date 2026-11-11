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
	consulta = Request("consulta")
%>
<form method="POST" id="frm" name="frm" action="solicitacao_con.asp?consulta=S">
	<input name="consulta" type="hidden" value="S">
  <div align="center"></div>
  <table width="100%" align="left" bgcolor="#FFFFFF" class="formulario">
    <tr>
      <td width="100%" height="85" align="center">
	  <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td  align="center"><span class="tituloPrincipal">Consulta de Solicitação de Material</span></td>
          </tr>
        </table>
		<br>
		Solicitante: 
		<input name="txtNome" type="text" class="text" id="txtNome" size="40" maxlength="40" value="<%=strNome%>">
		 		&nbsp;&nbsp;
<input type="button" name="cmdIncluir" style="cursor:hand"   value="Consultar" class="botao" <%=strDesabilitaIncluir%> onclick="Consulta()"><br>
<br>
	    <%
		if consulta = "S" then
			cont =0
			sql = "select _r.codigo as codrequisicao, _r.dataentrada, _r.solicitante, _s.descricao as situacao"
			sql = sql & " from est_requisicao _r"
			sql = sql & " inner join est_situacao _s on _s.codigo = _r.codsituacao"
			sql = sql & " inner join SEG_usuarios u on u.cpf = _r.solicitante"
			sql = sql & " where _r.CodEmpresa = " & session("CodEmpresa")	
			if session("bolUsuarioAcessaTodasRequisicoes")="" then 
				sql = sql & " and 	_r.solicitante = '" & session("strNomeUsuario") & "'"
			end if
			if Session("CodSecao")<>"0" then
				sql = sql & " and _r.cod_secao = " & Session("CodSecao")
			end if
			if strNome <> "" then
				sql = sql & " and u.nome like '%" & strNome & "%'"
			end if
			sql = sql & " order by 1 desc"
			rs.open sql, cnn
							
			if rs.eof = false then
			%>
			<table width = "98%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
			  <tr bgcolor="#E5E5E5">
				<td class="celula"><strong>Codigo</strong><strong class="TextoForm"></strong></td>
				<td width="22%" class="celula"><strong>Entrada</strong></td>
				<td width="24%" class="celula"><span class="texto1"><strong>usu&aacute;rio</strong></span></td>
				<td width="43%" height="21" class="celula"><strong>Situa&ccedil;&atilde;o</strong></td>
			  </tr>
			  <%
				while not rs.eof
					cont = cont + 1		
				
					usuarioInclusao			= UCASE(trim(Rs("solicitante")))
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
			  <tr  style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("codrequisicao")%>')"> 
				<td width="11%" class="celula"><%=rs("codrequisicao")%></td>
				<td class="celula"><%=rs("dataentrada")%></td>
				<td class="celula"><%=usuarioInclusao%></td>
				<td height="21" class="celula"><%=rs("situacao")%></td>
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
		end if
		%>
        </td> 
    </tr>
  </table>
</form>
</body>
</html>