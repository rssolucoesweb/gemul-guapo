<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 28/01/2009
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@hotmail.com
-->
<html>
<head>
<title><%=session("Titulo")%> - Alunos</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
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
<!--#include file="../includes/inc_sqlCodigoEmpresaUsuario.asp"-->
<br>
<%
	dim intPagina

	intCodEmpresaUsuario = Session("CodEmpresa")
	intCodGrupo = Session("CodGrupo")
	intCodOrdem 				= request.Form("cmbOrdem")
    strMes		 		        = Trim(Request("cmbMes"))
    strAno		 			    = Trim(Request("txtAno"))
	strClassificacao			= request.Form("cmbClassificacao")
	intCodUsuario               = request.Form("cmbUsuario")
	strMesDia          		    = request.Form("chkMesDia")

	if strClassificacao = "AN" then   
	   intCodOrdem 				= request.Form("cmbOrdem")
	   intCodSequencia 			= request.Form("cmbSequencia")
 	end if   
 	strTotalLancamentos	    = Trim(Request("txtTotalLancamentos"))
 	
	if strTotalLancamentos <> "" then
	   strTotalLancamentos = "TOP " &  strTotalLancamentos & " "
	end if
	strTituloRelatorio  	= "ACESSOS DE USUÁRIOS AO SISTEMA"

	sub mostraCabecalho()
		%>
		<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
		<br>
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
		  <tr bgcolor="#CCCCCC">
			<td align="center" class="celulaMenor"><strong>Empresa</strong></td>
		    <% if  strClassificacao <> "RE" then %>
			   <td class="celulaMenor"><strong>Mês</strong></td>
			<td class="celulaMenor"><strong>Usu&aacute;rio</strong></td>
			<% end if %>   
			<% if strClassificacao = "AN" then %>
			    <td class="celulaMenor"><strong>Instru&ccedil;&atilde;o</strong></td>
			<% else %>	
			    <td class="celulaMenor"><strong>Intera&ccedil;&otilde;es</strong></td>
			<% end if %>	
		  </tr>
		<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	mostraCabecalho
	cont = 0

	if strClassificacao = "AN" then
	
	    sql = "SELECT " & strTotalLancamentos & " E.RAZAOSOCIAL, L.LOGIN_USUARIO, L.DATALOG, L.SQL"
	    sql = sql & " FROM SEG_LOG L"
		sql = sql & " inner join seg_empresa E on E.codigo = L.cod_empresa "
		if intCodEmpresaUsuario <> "0" then
			sql = sql & " where L.cod_empresa in (" & intCodEmpresaUsuario & ")"
		else
			sql = sql & " where L.cod_empresa in (" & intEmpresasDoGrupo & ")"
		end if	
		if strAno <> "" then 
			sql = sql & " AND MONTH(L.DATALOG) = " & strMes 
			sql = sql & " AND YEAR(L.DATALOG) = " & strAno
		end if	
		if intCodUsuario <> "0" then
		   sql = sql & " AND L.LOGIN_USUARIO = '" & intCodUsuario & "'" 
		end if   
		if intCodOrdem = "1" then
		   sql = sql & " Order by L.idnt " & intCodSequencia
		elseif intCodOrdem = "2" then
		   sql = sql & " Order by L.sql " & intCodSequencia
		elseif intCodOrdem = "3" then
		   sql = sql & " Order by L.datalog " & intCodSequencia
		elseif intCodOrdem = "4" then
		   sql = sql & " Order by L.Login_usuario " & intCodSequencia
		end if	 
		
	elseif strClassificacao = "SI" then
		
		if strMesDia = "S" then
		
