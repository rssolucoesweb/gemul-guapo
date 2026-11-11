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
<title>GEMUL - Mapa Ficha</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet" href="css_rel/Estilo_Impressao.css">
</head>
<body>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="includes/inc_Botoes_relatorio.asp"-->	
<!--#include file="includes/inc_aguarde.asp"-->	
<br>
<%
	dim intPagina
	dim qtdeColuna
	
	strCurso	 				= replace(Trim(Request.Form("cmbCurso")),"_"," ")
	strPeriodo	 				= replace(Trim(Request.Form("cmbPeriodo")),"_"," ")
	intAnoLetivoAtual	 		= Trim(Request.Form("txtAnoLetivo"))
	intSemestreAtual	 		= Trim(Request.Form("cmbSemestre"))
	intCodEmpresaGrupo			= Trim(Request.Form("cmbEmpresaGrupo"))
	intCodBimestre				= Trim(Request.Form("cmbBimestre"))
	
	if strCurso = "0" then strCurso = ""
	if strPeriodo = "0" then strPeriodo = ""

	sql="select codigo as cod_ficha, descricao_abreviada"
	sql=sql & " from SCA_FICHA_DESCRITIVA "
	sql=sql & " where cod_grupo=" & session("CodGrupo")
	sql=sql & " and Situacao = 'A'"
	if strCurso<>"" and strCurso<>"0" then
		sql=sql & " and curso = '" & strCurso & "'"
	end if
	if strPeriodo<>"" and strPeriodo<>"0" then
		sql=sql & " and periodo = '" & strPeriodo & "'"
	end if
	sql=sql & " order by periodo, codigo"
	vetFicha = null
	rs.open sql, cnn
	if not rs.eof then
		vetFicha = rs.getRows
	end if
	rs.close
		
	if not isArray(vetFicha) then
		%>
			<script>
				alert("Ficha não foi encontrada!")
			</script>
		<%
		response.end
	end if
	
	
	bimestre = "<br>" & "TODOS BIMESTRES"
	IF intCodBimestre <> "0" THEN
		sql="select descricao from SCA_BIMESTRE"
		sql=sql & " where codigo=" & intCodBimestre
		rs.open sql, cnn
		if not rs.eof then
			bimestre = "<br>" & rs("descricao") 
		end if
		rs.close
	END IF
	
	strTituloRelatorio  	= "MAPA FICHA DESCRITIVA " 
	strTituloRelatorio = strTituloRelatorio & intAnoLetivoAtual & bimestre

	dim strAnoCab
	strAnoCab = intAnoLetivoAtual
		
	sub mostraCabecalho()
	%>
	<!--#include file="includes/inc_cabecalhoRelatorioGrupo.asp"-->
	<br>
	<table width="90%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
	  <tr bgcolor="#CCCCCC">
	    <td width="10%" class="celula"><div align="center"><strong>Turma</strong></div></td>
		<td width="5%" class="celula"><div align="center"><strong>Turno</strong></div></td>
	    <td width="6%" class="celula"><div align="center"><strong>Ocupa&ccedil;&atilde;o</strong></div></td>
        <%
		qtdeColuna = 0
		for i=0 to ubound(vetFicha,2)
		%>
	    <td width="5%" class="celula"><div align="center"><strong><%=vetFicha(1,i)%></strong></div></td>
		<%
			qtdeColuna = qtdeColuna + 1
		next
		%>
      </tr>
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub
	
	intPagina = 1
	mostraCabecalho
	cont = 0
	sql = "exec SP_rel_ficha_descritiva " & session("CodGrupo")	 & "," & intCodEmpresaGrupo & ",'" & intAnoLetivoAtual & "','" & intSemestreAtual & "','" & strCurso & "','" & strPeriodo & "'," & intCodBimestre
	'response.write sql
	rs.open sql, cnn
	if not rs.eof then
		While not rs.eof
			strCorLinhaNaoOferece = ""
			strMsnOferece = ""
			if intCodEmpresa <> RS("codigoEmpresa") then
				%>
				<tr bgcolor="#AAE3FF">
					<td align="center" class="celula" colspan="<%=cInt(qtdeColuna)+3%>"><strong><%=rs("empresa")%></strong></td>
				</tr>
				<%
			end if
			if cor = "#FFFFFF" then
				cor = "#E7E7E7"
			else
				cor = "#FFFFFF"
			end if
			%>
			<tr bgcolor="<%=cor%>">
                <td align="center" class="celula"><%=rs("NOMETURMA")%>&nbsp;&nbsp;<%=rs("TURMAALUNO")%></td>
                <td align="center" class="celula"><%=rs("TURNO")%></td>
                <td align="center" class="celula"><%=rs("OCUPACAO")%></td>
                <%
                for i=0 to ubound(vetFicha,2)
                %>
                <td class="celula" align="center"><%=rs("ficha_" & vetFicha(0,i))%></td>
                <%
                next
                %>
			</tr>
			<%
			intCodEmpresa = RS("codigoEmpresa")
			rs.movenext

		wend
	else
		%>
		  <tr>
			<td colspan="<%=qtdeColuna+3%>" class="celula" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
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
