<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 

response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 10/02/2022
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Notas 
-->
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_replaceRequest.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="includes/inc_log.asp"-->
<%
	cnn.begintrans
	acao 				= Trim(Request.QueryString("acao"))

	codHistoricoEscolar				= Trim(Request("codHistoricoEscolar"))
	codHistoricoEscolarDisciplina	= Trim(Request("codHistoricoEscolarDisciplina"))
	strExpandirHistorico			= Trim(Request("txtExpandirHistorico"))
	strMostraNota					= Trim(Request("txtMostraNota"))

	
	intCodEmp			= Session("CodEmpresa")
	intCodDisciplinaGrade	= Trim(Request.Form("cmbDisciplinaTurma"))
	intCodTipoNota 		= Trim(Request.Form("chkTipoNota"))
	intCodTurma 		= Trim(Request.Form("cmbTurma"))
	intCodTurno 		= Trim(Request.Form("cmbTurno"))
	intCodAluno			= Trim(Request.Form("txtCodAluno"))
	strMatricula		= Trim(Request.Form("txtMatricula"))
	strAnoLetivo 		= session("strAnoLetivo")
	strCHCumprida		= Trim(Request.Form("txtCHCumprida"))
	strCHExigida		= Trim(Request.Form("txtCHExigida"))
	
	'DADOS DO HISTORICO 
	strEscola			= Trim(Request.Form("txtEscola"))
	strCidade			= Trim(Request.Form("txtCidade"))
	strUfResidencia		= Trim(Request.Form("cmbUFResidencia"))

	strAnoHistorico		= Trim(Request.Form("txtAnoHistorico"))
	strSemestreHistorico= Trim(Request.Form("cmbSemestreHistorico"))

	strCurso			= Trim(Request.Form("txtCurso"))
	strSerie			= Trim(Request.Form("txtSerie"))
	strIngresso			= Trim(Request.Form("txtIngresso"))
	strCHTotal 			= Trim(Request.Form("txtCHTotal"))
	
	'DADOS DO HISTORICO DISCIPLINAS
	intCodDisciplinaGrade 	= Trim(Request.Form("cmbDisciplina"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intCodTurmaHistorico	= Trim(Request.Form("cmbTurmaHistorico"))

	strCH 				= Trim(Request.Form("txtCH"))
	strMedia			= replace(request.form("txtMedia"),",",".")
	strSituacaoPromocao	= Trim(Request("cmbSituacaoPromocao"))
	strObservacao		= replace(Trim(Request.Form("txtObservacao")),"'","")
	strObservacaoGeral	= replace(Trim(Request.Form("txtObservacaoGeral")),"'","")

	if ucase(trim(acao)) = "ED" then

		'exclui HISTORICO DISCIPLINA
		SQL = "delete from SCA_HISTORICO_ESCOLAR_DISCIPLINA"
		SQL = SQL & " where codigo = " & codHistoricoEscolarDisciplina
		
		cnn.execute SQL
		GravarLog sql			

		strMensagem = "Histórico disciplina excluído com sucesso..."

	elseif ucase(trim(acao)) = "EH" then

		'exclui HISTORICO DISCIPLINA
		SQL = "delete from SCA_HISTORICO_ESCOLAR_DISCIPLINA"
		SQL = SQL & " where cod_historico_escolar = " & codHistoricoEscolar
		
		cnn.execute SQL
		GravarLog sql			

		'exclui HISTORICO DISCIPLINA
		SQL = "delete from SCA_HISTORICO_ESCOLAR"
		SQL = SQL & " where codigo = " & codHistoricoEscolar
		SQL = SQL & " AND 	cod_empresa = " & intCodEmp
		
		cnn.execute SQL
		GravarLog sql			

		strMensagem = "Histórico Escolar excluído com sucesso..."
		codHistoricoEscolar = ""
	else
	
		'VALIDACAO HISTORICO ESCOLAR
		sql="SELECT CODIGO"
		sql=sql & " FROM SCA_HISTORICO_ESCOLAR"
		SQL = SQL & " WHERE cod_aluno = " & intCodAluno
		SQL = SQL & " AND cod_empresa = " & intCodEmp
		SQL = SQL & " AND ano_letivo = " & strAnoHistorico
		SQL = SQL & " AND semestre = " & strSemestreHistorico
		if intCodEmp <> "113" then
			SQL = SQL & " AND serie = '" & strSerie & "'"
		else
			SQL = SQL & " AND substring(serie,1,1) = '" & mid(strSerie,1,1) & "'"
		end if	
		rs.open sql, cnn, 3, 3

		if rs.eof then			
			SQL = "INSERT INTO SCA_HISTORICO_ESCOLAR (cod_aluno, cod_empresa, ano_letivo, semestre, escola, cidade, uf, "
			SQL = SQL & "curso, serie, cod_curso, cod_periodo, ch_total, observacao ) VALUES ("
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
			if intCodCurso = "" then
				SQL = SQL & "null,"
			else
				SQL = SQL & "'" & intCodCurso & "',"
			end if
			if intCodPeriodo = "" then
				SQL = SQL & "null,"
			else
				SQL = SQL & "'" & intCodPeriodo & "',"
			end if
			if strCHTotal = "" then
				SQL = SQL & "null,"
			else
				SQL = SQL & "" & strCHTotal & ","
			end if
			if strObservacao = "" then
				SQL = SQL & "null)"
			else
				SQL = SQL & "'" & strObservacao & "')"
			end if
			cnn.execute SQL
			GravarLog sql	
			
			
			sql="SELECT MAX(CODIGO) AS codhist"
			sql=sql & " FROM SCA_HISTORICO_ESCOLAR"
			SQL = SQL & " WHERE cod_aluno = " & intCodAluno
			SQL = SQL & " AND cod_empresa = " & intCodEmp
			SQL = SQL & " AND ano_letivo = " & strAnoHistorico
			SQL = SQL & " AND semestre = " & strSemestreHistorico
		    SQL = SQL & " AND serie = '" & strSerie & "'"
			rsAux.open sql, cnn, 3, 3
			codHistoricoEscolar = rsAux("codhist")
			rsAux.close
			
			
			if intCodDisciplinaGrade <> "0" then
				'inserindo HISTORICO DISCIPLINA
				IF intCodPeriodo <> "" THEN
					
					SQL = "INSERT INTO SCA_HISTORICO_ESCOLAR_DISCIPLINA (cod_historico_escolar, ano_letivo, cod_periodo, "
					SQL = SQL & " cod_curso, cod_turma, semestre, cod_disciplina, "
					SQL = SQL & " media, carga_horaria, situacao, mostraNota) "
					SQL = SQL & "VALUES ("

					SQL = SQL & "" & codHistoricoEscolar & ","
					SQL = SQL & "" & strAnoHistorico & ","
					SQL = SQL & "" & intCodPeriodo & ","
					SQL = SQL & "" & intCodCurso & ","
					if intCodTurmaHistorico = "0" OR intCodTurmaHistorico = ""  then
						SQL = SQL & "null,"
					else
						SQL = SQL & "" & intCodTurmaHistorico & ","
					end if
					SQL = SQL & "" & strSemestreHistorico & ","
					SQL = SQL & "" & intCodDisciplinaGrade & ","
					if strMedia = "" then
						SQL = SQL & " null,"
					else
						SQL = SQL & "" & strMedia & ","
					end if
					if strCH = "" then
						SQL = SQL & "null,"
					else
						SQL = SQL & "" & strCH & ","
					end if
					SQL = SQL & "'" & strSituacaoPromocao & "','" & strMostraNota & "')"
					cnn.execute SQL
					GravarLog sql	
					
				END IF		
			end if			
		else	
		    
			codHistoricoEscolarAntigo = codHistoricoEscolar
			codHistoricoEscolar = rs("codigo")
		
			SQL = "UPDATE SCA_HISTORICO_ESCOLAR SET "					
			SQL = SQL & "escola = '" & strEscola & "',"
			if strCidade = "" then
				SQL = SQL & "cidade=null,"
			else
				SQL = SQL & "cidade='" & strCidade & "',"
			end if
			if strUfResidencia = "" then
				SQL = SQL & "uf= null,"
			else
				SQL = SQL & "uf=" & strUfResidencia & ","
			end if
			if strCurso = "" then
				SQL = SQL & "curso=null,"
			else
				SQL = SQL & "curso='" & strCurso & "',"
			end if
			if strSerie = "" then
				SQL = SQL & "serie=null,"
			else
				SQL = SQL & "serie='" & strSerie & "',"
			end if
			if intCodCurso = "" then
				SQL = SQL & "cod_curso=null,"
			else
				SQL = SQL & "cod_curso='" & intCodCurso & "',"
			end if
			if intCodPeriodo = "" then
				SQL = SQL & "cod_periodo=null,"
			else
				SQL = SQL & "cod_periodo='" & intCodPeriodo & "',"
			end if
			SQL = SQL & " ano_letivo=" & strAnoHistorico & ","
			SQL = SQL & " semestre=" & strSemestreHistorico & ","
			
			if strCHTotal = "" then
				SQL = SQL & "ch_total=null,"
			else
				SQL = SQL & "ch_total='" & strCHTotal & "',"
			end if
			
			if strObservacao = "" then
				SQL = SQL & "Observacao=null"
			else
				SQL = SQL & "Observacao='" & strObservacao & "'"
			end if
			SQL = SQL & " where codigo=" & codHistoricoEscolar
			cnn.execute SQL
			GravarLog sql
		

			'VERFICAR SE E ALTERACAO OU INCLUSAO'
			if codHistoricoEscolarDisciplina = "" then
				if intCodDisciplinaGrade <> "0" then
	
					'inserindo HISTORICO DISCIPLINA
					SQL = "INSERT INTO SCA_HISTORICO_ESCOLAR_DISCIPLINA (cod_historico_escolar, ano_letivo, cod_periodo, cod_curso, cod_turma, semestre, cod_disciplina, "
					SQL = SQL & "media, carga_horaria, situacao, mostraNota) VALUES ("
					SQL = SQL & "" & codHistoricoEscolar & ","
					SQL = SQL & "" & strAnoHistorico & ","
					SQL = SQL & "" & intCodPeriodo & ","
					SQL = SQL & "" & intCodCurso & ","
					if intCodTurmaHistorico = "0" OR intCodTurmaHistorico = ""  then
						SQL = SQL & "null,"
					else
						SQL = SQL & "" & intCodTurmaHistorico & ","
					end if
					SQL = SQL & "" & strSemestreHistorico & ","
					SQL = SQL & "" & intCodDisciplinaGrade & ","
					if strMedia = "" then
						SQL = SQL & " null,"
					else
						SQL = SQL & "" & strMedia & ","
					end if
					if strCH = "" then
						SQL = SQL & " null,"
					else
						SQL = SQL & "" & strCH & ","
					end if
					if strSituacaoPromocao = "0" then strSituacaoPromocao = ""
					SQL = SQL & "'" & strSituacaoPromocao & "','" & strMostraNota & "')"
					
					'response.write sql
					'response.end
					cnn.execute SQL
					GravarLog sql			
				end if
			else
	
				if intCodDisciplinaGrade <> "0" then
	
					'inserindo HISTORICO DISCIPLINA
					SQL = "UPDATE SCA_HISTORICO_ESCOLAR_DISCIPLINA SET"
					SQL = SQL & " cod_historico_escolar=" & codHistoricoEscolar & ","
					SQL = SQL & " ano_letivo=" & strAnoHistorico & ","
					SQL = SQL & " cod_periodo=" & intCodPeriodo & ","
					SQL = SQL & " cod_curso=" & intCodCurso & ","
					if intCodTurmaHistorico = "0" OR intCodTurmaHistorico = ""  then
						SQL = SQL & " cod_turma=null,"
					else
						SQL = SQL & " cod_turma=" & intCodTurmaHistorico & ","
					end if
					SQL = SQL & " cod_disciplina=" & intCodDisciplinaGrade & ","
					if trim(strMedia) = "" then
						SQL = SQL & " media=null,"
					else
						SQL = SQL & " media=" & strMedia & ","
					end if
					if strCH = "" then
						SQL = SQL & " carga_horaria=null,"
					else
						SQL = SQL & " carga_horaria=" & strCH & ","
					end if
					SQL = SQL & " situacao = '" & strSituacaoPromocao & "',"
					SQL = SQL & " mostraNota='" & strMostraNota & "'"
					SQL = SQL & " where codigo = " & codHistoricoEscolarDisciplina
					'response.write sql
					'response.end
					cnn.execute SQL
					GravarLog sql	
					
					' Se não existe mais disciplina no periodo deleta a capa
					
					bolDeletaHistorico = False	
					sql="SELECT cod_historico_escolar"
					sql=sql & " FROM SCA_HISTORICO_ESCOLAR_DISCIPLINA"
					SQL = SQL & " WHERE cod_historico_escolar = " & codHistoricoEscolarAntigo
					rsAux.open sql, cnn, 3, 3
					if rsAux.eof then	
					   bolDeletaHistorico = True
					end if   		
					rsAux.close
					
					if bolDeletaHistorico then
						SQL = "delete from SCA_HISTORICO_ESCOLAR"
						SQL = SQL & " where codigo = " & codHistoricoEscolarAntigo
						cnn.execute SQL
						GravarLog sql	
					end if	
				end if		
			end if			
		end if
		rs.close

		sql = "delete SCA_HISTORICO_ESCOLAR_OBSERVACAO_GERAL where cod_aluno = " & intCodAluno
		cnn.execute SQL
			
		SQL = "INSERT INTO SCA_HISTORICO_ESCOLAR_OBSERVACAO_GERAL (cod_aluno, observacoes) values ("
		SQL = SQL & "" & intCodAluno & ","
		SQL = SQL & "'" & strObservacaoGeral & "')"
		cnn.execute SQL
		GravarLog sql

		strMensagem = "Histórico salvo com sucesso..."
	end if
	
	strParametro = "sca_historico_escolar.asp?codHistoricoEscolar="&codHistoricoEscolar
	strParametro = strParametro & "&txtCodAluno="&intCodAluno	
	strParametro = strParametro & "&txtMatricula="&strMatricula	
	strParametro = strParametro & "&txtExpandirHistorico="&strExpandirHistorico	
	strParametro = strParametro & "&cmbPeriodo="&intCodPeriodo	
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		if ucase(trim(acao)) = "EH" then
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='sca_historico_escolarCon.asp?txtMatricula=<%=strMatricula%>';
		</script>
		<%
		else
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='<%=strParametro%>';
		</script>
		<%
		end if
		response.end
	else
		cnn.rollbackTrans
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			window.history.back();
		</script>
		<%
	end if
%>