'			sql = "SELECT " & strTotalLancamentos & " E.RAZAOSOCIAL, convert(varchar, L.DATALOG, 103) AS DATALOG, L.LOGIN_USUARIO, COUNT(L.LOGIN_USUARIO) AS INTERACOES "
'			sql = sql & " FROM SEG_LOG L"
'			sql = sql & " inner join seg_empresa E on E.codigo = L.cod_empresa "
'			
'			if intCodEmpresaUsuario <> "0" then
'				sql = sql & " where L.cod_empresa in (" & intCodEmpresaUsuario & ")"
'			else
'				sql = sql & " where L.cod_empresa in (" & intEmpresasDoGrupo & ")"
'			end if	
'			
'			if strAno <> "" then
'				sql = sql & " AND MONTH(L.DATALOG) = " & strMes 
'				sql = sql & " AND YEAR(L.DATALOG) = " & strAno 
'			end if	
'			
'			if intCodUsuario <> "0" then
'			   sql = sql & " AND L.LOGIN_USUARIO = '" & intCodUsuario & "'" 
'			end if   
'			
'			
'			sql = sql & " GROUP BY E.RAZAOSOCIAL, convert(varchar, L.DATALOG, 103), L.LOGIN_USUARIO "
'			sql = sql & " ORDER BY E.RAZAOSOCIAL, INTERACOES DESC	"	
			
			sql = " SELECT E.RAZAOSOCIAL, convert(varchar, L.DATALOG, 103) AS DATALOG,"
			sql = sql & " 	   L.LOGIN_USUARIO,  "
			sql = sql & " 	   COUNT(L.LOGIN_USUARIO)            AS INTERACOES"
			sql = sql & " FROM   SEG_LOG L"
			sql = sql & " 	   INNER JOIN seg_empresa E ON  E.codigo = L.cod_empresa"
			sql = sql & " 	   INNER JOIN SEG_USUARIOS_EMPRESA UE ON UE.CODIGO_SEG_USUARIOS_SISTEMA = L.LOGIN_USUARIO"
			sql = sql & " WHERE  MONTH(L.DATALOG) = " & strMes 
			sql = sql & " AND YEAR(L.DATALOG) = " & strAno 
			sql = sql & " AND UE.COD_EMPRESA  in (" & intCodEmpresaUsuario & ")"
			
			if intCodUsuario <> "0" then
			   sql = sql & " AND UE.CODIGO_SEG_USUARIOS_SISTEMA = '" & intCodUsuario & "'" 
			end if   
			
			sql = sql & " AND UE.CODIGO_SEG_USUARIOS_SISTEMA <> 'FERNANDO.DOMINGOS'"
			sql = sql & " AND UE.CODIGO_SEG_USUARIOS_SISTEMA <> 'CLEOVIS'"
			sql = sql & " AND UE.CODIGO_SEG_USUARIOS_SISTEMA <> 'ROBERTO'"
			sql = sql & " GROUP BY E.RAZAOSOCIAL, convert(varchar, L.DATALOG, 103), L.LOGIN_USUARIO"
			sql = sql & " ORDER BY E.RAZAOSOCIAL, INTERACOES DESC"
		
		else
		
			sql = " SELECT E.RAZAOSOCIAL, MONTH(L.DATALOG) as Mes,"
			sql = sql & " 	   L.LOGIN_USUARIO,  "
			sql = sql & " 	   COUNT(L.LOGIN_USUARIO)            AS INTERACOES"
			sql = sql & " FROM   SEG_LOG L"
			sql = sql & " 	   INNER JOIN seg_empresa E ON  E.codigo = L.cod_empresa"
			sql = sql & " 	   INNER JOIN SEG_USUARIOS_EMPRESA UE ON UE.CODIGO_SEG_USUARIOS_SISTEMA = L.LOGIN_USUARIO"
			sql = sql & " WHERE  MONTH(L.DATALOG) = " & strMes 
			sql = sql & " AND YEAR(L.DATALOG) = " & strAno 
			sql = sql & " AND UE.COD_EMPRESA  in (" & intCodEmpresaUsuario & ")"
			
			if intCodUsuario <> "0" then
			   sql = sql & " AND UE.CODIGO_SEG_USUARIOS_SISTEMA = '" & intCodUsuario & "'" 
			end if   
			
			sql = sql & " AND UE.CODIGO_SEG_USUARIOS_SISTEMA <> 'FERNANDO.DOMINGOS'"
			sql = sql & " AND UE.CODIGO_SEG_USUARIOS_SISTEMA <> 'CLEOVIS'"
			sql = sql & " AND UE.CODIGO_SEG_USUARIOS_SISTEMA <> 'ROBERTO'"
			sql = sql & " GROUP BY E.RAZAOSOCIAL, MONTH(L.DATALOG), L.LOGIN_USUARIO"
			sql = sql & " ORDER BY E.RAZAOSOCIAL, INTERACOES DESC"
			
		end if
	   
		
	elseif strClassificacao = "RE" then
		sql = "SELECT " & strTotalLancamentos & " E.RAZAOSOCIAL, COUNT(L.LOGIN_USUARIO) AS INTERACOES "
		sql = sql & " FROM SEG_LOG L"
		sql = sql & " inner join seg_empresa E on E.codigo = L.cod_empresa "
		if intCodEmpresaUsuario <> "0" then
			sql = sql & " where L.cod_empresa in (" & intCodEmpresaUsuario & ")"
		else
			sql = sql & " where L.cod_empresa in (" & intEmpresasDoGrupo & ")"
		end if	
		if strAno <> "" then
			sql = sql & " AND MONTH(L.DATALOG) = " & strMes 
			sql = sql & " AND YEAR(L.DATALOG) = " & strAno 
		end if	
		if intCodUsuario <> "0" then
		   sql = sql & " AND L.LOGIN_USUARIO = '" & intCodUsuario & "'" 
		end if   
		sql = sql & " GROUP BY E.RAZAOSOCIAL "
		sql = sql & " ORDER BY INTERACOES DESC	"	
	end if 
	
	rs.open sql, cnn
	if not rs.eof then 
	    vSaltaEmpresa = "0"
		While not rs.eof
		    strEmpresa = rs("RAZAOSOCIAL")
			
			if strMesDia = "S" then
				strData = rs("DATALOG") 
			else
				strData = rs("Mes") 
			end if
			%>
			  <tr>
			    <% if vSaltaEmpresa = "0" then %>
				    <% vSaltaEmpresa = "1" %>
					<td class="celulaMenor" align="left"><%=rs("RAZAOSOCIAL")%>&nbsp;</td>
				<% else %>	
					<td class="celulaMenor" align="left">&nbsp;</td>
				<% end if %>
				<% if  strClassificacao <> "RE" then %>
				    <td class="celulaMenor" align="left"><%=strData%>&nbsp;</td>
				    <td class="celulaMenor"><%=rs("LOGIN_USUARIO")%>&nbsp;</td>
				<%end if%>	
			    <% if  strClassificacao = "AN" then %>
				   	<td align="center" class="celulaMenor"><div align="left"><%=rs("SQL")%>&nbsp;</div></td>
				<% else %>	
				   	<td align="center" class="celulaMenor"><div align="left"><%=rs("INTERACOES")%>&nbsp;</div></td>
				<% end if %>	
			  </tr>
			<%
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
						<td colspan="6" class="celulaMenor"><hr>&nbsp;</hr></td>
					   </tr>
				       <%
                   end if
			   end if
			end if
		wend
		%>
          <tr>
			<td colspan="6" class="celulaMenor">Quantidade Execuções: <%=cont%></td>
		  </tr>
		 <%
		else
		%>
		  <tr>
			<td colspan="6" class="celulaMenor" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
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