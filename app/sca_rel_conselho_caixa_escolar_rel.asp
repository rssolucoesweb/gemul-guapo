<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
response.Expires=0
Server.ScriptTimeOut = 5000
response.Buffer = false
%>
<html>
<head>
<title>GEMUL - Relatório do Conselho e Caixa Escolar</title>
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="js/js_funcoes_gerais.js"></script>
<body>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="includes/inc_Botoes_relatorio.asp"-->		
<br>
<%
	dim intPagina

	strclasse               = "celula"
	intCodTipoEmpresa			= Trim(Request.Form("cmbTipoEmpresa"))
	
	IF intCodTipoEmpresa<>"" AND intCodTipoEmpresa <> "0" THEN
		sql = "SELECT descricao"
		sql = sql & " FROM SEG_TIPOEMPRESA"
		SQL = SQL & " WHERE codigo = " & intCodTipoEmpresa
		rs.open sql, cnn
		if NOT rs.eof then
			strTipoEmpresa = "<br><strong>" & rs("descricao") & "</strong>"
		end if
		rs.close
	END IF
	
    strTituloRelatorio  	= "RELATÓRIO DE CONSELHO E CAIXA ESCOLAR " & strTipoEmpresa
	
	sub mostraCabecalho()
	%>
	<!--#include file="includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  
      <tr bgcolor="#CCCCCC">
        <td width="5%"  align="center" class="<%=strclasse%>"><strong>CNPJ</strong></td>
		<td width="20%" align="center" class="<%=strclasse%>"><strong>Unidade de Ensino</strong></td>
		<td width="15%" align="center" class="<%=strclasse%>"><strong>Diretor</strong></td>
		<td width="15%" align="center" class="<%=strclasse%>"><strong>Secretário</strong></td>
		<td width="10%" align="center" class="<%=strclasse%>"><strong>Conselho/Caixa</strong></td>
		<td width="10%" align="center" class="<%=strclasse%>"><strong>Presidente</strong></td>
		<td width="10%" align="center" class="<%=strclasse%>"><strong>Vigência</strong></td>
      </tr>
     
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub
%>
<%
	intPagina = 1
	mostraCabecalho
	cont = 0

		
	SQL = "SELECT " 
	SQL = SQL & " CNPJ,"
	SQL = SQL & " 	RAZAOSOCIAL,"
	SQL = SQL & " 	DIRETOR,"
	SQL = SQL & " 	SECRETARIA,"
	SQL = SQL & " 	NOMECAIXA,"
	SQL = SQL & " 	PRESIDENTE,"
	SQL = SQL & " 	DATAINICIO,"
	SQL = SQL & " 	DATAFIM"
	SQL = SQL & " FROM SEG_empresa"
	SQL = SQL & " WHERE uso_interno = 'N' and BLOQUEIO = 'N'"
	SQL = SQL & " and COD_GRUPO=" & SESSION("CODGRUPO")
	IF intCodTipoEmpresa<>"" AND intCodTipoEmpresa <> "0" THEN
		SQL = SQL & " and CodTipoEmpresa = " & intCodTipoEmpresa
	END IF
	SQL = SQL & " order by RAZAOSOCIAL"
	corLinha = "bgcolor='#F5F5F5'"
	
	rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof
            if trim(rs("RAZAOSOCIAL")) <> trim(RAZAOSOCIAL) then
				if trim(corLinha) = "" then
					corLinha = "bgcolor='#F5F5F5'"		
				else
					corLinha = ""		
				end if
			end if
			VIGENCIA = ""
			IF NOT ISNULL(rs("DATAINICIO")) THEN
				VIGENCIA = FORMATADATAAP(rs("DATAINICIO")) & " a " & FORMATADATAAP(rs("DATAFIM"))
			END IF
			%>
			  <tr <%=corLinha%>>
				<td <%=corLinha%> class="<%=strclasse%>" align="left"><%=rs("CNPJ")%>&nbsp;</td>
				<td <%=corLinha%> class="<%=strclasse%>" align="left"><%=rs("RAZAOSOCIAL")%>&nbsp;</td>
                <td <%=corLinha%> class="<%=strclasse%>" align="left"><%=rs("DIRETOR")%>&nbsp;</td>
				<td <%=corLinha%> class="<%=strclasse%>" align="left"><%=rs("SECRETARIA")%>&nbsp;</td>
				<td <%=corLinha%> class="<%=strclasse%>" align="left"><%=rs("NOMECAIXA")%>&nbsp;</td>
				<td <%=corLinha%> class="<%=strclasse%>" align="left"><%=rs("PRESIDENTE")%>&nbsp;</td>
				<td <%=corLinha%> class="<%=strclasse%>" align="left"><%=VIGENCIA%>&nbsp;</td>
			  </tr>
			<%
			RAZAOSOCIAL    = rs("RAZAOSOCIAL")
			rs.movenext
		wend
		rs.close
	else
		%>
		  <tr>
			<td colspan="6" class="<%=strclasse%>" ="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
		  </tr>
		<%
		rs.close
	end if
	
%>
</table>
</body>
</html>
