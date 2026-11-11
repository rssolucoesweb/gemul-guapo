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
	strTotalFaltas 			= Trim(Request.Form("txtTotalFaltas"))
	mostrar_historico_rel 			= Trim(Request.Form("cmbMostrar"))
	
	intCodCredenciamento				= Trim(Request("cmbCredenciamento"))
	intCodReCredenciamento				= Trim(Request("cmbRecredenciamento"))
	intCodAutorizacao					= Trim(Request("cmbAutorizacao"))
	intCodAutorizacaoRenovacao			= Trim(Request("cmbAutorizacaoRenovacao"))
	
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

	if acao = "I" then
	
		SQL = "INSERT INTO SCA_HISTORICO_ESCOLAR (cod_aluno, cod_empresa, ano_letivo, semestre, escola, cidade, uf, "
		SQL = SQL & "curso, serie, cod_curso, cod_periodo, ch_total, total_faltas, mostrar_historico_rel, observacao ) VALUES ("
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
		if strTotalFaltas = "" then
			SQL = SQL & "0,"
		else
			SQL = SQL & "" & strTotalFaltas & ","
		end if
		
		SQL = SQL & "'" & mostrar_historico_rel & "',"
		if strObservacao = "" then
			SQL = SQL & "null)"
		else
			SQL = SQL & "'" & strObservacao & "')"
		end if
		cnn.execute SQL
		GravarLog sql	
		
			
		existeObsGeral = "N"
		sql="SELECT codigo"
		sql=sql & " FROM SCA_HISTORICO_ESCOLAR_OBSERVACAO_GERAL"
		SQL = SQL & " WHERE cod_aluno = " & intCodAluno
		rsAux.open sql, cnn
		if not rsAux.eof then
			existeObsGeral = "S"
		end if
		rsAux.close
		
		if existeObsGeral = "N" then
			SQL = "INSERT INTO SCA_HISTORICO_ESCOLAR_OBSERVACAO_GERAL (cod_aluno, observacoes) values ("
			SQL = SQL & "" & intCodAluno & ","
			SQL = SQL & "'" & strObservacaoGeral & "')"
			cnn.execute SQL
		else
			SQL = "update SCA_HISTORICO_ESCOLAR_OBSERVACAO_GERAL set observacoes = '" & strObservacaoGeral & "'"
			SQL = SQL & " where cod_aluno = " & intCodAluno
			cnn.execute SQL
		end if
		
		SQL = "DELETE SCA_HISTORICO_ESCOLAR_ATOS_LEGALIZACAO "
		SQL = SQL & " where cod_aluno = " & intCodAluno
		cnn.execute SQL
		
		if intCodAutorizacao<>"0" or intCodCredenciamento<>"0" then
			IF intCodAutorizacao<>"0" then
				SQL = "INSERT INTO SCA_HISTORICO_ESCOLAR_ATOS_LEGALIZACAO (cod_aluno, cod_atos_legalizacao, usuario_incl, data_hora_incl) values ("
				SQL = SQL & "" & intCodAluno & ","
				SQL = SQL & "" & intCodAutorizacao & ","
				SQL = SQL & "'" & SESSION("USUARIOWEB") & "',"
				SQL = SQL & "GETDATE())"
				cnn.execute SQL
			END IF
			
			IF intCodCredenciamento<>"0" then
				SQL = "INSERT INTO SCA_HISTORICO_ESCOLAR_ATOS_LEGALIZACAO (cod_aluno, cod_atos_legalizacao, usuario_incl, data_hora_incl) values ("
				SQL = SQL & "" & intCodAluno & ","
				SQL = SQL & "" & intCodCredenciamento & ","
				SQL = SQL & "'" & SESSION("USUARIOWEB") & "',"
				SQL = SQL & "GETDATE())"
				cnn.execute SQL
			END IF
			
			IF intCodAutorizacaoRenovacao<>"0" then
				SQL = "INSERT INTO SCA_HISTORICO_ESCOLAR_ATOS_LEGALIZACAO_RENOVACAO (cod_aluno, cod_atos_legalizacao_renovacao, usuario_incl, data_hora_incl) values ("
				SQL = SQL & "" & intCodAluno & ","
				SQL = SQL & "" & intCodAutorizacaoRenovacao & ","
				SQL = SQL & "'" & SESSION("USUARIOWEB") & "',"
				SQL = SQL & "GETDATE())"
				cnn.execute SQL
			END IF
			
			IF intCodReCredenciamento<>"0" then
				SQL = "INSERT INTO SCA_HISTORICO_ESCOLAR_ATOS_LEGALIZACAO_RENOVACAO (cod_aluno, cod_atos_legalizacao_renovacao, usuario_incl, data_hora_incl) values ("
				SQL = SQL & "" & intCodAluno & ","
				SQL = SQL & "" & intCodReCredenciamento & ","
				SQL = SQL & "'" & SESSION("USUARIOWEB") & "',"
				SQL = SQL & "GETDATE())"
				cnn.execute SQL
			END IF
		end if 
		strMensagem = "Histórico incluído com sucesso..."		
	elseif acao = "A" then
		    
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
		if intCodCurso = "" or intCodCurso="999999" then
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
		if strTotalFaltas = "" then
			SQL = SQL & "total_faltas=0,"
		else
			SQL = SQL & "total_faltas='" & strTotalFaltas & "',"
		end if
		
		SQL = SQL & "mostrar_historico_rel='" & mostrar_historico_rel & "',"
		
		if strObservacao = "" then
			SQL = SQL & "Observacao=null"
		else
			SQL = SQL & "Observacao='" & strObservacao & "'"
		end if
		SQL = SQL & " where codigo=" & codHistoricoEscolar
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
			
		existeObsGeral = "N"
		sql="SELECT codigo"
		sql=sql & " FROM SCA_HISTORICO_ESCOLAR_OBSERVACAO_GERAL"
		SQL = SQL & " WHERE cod_aluno = " & intCodAluno
		rsAux.open sql, cnn
		if not rsAux.eof then
			existeObsGeral = "S"
		end if
		rsAux.close
		
		if existeObsGeral = "N" then
			SQL = "INSERT INTO SCA_HISTORICO_ESCOLAR_OBSERVACAO_GERAL (cod_aluno, observacoes) values ("
			SQL = SQL & "" & intCodAluno & ","
			SQL = SQL & "'" & strObservacaoGeral & "')"
			cnn.execute SQL
		else
			SQL = "update SCA_HISTORICO_ESCOLAR_OBSERVACAO_GERAL set observacoes = '" & strObservacaoGeral & "'"
			SQL = SQL & " where cod_aluno = " & intCodAluno
			cnn.execute SQL
		end if


		'atos legais
		existeAtos = "N"
		sql="SELECT codigo"
		sql=sql & " FROM SCA_HISTORICO_ESCOLAR_ATOS_LEGALIZACAO"
		SQL = SQL & " WHERE cod_aluno = " & intCodAluno
		rsAux.open sql, cnn
		if not rsAux.eof then
			existeAtos = "S"
		end if
		rsAux.close

		SQL = "DELETE SCA_HISTORICO_ESCOLAR_ATOS_LEGALIZACAO "
		SQL = SQL & " where cod_aluno = " & intCodAluno
		cnn.execute SQL
		
		if intCodAutorizacao<>"0" or intCodCredenciamento<>"0" then
			IF intCodAutorizacao<>"0" then
				SQL = "INSERT INTO SCA_HISTORICO_ESCOLAR_ATOS_LEGALIZACAO (cod_aluno, cod_atos_legalizacao, usuario_incl, data_hora_incl) values ("
				SQL = SQL & "" & intCodAluno & ","
				SQL = SQL & "" & intCodAutorizacao & ","
				SQL = SQL & "'" & SESSION("USUARIOWEB") & "',"
				SQL = SQL & "GETDATE())"
				cnn.execute SQL
			END IF
			
			IF intCodCredenciamento<>"0" then
				SQL = "INSERT INTO SCA_HISTORICO_ESCOLAR_ATOS_LEGALIZACAO (cod_aluno, cod_atos_legalizacao, usuario_incl, data_hora_incl) values ("
				SQL = SQL & "" & intCodAluno & ","
				SQL = SQL & "" & intCodCredenciamento & ","
				SQL = SQL & "'" & SESSION("USUARIOWEB") & "',"
				SQL = SQL & "GETDATE())"
				cnn.execute SQL
			END IF
			
			IF intCodAutorizacaoRenovacao<>"0" then
				SQL = "INSERT INTO SCA_HISTORICO_ESCOLAR_ATOS_LEGALIZACAO_RENOVACAO (cod_aluno, cod_atos_legalizacao_renovacao, usuario_incl, data_hora_incl) values ("
				SQL = SQL & "" & intCodAluno & ","
				SQL = SQL & "" & intCodAutorizacaoRenovacao & ","
				SQL = SQL & "'" & SESSION("USUARIOWEB") & "',"
				SQL = SQL & "GETDATE())"
				cnn.execute SQL
			END IF
			
			IF intCodReCredenciamento<>"0" then
				SQL = "INSERT INTO SCA_HISTORICO_ESCOLAR_ATOS_LEGALIZACAO_RENOVACAO (cod_aluno, cod_atos_legalizacao_renovacao, usuario_incl, data_hora_incl) values ("
				SQL = SQL & "" & intCodAluno & ","
				SQL = SQL & "" & intCodReCredenciamento & ","
				SQL = SQL & "'" & SESSION("USUARIOWEB") & "',"
				SQL = SQL & "GETDATE())"
				cnn.execute SQL
			END IF
			
		end if 	

		strMensagem = "Histórico alterado com sucesso..."
	end if
	
	strParametro = "sca_historico_escolar_novo.asp?codHistoricoEscolar="&codHistoricoEscolar
	strParametro = strParametro & "&txtCodAluno="&intCodAluno	
	strParametro = strParametro & "&txtMatricula="&strMatricula	
	strParametro = strParametro & "&txtExpandirHistorico="&strExpandirHistorico	
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		if ucase(trim(acao)) = "I" then
		'será direcionado para tela de lançamento de disciplinas
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='sca_historico_escolar_novoCon.asp?txtMatricula=<%=strMatricula%>';
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