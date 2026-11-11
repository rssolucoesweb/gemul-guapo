<meta http-equiv="content-type" content="text/html; charset=UTF-8">
	<!--#include file="../../includes/inc_verificaSession.asp"-->
	<!--#include file="../../includes/inc_cnndocumento.asp"-->
	<!--#include file="../../includes/inc_replaceRequest.asp"-->
    <!--#include file="../../includes/inc_formatadata.asp"-->
	<!--#include file="../../includes/inc_log.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 										= Trim(Request.QueryString("acao"))
	enviarFalta									= Trim(Request.QueryString("enviarFalta"))
	
	intCodEmp									= Session("CodEmpresa")
	intCodigo           	  					= Trim(Request.Form("txtCodigo_SRH_COLABORADOR_FREQUENCIA_FOLHA"))
	intCodModulacaoReferencia 					= Trim(Request.form("cmbModulacaoReferencia"))
	strDataLancamento         					= Trim(Request("txtDataLancamento"))
	strDataLancamentoFinal        				= Trim(Request("txtDataLancamentoFinal"))
	if strDataLancamentoFinal = "" then strDataLancamentoFinal = strDataLancamento
	intCodColaborador	         	 			= Trim(Request("cmbColaborador")) 
	strComparaDataLancamento 					= formataDataCalc(Trim(Request("txtDataLancamento")))
	strTipoLancamento          					= Trim(Request("optTipoLancamento"))
	strOptTipoColaborador     					= Trim(Request("optTipoColaborador"))
	strObservacao		    					= Trim(Request("txtObservacao"))
	strCodFuncaoFuncionario             		= Trim(Request("txtCodFuncaoFuncionario"))
	strCodTurnoFuncionario             			= Trim(Request("txtCodTurnoFuncionario"))
	strFechamento             					= Trim(Request("cmbFechamento"))
	intCodTurnoFaltas 							= Trim(Request.form("cmbTurnoFaltas"))
	strAnoLetivo             					= Trim(Request("txtAnoLetivo"))
	intSemestre             					= Trim(Request("txtSemestre"))
	codColaboradorFrequencia					= Trim(Request("chkCodigo"))
	
	if acao = "I" or acao = "A"  then
		strImagem									= Trim(Request("txtTexto"))
	end if
	
	' Dados do Usuario
	strUsuario_incl   	= session("usuarioWeb")
	strData_hora_incl 	= formataDataBDAccess(date) & " " & time
	strUsuario_altr   	= session("usuarioWeb")
	strData_hora_altr 	= formataDataBDAccess(date) & " " & time
	
	if acao = "I" then
		sql = "select codigo" 
		sql = sql & " from SRH_COLABORADOR_FREQUENCIA_FOLHA"
		sql = sql & " where cod_empresa = " & Session("CodEmpresa")  
		sql = sql & " and cod_colaborador = " & intCodColaborador
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
				alert("frequencia lancada para esse colaborador no mesmo turno. Verifique!");
				window.location='frequenciaColaborador_cad.asp';
			</script>
			<%
			response.end 
		end if	
		rs.close
		
		strMensagem = "Registro Incluido com sucesso..."

		sql = "SET NoCount ON Insert Into SRH_COLABORADOR_FREQUENCIA_FOLHA(cod_empresa,CodReferencia,ano_letivo,semestre_letivo,DataLancamento,DataLancamentoFinal,DataDiaLancamento,cod_colaborador,Cod_Funcao,cod_turno_colaborador,cod_turno_lancamento,observacao,usuario_inclusao,data_inclusao)"
		sql = sql & " Values ("
		sql = sql & ""  & intCodEmp & ","
		sql = sql & ""  & intCodModulacaoReferencia & ","
		sql = sql & ""  & strAnoLetivo & ","
		sql = sql & ""  & intSemestre & ","
		sql = sql & "'" & formatadataBD(strDataLancamento) & "',"
		sql = sql & "'" & formatadataBD(strDataLancamentoFinal) & "',"
		sql = sql & "getdate(),"
		sql = sql & ""  & intCodColaborador & ","
		sql = sql & ""  & strCodFuncaoFuncionario & "," 
		sql = sql & ""  & strCodTurnoFuncionario & "," 
		sql = sql & ""  & intCodTurnoFaltas & "," 
		sql = sql & "'"  & strObservacao & "'," 
		sql = sql & "'" & strUsuario_incl & "',GETDATE()); SELECT @@IDENTITY"
		'response.write sql
		'response.end
		Set rs = cnn.Execute(sql)
		intCodColaboradorFrequencia = rs(0)
		rs.close
		SQL = REPLACE(sql,"SET NoCount ON ","")
		SQL = REPLACE(sql," ; SELECT @@IDENTITY","")
		GravarLog SQL
		
		sql = "Insert Into SRH_COLABORADOR_FREQUENCIA_FOLHA_IMAGEM(cod_colaborador_frequencia_folha, cod_colaborador, imagem )"
		sql = sql & " Values ("
		sql = sql & "" & intCodColaboradorFrequencia & ","
		sql = sql & "" & intCodColaborador & ","
		sql = sql & "'" & strImagem & "')"
		cnn.execute sql
		
		
		strDataLancamentoCompara 		= strDataLancamento
		IF strDataLancamentoFinal = "" THEN strDataLancamentoFinal = strDataLancamento
		strDataLancamentoFinalCompara 	= strDataLancamentoFinal
					
		do while true
		
			sql = "Insert Into SRH_COLABORADOR_FREQUENCIA_FOLHA_DIARIA(cod_colaborador_frequencia_folha, dataDaFrequencia) values ("
			sql = sql & "" & intCodColaboradorFrequencia & ","
			sql = sql & "'" & formatadataBD(strDataLancamentoCompara) & "')"
			cnn.execute sql
				
			strDataLancamentoCompara = DateAdd("d", 1, strDataLancamentoCompara)
			
			if cCur(formatadataCalc(Trim(strDataLancamentoCompara))) > cCur(formatadataCalc(Trim(strDataLancamentoFinalCompara))) then
				exit do
			end if
			
		loop
	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		
		sql = "UPDATE SRH_COLABORADOR_FREQUENCIA_FOLHA SET "
		sql = sql & " observacao='" & strObservacao & "'"
		sql = sql & ",usuario_alteracao='" & strUsuario_incl & "'"
		sql = sql & ",data_alteracao=getdate()"
		sql = sql & " WHERE COD_EMPRESA = "  & session("CodEmpresa")
		sql = sql & " AND codigo = " & intCodigo
		cnn.execute sql
		
		sql = "UPDATE SRH_COLABORADOR_FREQUENCIA_FOLHA_IMAGEM SET "
		sql = sql & " imagem = '" & strImagem & "' "
		sql = sql & " WHERE cod_colaborador_frequencia_folha = " & intCodigo
		cnn.execute sql	
		
	elseif acao = "E" then
		sql = "delete from SRH_COLABORADOR_FREQUENCIA_FOLHA_DIARIA"
		sql = sql & " where cod_colaborador_frequencia_folha = " & intCodigo
		cnn.execute sql
		GravarLog sql
		
		sql = "delete from SRH_COLABORADOR_FREQUENCIA_FOLHA_IMAGEM"
		sql = sql & " where cod_colaborador_frequencia_folha = " & intCodigo
		cnn.execute sql
		GravarLog sql
		
		sql = "delete from SRH_COLABORADOR_FREQUENCIA_FOLHA"
		sql = sql & " where codigo = " & intCodigo
		
		
		cnn.execute sql
		GravarLog sql
		strMensagem = "Registro excluido com sucesso..."
	end if
	
	if enviarFalta = "S" and acao="ENVIAR" then

		sql = "UPDATE SRH_COLABORADOR_FREQUENCIA_FOLHA SET FECHAMENTO = 'S',DATA_FECHAMENTO=GETDATE(),USUARIO_FECHAMENTO='" & strUsuario_incl & "',Fechamento_devolvido=NULL, data_Fechamento_devolvido=null, usuario_Fechamento_devolvido=NULL "
		sql = sql & " WHERE codigo in (" & codColaboradorFrequencia & ") "
		sql = sql & " AND (FECHAMENTO = 'N' or ISNULL(FECHAMENTO,'0') = '0') "
		cnn.execute sql
		GravarLog sql
		strMensagem = "Registros enviados com sucesso..."

	end if   

	devolverFalta 				= Trim(Request.QueryString("devolverFalta"))
	if devolverFalta = "S" then
		
		sql = "UPDATE SRH_COLABORADOR_FREQUENCIA_FOLHA SET FECHAMENTO = 'N', Fechamento_devolvido='S', situacao = 'D', data_Fechamento_devolvido=getdate(), usuario_Fechamento_devolvido='" & strUsuario_incl & "'"
		sql = sql & " WHERE codigo in (" & codColaboradorFrequencia & ") "
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
			window.location = "frequenciaColaborador_cad.asp";
		</script>			
		<%
		
		response.end
		
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>