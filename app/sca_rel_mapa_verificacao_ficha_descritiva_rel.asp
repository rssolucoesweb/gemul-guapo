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
<title>GEMUL - Notas disciplina</title>
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
	
	intAnoLetivoAtual	 		= Trim(Request.Form("txtAnoLetivo"))
	intSemestreAtual	 		= Trim(Request.Form("cmbSemestre"))
	intCodEmpresaGrupo			= Trim(Request.Form("cmbEmpresaGrupo"))
	intCodBimestre				= Trim(Request.Form("cmbBimestre"))
	intCodFicha					= Trim(Request.Form("cmbFichaDescritiva"))

	sql="select 0 as codigo, 'SEM MARCAÇÃO' as descricao UNION select codigo, descricao as conceito"
	sql=sql & " from SCA_FICHA_DESCRITIVA_CONCEITO "
	sql=sql & " where cod_ficha_descritiva=" & intCodFicha
	sql=sql & " order by codigo"
	vetConceito = null
	rs.open sql, cnn
	if not rs.eof then
		vetConceito = rs.getRows
	end if
	rs.close
	
	sql="select 0 as codigo, 'SEM MARCAÇÃO' as descricao UNION select codigo, descricao as conceito"
	sql=sql & " from SCA_FICHA_DESCRITIVA_CONCEITO_PERGUNTA "
	sql=sql & " where cod_ficha_descritiva=" & intCodFicha
	sql=sql & " order by codigo"
	vetConceitoPergunta = null
	rs.open sql, cnn
	if not rs.eof then
		vetConceitoPergunta = rs.getRows
	end if
	rs.close
	
	sql="select descricao from SEG_GRUPO"
	sql=sql & " where codigo=" & session("CodGrupo")
	rs.open sql, cnn
	if not rs.eof then
		session("strNomeGrupo") = rs("descricao") 
	end if
	rs.close
	
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
	
	sql="select descricao from SCA_FICHA_DESCRITIVA"
	sql=sql & " where codigo=" & intCodFicha
	rs.open sql, cnn
	if not rs.eof then
		ficha = rs("descricao") 
	end if
	rs.close
	
	empresa = ""
	if intCodEmpresaGrupo <> "0" then
		sql="select razaosocial as empresa"
		sql=sql & " from seg_empresa "
		sql=sql & " where codigo=" & intCodEmpresaGrupo
		rs.open sql, cnn
		if not rs.eof then
			empresa = "<br>" & rs("empresa") 
		end if
		rs.close
	end if
	
	strTituloRelatorio  	= "FICHA DESCRITIVA "
	strTituloRelatorio = strTituloRelatorio & intAnoLetivoAtual
	strTituloRelatorio = strTituloRelatorio & empresa
	strTituloRelatorio = strTituloRelatorio & bimestre

	
	strAnoCab = intAnoLetivoAtual
		
	%>
	<!--#include file="includes/inc_cabecalhoRelatorioGrupo.asp"-->
	<br>
	<h2><div align="center"><strong><%=ficha%></strong></div></h2>
	<br>
	<table width="90%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
	  <tr bgcolor="#CCCCCC">
	    <td width="10%" class="celula"><div align="center"><strong>Pergunta</strong></div></td>
        <%
		qtdeColuna = 0
		for i=0 to ubound(vetConceito,2)
		%>
	    <td width="5%" class="celula"><div align="center"><strong><%=vetConceito(1,i)%></strong></div></td>
		<%
			qtdeColuna = qtdeColuna + 1
		next
		%>
		<td width="5%" class="celula" align="center"><strong>TOTAL</strong></td>
      </tr>
		<%
		
		intPagina = 1
		
		semdados = ""
		
		sql = "exec SP_rel_ficha_descritiva_quantitativo " & session("CodGrupo") & "," & intCodEmpresaGrupo & ",'" & intAnoLetivoAtual & "','" & intSemestreAtual & "'," & intCodBimestre & "," & intCodFicha & ""
		rs.open sql, cnn
		if not rs.eof then
			semdados = "SIM"
			While not rs.eof
				total = 0
				strCorLinhaNaoOferece = ""
				strMsnOferece = ""
				if cor = "#FFFFFF" then
					cor = "#E7E7E7"
				else
					cor = "#FFFFFF"
				end if
				%>
				<tr bgcolor="<%=cor%>">
					<td align="left" class="celula"><%=rs("descricao")%></td>
					<%
					controle_posicao = 3
					for i=0 to ubound(vetConceito,2)
							
					%>
					<td class="celula" align="center"><%=rs(controle_posicao)%></td>
					<%
						if not isnull(rs(controle_posicao)) then total = total + rs(controle_posicao)
						controle_posicao = controle_posicao + 2
					next
					%>
					<td class="celula" align="center"><%=total%></td>
				</tr>
				<%
				rs.movenext
			wend
		end if
		rs.close
		%>
	</table>
		<%
	
		sql = "exec SP_rel_ficha_descritiva_quantitativo_conceito_pergunta " & session("CodGrupo") & "," & intCodEmpresaGrupo & ",'" & intAnoLetivoAtual & "','" & intSemestreAtual & "'," & intCodBimestre & "," & intCodFicha & ""
		
		rs.open sql, cnn
		if not rs.eof then
			%>
			<br>
			<table width="90%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
			  <tr bgcolor="#CCCCCC">
				<td width="10%" class="celula"><div align="center"><strong>Pergunta</strong></div></td>
				<%
				qtdeColuna = 0
				for i=0 to ubound(vetConceitoPergunta,2)
				%>
				<td width="5%" class="celula"><div align="center"><strong><%=vetConceitoPergunta(1,i)%></strong></div></td>
				<%
					qtdeColuna = qtdeColuna + 1
				next
				%>
				<td width="5%" class="celula" align="center"><strong>TOTAL</strong></td>
			  </tr>
			<%
			semdados = "SIM"
			While not rs.eof
				total = 0
				strCorLinhaNaoOferece = ""
				strMsnOferece = ""
				if cor = "#FFFFFF" then
					cor = "#E7E7E7"
				else
					cor = "#FFFFFF"
				end if
				%>
				<tr bgcolor="<%=cor%>">
					<td align="left" class="celula"><%=rs("descricao")%></td>
					<%
					controle_posicao = 3
					for i=0 to ubound(vetConceitoPergunta,2)
							
					%>
					<td class="celula" align="center"><%=rs(controle_posicao)%></td>
					<%
						if not isnull(rs(controle_posicao)) then total = total + rs(controle_posicao)
						controle_posicao = controle_posicao + 2
					next
					%>
					<td class="celula" align="center"><%=total%></td>
				</tr>
				<%
				rs.movenext
			wend
			%>
			</table>
			<%
		end if
		rs.close

		cor = "#E7E7E7"
		sql = "exec SP_rel_ficha_descritiva_quantitativo_conceito_pergunta_x " & session("CodGrupo") & "," & intCodEmpresaGrupo & ",'" & intAnoLetivoAtual & "','" & intSemestreAtual & "'," & intCodBimestre & "," & intCodFicha & ""
		rs.open sql, cnn
		if not rs.eof then
		%>
		<br>
		
		<table width="90%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
		  <tr bgcolor="#CCCCCC">
			<td width="10%" class="celula"><div align="center"><strong>Pergunta</strong></div></td>
			<td width="5%" class="celula"><div align="center"><strong>Conceito</strong></div></td>
			<td width="5%" class="celula" align="center"><strong>TOTAL</strong></td>
		  </tr>
		
		<%
			semdados = "SIM"
			While not rs.eof
				total = 0
				strCorLinhaNaoOferece = ""
				strMsnOferece = ""
				if rs("codigo")<> codigo then
					if cor = "#FFFFFF" then
						cor = "#E7E7E7"
					else
						cor = "#FFFFFF"
					end if
					%>
					<tr>
					  <td rowspan="<%=rs("linhas")%>" align="left" class="celula" bgcolor="<%=cor%>"><%=rs("descricao")%></td>
						<td class="celula" align="center" bgcolor="<%=cor%>"><%=rs("conceito")%></td>
						<td class="celula" align="center" bgcolor="<%=cor%>"><%=rs("qtde")%></td>
					</tr>
					<%
				else
					%>
					<tr>
						<td class="celula" align="center" bgcolor="<%=cor%>"><%=rs("conceito")%></td>
						<td class="celula" align="center" bgcolor="<%=cor%>"><%=rs("qtde")%></td>
					</tr>
					<%
				end if
				codigo = rs("codigo")
				rs.movenext
			wend
			%>
			</table>
			<%
		end if
	rs.close

	if semdados = "" then
		%>
		<table width="90%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
		  <tr>
			<td colspan="3" class="celula" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
		  </tr>
		  </table>
		<%
	end if
%>


<script>
	aguarde.style.display="none";
</script>
</body>
</html>
