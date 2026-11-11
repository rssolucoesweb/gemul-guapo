<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formataData.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 					= Trim(Request.QueryString("acao"))
	intCodEmp				= Session("CodEmpresa")
	intCodigo		 		= Trim(Request.Form("txtCodigo"))
	intCodAluno 			= Trim(Request.Form("txtCodAluno"))
	strDataOcorrencia 		= FORMATADATABD(Trim(Request.Form("txtDataOcorrencia"))) 
	strOcorrencia 			= Trim(Request.Form("txtOcorrencia"))
    
	strAnoLetivo = session("strAnoLetivo")
	intSemestre  = session("strSemestre")

	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
		
		strMostraMensagemBloqueiaLancamentoMesmaData=""
		sql = "select COD_ALUNO from sca_ocorrencia_faltas"
		sql = sql & " where cod_aluno = " & intCodAluno
		sql = sql & " and DATAOCORRENCIA = '" & strDataOcorrencia & "'"
		sql = sql & " and USUARIO_INCL = '" & Session("UsuarioWeb") & "'"
		RS.OPEN SQL, CNN
		IF not RS.EOF THEN
			strMostraMensagemBloqueiaLancamentoMesmaData = "S"
		END IF
		rs.close
		
		if strMostraMensagemBloqueiaLancamentoMesmaData = "S" then
			%>
			<script>
				alert("Você já lançou uma ocorrência nessa mesma data!");
				window.history.back();
			</script>
			<%
			response.End()
		end if
		
		sql = "Insert Into SCA_OCORRENCIA_FALTAS (COD_EMPRESA, COD_ALUNO, ANO_LETIVO, SEMESTRE, DATAOCORRENCIA, OCORRENCIA, USUARIO_INCL, DATA_HORA_INCL)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & intCodAluno & ","
		sql = sql & "" & strAnoLetivo & ","
		sql = sql & "" & intSemestre & ","
		sql = sql & "'" & strDataOcorrencia & "',"
		sql = sql & "'" & strOcorrencia & "',"
		sql = sql & "'" & Session("UsuarioWeb") & "',"
		sql = sql & "GETDATE())"
	
	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		
		sql = "Update SCA_OCORRENCIA_FALTAS Set"
		sql = sql & " OCORRENCIA = '" & strOcorrencia & "',"
		sql = sql & " DATA_HORA_INCL = GETDATE()"
		sql = sql & " where COD_OCORRENCIA_FALTAS = " & intCodigo
		sql = sql & " and COD_empresa = " & intCodEmp
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."

		sql = "Delete from SCA_OCORRENCIA_FALTAS "
		sql = sql & " where COD_OCORRENCIA_FALTAS = " & intCodigo
		sql = sql & " and COD_empresa = " & intCodEmp
		
	end if
	
	cnn.execute sql
	GravarLog sql
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location="FaltasHorarioOcorrencia_cad.asp?txtCodAluno=<%=intCodAluno%>";
			//window.opener.frm.submit();
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