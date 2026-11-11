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
		
	intCodEmpresa	 			= Session("CodEmpresa")
    intCodUsuario		        = request.Form("cmbUsuario")
	strTituloRelatorio  		= "Mapa de Controle de Acessos"

	sub mostraCabecalho()
		%>
		<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
		<br>
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
            <tr bgcolor="#CCCCCC">
            <td align="left" class="celulaMenor"><strong>Usu&aacute;rio</strong></td>
            <td class="celulaMenor"><strong>Modulo</strong></td>
            <td class="celulaMenor"><strong>Perfil</strong></td>
            <td class="celulaMenor"><strong>Itens</strong></td>
          </tr>
        <%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	mostraCabecalho
	cont = 0
	
	sql = " SELECT e.CODIGO, E.razaoSocial, U.USUA_CODG"
	sql = sql & " FROM SEG_EMPRESA E"
	sql = sql & " INNER JOIN SEG_USUARIOS_SISTEMA U ON E.CODIGO = U.COD_EMPRESA"
	sql = sql & " Where 1=1"
	if intCodUsuario <> "0" then
		sql = sql & " And  U.USUA_CODG = '" & intCodUsuario & "'"
	else
		sql = sql & " And  e.CODIGO = " & intCodEmpresa
	end if
	
	sql = sql & " Order by E.razaoSocial"
	rs.open sql, cnn

	if not rs.eof then 
	    vSaltaEmpresa = "0"
		While not rs.eof
		    strEmpresa = rs("RAZAOSOCIAL")
			strModulos = "" 
			strPerfil = "" 
			
			sql = "SELECT Aces_Usua_Codg, Perf_Codg, Perf_Sist_Sigl, Perf_Desc, "
			sql = sql & " SIST_DESC, MOD_DESCRICAO, SIST_STAT"
			sql = sql & " FROM Seg_Acessos_Usuario, Seg_Perfis_Sistema, "
			sql = sql & " Seg_Sistemas_informatica, SEG_MODULO"
			sql = sql & " WHERE Aces_Perf_Codg = Perf_Codg"
			sql = sql & " AND Seg_Perfis_Sistema.PERF_SIST_SIGL = SEG_SISTEMAS_INFORMATICA.SIST_SIGL"
			sql = sql & " AND Seg_Sistemas_informatica.MOD_COD = SEG_MODULO.MOD_COD"
			sql = sql & " AND SEG_SISTEMAS_INFORMATICA.SIST_STAT  = 'A'"
			sql = sql & " AND Aces_Usua_Codg = '" & trim(rs("USUA_CODG")) & "'"
			sql = sql & " AND Seg_Perfis_Sistema.Perf_Sist_Sigl = Seg_Sistemas_informatica.SIST_SIGL"
			rsAux.open sql, cnn
			
			if rsAux.eof = false then
				While not rsAux.eof

					strModulos = strModulos & Trim(rsAux("MOD_DESCRICAO")) & "<br>"
					strPerfil = strPerfil & Trim(rsAux("Perf_Desc")) & "<br>"

					sql = " SELECT ISIS.Item_Codg, ISIS.Item_Sist_Sigl , MS.MENU_DESC, ISIS.Item_Nome, ISIS.Item_Desc, ISIS.Item_Stat, ISIS.ITEM_NUMR_POSICAO "
					sql = sql & " FROM SEG_ITENS_SISTEMA ISIS " 
					sql = sql & " INNER JOIN SEG_PERFIS_ITENS_SISTEMA PIS ON PIS.PITE_ITEM_CODG = ISIS.Item_Codg "
					sql = sql & " INNER JOIN SEG_MENUS_SISTEMA MS ON MS.MENU_CODG = ISIS.ITEM_MENU_CODG " 
					sql = sql & " WHERE PIS.PITE_PERF_CODG = " & Trim(rsAux("Perf_Codg")) 
					sql = sql & " AND ISIS.ITEM_STAT = 'A' " 
					sql = sql & " ORDER BY MS.MENU_NUMR_POSICAO, ISIS.ITEM_DESC " 
					rsAux1.open sql, cnn
					if rsAux1.eof = false then
					While not rsAux1.eof
							strItens = strItens & UCASE(Trim(rsAux("Perf_Sist_Sigl"))) & " -> " &  Trim(rsAux1("MENU_DESC")) & " -> " &  Trim(rsAux1("Item_Nome")) & "<br>"
							rsAux1.movenext
						wend
						
					end if
					rsAux1.close
				
					rsAux.movenext
				wend
			end if 
			rsAux.close
							
			%>
            <tr>
                <td class="celulaMenor" align="left">&nbsp;<%=rs("USUA_CODG")%></td>
              <td class="celulaMenor" align="left"><%=strModulos%>&nbsp;</td>
              <td class="celulaMenor" align="left"><%=strPerfil%>&nbsp;</td>
                <td class="celulaMenor"><%=strItens%>&nbsp;</td>
          </tr>
			<%
			strItens = ""
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
			if not rs.eof then
			   if  strEmpresa <> rs("RAZAOSOCIAL") then
			       vSaltaEmpresa = "0"
				   if  strClassificacao <> "RE" then 
				       %>
					   <tr>
						<td colspan="5" class="celulaMenor"><hr>&nbsp;</hr></td>
					   </tr>
				       <%
                   end if
			   end if
			end if
		wend
		%>
          <tr>
			<td colspan="5" class="celulaMenor">Quantidade Execuções: <%=cont%></td>
		  </tr>
		 <%
		else
		%>
		  <tr>
			<td colspan="5" class="celulaMenor" align="center"><br>
		    <br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
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