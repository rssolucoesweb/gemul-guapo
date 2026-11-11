<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 26/07/2012
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script></head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_Botoes_relatorio.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<br>
<%
	dim intPagina
	strCod_empresa 			= Session("CodEmpresa")
	intOrdenacao 			= request.Form("cmbOrdenacao")
	intCurso	 			= request.Form("cmbAgrupamento")
	strDataInicio = ""
	strDataFim = ""
	strTituloRelatorio  	= "Rela&ccedil;&atilde;o de Cadastro de Reservas da <br> Matrícula " & year(date)
	if intCurso <> "0" then
		sql = "select * from [dbo].[MAT_periodo_curso] where codigo = " & intCurso
		RS.OPEN SQL, CNN
		IF RS.EOF = FALSE THEN
			strDataInicio 	= formataDataBD(rs("dt_inicial"))
			strDataFim 		= formataDataBD(rs("dt_final"))
			strCurso 		= rs("curso")
			strTituloRelatorio  	= "Rela&ccedil;&atilde;o de Cadastro de Reservas do <strong>" & strCurso & "</strong> <br> Matrícula " & year(date)
		END IF
		rs.close
	end if
	
	
	sub mostraCabecalhoLogo()
%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<%
	end Sub
	sub mostraCabecalho()
%>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
		<td width="3%" align="center" class="celula"><strong>Inscrição</strong></td>
		<td width="17%" class="celula"><strong>Nome Aluno</strong></td>
		<td width="6%" class="celula"><strong>Data Nasc</strong></td>
		<!--<td width="7%" class="celula"><strong>Contato</strong></td>-->
		<td width="11%" class="celula"><strong>M&atilde;e</strong></td>
		<td width="6%" class="celula"><strong>Ser&iacute;e</strong></td>
		<td width="8%" class="celula"><strong>Turno</strong></td>
		<td width="14%" class="celula"><strong>Endere&ccedil;o</strong></td>
		<td width="14%" class="celula"><strong>Bairro</strong></td>
		<td width="13%" class="celula"><strong>Cidade</strong></td>
        <td width="8%" class="celula"><strong>Telefone</strong></td>
	  </tr>
	<%
	end Sub
	sub mostraCabecalhoTotal()
