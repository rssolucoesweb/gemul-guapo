<meta http-equiv="content-type" content="text/html; charset=UTF-8">
	<!--#include file="../../includes/inc_verificaSession.asp"-->
	<!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../../includes/inc_replaceRequest.asp"-->
    <!--#include file="../../includes/inc_formatadata.asp"-->
	<!--#include file="../../includes/inc_log.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 										= Trim(Request.QueryString("acao"))
	enviarFalta									= Trim(Request.QueryString("enviarFalta"))
	CodRegistroMestre							= Trim(Request.QueryString("CodRegistroMestre"))
	
	intCodEmp									= Session("CodEmpresa")
	intCodigo           	  					= Trim(Request.Form("txtCodigo"))
	intCodModulacaoReferencia 					= Trim(Request.form("cmbModulacaoReferencia"))
	strDataLancamento         					= Trim(Request("txtDataLancamento"))
	strDataLancamentoFinal        				= Trim(Request("txtDataLancamentoFinal"))
	if strDataLancamentoFinal = "" then strDataLancamentoFinal = strDataLancamento
	intCodColaborador	         	 				= Trim(Request("cmbColaborador")) 
	strComparaDataLancamento 					= formataDataCalc(Trim(Request("txtDataLancamento")))
	strTipoLancamento          					= Trim(Request("optTipoLancamento"))
	strOptTipoColaborador     					= Trim(Request("optTipoColaborador"))
	strJustificativaAbono    					= Trim(Request("txtJustificativaAbono"))
	strJustificativa          					= Trim(Request("txtJustificativa"))
	strSimouNao               					= Trim(Request("cmbSimouNao"))
	strCodFuncaoFuncionario             		= Trim(Request("txtCodFuncaoFuncionario"))
	strCodTurnoFuncionario             			= Trim(Request("txtCodTurnoFuncionario"))
	intCodColaboradorJustificativa             	= Trim(Request("txtCodColaboradorJustificativa"))
	strFechamento             					= Trim(Request("cmbFechamento"))
	intCodTurnoFaltas 							= Trim(Request.form("cmbTurnoFaltas"))
	strAnoLetivo             					= Trim(Request("txtAnoLetivo"))
	intSemestre             					= Trim(Request("cmbSemestre"))
	codColaboradorFaltas						= Trim(Request("chkCodigo"))
	
	' Dados do Usuario
	strUsuario_incl   	= session("usuarioWeb")
	strData_hora_incl 	= formataDataBDAccess(date) & " " & time
	strUsuario_altr   	= session("usuarioWeb")
	strData_hora_altr 	= formataDataBDAccess(date) & " " & time
	
	if acao = "I" then
		sql = "select codigo" 
		sql = sql & " from SRH_COLABORADOR_FALTAS"
		sql = sql & " where cod_empresa = " & Session("CodEmpresa")  
		sql = sql & " and cod_colaborador = " & intCodColaborador
		sql = sql & " and tela_inclusao = 'TELA_FUNCIONARIO'"
		sql = sql & " and cod_turno_lancamento = " & intCodTurnoFaltas
		if strDataLancamentoFinal <> "" then
			sql = sql & " and ("
			sql = sql & " 		'" & formatadataBD(strDataLancamento) & "' between DataLancamento and DataLancamentoFinal"
			sql = sql & " 		or " 
			sql = sql & " 		'" & formatadataBD(strDataLancamentoFinal) & "' between DataLancamento and DataLancamentoFinal"
			sql = sql & " 		or "	
			sql = sql & " 			("
			sql = sql & " 			 DataLancamento > '" & formatadataBD(strDataLancamento) & "' and DataLancamentoFinal < '" & formatadataBD(strDataLancamentoFinal) & "'"
			sql = sql & " 			)"
			sql = sql & " 		)"	
		else
			sql = sql & " and convert(datetime,convert(varchar, DataLancamento, 103),103) = convert(datetime, ' " & formatadataAP(strDataLancamento) & " ',103) " 
		end if
		rs.open sql, cnn
		if rs.eof = false then
			%>
			<script>
				alert("Falta lancada para esse colaborador no mesmo turno. Verifique!");
				window.location='faltas_nao_justificadas_funcionario_cad.asp';
			</script>
			<%
			response.end 
		end if	
		rs.close
		
		strMensagem = "Registro Incluido com sucesso..."

		sql = "SET NoCount ON Insert Into SRH_COLABORADOR_FALTAS(cod_empresa,CodReferencia,ano_letivo,semestre_letivo,DataLancamento,DataLancamentoFinal,DataDiaLancamento,cod_colaborador,Cod_Funcao, cod_turno_colaborador, cod_turno_lancamento,tela_inclusao,usuario_inclusao,data_inclusao)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & intCodModulacaoReferencia & ","
		sql = sql & "" & strAnoLetivo & ","
		sql = sql & "" & intSemestre & ","
		sql = sql & "'" & formatadataBD(strDataLancamento) & "',"
		sql = sql & "'" & formatadataBD(strDataLancamentoFinal) & "',"
		sql = sql & "'" & formataDataBDAccess(date) & "',"
		sql = sql & "" & intCodColaborador & ","
		sql = sql & "" & strCodFuncaoFuncionario & "," 
		sql = sql & "" & strCodTurnoFuncionario & "," 
		sql = sql & "" & intCodTurnoFaltas & "," 
		sql = sql & "'TELA_FUNCIONARIO','" & strUsuario_incl & "',GETDATE()); SELECT @@IDENTITY"
		response.write sql
		Set rs = cnn.Execute(sql)
		intCodColaboradorFalta = rs(0)
		rs.close
		SQL = REPLACE(sql,"SET NoCount ON ","")
		SQL = REPLACE(sql," ; SELECT @@IDENTITY","")
		GravarLog SQL
		
		strDataLancamentoCompara 		= strDataLancamento
		IF strDataLancamentoFinal = "" THEN strDataLancamentoFinal = strDataLancamento
		strDataLancamentoFinalCompara 	= strDataLancamentoFinal
					
		do while true
		
			sql = "Insert Into SRH_COLABORADOR_FALTAS_DIARIA(cod_colaborador_faltas, dataFalta) values ("
			sql = sql & "" & intCodColaboradorFalta & ","
			sql = sql & "'" & formatadataBD(strDataLancamentoCompara) & "')"
			cnn.execute sql
				
			strDataLancamentoCompara = DateAdd("d", 1, strDataLancamentoCompara)
			
			if cCur(formatadataCalc(Trim(strDataLancamentoCompara))) > cCur(formatadataCalc(Trim(strDataLancamentoFinalCompara))) then
				exit do
			end if
			
		loop
		
		
	elseif acao = "E" then
		sql = "delete from SRH_COLABORADOR_FALTAS_DIARIA"
		sql = sql & " where cod_colaborador_faltas = " & intCodigo
		cnn.execute sql
		GravarLog sql
		
		sql = "delete from SRH_COLABORADOR_FALTAS"
		sql = sql & " where codigo = " & intCodigo
		cnn.execute sql
		GravarLog sql
		strMensagem = "Registro excluido com sucesso..."
	end if
	
	if enviarFalta = "S" and acao="ENVIAR" then

		sql = "UPDATE SRH_COLABORADOR_FALTAS SET FECHAMENTO = 'S',DATA_FECHAMENTO=GETDATE(),USUARIO_FECHAMENTO='" & strUsuario_incl & "',Fechamento_devolvido=NULL, data_Fechamento_devolvido=null, usuario_Fechamento_devolvido=NULL "
		sql = sql & " WHERE codigo in (" & codColaboradorFaltas & ") "
		sql = sql & " AND (FECHAMENTO = 'N' or ISNULL(FECHAMENTO,'0') = '0') "
		cnn.execute sql
		GravarLog sql
		strMensagem = "Registros enviados com sucesso..."

	end if   

	devolverFalta 				= Trim(Request.QueryString("devolverFalta"))
	if devolverFalta = "S" then
		
		sql = "UPDATE SRH_COLABORADOR_FALTAS SET FECHAMENTO = 'N', Fechamento_devolvido='S', situacao = 'D', data_Fechamento_devolvido=getdate(), usuario_Fechamento_devolvido='" & strUsuario_incl & "'"
		sql = sql & " WHERE codigo in (" & codColaboradorFaltas & ") "
		sql = sql & " AND (FECHAMENTO = 'S') "
		cnn.execute sql
		GravarLog sql

		strMensagem = "Registros devolvidos com sucesso..."
	
	end if

	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------

		cnn.commitTrans
		
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location = "faltas_nao_justificadas_funcionario_cad.asp";
		</script>			
		<%
		
		response.end
		
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>