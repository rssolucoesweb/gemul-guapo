<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/02/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Extrato de Notas
-->
<html>
<head>
<title><%=session("Titulo")%> - Grade Curricular</title>
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
<!--#include file="../includes/inc_CompartilharDadosCadastrais.asp"-->
<br>
<%
	dim intPagina
	dim strInfoTurma
	
	strSituacao					= Trim(Request.Form("cmbSituacao"))	
	strTipoRelatorio			= request.Form("cmbTipoRelatorio")
	intCodCargo 	    		= TRIM(Request.Form("cmbCargo"))
	intCodEmpresaUsuario 	    = TRIM(Request.Form("cmdEmpresaUsuario"))

	if strTipoRelatorio = "A" then 
		strTituloRelatorio  	= "Relação Cargos por Colaboradores"
	else
		strTituloRelatorio  	= "Totais de Cargos por Colaboradores"
	end if

	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
	  <tr bgcolor="#CCCCCC">
      	<% if strTipoRelatorio = "A" then %>
	    	<td width="5%" class="celula"><div align="center"><strong>C&oacute;digo </strong></div></td>
    	<td width="21%" class="celula"><div align="center"><strong>Colaborador</strong></div></td>
			<%if Session("NivelPermissao") = "A" then%> 
		    	<td width="18%" class="celula"><strong>Unidade</strong></td>
			<%end if%> 
			<td width="6%" class="celula"><strong>Matr&iacute;cula</strong></td>
			<td width="6%" class="celula"><div align="center"><strong>Situa&ccedil;&atilde;o</strong></div></td>
        <%end if%>    
		<td width="12%" class="celula"><div align="center"><strong>Forma de<br>Nomea&ccedil;&atilde;o</strong></div></td>
		<td width="27%" class="celula"><div align="center"><strong>Cargo</strong></div></td>
		<% if strTipoRelatorio = "S" then %>
	    	<td width="5%" class="celula"><div align="center"><strong>Quant.</strong></div></td>
        <%end if%> 
	  </tr>
	   <%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	mostraCabecalho
	cont = 0
	contColaboradorEmpresa = 0
	intQtdeRegistroPorPagina = 0
	
	if strTipoRelatorio = "S" then 
		sql = " SELECT " 
		sql = sql & " FM.Desc_FormaNomeacao, "  
		sql = sql & " CC.DESC_CARGO AS CARGO, "  
		sql = sql & " isnull(COUNT(CC.COD_CARGO),'0') AS TOTAL " 
		sql = sql & " FROM SRH_COLABORADOR C "  
		sql = sql & " inner join SEG_EMPRESA E ON E.CODIGO = C.CodLotacao "  
		sql = sql & " LEFT JOIN SRH_CARGOCOLABORADOR CC ON CC.COD_CARGO = C.CODCARGO " 
		sql = sql & " LEFT JOIN SRH_FORMANOMEACAOCOLABORADOR FM ON FM.Cod_FormaNomeacao = C.codFormaNomeacao " 
		if Session("NivelPermissao") <> "A" then
		   sql = sql & " WHERE C.CodLotacao	= " & session("CodEmpresa")
		else   
			if intCodEmpresaUsuario <> "0" and intCodEmpresaUsuario <> "" then
				sql = sql & " where C.CodLotacao in (" & intCodEmpresaUsuario & ")"
			else
				sql = sql & " where C.CodLotacao in (" & intEmpresasDoGrupo & ")"
			end if   
		end if
		if strSituacao <> "" and strSituacao <> "0" then
		   sql = sql & " AND C.SITUACAO	= '" & strSituacao & "'"
		end if 
		if intCodCargo <> "" and intCodCargo <> "0" then
		   sql = sql & " AND C.CODCARGO	= " & intCodCargo
		end if
		sql = sql & " GROUP BY FM.Desc_FormaNomeacao, CC.DESC_CARGO "   
		sql = sql & " ORDER BY FM.Desc_FormaNomeacao, CC.DESC_CARGO " 
	else
		sql = " SELECT "
		sql = sql & " C.CODIGO AS COD_COLABORADOR, C.SITUACAO, "
		sql = sql & " C.NOME AS NOME_COLABORADOR, " 
		sql = sql & " E.RAZAOSOCIAL, " 
		sql = sql & " CC.DESC_CARGO AS CARGO, "
		sql = sql & " C.CodFuncional, "
		sql = sql & " FM.Desc_FormaNomeacao "
		sql = sql & " FROM SRH_COLABORADOR C " 
		sql = sql & " inner join SEG_EMPRESA E ON E.CODIGO = C.CodLotacao " 
		sql = sql & " LEFT JOIN SRH_CARGOCOLABORADOR CC ON CC.COD_CARGO = C.CODCARGO "
		sql = sql & " LEFT JOIN SRH_FORMANOMEACAOCOLABORADOR FM ON FM.Cod_FormaNomeacao = C.codFormaNomeacao " 
		if Session("NivelPermissao") <> "A" then
		   sql = sql & " WHERE C.CodLotacao	= " & session("CodEmpresa")
		else   
			if intCodEmpresaUsuario <> "0" and intCodEmpresaUsuario <> "" then
				sql = sql & " where C.CodLotacao in (" & intCodEmpresaUsuario & ")"
			else
				sql = sql & " where C.CodLotacao in (" & intEmpresasDoGrupo & ")"
			end if   
		end if
		if strSituacao <> "" and strSituacao <> "0" then
		   sql = sql & " AND C.SITUACAO	= '" & strSituacao & "'"
		end if 
		if intCodCargo <> "" and intCodCargo <> "0" then
		   sql = sql & " AND C.CODCARGO	= " & intCodCargo
		end if
		sql = sql & " ORDER BY C.NOME "	
	end if
	rs.open sql, cnn
	if not rs.eof then 
	   somaParcial = 0
	   somaParcialTotal = 0
	   While not rs.eof 
	   		if strTipoRelatorio = "A" then 
				if trim(rs("Situacao")) = "A" then 
				   strSituacao = "ATIVO"
				elseif trim(rs("Situacao")) = "I" then  
				   strSituacao = "INATIVO"	  
				end if 
			end if 
  		    %> 
			<tr>
            <% if strTipoRelatorio = "A" then %>
				<td class="celula"><div align="center">&nbsp;<%=rs("COD_COLABORADOR")%></div></td>
				<td class="celula">&nbsp;<%=rs("NOME_COLABORADOR")%></td>
		    	<%if Session("NivelPermissao") = "A" then%> 
					<td  class="celula">&nbsp;<%=rs("RAZAOSOCIAL")%></td>			
				<%end if%> 
				<td  class="celula"><div align="center"><%=rs("CodFuncional")%>&nbsp;</div></td>
				<td  class="celula"><div align="center"><%=strSituacao%>&nbsp;</div></td>
            <%end if%> 
			<td  class="celula"><div align="left"><%=rs("Desc_FormaNomeacao")%>&nbsp;</div></td>
			<td  class="celula"><div align="left"><%=rs("Cargo")%>&nbsp;</div></td>
            <% if strTipoRelatorio = "S" then %>
				<td  class="celula"><div align="center"><strong><%=rs("TOTAL")%></strong></div></td>
            <%end if%> 
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
			contColaboradorEmpresa = contColaboradorEmpresa + 1
			intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
			if strTipoRelatorio = "S" then
				somaParcial =  somaParcial + rs("TOTAL")
				somaParcialTotal =  somaParcialTotal + rs("TOTAL")
			end if
			strDescFormaNomeacao = trim(rs("Desc_FormaNomeacao"))
			rs.movenext
			if not rs.eof then 
				strDescFormaNomeacao1 = trim(rs("Desc_FormaNomeacao"))
			else
				strDescFormaNomeacao1 = ""
			end if
            if strTipoRelatorio = "S" and strDescFormaNomeacao <> strDescFormaNomeacao1  then 
				%>
                <tr  bgcolor="#CCCCCC">
                  <td colspan="2" class="celula"><div align="right"><strong>Total...&nbsp;&nbsp;&nbsp;&nbsp;</strong></div></td>
                  <td  class="celula"><div align="center"><%=somaParcial%></div></td>
                </tr>
            	<%
				somaParcial = 0
			end if 
		wend
		if strTipoRelatorio = "S" then 
			%>
			<tr  bgcolor="#CCCCCC">
			  <td colspan="2" class="celula"><div align="right"><strong>T o t a l&nbsp;&nbsp;G e r a l...&nbsp;&nbsp;&nbsp;&nbsp;</strong></div></td>
			  <td  class="celula"><div align="center"><%=somaParcialTotal%></div></td>
			</tr>
			<%
		end if 

	else
		%>
		  <tr>
			<td colspan="38" class="celula" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
		  </tr>
		<%
	end if
	rs.close
%>
<tr>
<td colspan="38" class="celula" align="center"><div align="left">Total de Registros: <%=cont%> </div></td>
</tr>
</table>

<script>
	aguarde.style.display="none";
</script>
</body>
</html>
