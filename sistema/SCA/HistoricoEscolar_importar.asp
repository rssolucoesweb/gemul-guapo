<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 23/05/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: historico escolar
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formataData.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	'cnn.begintrans
	
	intCodEmp			= Session("CodEmpresa")
	intCodAluno			= Trim(Request.Form("txtCodAluno"))
	strMatricula		= Trim(Request.Form("txtMatricula"))

	'busca dados do historico (sistema anterior)
	sql="select	distinct "
	sql=sql & " 		a.codigo as cod_aluno,"
	sql=sql & " 		8 as cod_empresa,"
	sql=sql & " 		t.AnoLetivo,"
	sql=sql & " 		t.Cod_Semestre,"
	sql=sql & " 		'ASSOC. EDUC. NOSSA SENHORA APARECIDA'  as estabelecimento,"
	sql=sql & " 		h.cidadeest as cidade,"
	sql=sql & " 		9 as estado,"
	sql=sql & " 		c.descricao as curso,"
	sql=sql & " 		p.descricao as serie,"
	sql=sql & " 		'' as observacao"
	sql=sql & " from	historico h"
	sql=sql & " inner	join sca_turma t on t.NOMETURMA = h.TURMALUNO"
	sql=sql & " inner	join sca_GradeCurricular g on g.Cod_GradeCurricular = t.Cod_GradeCurricular  and g.cod_empresa = t.cod_empresa"
	sql=sql & " inner	join sca_periodo p on p.Cod_Periodo = g.Cod_Periodo and p.cod_empresa = t.cod_empresa"
	sql=sql & " inner	join sca_curso c on c.Cod_curso = p.Cod_curso and p.cod_empresa = c.cod_empresa"
	sql=sql & " inner	join sca_aluno a on a.matricula = h.matricula "
	sql=sql & " where	h.matricula = " & strMatricula
	sql=sql & " and		t.cod_empresa = " & intCodEmp
	sql=sql & " and		a.cod_empresa = " & intCodEmp
	sql=sql & " order by t.AnoLetivo,t.Cod_Semestre"
	rs.open sql, cnn, 3, 3
	if not rs.eof then	
		while not rs.eof
		
			intCodAluno = rs("cod_aluno")
			strAnoHistorico = rs("AnoLetivo")
			strSemestreHistorico = rs("Cod_Semestre")
			strEscola =rs("estabelecimento")
			strCidade =rs("cidade")
			strUfResidencia =rs("estado")
			strCurso = rs("curso")
			strSerie = rs("serie")
			strObservacao = rs("observacao")
			
			bolExisteHistorico = false
			SQL = "select cod_aluno"
			SQL = SQL & " from SCA_HISTORICO_ESCOLAR"
			SQL = SQL & " where cod_aluno = "& intCodAluno
			SQL = SQL & " and cod_empresa = "& intCodEmp
			SQL = SQL & " and ano_letivo = "& strAnoHistorico
			SQL = SQL & " and semestre = "& strSemestreHistorico
			rsAux.open sql, cnn, 3, 3
			if not rsAux.eof then	
				bolExisteHistorico = true
			end if
			rsAux.close
			
			if bolExisteHistorico = false then
				
				SQL = "SET NoCount ON INSERT INTO SCA_HISTORICO_ESCOLAR (cod_aluno, cod_empresa, ano_letivo, semestre, escola, cidade, uf, "
				SQL = SQL & "curso, cod_curso, cod_periodo,serie, observacao ) VALUES ("
				SQL = SQL & "" & intCodAluno & ","
				SQL = SQL & "" & intCodEmp & ","
				SQL = SQL & "" & strAnoHistorico & ","
				SQL = SQL & "" & strSemestreHistorico & ","
				SQL = SQL & "'" & strEscola & "',"
				if strCidade = "" then
					SQL = SQL & "null,"
				else
					SQL = SQL & "'" & strCidade & "',"
				end if
				if strUfResidencia = "" then
					SQL = SQL & "null,"
				else
					SQL = SQL & "" & strUfResidencia & ","
				end if
				if strCurso = "" then
					SQL = SQL & "null,"
				else
					SQL = SQL & "'" & strCurso & "',"
				end if
				if strSerie = "" then
					SQL = SQL & "null,"
				else
					SQL = SQL & "'" & strSerie & "',"
				end if
				SQL = SQL & "null," 'cod_curso
				SQL = SQL & "null," 'cod_periodo
				if strObservacao = "" then
					SQL = SQL & "null); SELECT @@IDENTITY"
				else
					SQL = SQL & "'" & strObservacao & "'); SELECT @@IDENTITY"
				end if
				Set rsAux = cnn.Execute(sql)
				intCodHist = rsAux(0)
				'GravarLog sql
				rsAux.close
				
				'inserindo HISTORICO DISCIPLINA
				SQL = "insert SCA_HISTORICO_ESCOLAR_DISCIPLINA"
				SQL = SQL & " select	"
				SQL = SQL & "		" & intCodHist & " as cod_hist,"
				SQL = SQL & "		t.AnoLetivo,"
				SQL = SQL & "		p.Cod_Periodo,"
				SQL = SQL & "		null as Cod_curso,"
				SQL = SQL & "		t.Cod_Semestre,"
				SQL = SQL & "		gd.cod_disciplina,"
				SQL = SQL & "		t.cod_turma,"
				SQL = SQL & "		gdh.Cod_GradeCurricularDisciplina,"
				SQL = SQL & "		h.NOTABI101,"
				SQL = SQL & "		h.FALTBIM01,"
				SQL = SQL & "		h.NOTABI102,"
				SQL = SQL & "		h.FALTBIM02,"
				SQL = SQL & "		null as nota03,"
				SQL = SQL & "		null as falta03,"
				SQL = SQL & "		null as nota04,"
				SQL = SQL & "		null as falta04,"
				SQL = SQL & "		null as nota05,"
				SQL = SQL & "		null as falta05,"
				SQL = SQL & "		null as nota06,"
				SQL = SQL & "		null as falta06,"
				SQL = SQL & "		null as nota07,"
				SQL = SQL & "		null as falta07,"
				SQL = SQL & "		null as nota08,"
				SQL = SQL & "		null as falta08,"
				SQL = SQL & "		null as nota09,"
				SQL = SQL & "		null as falta09,"
				SQL = SQL & "		null as nota10,"
				SQL = SQL & "		null as falta10,"
				SQL = SQL & "		null as nota11,"
				SQL = SQL & "		null as falta11,"
				SQL = SQL & "		null as nota12,"
				SQL = SQL & "		null as falta12,"
				SQL = SQL & "		null as nota13,"
				SQL = SQL & "		null as falta13,"
				SQL = SQL & "		null as nota14,"
				SQL = SQL & "		null as falta14,"
				SQL = SQL & "		null as nota15,"
				SQL = SQL & "		null as falta15,"
				SQL = SQL & "		h.mediafina as media,"
				SQL = SQL & "		h.cargahora as ch,"
				SQL = SQL & "		h.statusdis as situacao,"
				SQL = SQL & "		'' as observavao,"
				SQL = SQL & "		'S' as mostraNota"
				SQL = SQL & " from	historico h"
				SQL = SQL & " inner join sca_turma t on t.NOMETURMA = h.TURMALUNO "
				SQL = SQL & " inner join sca_GradeCurricular g on g.Cod_GradeCurricular = t.Cod_GradeCurricular and g.cod_empresa = t.cod_empresa "
				SQL = SQL & " inner join sca_GradeCurriculardisciplinahistorico gdh on gdh.Cod_disciplina_hsitorico = h.CODIGODIS "
				SQL = SQL & " inner join sca_GradeCurriculardisciplina gd on gd.Cod_GradeCurricular = g.Cod_GradeCurricular and gd.Cod_GradeCurricularDisciplina = gdh.Cod_GradeCurricularDisciplina"
				SQL = SQL & " inner join sca_periodo p on p.Cod_Periodo = g.Cod_Periodo and p.cod_empresa = t.cod_empresa "
				SQL = SQL & " inner join sca_curso c on c.Cod_curso = p.Cod_curso "
				SQL = SQL & " where	h.matricula = " & strMatricula
				SQL = SQL & " and		t.cod_empresa = " & intCodEmp
				SQL = SQL & " and 		t.AnoLetivo=" & strAnoHistorico
				SQL = SQL & " and		t.Cod_Semestre=" & strSemestreHistorico
				SQL = SQL & " and 		c.descricao='" & strCurso & "'"
				SQL = SQL & " and 		p.descricao='" & strSerie & "'"
				SQL = SQL & " order by gdh.Cod_GradeCurricularDisciplina"
				cnn.execute SQL
				'GravarLog sql	
			end if
			
			rs.movenext
		wend
		
		strMensagem = "Histórico importador com sucesso..."
	else
	%>
		<script>
			alert("ATENÇÃO: não foi encontrada informações para essa matrícula.");
			window.history.back();
		</script>
		<%
	end if
	rs.close
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		'cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='HistoricoEscolar_con.asp?txtMatricula=<%=strMatricula%>';
		</script>
		<%
		response.end
	else
		'cnn.rollbackTrans
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			window.history.back();
		</script>
		<%
	end if
%>