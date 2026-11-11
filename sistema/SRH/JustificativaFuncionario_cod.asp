<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnndocumento.asp"-->
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
	intCodProfessor	         	 				= Trim(Request("cmbColaborador")) 
	strComparaDataLancamento 					= formataDataCalc(Trim(Request("txtDataLancamento")))
	strTipoLancamento          					= Trim(Request("optTipoLancamento"))
	strOptTipoColaborador     					= Trim(Request("optTipoColaborador"))
	strJustificativa          					= Trim(Request("txtJustificativa"))
	strSimouNao               					= Trim(Request("cmbSimouNao"))
	strFechamento             					= Trim(Request("cmbFechamento"))
	strCodFuncaoFuncionario             		= Trim(Request("txtCodFuncaoFuncionario"))
	if acao <> "E" then
		strImagem									= Trim(Request("txtTexto"))
	end if
	strAnoLetivo             					= Trim(Request("txtAnoLetivo"))
	intSemestre             					= Trim(Request("cmbSemestre"))
	
	if strSimouNao = "" then
	   strSimouNao = "N"
	end if 
	if acao="I" then
		if LEFT(strImagem,9)<>"<img src=" then
			%>
			<script>
				alert("Imagem do documento invalida, devera ser enviado somente documento do tipo IMAGEM!");
				window.history.back();
			</script>
			<%
			response.end 
		end if	
		if LEN(strImagem)>9999999 then
			%>
			<script>
				alert("Imagem não permitida, Favor redur o tamanho da imagem!");
				window.history.back();
			</script>
			<%
			response.end 
		end if	
	end if
	  
	if acao="I" then
		
		strMaximoDiasParaJustificativa = DateDiff("d",strDataLancamento,date) 
		if strMaximoDiasParaJustificativa = "" then strMaximoDiasParaJustificativa = 0
		if cInt(strMaximoDiasParaJustificativa)>30000 then
			%>
			<script>
				alert("O envio da justificativa pode ser no maximo de 72 horas!");
				window.history.back();
			</script>
			<%
			response.end 
		end if	
		sql = " select codigo from SRH_COLABORADOR_JUSTIFICATIVA " 
		sql = sql & " where cod_empresa = " & Session("CodEmpresa")  
		sql = sql & " and cod_colaborador = " & intCodProfessor 
		sql = sql & " and convert(datetime,convert(varchar, DataLancamento, 103),103) >= convert(datetime, ' " & formatadataAP(strDataLancamento) & " ',103) " 
		sql = sql & " and convert(datetime,convert(varchar, DataLancamentoFinal, 103),103) <= convert(datetime, ' " & formatadataAP(strDataLancamentoFinal) & " ',103) "
		rs.open sql, cnn
		if rs.eof = false then
			%>
			<script>
				alert("ATENÇÃO: Justificativa já lancada para esse Colaborador. Verifique!");
				window.location='JustificativaFuncionario_Cad.asp';
			</script>
			<%
			response.end 
		end if	
		rs.close
	
		strMensagem = "Registro Incluido com sucesso..."
	
		strDataLancamentoCompara 		= strDataLancamento
		strDataLancamentoFinalCompara 	= strDataLancamentoFinal
		strTipoLancamento				= "I"
		strOptTipoColaborador			= "F"

		sql = "SET NoCount ON Insert Into SRH_COLABORADOR_Justificativa(cod_empresa, Cod_JustificativaFaltas, CodReferencia, ano_letivo, semestre_letivo, "
		sql = sql & " Datalancamento, DataLancamentoFinal, DataDiaLancamento, "
		sql = sql & " tipo_colaborador, cod_colaborador, cod_funcao, "
		sql = sql & " justificativa, "
		sql = sql & " situacao, fechamento, tipoLancamento, incluido_por)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & intCodJustificativaFaltas & ","
		sql = sql & "" & intCodModulacaoReferencia & ","
		sql = sql & "" & strAnoLetivo & ","
		sql = sql & "" & intSemestre & ","
		sql = sql & "'" & formatadataBD(strDataLancamento) & "',"
		sql = sql & "'" & formatadataBD(strDataLancamentoFinal) & "',"
		sql = sql & "'" & formatadataBD(date) & "',"
		sql = sql & "'" & strOptTipoColaborador & "',"
		sql = sql & "" & intCodProfessor & ","
		sql = sql & "" & strCodFuncaoFuncionario & "," 
		if strJustificativa <> "" then
			sql = sql & "'" & strJustificativa & "',"
		else 
			sql = sql &" null ,"
		end if
		if strSimouNao <> "" then
			sql = sql & "'" & strSimouNao & "',"
		else 
			sql = sql &" null ,"
		end if
		if strFechamento <> "" then
			sql = sql & "'" & strFechamento & "',"
		else 
			sql = sql &" null,"
		end if
		sql = sql & "'" & strTipoLancamento & "','JustificativaFuncionario_cad.asp') ; SELECT @@IDENTITY"
		Set rs = cnn.Execute(sql)
		intCodigo = rs(0)
		rs.close
		SQL = REPLACE(sql,"SET NoCount ON ","")
		SQL = REPLACE(sql," ; SELECT @@IDENTITY","")
		GravarLog SQL
		
		sql = "Insert Into SRH_COLABORADOR_Justificativa_imagem(cod_colaborador_Justificativa, cod_colaborador, imagem )"
		sql = sql & " Values ("
		sql = sql & "" & intCodigo & ","
		sql = sql & "" & intCodProfessor & ","
		sql = sql & "'" & strImagem & "')"
		cnn.execute sql
		
	
	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		
		sql = "UPDATE SRH_COLABORADOR_JUSTIFICATIVA SET "
		sql = sql & " Datalancamento = '" & formatadataBD(strDataLancamento) & "'"
		sql = sql & " ,DataLancamentoFinal = '" & formatadataBD(strDataLancamentoFinal) & "'"
		if strJustificativa <> "" then
			sql = sql & ",justificativa='" & strJustificativa & "'"
		else 
			sql = sql & ",justificativa=null "
		end if		
		sql = sql & " WHERE COD_EMPRESA = "  & session("CodEmpresa")
		sql = sql & " AND codigo = " & intCodigo
		cnn.execute sql
		
		sql = "UPDATE SRH_COLABORADOR_JUSTIFICATIVA_IMAGEM SET "
		sql = sql & " imagem = '" & strImagem & "' "
		sql = sql & " WHERE cod_colaborador_Justificativa = " & intCodigo
		cnn.execute sql

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
		sql = sql & " COD_COLABORADOR "
		sql = sql & " from SRH_COLABORADOR_JUSTIFICATIVA "
		sql = sql & " WHERE CODIGO = " & intCodigo
