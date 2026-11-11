<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false

SESSION.Timeout = 1200
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 19/07/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Mapa Verificação de Notas
    ::	Obs...............: Hoje Aniversario do meu filho gustavo
-->
<html>
<head>
<title><%=session("Titulo")%> - Mapa Verificação de Notas</title>
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
	
	intCodEmpresa				= Session("CodEmpresa")
	intCodEmpresaGrupo		    = Trim(Request.Form("cmbEmpresaGrupo"))
	strAnoLetivo 				= Trim(Request.Form("txtAnoLetivo"))
	intSemestre 				= Trim(Request.Form("cmbSemestre"))
	intCodCurso	 				= Trim(Request.Form("cmbCurso"))
	intCodDisciplinaCurso		= Trim(Request.Form("cmbDisciplinaCurso"))
	strTipoNota	 				= Trim(Request.Form("chkTipoNota"))
	
	if intCodSemestre = "" then intCodSemestre = "0"
	if intCodDisciplinaCurso = "" then intCodDisciplinaCurso = "0"

	strTituloRelatorio  	= "MAPA DE VERIFICAÇÃO DE NOTAS"
	
	dim strAnoCab
	strAnoCab = intAnoLetivoAtual
	
	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorioGrupo.asp"-->
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
	  <tr bgcolor="#CCCCCC">
	    <td width="25%" class="celula"><strong>Empresa</strong></td>
		<td width="34%" class="celula"><strong>Turma</strong></td>
		<td width="9%" class="celula"><strong>Disciplina</strong></td>
	    <td width="10%" align="center" class="celula"><strong>Notas Lan&ccedil;adas</strong></td>
	    <td width="13%" align="center" class="celula"><strong>Notas N&atilde;o Lan&ccedil;adas</strong></td>
	    <td width="9%" align="center" class="celula"><strong>Total Alunos</strong></td>
      </tr>
	<%
	end Sub
	
	sub quebraTurma() 
	  %>
	  <tr bgcolor="#E2E2E2">
	    <td class="celula"><%=strInfoEmpresa%>&nbsp;</td>
	    <td class="celula"><%=strInfoTurma%>&nbsp;</td>
        <td class="celula"><%=strDisciplina%></td>
	    <td align="center" class="celula"><%=strNotasLancadas%></td>
	    <td align="center" class="celula"><%=strNotasNaoLancadas%></td>
	    <td align="center" class="celula"><%=strTotalAlunos%></td>
      </tr>
	  <%
	end Sub	
	
	
	sub fimTabela()
		response.Write("</table>")
	end Sub
	
	intPagina = 1
	mostraCabecalho
	cont = 0
	
	sql = " SELECT TA.posicao"
	sql = sql & " FROM SCA_CRITERIO_AVALIACAO CA "
	sql = sql & " INNER JOIN SCA_AVALIACAO A ON A.CODCRITERIOAVALIACAO = CA.CODIGO AND A.COD_EMPRESA = CA.COD_EMPRESA "
	sql = sql & " INNER JOIN SCA_TIPO_AVALIACAO TA ON A.CODTIPOAVALIACAO = TA.CODIGO AND A.COD_EMPRESA = TA.COD_EMPRESA AND CA.COD_CURSO = TA.COD_CURSO "
	sql = sql & " INNER JOIN SCA_TIPO_AVALIACAO_AGRUPAMENTO TAA ON TAA.CODIGO = TA.BIMESTRE "
	sql = sql & " WHERE CA.COD_EMPRESA = " & intCodEmpresa
	sql = sql & " AND CA.COD_CURSO = " & intCodCurso
	sql = sql & " AND TA.digitar = 'S' "
	sql = sql & " AND TA.codigo = " & strTipoNota
	rs.open sql, cnn
	
	if rs.eof = false then
		intPosicao	= rs("posicao")
	end if 
	rs.close
	
	sql = " SELECT distinct SCA_PERIODO.cod_Periodo, "
	sql = sql & " SCA_PERIODO.DESCRICAO AS PERIODO," 
	sql = sql & " SCA_CURSO.Cod_curso, "
	sql = sql & " SCA_CURSO.DESCRICAO AS CURSO, "
	sql = sql & " SCA_TURMA.COD_TURMA, "
	sql = sql & " SCA_TURMA.NomeTurma, "
	sql = sql & " SCA_TURNO.DESC_TURNO AS TURNO, "
	sql = sql & " SEG_EMPRESA.RAZAOSOCIAL as empresa, "
	sql = sql & " SEG_EMPRESA.Codigo as CodigoEmpresa, "
	sql = sql & " SCA_DISCIPLINA.Desc_Disciplina,"
	sql = sql & " SCA_DISCIPLINA.Cod_Disciplina"
	sql = sql & " FROM SCA_ALUNO_TURMA  "
	sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma AND SCA_ALUNO_TURMA.ANO_LETIVO = SCA_TURMA.AnoLetivo AND SCA_ALUNO_TURMA.SEMESTRE = SCA_TURMA.Cod_Semestre AND SCA_ALUNO_TURMA.cod_empresa = SCA_TURMA.cod_empresa "
	sql = sql & " INNER JOIN SCA_TURNO ON SCA_TURNO.Cod_TURNO = SCA_TURMA.Cod_TURNO and SCA_TURNO.cod_empresa = SCA_TURMA.cod_empresa "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
	sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA ON SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
	sql = sql & " INNER JOIN SCA_DISCIPLINA ON SCA_DISCIPLINA.Cod_Disciplina = SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina "
	sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_Periodo = SCA_GRADECURRICULAR.Cod_Periodo and SCA_PERIODO.cod_empresa = SCA_GRADECURRICULAR.cod_empresa "
	sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_Curso = SCA_PERIODO.Cod_Curso and SCA_CURSO.cod_empresa = SCA_PERIODO.cod_empresa "
	sql = sql & " INNER JOIN SEG_EMPRESA ON SEG_EMPRESA.CODIGO = SCA_TURMA.cod_empresa "
	sql = sql & " where SCA_TURMA.cod_empresa = " & intCodEmpresa
	sql = sql & " and SCA_ALUNO_TURMA.situacao = 'A' "
	sql = sql & " and SCA_ALUNO_TURMA.Ano_Letivo = " & strAnoLetivo
	sql = sql & " and SCA_ALUNO_TURMA.SEMESTRE = " & intSemestre
	sql = sql & " and SCA_CURSO.Cod_Curso = " & intCodCurso
	
	if intCodDisciplinaCurso <> "0" then
		sql = sql & " and SCA_DISCIPLINA.Cod_Disciplina = " & intCodDisciplinaCurso
	end if
	
	sql = sql & " Order By SEG_EMPRESA.RAZAOSOCIAL, SCA_TURMA.NomeTurma "
	rs.open sql, cnn
	if not rs.eof then
		While not rs.eof
		
			sql = " Select count(nota" & ZeroLeft(intPosicao,2) & ") As NotasNaoLancadas"
			sql = sql & " From SCA_NOTAS_FALTAS "
			sql = sql & " inner join SCA_PERIODO on SCA_PERIODO.Cod_Periodo = SCA_NOTAS_FALTAS.Cod_Periodo "
			sql = sql & " inner join SCA_ALUNO_DISCIPLINA on SCA_ALUNO_DISCIPLINA.CODIGO = SCA_NOTAS_FALTAS.cod_aluno_disciplina"
			sql = sql & " where SCA_NOTAS_FALTAS.cod_disciplina = " & trim(rs("Cod_Disciplina")) 
			sql = sql & " And SCA_ALUNO_DISCIPLINA.COD_TURMA = " & trim(rs("COD_TURMA")) 
			sql = sql & " and isnull(SCA_NOTAS_FALTAS.nota02,'0') = '0'"
			rsAux.open sql, cnn
			
			if rsAux.eof = false then
				strNotasNaoLancadas = rsAux("NotasNaoLancadas")
			end if 
			rsAux.close
			
			sql = " Select count(nota" & ZeroLeft(intPosicao,2) & ") As NotasNaoLancadas"
			sql = sql & " From SCA_NOTAS_FALTAS "
			sql = sql & " inner join SCA_PERIODO on SCA_PERIODO.Cod_Periodo = SCA_NOTAS_FALTAS.Cod_Periodo "
			sql = sql & " inner join SCA_ALUNO_DISCIPLINA on SCA_ALUNO_DISCIPLINA.CODIGO = SCA_NOTAS_FALTAS.cod_aluno_disciplina"
			sql = sql & " where SCA_NOTAS_FALTAS.cod_disciplina = " & trim(rs("Cod_Disciplina"))    
			sql = sql & " And SCA_ALUNO_DISCIPLINA.COD_TURMA = " & trim(rs("COD_TURMA")) 
			sql = sql & " and isnull(SCA_NOTAS_FALTAS.nota02,'0') = '0'"
			rsAux.open sql, cnn
			
			if rsAux.eof = false then
				strNotasNaoLancadas = rsAux("NotasNaoLancadas")
			end if 
			rsAux.close
			
			sql = " Select count(nota" & ZeroLeft(intPosicao,2) & ") As NotasLancadas"
			sql = sql & " From SCA_NOTAS_FALTAS "
			sql = sql & " inner join SCA_PERIODO on SCA_PERIODO.Cod_Periodo = SCA_NOTAS_FALTAS.Cod_Periodo "
			sql = sql & " inner join SCA_ALUNO_DISCIPLINA on SCA_ALUNO_DISCIPLINA.CODIGO = SCA_NOTAS_FALTAS.cod_aluno_disciplina"
			sql = sql & " where SCA_NOTAS_FALTAS.cod_disciplina = " & trim(rs("Cod_Disciplina")) 
			sql = sql & " And SCA_ALUNO_DISCIPLINA.COD_TURMA = " & trim(rs("COD_TURMA")) 
			rsAux.open sql, cnn
			
			if rsAux.eof = false then
				strNotasLancadas = rsAux("NotasLancadas")
			end if 
			rsAux.close
	
			IF intCodTurma <> RS("COD_TURMA") then
			
			    if strMarcaEmpresa <>  trim(RS("empresa")) then
				   strInfoEmpresa =  "<strong>" & RS("empresa") & "</strong>"
				else   
				   strInfoEmpresa = ""
				end if   
				
				strInfoTurma =  "<strong>" & RS("NomeTurma") & "</strong> - " & RS("CURSO") & " - " & RS("PERIODO")
				strTurno	 = RS("TURNO")

			END IF
			
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
			
			cont = cint(cont) + 1
		
			intCodTurma 		= RS("COD_TURMA") 
			strMarcaEmpresa 	= TRIM(RS("empresa"))
			strDisciplina		= trim(RS("Desc_Disciplina"))
			strTotalAlunos		= cint(strNotasLancadas) + cint(strNotasNaoLancadas)
			quebraTurma
			
			rs.movenext
		wend
		%>
		  <tr>
			<td colspan="6" class="celula">&nbsp;</td>
		  </tr>
		 <%
		else
		%>
		  <tr>
			<td height="62" colspan="6" align="center" class="celula"><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
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