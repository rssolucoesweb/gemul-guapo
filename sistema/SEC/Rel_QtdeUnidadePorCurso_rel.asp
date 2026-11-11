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
<title><%=session("Titulo")%> - Mapa Semestral de Turmas</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script>
</head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<br>
<%
	dim intPagina
	dim vetCursoPeriodo
	
	intAnoLetivoAtual	 	= Trim(Request.Form("txtAnoLetivo"))
	intSemestreAtual	 	= Trim(Request.Form("cmbSemestre"))
	intCodSituacaoAluno		= Trim(Request.Form("cmbSituacaoAluno"))
		
	strFiltroSerie = "0"
	strFiltroTurno = "0"
	
	dim strAnoCab
	strAnoCab = intAnoLetivoAtual
	
	if intCodSituacaoAluno <> "" then
	
		sql = "SELECT COD_SITUACAOALUNO, DESC_SITUACAOALUNO"
		sql = sql & " FROM SCA_SITUACAOALUNO"
		sql = sql & " WHERE cod_empresa=" & Session("CodEmpresa")
		sql = sql & " And COD_SITUACAOALUNO=" & intCodSituacaoAluno
		rs.open sql, cnn
		if rs.eof = false then
			strSITUACAOALUNO 		= Trim(rs("DESC_SITUACAOALUNO"))
		end if
		rs.close
	end if
	
	if strSITUACAOALUNO <> "" then
		strTituloRelatorio  	= "QUANTITATIVO DE ALUNOS POR CURSO E PERÍODO - " & strSITUACAOALUNO
	else
		strTituloRelatorio  	= "QUANTITATIVO DE ALUNOS POR CURSO E PERÍODO "
	end if
	
	function buscaTotalGeral(Curso, Periodo, strAno, strSemestre)
		intQtdeAluno = 0
		sql = "select	count(at.cod_aluno) as alunos"
		sql = sql & " from	sca_aluno_turma at"
		sql = sql & " INNER JOIN sca_turma t on t.cod_turma = at.cod_turma and t.anoletivo = at.ano_letivo and at.cod_empresa = t.cod_empresa"
		sql = sql & " INNER JOIN SCA_TURNO tu ON tu.Cod_TURNO = t.Cod_TURNO and tu.cod_empresa = t.cod_empresa "
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR g ON t.Cod_GradeCurricular = g.Cod_GradeCurricular and t.cod_empresa = g.cod_empresa "
		sql = sql & " INNER JOIN SCA_PERIODO p ON p.Cod_Periodo = g.Cod_Periodo and p.cod_empresa = g.cod_empresa "
		sql = sql & " INNER JOIN SCA_CURSO c ON c.Cod_Curso = p.Cod_Curso and c.cod_empresa = p.cod_empresa "
		sql = sql & " INNER JOIN SEG_EMPRESA e ON e.codigo = at.cod_empresa"
		SQL = SQL & " INNER JOIN SCA_ALUNO ON SCA_ALUNO.CODIGO = at.COD_ALUNO AND at.COD_EMPRESA = SCA_ALUNO.COD_EMPRESA "
		SQL = SQL & " INNER JOIN SCA_SITUACAOALUNO ON SCA_ALUNO.COD_SITUACAOALUNO = SCA_SITUACAOALUNO.COD_SITUACAOALUNO AND at.COD_EMPRESA = SCA_ALUNO.COD_EMPRESA "
		sql = sql& " where	at.cod_empresa in (" & Session("CodTodasEmpresaGrupo") & ")"
		sql = sql & " and		at.situacao = 'A'"
		sql = sql & " and		at.ano_letivo = " & strAno
		sql = sql & " and		at.semestre = " & strSemestre
		sql = sql & " and		c.descricao = '" & Curso & "'"
		sql = sql & " and		p.descricao = '" & Periodo & "'"
		
		if trim(strSITUACAOALUNO) <> "" then
			SQL = SQL & " and SCA_SITUACAOALUNO.Desc_SituacaoAluno = '" & trim(strSITUACAOALUNO) & "'"
		end if
			
		rsAux.open sql, cnn		
		if rsAux.eof = false then
			intQtdeAluno = rsAux("alunos")
		end if
		rsAux.close
		buscaTotalGeral = intQtdeAluno
	end function	
	function buscaQtde(Curso, Periodo, codEmpresa, strAno, strSemestre)
		intQtdeAluno = 0
		sql = "select	count(at.cod_aluno) as alunos"
		sql = sql & " from	sca_aluno_turma at"
		sql = sql & " INNER JOIN sca_turma t on t.cod_turma = at.cod_turma and t.anoletivo = at.ano_letivo and at.cod_empresa = t.cod_empresa"
		sql = sql & " INNER JOIN SCA_TURNO tu ON tu.Cod_TURNO = t.Cod_TURNO and tu.cod_empresa = t.cod_empresa "
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR g ON t.Cod_GradeCurricular = g.Cod_GradeCurricular and t.cod_empresa = g.cod_empresa "
		sql = sql & " INNER JOIN SCA_PERIODO p ON p.Cod_Periodo = g.Cod_Periodo and p.cod_empresa = g.cod_empresa "
		sql = sql & " INNER JOIN SCA_CURSO c ON c.Cod_Curso = p.Cod_Curso and c.cod_empresa = p.cod_empresa "
		sql = sql & " INNER JOIN SEG_EMPRESA e ON e.codigo = at.cod_empresa"
		SQL = SQL & " INNER JOIN SCA_ALUNO ON SCA_ALUNO.CODIGO = at.COD_ALUNO AND at.COD_EMPRESA = SCA_ALUNO.COD_EMPRESA "
		SQL = SQL & " INNER JOIN SCA_SITUACAOALUNO ON SCA_ALUNO.COD_SITUACAOALUNO = SCA_SITUACAOALUNO.COD_SITUACAOALUNO AND at.COD_EMPRESA = SCA_ALUNO.COD_EMPRESA "
		sql = sql & " where	at.cod_empresa = " & codEmpresa
		sql = sql & " and		at.situacao = 'A'"
		sql = sql & " and		at.ano_letivo = " & strAno
		sql = sql & " and		at.semestre = " & strSemestre
		sql = sql & " and		c.descricao = '" & Curso & "'"
		sql = sql & " and		p.descricao = '" & Periodo & "'"
		
		if trim(strSITUACAOALUNO) <> "" then
			SQL = SQL & " and SCA_SITUACAOALUNO.Desc_SituacaoAluno = '" & trim(strSITUACAOALUNO) & "'"
		end if
	
		rsAux.open sql, cnn		
	
		if rsAux.eof = false then
			intQtdeAluno = rsAux("alunos")
		end if
		rsAux.close
		buscaQtde = intQtdeAluno
	end function
	
	sql = "select	codigo as cod_empresa, RAZAOSOCIAL as empresa"
	sql = sql& " from SEG_EMPRESA"
	sql = sql& " where	codigo in (" & Session("CodTodasEmpresaGrupo") & ")"
	sql = sql& " order by RAZAOSOCIAL"
	vetEmpresa = null
	rs.open sql, cnn
	if not rs.eof then
		vetEmpresa = rs.getRows
	end if
	rs.close		
	
	sql = "select distinct '0' as Cod_Curso, c.descricao as curso"
	sql = sql& " from	sca_aluno_turma at"
	sql = sql& " INNER JOIN sca_turma t on t.cod_turma = at.cod_turma and t.anoletivo = at.ano_letivo and at.cod_empresa = t.cod_empresa"
	sql = sql& " INNER JOIN SCA_TURNO tu ON tu.Cod_TURNO = t.Cod_TURNO and tu.cod_empresa = t.cod_empresa "
	sql = sql& " INNER JOIN SCA_GRADECURRICULAR g ON t.Cod_GradeCurricular = g.Cod_GradeCurricular and t.cod_empresa = g.cod_empresa "
	sql = sql& " INNER JOIN SCA_PERIODO p ON p.Cod_Periodo = g.Cod_Periodo and p.cod_empresa = g.cod_empresa "
	sql = sql& " INNER JOIN SCA_CURSO c ON c.Cod_Curso = p.Cod_Curso and c.cod_empresa = p.cod_empresa "
	sql = sql& " INNER JOIN SEG_EMPRESA e ON e.codigo = at.cod_empresa"
	SQL = SQL & " INNER JOIN SCA_ALUNO ON SCA_ALUNO.CODIGO = at.COD_ALUNO AND at.COD_EMPRESA = SCA_ALUNO.COD_EMPRESA "
	SQL = SQL & " INNER JOIN SCA_SITUACAOALUNO ON SCA_ALUNO.COD_SITUACAOALUNO = SCA_SITUACAOALUNO.COD_SITUACAOALUNO AND at.COD_EMPRESA = SCA_ALUNO.COD_EMPRESA "
	sql = sql& " where	at.cod_empresa in (" & Session("CodTodasEmpresaGrupo") & ")"
	sql = sql& " and		at.situacao = 'A'"
	sql = sql& " and		at.ano_letivo = " & intAnoLetivoAtual
	sql = sql& " and		at.semestre = " & intSemestreAtual
	
	if trim(strSITUACAOALUNO) <> "" then
		SQL = SQL & " and SCA_SITUACAOALUNO.Desc_SituacaoAluno = '" & trim(strSITUACAOALUNO) & "'"
	end if
		
	sql = sql& " order by 1,c.descricao"
	
	vetCurso = null
	rs.open sql, cnn
	if not rs.eof then
		vetCurso = rs.getRows
	end if
	rs.close
	if not isArray(vetCurso) then
	%>
		<script>
			alert("ATENÇÃO: Não foi encontrado informações para gerar esse relatório (curso).");
			window.history.back();
		</script>
		<%
	end if

	sub buscaPeriodo (Curso, strAno, strSemestre)
		sql = "select	c.descricao as curso, p.descricao as periodo"
		sql = sql& " from	sca_aluno_turma at"
		sql = sql& " INNER JOIN sca_turma t on t.cod_turma = at.cod_turma and t.anoletivo = at.ano_letivo and at.cod_empresa = t.cod_empresa"
		sql = sql& " INNER JOIN SCA_TURNO tu ON tu.Cod_TURNO = t.Cod_TURNO and tu.cod_empresa = t.cod_empresa "
		sql = sql& " INNER JOIN SCA_GRADECURRICULAR g ON t.Cod_GradeCurricular = g.Cod_GradeCurricular and t.cod_empresa = g.cod_empresa "
		sql = sql& " INNER JOIN SCA_PERIODO p ON p.Cod_Periodo = g.Cod_Periodo and p.cod_empresa = g.cod_empresa "
		sql = sql& " INNER JOIN SCA_CURSO c ON c.Cod_Curso = p.Cod_Curso and c.cod_empresa = p.cod_empresa "
		sql = sql& " INNER JOIN SEG_EMPRESA e ON e.codigo = at.cod_empresa"
		sql = sql & " where	at.cod_empresa in (" & Session("CodTodasEmpresaGrupo") & ")"
		sql = sql & " and		at.situacao = 'A'"
		sql = sql & " and		at.ano_letivo = " & strAno
		sql = sql & " and		at.semestre = " & strSemestre
		sql = sql & " and		c.descricao = '" & Curso & "'"
		sql = sql& " group by c.descricao, p.descricao"
		sql = sql& " order by c.descricao, p.descricao"
		vetCursoPeriodo = null
		rs.open sql, cnn
		if not rs.eof then
			vetCursoPeriodo = rs.getRows
		end if
		rs.close
		if not isArray(vetCursoPeriodo) then
			%>
			<script>
				alert("ATENÇÃO: Não foi encontrado informações para gerar esse relatório (período).");
				window.history.back();
			</script>
			<%
		end if
	end sub
	
		
	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorioGrupo.asp"-->
	<br>
		<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub
	
	intPagina = 1
	mostraCabecalho
	cont = 0
	
	
	for y=0 to ubound(vetCurso,2)
		strDescCurso = vetCurso(1,y)
		buscaPeriodo strDescCurso, intAnoLetivoAtual, intSemestreAtual
		%>
		<table width="98%" border="1" cellspacing="0" cellpadding="0" class="tabela" align="center">
		  <tr bgcolor="#CCCCCC">
			<td width="36%" rowspan="2"  class="celula" align="center"><strong>Unidade de Ensino</strong></td>
			<td width="50%" class="celula" colspan="<%=ubound(vetCursoPeriodo,2)+1%>"><div align="center"><strong><%=strDescCurso%></strong></div></td>
			<td width="14%" rowspan="2" class="celula"><div align="center"><strong>Total de Alunos</strong></div></td>
		  </tr>
		<tr>
		<%
		for j=0 to ubound(vetCursoPeriodo,2)
			strCurso = vetCursoPeriodo (0,j)
			strPerido = vetCursoPeriodo (1,j)
			%>
			<td class="celula" align="center"><strong><%=strPerido%></strong></td>
			<%
		next
			%>
		  </tr>
		<%
		
		for i=0 to ubound(vetEmpresa,2)
			codEmpresa = vetEmpresa (0,i)
			strEmpresa = vetEmpresa (1,i)
			intTotalAluno = 0
			
				strTagColuna = ""
				
                for j=0 to ubound(vetCursoPeriodo,2)
                    strCurso = vetCursoPeriodo (0,j)
                    strPerido = vetCursoPeriodo (1,j)
                    intAluno = buscaQtde (strCurso, strPerido, codEmpresa, intAnoLetivoAtual, intSemestreAtual)
                    
					strTagColuna = strTagColuna & " <td class='celula' align='center'>" & intAluno & "</td>"
                    intTotalAluno = intTotalAluno + intAluno
                next
                if intTotalAluno <> 0 then
				%>
                    <tr>
                        <td height="20" class="celula"><%=Ucase(strEmpresa)%></td>
                        <%=strTagColuna%>
                        <td class="celula" align="center"><strong><%=intTotalAluno%></strong></td>
                    </tr>
		  <%
				end if
		next
		%>
		 <tr bgcolor="#F3F3F3">
				<td class="celula"><strong>Total Geral</strong></td>
				<%
				intTotalAlunoGeral = 0
	
				for j=0 to ubound(vetCursoPeriodo,2)
					strCurso = vetCursoPeriodo (0,j)
					strPerido = vetCursoPeriodo (1,j)
					intAlunoGeral = buscaTotalGeral (strCurso, strPerido, intAnoLetivoAtual, intSemestreAtual)
					%>
					<td class="celula" align="center"><strong><%=intAlunoGeral%></strong></td>
					<%
					intTotalAlunoGeral = intTotalAlunoGeral + intAlunoGeral
				next
			%>
				<td class="celula" align="center"><strong><%=intTotalAlunoGeral%></strong></td>
		  </tr>
	</table>
    <br><br>
