<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
strPaginaDestino = "window.location='LiberarMaterial_con.asp'"
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 07/04/2009
	::	Desenvolvedores...: Sérgio - sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: Relatorio de LIquidacao diária
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link type="text/css" rel="stylesheet" href="../../../Estilo/Estilo_Impressao.css">
<script src="../../../js/js_funcoes_gerais.js"></script>
<script src="../../../js/js_barra_movel.js"></script></head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_Botoes_relatorio.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<br>
<%
	strlpp 						= 50
	intCodRequisicao          	= Trim(Request("req"))

	sql = "select _r.codigo, _u.nome, _ul.nome as liberadoPor,  _r.usuario_liberacao, _r.data_liberacao, _r.obs,"
	sql = sql & " case "
	sql = sql & " 	when _di.codigo is null then _d.descricao "
	sql = sql & " 	else _dd.descricao "
	sql = sql & " 	end as depto "	
	sql = sql & " from est_requisicao _r"
	sql = sql & " inner join SEG_usuarios _u on _u.cpf = _r.solicitante"
	sql = sql & " inner join SEG_usuarios _ul on _ul.cpf = _r.usuario_liberacao"
	sql = sql & " inner join EST_departamento _d on _d.codigo = _u.codDepartamento"
	sql = sql & " left  join EST_departamento _dd				on _dd.codigo = _r.codDepartamento "
	sql = sql & " left  join est_requisicaoDistribuicao _di	on _di.codRequisicao = _r.codigo "
	sql = sql & " where _r.codSituacao = 4 "
	sql = sql & " and	_r.codigo = " & intCodRequisicao
	rs.open sql, cnn
	if not rs.eof then 
		strSolicitante = rs("nome")
		strDepto = rs("depto")
		strDataLiberacao = rs("data_liberacao")
		strliberadoPor = rs("liberadoPor")
		strJustificativa = rs("obs")
		if isnull(strJustificativa) then strJustificativa = ""
	end if
	rs.close


	strTituloRelatorio  	= "LIBERAÇÃO DE MATERIAL"

	sub mostraSolicitante()
	%>
	<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
	  <tr>
	    <td width="7%" height="14" align="left" class="celula"><strong>Solicitante</strong></td>
	    <td width="45%" align="left" class="celula"><strong><%=ucase(strSolicitante)%></strong>&nbsp;</td>
	    <td width="20%" align="left" class="celula"><strong>N&deg;. Solicita&ccedil;&atilde;o</strong></td>
	    <td width="28%" align="left" class="celula"><strong><%=intCodRequisicao%></strong>&nbsp;</td>
      </tr>
	  <tr>
	    <td height="14" align="left" class="celula"><strong>Unidade</strong></td>
	    <td align="left" class="celula"><strong><%=ucase(strDepto)%></strong>&nbsp;</td>
	    <td align="left" class="celula"><strong>Data</strong></td>
	    <td align="left" class="celula"><strong><%=strDataLiberacao%></strong>&nbsp;</td>
      </tr>
      </table>
	<%
	end Sub
	sub mostraTopo()
		%>
		<!--#include file="../../../includes/inc_cabecalhoRelatorio.asp"-->
		<%
	end sub

	sub mostraCabecalho()
	%>
	<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
	  <tr bgcolor="#CCCCCC">
	    <td width="45%" height="14" rowspan="2" align="center" class="celula"><strong>Material</strong></td>
	    <td width="15%" rowspan="2" align="center" class="celula"><strong>Unidade</strong></td>
	    <td colspan="2" align="center" class="celula"><strong>Quantidade</strong></td>
      </tr>
	  <tr bgcolor="#CCCCCC">
	    <td width="10%" align="center" class="celula"><strong>Solicitada</strong></td>
	    <td width="10%" align="center" class="celula"><strong>Autorizada/Retirada</strong></td>
      </tr>
	<%
	end Sub
	sub fimTabela()
		response.Write("</table>")
	end Sub


	intPagina 		= 1
	mostraTopo
	mostraSolicitante
	mostraCabecalho
	
	cont 			= 0

	sql = "  select	_p.DESCRICAO as produto,_rp.codigo, _rp.codProduto,_up.descricao as unidade, _s.descricao as secao,"
	sql = sql & " 	_rp.quantidade,"
	sql = sql & " 	_rp.quantidade_autorizada,"
	sql = sql & " 	_rp.quantidade_liberada, _rp.numero_tombamento,"
	sql = sql & " 		_p.QTD_ATUAL_ESTOQUE"									
	sql = sql & " from EST_RequisicaoProduto _rp"
	sql = sql & " inner join EST_PRODUTO _p on _p.codigo = _rp.codProduto"
	sql = sql & " left join EST_UNIDADE_PRODUTO _up on _up.codigo = _p.COD_UNIDADE"
	sql = sql & " left join EST_SECAO_PRODUTO _S on _S.codigo = _P.COD_SECAO AND _S.COD_EMPRESA = _P.COD_EMPRESA"
	sql = sql & " where _rp.codRequisicao = "& intCodRequisicao

	rs.open sql, cnn
	if not rs.eof then 
	%>
		<tr>
			<td class="celula" colspan="4" align="center"><strong>Local Retirado: <%=rs("secao")%></strong></td>
		</tr>
        <%
		While not rs.eof 
			if rs("quantidade_liberada")=0 then
				strRiscaDescricao1 = "<s>"
				strFimRiscaDescricao1 = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</s>"
				strRiscaDescricao = "<s>&nbsp;&nbsp;&nbsp;"
				strFimRiscaDescricao = "&nbsp;&nbsp;&nbsp;</s>"
			else
				strRiscaDescricao1 = ""
				strFimRiscaDescricao1 = ""								
				strRiscaDescricao = ""
				strFimRiscaDescricao = ""								
			end if
			numero_tombamento = ""
			if not isnull(rs("numero_tombamento")) then
				numero_tombamento = "&nbsp;(" & rs("numero_tombamento") & ")"
			end if
			%>
	  	<tr>
			<td height="20" align="left" class="celula"><%=strRiscaDescricao1%><%=rs("produto")%><%=numero_tombamento%><%=strFimRiscaDescricao1%>&nbsp;</td>
			<td align="center" class="celula"><%=strRiscaDescricao%><%=rs("unidade")%><%=strFimRiscaDescricao%></td>
			<td align="center" class="celula"><%=strRiscaDescricao%><%=rs("quantidade")%><%=strFimRiscaDescricao%>&nbsp;</td>
	    	<td align="center" class="celula"><%=strRiscaDescricao%><%=rs("quantidade_liberada")%><%=strFimRiscaDescricao%>&nbsp;</td>
	  	</tr>
	  
			<%
			'quantidade de registros da página
			if int(intQtdeRegistroPorPagina) = int(strlpp) - 1 then
				 intPagina = intPagina + 1
				 intQtdeRegistroPorPagina = 1
				 fimTabela
				%>
				<pre>&nbsp;</pre>				
				<%			
				mostraCabecalho
			end if	
			cont = cont + 1
			ord = ord + 1
			intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
			rs.movenext
		wend
		contPeriodo = contPeriodo + 1
		%>
      <%
	else
		%>
		  <tr>
			<td colspan="4" class="celula" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
		  </tr>
		<%
	end if
	rs.close
%>
</table>
<br>
<%if strJustificativa <> "" then%>
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td align="left">Justificativa: <strong><%=strJustificativa%></strong>
    </td>
  </tr>
</table>
<br>
<%end if%>
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td align="left"><table width="80%" border="0" cellspacing="0" cellpadding="0" class="tabela">
      <tr>
        <td width="12%" height="14" align="left" class="celula"><strong><br>
          Liberado por <%=strliberadoPor%><br>
          <br>
          Em: <%=day(strDataLiberacao)%>/<%=month(strDataLiberacao)%>/<%=year(strDataLiberacao)%> &nbsp;&nbsp;&nbsp;&nbsp;Visto:__________________<br><br>
        </strong></td>
        </tr>
    </table></td>
    <td align="right"><table width="80%" border="0" cellspacing="0" cellpadding="0" class="tabela">
      <tr>
        <td width="12%" height="14" align="left" class="celula"><strong><br>
          Retirado por: ___________________________<br>
          <br>
          Em:___/____/_______ <br><br>
        </strong></td>
      </tr>
    </table></td>
  </tr>
</table>
<script>
	aguarde.style.display="none";
</script>
</body>
</html>