%>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
		<td colspan="10" align="center" class="celula"><strong>Totais</strong></td>
	  </tr>
      <%
      
      	sql = "SELECT periodo, count(*) as qtde "
		sql = sql & " FROM MAT_Reserva "
		sql = sql & " where Situacao = 'R'"
		sql = sql & " AND ISNULL(ATUALIZADO,'N') = 'N'"
		sql = sql & " group by periodo order by periodo	"
		rs.open sql, cnn
		if not rs.eof then 
			While not rs.eof
				%>
				<tr>
					<td colspan="10" class="celula">Total <%=rs("periodo")%>:<%=rs("qtde")%></td>
				</tr>
				<%
				total = total + rs("qtde")
				rs.movenext
			wend
		end if
		rs.close
	%>
        <tr>
       		<td height="40" colspan="10" class="celula">Quantidade de Candidatos: <%=total%></td>
        </tr>
      
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub
%>
<%
	intPagina = 1
	intQtdeRegistroPorPagina = 1
	mostraCabecalhoLogo
	mostraCabecalhoTotal
	mostraCabecalho

	cont = 0
	
	intTotal_AgrupamentoI = 0
	intTotal_AgrupamentoII = 0
	intTotal_AgrupamentoIII = 0
	intTotal_AgrupamentoIV = 0
	intTotal_AgrupamentoV = 0

	
	cont = 0
	sql = "SELECT Codigo, inscricao, nome, data_nascimento, mae, cep, Logradouro, "
	sql = sql & " bairro, cidade, email, Periodo, Turno, EMAIL, Contato, Celular, FonePai, FoneMae  "
	sql = sql & " FROM MAT_Reserva "
	sql = sql & " where 1 = 1" 
	sql = sql & " and Situacao = 'R'"
	sql = sql & " AND ISNULL(ATUALIZADO,'N') = 'N'"
	
	if intCurso <> "0" then
		sql = sql & " and data_nascimento between '" & strDataInicio & "' and '" & strDataFim & "'"
		sql = sql & " and periodo = '" & strCurso & "'"
	end if
	
	if intOrdenacao = 1 then 
		sql = sql & " order by Codigo"
	end if
	
	if intOrdenacao = 2 then 
		sql = sql & " order by nome"
	end if
	
	if intOrdenacao = 3 then 
		sql = sql & " order by Periodo"
	end if
	
	if intOrdenacao = 4 then 
		sql = sql & " order by bairro"
	end if
	intQtdeRegistroPorPagina = 10
	rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof
		
				cont = cont + 1
			
				if trim(rs("TURNO")) <> "0" then
					strTurno = trim(rs("TURNO"))
				else
					strTurno =  "INTEGRAL"
				end if
				
				if trim(rs("Periodo")) = "AGRUPAMENTO I" then
					intTotal_AgrupamentoI = intTotal_AgrupamentoI + 1
				end if
				
				if trim(rs("Periodo")) = "AGRUPAMENTO II" then
					intTotal_AgrupamentoII = intTotal_AgrupamentoII + 1
				end if
				
				if trim(rs("Periodo")) = "AGRUPAMENTO III" then
					intTotal_AgrupamentoIII = intTotal_AgrupamentoIII + 1
				end if
				
				if trim(rs("Periodo")) = "AGRUPAMENTO IV" then
					intTotal_AgrupamentoIV = intTotal_AgrupamentoIV + 1
				end if
				
				if trim(rs("Periodo")) = "AGRUPAMENTO V" then
					intTotal_AgrupamentoV = intTotal_AgrupamentoV + 1
				end if
				
			%>
			  <tr>
				<td class="celula" align="center"><%=rs("INSCRICAO")%>&nbsp;</td>
				<td align="left" class="celula"><%=rs("nome")%>&nbsp;</td>
				<td align="left" class="celula"><%=formataDataAP(rs("data_nascimento"))%></td>
				<!--<td align="left" class="celula"><%=rs("Contato")%>&nbsp;</td>-->
             	<td align="left" class="celula"><%=rs("mae")%></td>
				<td align="left" class="celula"><%=rs("Periodo")%></td>
				<td align="left" class="celula"><%=strTurno%>&nbsp;</td>
				<td align="left" class="celula"><%=rs("Logradouro")%></td>
				<td align="left" class="celula"><%=rs("bairro")%></td>
				<td align="left" class="celula"><%=rs("cidade")%></td>
                <td align="left" class="celula"><%=rs("Contato")%></td>
			  </tr>
			<%
			'quantidade de registros da página
			if intQtdeRegistroPorPagina = 20 then
				 intPagina = intPagina + 1
				 intQtdeRegistroPorPagina = 1
				 fimTabela
				%>
				<pre></pre>				
				<%			
				mostraCabecalho
			end if	
			
			intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
			rs.movenext
		wend
		%>
	  <tr bgcolor="#CCCCCC">
		<td colspan="10" align="center" class="celula"><strong>Totais</strong></td>
	  </tr>
		<tr>
			<td colspan="10" class="celula">Total Agrupamento I:<%=intTotal_AgrupamentoI%></td>
		</tr>
		<tr>
			<td colspan="10" class="celula">Total Agrupamento II:<%=intTotal_AgrupamentoII%></td>
		</tr>
		<tr>
			<td colspan="10" class="celula">Total Agrupamento III:<%=intTotal_AgrupamentoIII%></td>
		</tr>
		<tr>
			<td colspan="10" class="celula">Total Agrupamento IV:<%=intTotal_AgrupamentoIV%></td>
		</tr>
		<tr>
			<td colspan="10" class="celula">Total Agrupamento V:<%=intTotal_AgrupamentoV%></td>
		</tr>
		<tr>
			<td height="40" colspan="10" class="celula">Quantidade de Candidatos: <%=cont%></td>
		</tr>
		 <%
	else
		%>
		  <tr>
			<td height="48" colspan="10" align="center" class="celula"><p><br>
	          <br>
            <font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></p></td>
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
