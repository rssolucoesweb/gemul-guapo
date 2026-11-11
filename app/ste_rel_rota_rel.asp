<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
SESSION.Timeout = 1200
Server.ScriptTimeout = 1200
%>
<html>
<head>
<title>Rota</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet" href="css_rel/Estilo_Impressao.css">
<script src="js/js_funcoes_gerais.js"></script>
<script src="js_app/js_barra_movel.js"></script>
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
	
	intCodGrupo				= Session("CodGrupo") 		
	intCodRota 				= Trim(Request.Form("cmbRota"))
	intCodTurno				= Trim(Request.Form("cmbTurno"))
	strEnderecoAluno				= Trim(Request.Form("cmbEnderecoAluno"))
	strAnoLetivo			= Trim(Request.Form("txtAnoLetivo"))
	if intCodRota <> "" then
	
		sql = " SELECT r.Cod_Rota, r.Descricao, c.nome"
		sql = sql & " FROM STE_ROTA r left JOIN"
		sql = sql & " SRH_COLABORADOR c ON r.CodColaborador = c.codigo"
		sql = sql & " WHERE r.Cod_Rota = " & intCodRota
		rs.open sql, cnn
		if rs.eof = false then
			strNomeRota     = rs("Descricao")
			strMotorista	= rs("nome")
		end if
		rs.close
	
	end if 
	
	if intCodTurno <> "0" then
		sql = "select desc_turno from sca_turno where cod_turno = " & intCodTurno
		rs.open sql, cnn
		if rs.eof = false then
			strTurno     = rs("desc_turno")
		end if
		rs.close
	
	end if 
	
	strTituloRelatorio  	= "Transporte Escolar " & strAnoLetivo & "<br> " & strNomeRota
	if strMotorista<>"" then strTituloRelatorio = strTituloRelatorio & "<br>Motorista: " & strMotorista
	
	sub mostraCabecalho()
	%>
	<!--#include file="includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
	    <td width="30%" align="left" class="celula"><strong>Unidade</strong></td>
		<td width="1%" align="left" class="celula"><strong>Id</strong></td>
		<td width="21%" class="celula"><strong>Nome do Aluno</strong></td>
		<td width="17%" class="celula"><strong>Nome da M&atilde;e </strong></td>
		<td width="5%" align="left" class="celula"><strong>Data Nasc. </strong>
	    <div align="center"></div></td>
		<td width="8%" align="left" class="celula"><strong>Telefone</strong></td>
		<td width="10%" align="left" class="celula"><strong>Turma</strong></td>
		<td width="10%" align="left" class="celula"><strong>Turno</strong></td>
		<%if strEnderecoAluno="S" then%>
		<td align="left" class="celula"><strong>Logradouro</strong></td>
		<td align="left" class="celula"><strong>Número</strong></td>
		<td align="left" class="celula"><strong>Complemento</strong></td>
		<td align="left" class="celula"><strong>Bairro</strong></td>
		<td align="left" class="celula"><strong>Município</strong></td>
		<td align="left" class="celula"><strong>Cep</strong></td>
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

	sql = " select t.CODIGO, t.nome as NOMEALUNO, t.data_nascimento as DATANASCIMENTO, t.MAE, t.Contato, t.Celular, t.FonePai, t.FoneMae, "
	sql = sql & " va.CodTurma, va.cod_aluno, r.CodColaborador, r.Distancia_percorrida, tm.NomeTurma, tm.TurmaAluno, "
	sql = sql & " case"
	sql = sql & " 	when t.codigo_escola_estadual is null then Em.RAZAOSOCIAL"
	sql = sql & " 	else ee.nome"
	sql = sql & " end AS EMPRESA," 
	sql = sql & " case"
	sql = sql & " 	when t.codigo_escola_estadual is null then tu.desc_turno"
	sql = sql & " 	else t.turno_estadual"
	sql = sql & " end AS turno, "
	sql = sql & " t.LOGRADOURO, t.NumeroEndereco as NUMERO_ENDERECO, t.ComplementoEndereco as COMP_ENDERECO, t.bairro as BAIRROALUNO, "
	sql = sql & " t.cidade as CIDADERESIDENCIA, t.uf as UFRESIDENCIA, t.cep as CEPRESIDENCIA "
	sql = sql & " from ste_solicitacao_transporte t"
	sql = sql & " INNER JOIN STE_ROTA r ON r.Cod_Rota = t.Cod_Rota "
	sql = sql & " LEFT JOIN SCA_ROTA_VICULA_ALUNO va on va.cod_solicitacao_transporte = t.codigo"
	sql = sql & " LEFT JOIN SCA_TURMA tm ON tm.cod_Turma = va.codTurma"
	sql = sql & " LEFT JOIN SCA_TURNO tu ON tu.cod_turno = tm.Cod_turno" 
	sql = sql & " LEFT JOIN SEG_EMPRESA Em ON Em.CODIGO = tm.COD_EMPRESA"
	sql = sql & " LEFT JOIN ste_escola_estadual Ee ON Ee.codigo_escola_estadual = t.codigo_escola_estadual"
	sql = sql & " WHERE t.situacao='D' "
	sql = sql & " and t.ano_letivo = " & strAnoLetivo	
	sql = sql & " and t.cod_rota = " & intCodRota
	'sql = sql & " 	case "
	'sql = sql & " 		when t.codigo_escola_estadual is null then va.cod_rota"
	'sql = sql & " 		else t.cod_rota"
	'sql = sql & " 	end = " & intCodRota

	if intCodTurno<>"0" then
		sql = sql & " and (tu.desc_turno in (select desc_turno from sca_turno where cod_turno = " & intCodTurno & ") or t.turno_estadual = '" & strTurno & "')"
	end if
	
	if session("usuarioWeb") = "SERGIO"  then
		'response.write sql
	end if	
	
	sql = sql & " Order By EMPRESA, NOMEALUNO"
	rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof
			
			telefone = ""
			if not isnull(rs("Contato")) then
				telefone = rs("Contato")
			elseif not isnull(rs("Celular")) then
				telefone = rs("Celular")
			elseif not isnull(rs("FoneMae")) then
				telefone = rs("FoneMae")
			elseif not isnull(rs("FonePai")) then
				telefone = rs("FonePai")
			end if
			
			%>
			  <tr >
			    <td  class="celula" align="left"><%=rs("EMPRESA")%>&nbsp;</td>
				<td class="celula" align="left"><%=rs("codigo")%>&nbsp;</td>
				<td class="celula" align="left"><%=rs("NOMEALUNO")%>&nbsp;</td>
				<td class="celula"><%=rs("MAE")%>&nbsp;</td>
				<td align="left" class="celula"><%=formatadataAP(rs("DATANASCIMENTO"))%>&nbsp;</td>
				<td class="celula" align="left"><strong><%=telefone%>&nbsp;</strong></td>
				<td class="celula" align="left"><%=rs("NomeTurma")%>&nbsp;<%=rs("TurmaAluno")%></td>
				<td class="celula" align="left"><%=rs("turno")%>&nbsp;</td>
				<%if strEnderecoAluno="S" then%>
				<td class="celula" align="left"><%=rs("LOGRADOURO")%>&nbsp;</td>
				<td class="celula" align="left"><%=rs("NUMERO_ENDERECO")%>&nbsp;</td>
				<td class="celula" align="left"><%=rs("COMP_ENDERECO")%>&nbsp;</td>
				<td class="celula" align="left"><%=rs("BAIRROALUNO")%>&nbsp;</td>
				<td class="celula" align="left"><%=rs("CIDADERESIDENCIA")%>&nbsp;</td>
				<td class="celula" align="left"><%=rs("CEPRESIDENCIA")%>&nbsp;</td>
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
			intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
			rs.movenext
		wend
		colunas = 8
		if strEnderecoAluno="S" then
			colunas = colunas + 6
		end if
		%>
		  <tr>
			<td colspan="<%=colunas%>" bgcolor="#CCCCCC" class="celula">Quantidade de Alunos: <%=cont%></td>
		  </tr>
		 <%
	else
		colunas = 8
		if strEnderecoAluno="S" then
			colunas = colunas + 6
		end if
		%>
		  <tr>
			<td height="13" colspan="<%=colunas%>" align="center" class="celula"><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
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