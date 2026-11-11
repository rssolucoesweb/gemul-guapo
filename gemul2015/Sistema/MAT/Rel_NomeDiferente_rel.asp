<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
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
<!--include file="../../includes/inc_Botoes_relatorio.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<br>
<%
	dim intPagina
	strCod_empresa 			= Session("CodEmpresa")
	intAnoLetivo 	= request.Form("txtAnoLetivo")
	if intAnoLetivo="" then intAnoLetivo = year(date)
	intCodEmpresaUsuario 	= request.Form("cmdEmpresaUsuario")
	if intCodEmpresaUsuario = "" then intCodEmpresaUsuario = "0"
	intQtde		 			= request.Form("txtQtde")
	strTituloRelatorio  	= "Rela&ccedil;&atilde;o de Matrícula <br> Alteração do Nome do Aluno e Data de Nascimento"
	
	sub mostraCabecalho()
%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
		<td width="3%" rowspan="2" class="celula"><strong>Matr&iacute;cula</strong></td>
		<td colspan="2" align="center" class="celula"><strong>Matr&iacute;cula</strong></td>
		<td colspan="2" align="center" class="celula"><strong> Cadastro</strong></td>
        <td width="18%" rowspan="2" align="center" class="celula"><strong>Escola</strong></td>
		<td colspan="2" align="center" class="celula"><strong>Altera&ccedil;&atilde;o</strong></td>
	  </tr>
	  <tr bgcolor="#CCCCCC">
	    <td width="20%" align="center" class="celula"><strong>Nome Aluno</strong></td>
	    <td width="5%" align="center" class="celula"><strong>Nascimento</strong></td>
	    <td width="20%" align="center" class="celula"><strong>Nome Aluno</strong></td>
	    <td width="5%" align="center" class="celula"><strong>Nascimento</strong></td>
	    <td width="8%" align="center" class="celula"><strong>Usuario</strong></td>
	    <td width="5%" align="center" class="celula"><strong>Data</strong></td>
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
	mostraCabecalho
	cont = 0
	cor = "bgcolor='#FFFFFF'"
	escola=""
	sql = "select distinct isnull(a.matricula,999) as matricula, o.nome_aluno_matricula, o.nome_aluno_efetivacao,data_nascimento_matricula,data_nascimento_efetivacao, e.razaosocial as escola, o.USUARIO_INCL, convert(varchar,o.DATAOCORRENCIA,111) as DATAOCORRENCIA  "
	sql = sql & " from MAT_OCORRENCIA_MATRICULA o"
	sql = sql & " inner join sca_aluno a on a.codigo = o.cod_aluno"
	sql = sql & " inner join seg_empresa e on e.codigo = o.cod_empresa"
	sql = sql & " where ((nome_aluno_matricula  collate Latin1_General_CI_AI<>nome_aluno_efetivacao  collate Latin1_General_CI_AI) or (data_nascimento_matricula<>data_nascimento_efetivacao))"
	sql = sql & " AND COD_OCORRENCIA_MATRICULA IN (select max(COD_OCORRENCIA_MATRICULA) "
	sql = sql & " 									from MAT_OCORRENCIA_MATRICULA o "
	sql = sql & " 									left join sca_aluno a on a.codigo = o.cod_aluno "
	sql = sql & " 									group by o.cod_empresa, o.cod_aluno ) "
	if intQtde <> "" and intQtde <> "0" then
		sql = sql & " and substring(o.nome_aluno_matricula collate Latin1_General_CI_AI,1,"& intQtde &") <> substring(o.nome_aluno_efetivacao collate Latin1_General_CI_AI,1,"& intQtde &") "
	end if 
	if intCodEmpresaUsuario<>"0" then
		sql = sql & " and o.cod_empresa=" & intCodEmpresaUsuario
	end if
	sql = sql & " and year(o.DATAOCORRENCIA) = " &intAnoLetivo 
	sql = sql & " order by escola, nome_aluno_matricula	"
'	response.Write(sql)
	rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof
			matricula = rs("matricula")
			if rs("matricula") = "999" then matricula = "excluída"
			
			%>
			  <tr <%=cor%>>
				<td align="left" class="celula"><%=matricula%>&nbsp;</td>
				<td align="left" class="celula"><%=rs("nome_aluno_matricula")%>&nbsp;</td>
                <td align="center" class="celula"><%=formatadataAP(rs("data_nascimento_matricula"))%></td>
                <td align="left" class="celula"><%=rs("nome_aluno_efetivacao")%></td>
                <td align="center" class="celula"><%=formatadataAP(rs("data_nascimento_efetivacao"))%></td>
				<td align="left" class="celula"><%=rs("escola")%>&nbsp;</td>
				<td align="left" class="celula"><%=rs("USUARIO_INCL")%></td>
				<td align="center" class="celula"><%=rs("DATAOCORRENCIA")%></td>
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
			escola = rs("escola")
			intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
			rs.movenext
			if not rs.eof then
				if trim(escola)<>trim(rs("escola")) then
					if cor = "bgcolor='#FFFFFF'" then
						cor = "bgcolor='#C4E1FF'"
					else
						cor = "bgcolor='#FFFFFF'"
					end if
				end if
			end if
			
		wend
		%>
		  <tr>
			<td colspan="8" class="celula">Quantidade de alunos: <%=cont%></td>
		  </tr>
		 <%
	else
		%>
		  <tr>
			<td height="48" colspan="6" align="center" class="celula"><p><br>
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
