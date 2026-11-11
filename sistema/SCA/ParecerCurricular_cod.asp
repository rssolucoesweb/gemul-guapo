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
	cnn.begintrans
	acao 				= Trim(Request.QueryString("acao"))

	intCodEmpresa 		= Session("CodEmpresa")
	intCodEmp			= intCodEmpresa
	strCodigo							= Trim(Request("txtCodigo"))
	strCodigoGradeCurricularDisciplina	= Trim(Request("txtCodigoGradeCurricularDisciplina"))
	strCodDisciplinaOutrasAnterior	= Trim(Request("txtCodDisciplinaOutrasAnterior"))
	intCodFicha	= Trim(Request("txtCodigoFicha"))
	
	strCodAluno			= Trim(Request("txtCodAluno"))
	strMatricula 		= Trim(Request("txtMatricula"))
	
	strEscola 			= Trim(Request.Form("txtEscola"))
	strCidade 			= Trim(Request.Form("txtCidade"))
	strUfResidencia		= Trim(Request.Form("cmbUFResidencia"))
	
	strAnoLetivo 		= Trim(Request.Form("txtAnoLetivo"))
	intSemestre 		= Trim(Request.Form("cmbSemestre"))
	
	strAnoHistorico		= strAnoLetivo
	strSemestreHistorico= intSemestre
	
    intCodDisciplina        = request("cmbDisciplina")
	intCodDisciplinaOutras	= Trim(Request.Form("cmbDisciplinaOutras"))
	strDisciplinaNova		= Trim(Request.Form("txtDisciplinaNova"))
    strCH			        = request("txtCH")
	strNota					= replace(replace(Trim(Request.Form("txtNota")),".",""),",",".")
	strConceito				= Trim(Request.Form("txtConceito"))
	strSituacaoPromocao		= Trim(Request.Form("cmbSituacaoPromocao"))

	intCodAluno			= Trim(Request.Form("txtCodAluno"))
	strMatricula		= Trim(Request.Form("txtMatricula"))

	'DADOS DO HISTORICO 
	strEscola			= Trim(Request.Form("txtEscola"))
	strCidade			= Trim(Request.Form("txtCidade"))
	strUfResidencia		= Trim(Request.Form("cmbUFResidencia"))

		
	if ucase(trim(acao)) = "I" then
		if intCodFicha = "" then
			SQL = "SET NoCount ON INSERT INTO SCA_FICHA_EQUIVALENCIA (cod_empresa,Cod_Aluno,Escola,Cidade,UF) VALUES ("
			SQL = SQL & "" & intCodEmpresa & ","
			SQL = SQL & "" & intCodAluno & ","
			SQL = SQL & "'" & strEscola & "',"
			SQL = SQL & "'" & strCidade & "',"
			SQL = SQL & "'" & strUfResidencia & "'); SELECT @@IDENTITY "
			Set rs = cnn.Execute(sql)
			intCodFicha = rs(0)
			rs.close
		end if
				
		if intCodDisciplinaOutras = "-1" then
			SQL = "select  Cod_Disciplina, Desc_Disciplina "
			SQL = SQL & " from SCA_DISCIPLINA"
			SQL = SQL & " where Desc_Disciplina = '" & strDisciplinaNova & "'"
			SQL = SQL & " and cod_empresa = " & intCodEmpresa
			rsAux.open sql, cnn, 3, 3
			if not rsAux.eof then	
				rsaux("Desc_Disciplina")
				intCodDisciplinaOutras = rsaux("Cod_Disciplina")
			else
				strDisc = strDisciplinaNova
			end if   		
			rsAux.close
		else
			SQL = "select  Cod_Disciplina, Desc_Disciplina "
			SQL = SQL & " from SCA_DISCIPLINA"
			SQL = SQL & " where Cod_Disciplina = " & intCodDisciplinaOutras
			SQL = SQL & " and cod_empresa = " & intCodEmpresa
			rsAux.open sql, cnn, 3, 3
			if not rsAux.eof then	
				strDisc = rsaux("Desc_Disciplina")
			end if   		
			rsAux.close
		end if
		
		bolInsere = true
		SQL = "select  Cod_Disciplina, Desc_Disciplina "
		SQL = SQL & " from SCA_DISCIPLINAOUTRASINSTITUICOES"
		SQL = SQL & " where Desc_Disciplina = '" & strDisc & "'"
		SQL = SQL & " and cod_empresa = " & intCodEmpresa
		rsAux.open sql, cnn, 3, 3
		if NOT rsAux.eof then	
			bolInsere = false
			intCodDisciplinaOutras=rsaux("Cod_Disciplina")
		end if   		
		rsAux.close

		if bolInsere then
			SQL = "SET NoCount ON INSERT INTO SCA_DISCIPLINAOUTRASINSTITUICOES (Cod_Empresa, desc_disciplina) "
			SQL = SQL & "VALUES ("
			SQL = SQL & "" & intCodEmpresa & ","		
			SQL = SQL & "'" & strDisc & "'); SELECT @@IDENTITY "
			Set rs = cnn.Execute(sql)
			intCodDisciplinaOutras = rs(0)
			rs.close
		end if
				
		SQL = "INSERT INTO SCA_FICHA_EQUIVALENCIA_DISCIPLINA (cod_ficha_equivalencia, Cod_GradeCurricularDisciplina, ano_letivo, semestre, Cod_DisciplinaOutrasInstituicoes, CH, Nota, Conceito, Cod_SituacaoPromocao) "
		SQL = SQL & "VALUES ("
		SQL = SQL & "" & intCodFicha & ","
		SQL = SQL & "" & strCodigoGradeCurricularDisciplina & ","
		SQL = SQL & "" & strAnoLetivo & ","
		SQL = SQL & "" & intSemestre & ","
		SQL = SQL & "" & intCodDisciplinaOutras & ","
		SQL = SQL & "" & strCH & ","
		if strNota = "" then
			SQL = SQL & "null,"
		else
			SQL = SQL & "" & strNota & ","
		end if
		if strConceito = "" then
			SQL = SQL & "null,"
		else
			SQL = SQL & "'" & strConceito & "',"
		end if
		SQL = SQL & "'" & strSituacaoPromocao & "')"
		cnn.execute SQL
		GravarLog sql	

		strMensagem = "Parecer salvo com sucesso..."
	elseif ucase(trim(acao)) = "A" then
		SQL = "update SCA_FICHA_EQUIVALENCIA set "
		SQL = SQL & " Escola = '" & strEscola & "',"
		SQL = SQL & " Cidade = '" & strCidade & "',"
		SQL = SQL & " UF = '" & strUfResidencia & "'"
		sql = sql & " where codigo = " & intCodFicha
		cnn.Execute(sql)

		SQL = "delete SCA_FICHA_EQUIVALENCIA_DISCIPLINA "
		sql = sql & " where cod_ficha_equivalencia = " & intCodFicha
		sql = sql & " and Cod_DisciplinaOutrasInstituicoes = " & strCodDisciplinaOutrasAnterior
		sql = sql & " and codigo = " & strCodigo
		cnn.Execute(sql)

		if intCodDisciplinaOutras = "-1" then
			SQL = "select  Cod_Disciplina, Desc_Disciplina "
			SQL = SQL & " from SCA_DISCIPLINA"
			SQL = SQL & " where Desc_Disciplina = '" & strDisciplinaNova & "'"
			SQL = SQL & " and cod_empresa = " & intCodEmpresa
			rsAux.open sql, cnn, 3, 3
			if not rsAux.eof then	
				rsaux("Desc_Disciplina")
				intCodDisciplinaOutras = rsaux("Cod_Disciplina")
			else
				strDisc = strDisciplinaNova
			end if   		
			rsAux.close
		else
			SQL = "select  Cod_Disciplina, Desc_Disciplina "
			SQL = SQL & " from SCA_DISCIPLINA"
			SQL = SQL & " where Cod_Disciplina = " & intCodDisciplinaOutras
			SQL = SQL & " and cod_empresa = " & intCodEmpresa
			rsAux.open sql, cnn, 3, 3
			if not rsAux.eof then	
				strDisc = rsaux("Desc_Disciplina")
			end if   		
			rsAux.close
		end if
		
		bolInsere = true
		SQL = "select  Cod_Disciplina, Desc_Disciplina "
		SQL = SQL & " from SCA_DISCIPLINAOUTRASINSTITUICOES"
		SQL = SQL & " where Desc_Disciplina = '" & strDisc & "'"
		SQL = SQL & " and cod_empresa = " & intCodEmpresa
		rsAux.open sql, cnn, 3, 3
		if NOT rsAux.eof then	
			bolInsere = false
			intCodDisciplinaOutras=rsaux("Cod_Disciplina")
		end if   		
		rsAux.close

		if bolInsere then
			SQL = "SET NoCount ON INSERT INTO SCA_DISCIPLINAOUTRASINSTITUICOES (Cod_Empresa, desc_disciplina) "
			SQL = SQL & "VALUES ("
			SQL = SQL & "" & intCodEmpresa & ","		
			SQL = SQL & "'" & strDisc & "'); SELECT @@IDENTITY "
			Set rs = cnn.Execute(sql)
			intCodDisciplinaOutras = rs(0)
			rs.close
		end if
	
		SQL = "INSERT INTO SCA_FICHA_EQUIVALENCIA_DISCIPLINA (cod_ficha_equivalencia, Cod_GradeCurricularDisciplina, ano_letivo, semestre, Cod_DisciplinaOutrasInstituicoes, CH, Nota, Conceito, Cod_SituacaoPromocao) "
		SQL = SQL & "VALUES ("
		SQL = SQL & "" & intCodFicha & ","
		SQL = SQL & "" & strCodigoGradeCurricularDisciplina & ","
		SQL = SQL & "" & strAnoLetivo & ","
		SQL = SQL & "" & intSemestre & ","
		SQL = SQL & "" & intCodDisciplinaOutras & ","
		SQL = SQL & "" & strCH & ","
		if strNota = "" then
			SQL = SQL & "null,"
		else
			SQL = SQL & "" & strNota & ","
		end if
		if strConceito = "" then
			SQL = SQL & "null,"
		else
			SQL = SQL & "'" & strConceito & "',"
		end if
		SQL = SQL & "'" & strSituacaoPromocao & "')"
		cnn.execute SQL
		GravarLog sql			
		
		strMensagem = "Parecer salvo com sucesso..."
	elseif ucase(trim(acao)) = "E" then
		bolDeleta = False	
		sql="delete "
		sql=sql & " FROM SCA_FICHA_EQUIVALENCIA_DISCIPLINA"
		SQL = SQL & " WHERE codigo = " & strCodigo
		cnn.execute SQL
		GravarLog sql	

		sql="SELECT codigo"
		sql=sql & " FROM SCA_FICHA_EQUIVALENCIA_DISCIPLINA"
		SQL = SQL & " WHERE cod_ficha_equivalencia = " & intCodFicha
		rsAux.open sql, cnn, 3, 3
		if rsAux.eof then	
		   bolDeleta = True
		end if   		
		rsAux.close
		strMensagem = "Parecer excluído com sucesso..."	
		
		if bolDeleta then
			SQL = "delete from SCA_HISTORICO_ESCOLAR_DISCIPLINA"
			SQL = SQL & " where cod_historico_escolar in (" 
			SQL = SQL & " 		select cod_historicoEscolar from SCA_FICHA_EQUIVALENCIA"
			SQL = SQL & " 		where codigo = " & intCodFicha & ")"
			cnn.execute SQL
			GravarLog sql	

			SQL = "delete from SCA_HISTORICO_ESCOLAR"
			SQL = SQL & " where codigo in (" 
			SQL = SQL & " 		select cod_historicoEscolar from SCA_FICHA_EQUIVALENCIA"
			SQL = SQL & " 		where codigo = " & intCodFicha & ")"
			cnn.execute SQL
			GravarLog sql	

			SQL = "delete from SCA_FICHA_EQUIVALENCIA"
			SQL = SQL & " where codigo = " & intCodFicha
			cnn.execute SQL
			GravarLog sql	
		end if	
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='ParecerCurricular_cad.asp?txtCodAluno=<%=intCodAluno%>';
		</script>
		<%
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