'response.write sql & "<hr>"		
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
		end if 
		rs.close
		
		sql = "Delete from SRH_COLABORADOR_JUSTIFICATIVA_IMAGEM "
		sql = sql & " where cod_colaborador_justificativa =" & intCodigo
'response.write sql & "<hr>"		
		cnn.execute sql
		GravarLog sql		
		
		sql = "Delete from SRH_COLABORADOR_JUSTIFICATIVA "
		sql = sql & " where codigo = " & intCodigo
'response.write sql & "<hr>"		
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
		sql = sql & " COD_COLABORADOR "
		sql = sql & " from SRH_COLABORADOR_JUSTIFICATIVA "
		sql = sql & " WHERE CODIGO = " & CodRegistroMestre
		'sql = sql & " and incluido_por = 'JustificativaFuncionario_cad.asp'" 
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
		end if 
		rs.close

		sql = "UPDATE SRH_COLABORADOR_JUSTIFICATIVA SET FECHAMENTO = 'S',Fechamento_devolvido=NULL "
		sql = sql & " WHERE COD_EMPRESA = "  & session("CodEmpresa")
		sql = sql & " AND (FECHAMENTO = 'N' or ISNULL(FECHAMENTO,'0') = '0') "
		sql = sql & " and Cod_JustificativaFaltas = " & intCodJustificativaFaltas
		sql = sql & " and codReferencia = " & intCodModulacaoReferencia
		sql = sql & " and DATALANCAMENTO = '" & strDataLancamento & "'"
		sql = sql & " and DATALANCAMENTOFINAL = '" & strDataLancamentoFinal & "'"
		sql = sql & " and DataDiaLancamento = '" & strDataDiaLancamento & "'"
		sql = sql & " and COD_COLABORADOR = " & intCodProfessor
		'sql = sql & " and incluido_por = 'JustificativaFuncionario_cad.asp'" 
		cnn.execute sql
		GravarLog sql
		strMensagem = "Registros enviado com sucesso..."
	end if   

	devolverFalta 				= Trim(Request.QueryString("devolverFalta"))
	if devolverFalta = "S" then

		sql = "UPDATE SRH_COLABORADOR_JUSTIFICATIVA SET FECHAMENTO = 'N',Fechamento_devolvido='S' "
		sql = sql & " WHERE COD_EMPRESA = "  & session("CodEmpresa")
		sql = sql & " AND FECHAMENTO = 'S' "
		sql = sql & " and CODIGO = " & CodRegistroMestre
		cnn.execute sql
		GravarLog sql		
		strMensagem = "Registros devolvidos com sucesso..."
	end if  
	if ucase(session("usuarioWeb")) = "SERGIO"  THEN
		'response.write "<hr>" & sql
		'response.write "<hr>"
		'response.end	
	end if			

	if err.number = 0 then
		'----------Finaliza tranzação iniciada--------------
		'cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='JustificativaFuncionario_cad.asp?tipo_colaborador=F&cmbModulacaoReferencia=<%=intCodModulacaoReferencia%>';
		</script>
		<%
		response.end
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		'cnn.rollbacktrans
	end if
%>