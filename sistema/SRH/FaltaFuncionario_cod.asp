<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%
	'on error resume next
	'----------Inicia uma transação--------------
	'cnn.begintrans
	acao 										= Trim(Request.QueryString("acao"))
	enviarFalta									= Trim(Request.QueryString("enviarFalta"))
	CodRegistroMestre							= Trim(Request.QueryString("CodRegistroMestre"))
	
	intCodEmp									= Session("CodEmpresa")
	intCodigo           	  					= Trim(Request.Form("txtCodigo"))
	intCodModulacaoReferencia 					= Trim(Request.form("cmbModulacaoReferencia"))
	intCodJustificativaFaltas					= Trim(Request.form("cmbJustificativaFaltas"))
	strDataLancamento         					= Trim(Request("txtDataLancamento"))
	strDataLancamentoFinal        				= Trim(Request("txtDataLancamentoFinal"))
	intCodProfessor	         	 				= Trim(Request("cmbColaboradorFrequencia")) 
	strComparaDataLancamento 					= formataDataCalc(Trim(Request("txtDataLancamento")))
	strTipoLancamento          					= Trim(Request("optTipoLancamento"))
	strOptTipoColaborador     					= Trim(Request("optTipoColaborador"))
	strJustificativaAbono    					= Trim(Request("txtJustificativaAbono"))
	strJustificativa          					= Trim(Request("txtJustificativa"))
	strSimouNao               					= Trim(Request("cmbSimouNao"))
	strFechamento             					= Trim(Request("cmbFechamento"))
	strCodFuncaoFuncionario             		= Trim(Request("txtCodFuncaoFuncionario"))
	strCodTurnoFuncionario             			= Trim(Request("txtCodTurnoFuncionario"))
	
	strAnoLetivo             					= Trim(Request("txtAnoLetivo"))
	intSemestre             					= Trim(Request("cmbSemestre"))
	
	if strSimouNao = "" then
	   strSimouNao = "N"
	end if 
	  
	if acao="I" then

		sql = " select * from SRH_COLABORADOR_FREQUENCIA " 
		sql = sql & " where cod_empresa = " & Session("CodEmpresa")  
		sql = sql & " and cod_colaborador = " & intCodProfessor 
		sql = sql & " and convert(datetime,convert(varchar, DataFalta, 103),103) >= convert(datetime, ' " & formatadataAP(strDataLancamento) & " ',103) " 
		sql = sql & " and convert(datetime,convert(varchar, DataFalta, 103),103) <= convert(datetime, ' " & formatadataAP(strDataLancamentoFinal) & " ',103) "
		rs.open sql, cnn
		if rs.eof = false then
			%>
			<script>
				alert("ATENÇÃO: Falta já lancada para esse Colaborador. Verifique!");
				window.location='FaltaFuncionario_Cad.asp';
			</script>
			<%
			response.end 
		end if	
		rs.close
	
		strMensagem = "Registro Incluido com sucesso..."
	
		strDataLancamentoCompara 		= strDataLancamento
		strDataLancamentoFinalCompara 	= strDataLancamentoFinal
		TotalFalta 						= 1
		strTurmaLocalizada 				= ""
		strTipoLancamento				= "I"
		strOptTipoColaborador			= "F"
		do while true

			sql = "Insert Into SRH_COLABORADOR_FREQUENCIA(cod_empresa, Cod_JustificativaFaltas, CodReferencia, ano_letivo, semestre_letivo, DATAFALTA, "
			sql = sql & " Datalancamento, DataLancamentoFinal, DataDiaLancamento, "
			sql = sql & " tipo_colaborador, cod_turma, cod_colaborador, cod_disciplina, cod_funcao, numero_falta, "
			sql = sql & " justificativa, numero_aula, "
			sql = sql & " situacao, justificativa_abono, fechamento, tipoLancamento, cod_turno )"
			sql = sql & " Values ("
			sql = sql & "" & intCodEmp & ","
			sql = sql & "" & intCodJustificativaFaltas & ","
			sql = sql & "" & intCodModulacaoReferencia & ","
			sql = sql & "" & strAnoLetivo & ","
			sql = sql & "" & intSemestre & ","
			sql = sql & "'" & formatadataBD(strDataLancamentoCompara) & "',"
			sql = sql & "'" & formatadataBD(strDataLancamento) & "',"
			sql = sql & "'" & formatadataBD(strDataLancamentoFinal) & "',"
			sql = sql & "'" & formatadataBD(date) & "',"
			sql = sql & "'" & strOptTipoColaborador & "',"
			sql = sql & "null,"
			sql = sql & "" & intCodProfessor & ","
			sql = sql & " null ," 'intCodDisciplina - Neste caso nao tenho a disciplina
			sql = sql & "" & strCodFuncaoFuncionario & "," 
			sql = sql & "" & TotalFalta & ","
			if strJustificativa <> "" then
				sql = sql & "'" & strJustificativa & "',"
			else 
				sql = sql &" null ,"
			end if
			if intQtdeAula <> "" then
				sql = sql & "" & intQtdeAula & ","
			else 
				sql = sql &" null ,"
			end if
			if strSimouNao <> "" then
				sql = sql & "'" & strSimouNao & "',"
			else 
				sql = sql &" null ,"
			end if
			if strJustificativaAbono <> "" then
				sql = sql & "'" & strJustificativaAbono & "',"
			else 
				sql = sql &" null ,"
			end if
			if strFechamento <> "" then
				sql = sql & "'" & strFechamento & "',"
			else 
				sql = sql &" null,"
			end if
			sql = sql & "'" & strTipoLancamento & "',"
			if trim(strCodTurnoFuncionario) <> "0" and trim(strCodTurnoFuncionario) <> "" then
				sql = sql & "'" & trim(strCodTurnoFuncionario) & "')"
			else
				sql = sql & "null)"
			end if

			cnn.execute sql
			GravarLog sql
			
			strDataLancamentoCompara = DateAdd("d", 1, strDataLancamentoCompara)
			
			if cCur(formatadataCalc(Trim(strDataLancamentoCompara))) > cCur(formatadataCalc(Trim(strDataLancamentoFinalCompara))) then
				exit do
			end if
			
		loop
	
	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		
	elseif acao = "E" then
		
		strMensagem = "Registro Excluido com sucesso..."

		sql = " SELECT CODIGO, "
		sql = sql & " ANO_LETIVO, "
		sql = sql & " SEMESTRE_LETIVO, "
		sql = sql & " Cod_JustificativaFaltas, "
		sql = sql & " codReferencia, "
		sql = sql & " DATALANCAMENTO, "
		sql = sql & " DATALANCAMENTOFINAL, "
		sql = sql & " DataDiaLancamento, "
		sql = sql & " COD_COLABORADOR, "
		sql = sql & " COD_TURMA, "
		sql = sql & " COD_DISCIPLINA, "
		sql = sql & " COD_TURNO "
		sql = sql & " from SRH_COLABORADOR_FREQUENCIA "
		sql = sql & " WHERE CODIGO = " & intCodigo
		rs.open sql, cnn		
		if rs.eof = false then
			strAnoLetivo								= trim(rs("ANO_LETIVO"))
			intSemestre									= trim(rs("SEMESTRE_LETIVO"))
			intCodJustificativaFaltas					= trim(rs("Cod_JustificativaFaltas"))
			intCodModulacaoReferencia 					= trim(rs("codReferencia"))
			strDataLancamento         					= formataDataBD(trim(rs("DATALANCAMENTO")))
			strDataLancamentoFinal        				= formataDataBD(trim(rs("DATALANCAMENTOFINAL")))
			strDataDiaLancamento         				= formataDataBD(trim(rs("DataDiaLancamento")))
			intCodProfessor	         	 				= Trim(rs("COD_COLABORADOR"))
			intCodTurma	         	 					= Trim(rs("COD_TURMA"))
			intCodDisciplina	         	 			= Trim(rs("COD_DISCIPLINA"))
			intCodTurno	         	 					= Trim(rs("COD_TURNO"))
		end if 
		rs.close
		
		sql = "Delete from SRH_COLABORADOR_FREQUENCIA "
		sql = sql & " where ANO_LETIVO = " & strAnoLetivo
		sql = sql & " and SEMESTRE_LETIVO = " & intSemestre
		sql = sql & " and Cod_JustificativaFaltas = " & intCodJustificativaFaltas
		sql = sql & " and codReferencia = " & intCodModulacaoReferencia
		sql = sql & " and DATALANCAMENTO = '" & strDataLancamento & "'"
		sql = sql & " and DATALANCAMENTOFINAL = '" & strDataLancamentoFinal & "'"
		sql = sql & " and DataDiaLancamento = '" & strDataDiaLancamento & "'"
		sql = sql & " and COD_COLABORADOR = " & intCodProfessor
		cnn.execute sql
		GravarLog sql
	
	end if
	
	if enviarFalta = "S" and acao="ENVIAR" then

		sql = " SELECT CODIGO, "
		sql = sql & " ANO_LETIVO, "
		sql = sql & " SEMESTRE_LETIVO, "
		sql = sql & " Cod_JustificativaFaltas, "
		sql = sql & " codReferencia, "
		sql = sql & " DATALANCAMENTO, "
		sql = sql & " DATALANCAMENTOFINAL, "
		sql = sql & " DataDiaLancamento, "
		sql = sql & " COD_COLABORADOR, "
		sql = sql & " COD_TURMA, "
		sql = sql & " COD_DISCIPLINA, "
		sql = sql & " COD_TURNO "
		sql = sql & " from SRH_COLABORADOR_FREQUENCIA "
		sql = sql & " WHERE CODIGO = " & CodRegistroMestre
		rs.open sql, cnn		
		if rs.eof = false then
			strAnoLetivo								= trim(rs("ANO_LETIVO"))
			intSemestre									= trim(rs("SEMESTRE_LETIVO"))
			intCodJustificativaFaltas					= trim(rs("Cod_JustificativaFaltas"))
			intCodModulacaoReferencia 					= trim(rs("codReferencia"))
			strDataLancamento         					= formataDataBD(trim(rs("DATALANCAMENTO")))
			strDataLancamentoFinal        				= formataDataBD(trim(rs("DATALANCAMENTOFINAL")))
			strDataDiaLancamento         				= formataDataBD(trim(rs("DataDiaLancamento")))
			intCodProfessor	         	 				= Trim(rs("COD_COLABORADOR"))
			intCodTurma	         	 					= Trim(rs("COD_TURMA"))
			intCodDisciplina	         	 			= Trim(rs("COD_DISCIPLINA"))
			intCodTurno	         	 					= Trim(rs("COD_TURNO"))
		end if 
		rs.close

		sql = "UPDATE SRH_COLABORADOR_FREQUENCIA SET FECHAMENTO = 'S' "
		sql = sql & " WHERE COD_EMPRESA = "  & session("CodEmpresa")
		sql = sql & " AND (FECHAMENTO = 'N' or ISNULL(FECHAMENTO,'0') = '0') "
		sql = sql & " and Cod_JustificativaFaltas = " & intCodJustificativaFaltas
		sql = sql & " and codReferencia = " & intCodModulacaoReferencia
		sql = sql & " and DATALANCAMENTO = '" & strDataLancamento & "'"
		sql = sql & " and DATALANCAMENTOFINAL = '" & strDataLancamentoFinal & "'"
		sql = sql & " and DataDiaLancamento = '" & strDataDiaLancamento & "'"
		sql = sql & " and COD_COLABORADOR = " & intCodProfessor
		cnn.execute sql
		GravarLog sql
		strMensagem = "Registros enviado com sucesso..."
	end if   

	if err.number = 0 then
		'----------Finaliza tranzação iniciada--------------
		'cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='FaltaFuncionario_cad.asp';
		</script>
		<%
		response.end
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		'cnn.rollbacktrans
	end if
%>