<%
next
	%>
     <table width="36%" border="1" cellspacing="0" cellpadding="0" class="tabela" align="center">
          <tr>
       		  <td height="16" colspan="2" align="center" bgcolor="#CCCCCC" class="celula"><strong>Resumo por Curso</strong></td>
	   </tr>
       <%
		  intTotalAlunoGeralTodos = 0
		  
		for y=0 to ubound(vetCurso,2)
		
		strDescCurso = vetCurso(1,y)
		buscaPeriodo strDescCurso, intAnoLetivoAtual, intSemestreAtual
		%>
       		
       		<tr>
            <td width="70%" class="celula"><%=strDescCurso%></td>
            <%
				intTotalAlunoGeral = 0
	
				for j=0 to ubound(vetCursoPeriodo,2)
					strCurso = vetCursoPeriodo (0,j)
					strPerido = vetCursoPeriodo (1,j)
					intAlunoGeral = buscaTotalGeral (strCurso, strPerido, intAnoLetivoAtual, intSemestreAtual)
					intTotalAlunoGeral = intTotalAlunoGeral + intAlunoGeral
				next
				
				intTotalAlunoGeralTodos = intTotalAlunoGeralTodos + intTotalAlunoGeral
			%>
            
            <td width="30%" class="celula" ><strong><%=intTotalAlunoGeral%></strong></td>
         	</tr>
		<%
        next
        %>
          <tr>
            <td bgcolor="#CCCCCC" class="celula"><strong>Total Geral:</strong></td>
            <td bgcolor="#CCCCCC" class="celula"><strong><%=intTotalAlunoGeralTodos%></strong></td>
          </tr>
</table>
        <br><br>
<script>
	aguarde.style.display="none";
</script>
</body>
</html>
