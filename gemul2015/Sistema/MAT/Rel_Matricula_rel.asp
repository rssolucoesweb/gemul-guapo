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
<!--include file="../../includes/inc_Botoes_relatorio.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<br>
<%
	dim intPagina
	strCod_empresa 			= Session("CodEmpresa")
	
	intCodEmpresaUsuario 	= request.Form("cmdEmpresaUsuario")
	intOrdenacao 			= request.Form("cmbOrdenacao")
	strBolsaFamilia			= request.Form("cmbBolsaFamilia")
	strTipoEmpresa			= request.Form("cmbTipoEmpresa")
	strAlunoMae				= request.Form("cmbAlunoMae")
	strTituloRelatorio  	= "Rela&ccedil;&atilde;o de Matrícula " & Session("MatriculaInformatizadaAnoEfetivacao")
	
	sub mostraCabecalho()
%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
		<td width="5%" class="celula"><strong>C&oacute;d. Aluno</strong></td>
		<td width="5%" class="celula"><strong>B.Fam&iacute;lia</strong></td>
		<td width="5%" class="celula"><strong>Matr&iacute;cula</strong></td>
        <%if strAlunoMae = "S" then %>
		<td width="16%" class="celula"><strong>Nome Aluno</strong></td>
        <td width="17%" class="celula"><strong>M&atilde;e</strong></td>
        <%end if%>
		<td width="5%" class="celula"><strong>Data Nasc.</strong></td>
		<td width="6%" class="celula"><strong>Ser&iacute;e</strong></td>
		<td width="6%" class="celula"><strong>Turno</strong></td>
		<td width="8%" class="celula"><strong>Curso</strong></td>
		<td width="23%" class="celula"><strong>Escola</strong></td>
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
	
	sql = "SELECT MT.Codigo, MT.cod_aluno, MT.matricula, MT.nome, MT.data_nascimento, MT.mae, MT.cep, MT.Logradouro, "
	sql = sql & " MT.bairro, MT.cidade, MT.email, MT.Cod_periodo, MT.Cod_turno, MT.Cod_empresa, "
	sql = sql & " PE.Descricao, T.DESC_TURNO, SEG_EMPRESA.RAZAOSOCIAL, C.Descricao as Curso, MT.bolsa_familia"
	sql = sql & " FROM MAT_inscricao  MT "
	sql = sql & " inner join SCA_PERIODO PE on PE.Cod_Periodo = MT.Cod_periodo"
	sql = sql & " inner join SCA_CURSO C on C.Cod_curso = PE.Cod_Curso"
	sql = sql & " inner join SCA_TURNO T on T.COD_TURNO = MT.Cod_turno"
	SQL = SQL & " INNER JOIN SEG_EMPRESA ON SEG_EMPRESA.CODIGO = MT.COD_EMPRESA"
	sql = sql & " where  MT.Situacao = 'S' and MT.excluido = 'N' "
	
	if strTipoEmpresa <> "0" then
		sql = sql & " And  SEG_EMPRESA.codTipoEmpresa = " & strTipoEmpresa 
	end if
	
	if intCodEmpresaUsuario <> "0" then
		sql = sql & " And  MT.Cod_empresa = " & intCodEmpresaUsuario 
	end if
	
	if strBolsaFamilia = "N" then
		sql = sql & " And  MT.bolsa_familia is null"
	end if
	if strBolsaFamilia = "S" then
		sql = sql & " And  MT.bolsa_familia is not null"
	end if
	
	if intOrdenacao = 1 then 
		sql = sql & " order by Codigo"
	end if
	
	if intOrdenacao = 2 then 
		sql = sql & " order by nome"
	end if
	
	if intOrdenacao = 3 then 
		sql = sql & " order by Descricao"
	end if
	
	if intOrdenacao = 4 then 
		sql = sql & " order by SEG_EMPRESA.RAZAOSOCIAL, nome"
	end if

	rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof
			%>
			  <tr>
				<td align="left" class="celula"><%=rs("cod_aluno")%></td>
				<td align="left" class="celula"><%=rs("bolsa_familia")%>&nbsp;</td>
				<td align="left" class="celula"><%=rs("matricula")%>&nbsp;</td>
                <%if strAlunoMae = "S" then %>
				<td align="left" class="celula"><%=rs("nome")%>&nbsp;</td>
                <td align="left" class="celula"><%=rs("mae")%></td>
                <%end if%>
				<td align="left" class="celula"><%=formataDataAP(rs("data_nascimento"))%>&nbsp;</td>
				<td align="left" class="celula"><%=rs("Descricao")%></td>
				<td align="left" class="celula"><%=rs("DESC_TURNO")%></td>
				<td align="left" class="celula"><%=rs("Curso")%></td>
				<td align="left" class="celula"><%=rs("RAZAOSOCIAL")%></td>
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
		%>
		  <tr>
			<td colspan="11" class="celula">Quantidade de Candidatos: <%=cont%></td>
		  </tr>
		 <%
	else
		%>
		  <tr>
			<td height="48" colspan="11" align="center" class="celula"><p><br>
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
