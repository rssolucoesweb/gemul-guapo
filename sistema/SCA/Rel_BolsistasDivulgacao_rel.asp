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
<title><%=session("Titulo")%> - Alunos Por Turma</title>
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
	dim strInfoTurma
	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"
	strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"
	
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	intCodSituacaoAluno		= Trim(Request.Form("cmbSituacaoAluno"))
	strOrdem				= Trim(Request.Form("cmbOrdem"))
	strQuebraPagina			= Trim(Request.Form("cmbQuebraPagina"))
	intCodCategoriaDesconto	= Trim(Request.Form("cmbCategoriaDesconto"))

	intCodTurno		 		= Trim(Request.Form("cmbTurno"))
	strSemestre 			= session("strSemestre")
	strAnoLetivo 			= session("strAnoLetivo")
    strSubTitulo 			= Trim(Request.Form("txtSubTitulo"))


	strFiltroSerie = "0"
	strFiltroTurno = "0"

	if intCodComp = "" then intCodComp = "0"
	if intCodSerie = "" then intCodSerie = "0"
	if intCodTurno = "" then intCodTurno = "0"
	if intCodTurma = "" then intCodTurma = "0"
	if intCodSemestre = "" then intCodSemestre = "0"
	
	strTituloRelatorio  	= "BOLSISTAS"

	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <%
	  if strSubTitulo <> "" then
	     %>
	     <tr bgcolor="#CCCCCC">
	     <td colspan="5" class="celula"><div align="center"><%=strSubTitulo%>&nbsp;</div></td>
         </tr>
		 <%
	  end if	
	  %> 
	  <tr bgcolor="#CCCCCC">
	    <td colspan="4" class="celula"><strong>Curso: <%=strInfoTurma%></strong></td>
      </tr>
	  <tr bgcolor="#CCCCCC">
		<td width="8%" class="celula"><div align="center"><strong>Ordem</strong></div></td>
		<td width="11%" class="celula"><div align="center"><strong>Matr&iacute;cula</strong></div></td>
		<td width="55%" class="celula"><div align="left"><strong>&nbsp;&nbsp;Nome do Aluno</strong></div></td>
	    <td width="26%" class="celula"><strong>&nbsp;&nbsp;Descri&ccedil;&atilde;o da Bolsa </strong></td>
	  </tr> 
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub


	intPagina = 1
	cont = 0
	
	sql = "select a.matricula, a.nomealuno, a.perc_desconto, cd.descricao as origem, at.COD_TURMA, t.nomeTurma, SCA_PERIODO.Descricao as periodo, SCA_CURSO.Descricao as curso, SCA_CURSO.Cod_Curso  "
	sql = sql & " from sca_aluno a"
	sql = sql & " inner join sca_aluno_turma at on at.COD_ALUNO = a.CODIGO and at.cod_empresa = a.cod_empresa"
	sql = sql & " inner join scf_categoria_desconto cd on cd.codigo = a.cod_categoria_desconto and cd.cod_empresa = a.cod_empresa"
	sql = sql & " INNER JOIN SCA_TURMA t ON at.COD_TURMA = t.Cod_Turma AND at.ANO_LETIVO = t.AnoLetivo AND at.SEMESTRE = t.Cod_Semestre AND at.cod_empresa = t.cod_empresa "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON t.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
	sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_Periodo = SCA_GRADECURRICULAR.Cod_Periodo and SCA_PERIODO.cod_empresa = SCA_GRADECURRICULAR.cod_empresa "
	sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_Curso = SCA_PERIODO.Cod_Curso and SCA_CURSO.cod_empresa = SCA_PERIODO.cod_empresa "
	sql = sql & " where	a.perc_desconto is not null"
	sql = sql & " and		at.situacao = 'A'"
	sql = sql & " and		t.cod_empresa = " & session("CodEmpresa")
	sql = sql & " and		at.Ano_Letivo = " & strAnoLetivo
	sql = sql & " and		at.Semestre in (" & strSemestre & ")"
	if intCodCurso <> "0" then
		sql = sql & " and SCA_CURSO.Cod_Curso = " & intCodCurso
	end if
	if intCodPeriodo <> "0" then
		sql = sql & " and SCA_GRADECURRICULAR.Cod_Periodo = " & intCodPeriodo
	end if
	if intCodTurno <> "0" then
		sql = sql & " and t.COD_TURNO = " & intCodTurno
	end if
	if intCodTurma <> "0" then
		sql = sql & " and at.COD_TURMA = " & intCodTurma
	end if
	if intCodSituacaoAluno <> "0" then
		sql = sql & " and a.COD_SITUACAOALUNO = " & intCodSituacaoAluno
	end if
	if intCodCategoriaDesconto <> "0" then
		sql = sql & " and a.cod_categoria_desconto = " & intCodCategoriaDesconto
	end if
	'ordem de classificação do relatorio
	 if strOrdem = "alfabetica" then
	 	sql = sql & " Order By SCA_CURSO.Cod_Curso, a.NOMEALUNO"
	 elseif strOrdem = "matricula" then
	 	sql = sql & " Order By SCA_CURSO.Cod_Curso, a.matricula"
	 elseif strOrdem = "datamatricula" then
	 	sql = sql & " Order By SCA_CURSO.Cod_Curso, a.datamatricula"
	 elseif strOrdem = "dataafastamento" then
'	 verificar qual o campos data afastamento no cadastro
	 	sql = sql & " Order By SCA_CURSO.Cod_Curso, a.NOMEALUNO"
	 elseif strOrdem = "idade" then
	 	sql = sql & " Order By SCA_CURSO.Cod_Curso, a.DATANASCIMENTO"
	 elseif strOrdem = "bairro" then
	 	sql = sql & " Order By SCA_CURSO.Cod_Curso, a.CIDADERESIDENCIA"
	 end if
	rs.open sql, cnn
	if not rs.eof then 
		IntOrd = 1
		strInfoTurma = trim(rs("Curso"))
		if intCodTurma <>"" and intCodturma<>0 then
		   strInfoTurma = strInfoTurma & " - " & trim(rs("nomeTurma"))
		end if   
		mostraCabecalho
		While not rs.eof
			%>
			  <tr>
				<td class="celula" align="left"><div align="center"><%=IntOrd%>&nbsp;</div></td>
				<td class="celula" align="left"><div align="center"><%=rs("MATRICULA")%></div></td>
				<td align="left" class="celula">&nbsp;&nbsp;<%=rs("NOMEALUNO")%></td>
			    <td align="left" class="celula">&nbsp;&nbsp;<%=rs("ORIGEM")%></td>
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
			IntOrd = IntOrd + 1
			rs.movenext
		wend
		%>
	    <tr>
		   <td colspan="4" class="celula" align="right"><strong>Total Geral de Bolsas: <%=cont%></strong>&nbsp;&nbsp;</td>
	    </tr>
		<%
	else
	    mostraCabecalho
		%>
		  <tr>
			<td colspan="4" class="celula" align="center"><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
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
