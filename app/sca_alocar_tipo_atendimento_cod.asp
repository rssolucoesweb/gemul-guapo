<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_log.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="includes/inc_cursosAtendimento.asp"-->
<%
cnn.begintrans
	
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmp			= Session("CodEmpresa")
	strAnoLetivo		= Session("strAnoLetivo")
	intCodAluno			= Trim(Request("txtCodAluno"))
	strMatricula		= Trim(Request("txtMatricula"))	
	strTipoAtendimento	= Trim(Request("cmbTipoAtendimento"))	
	intCodSituacaoAluno	= Trim(Request("txtCodSituacaoAluno"))	

	if acao="I" then
		
		' Excluir todos registro do aluno
		sql = " Delete from SCA_ALUNO_TIPO_ATENDIMENTO"
		sql = sql & " Where cod_aluno = " & intCodAluno
		sql = sql & " and cod_empresa = " & intCodEmp
		sql = sql & " and ano_letivo = " & strAnoLetivo
		cnn.execute sql

		strMensagem = "Registro Salvo com sucesso..."
		
		sql = "select t.Cod_Turma"
		sql = sql & " from sca_turma t"
		sql = sql & " inner join SCA_TURNO tu on tu.Cod_Turno = t.Cod_Turno"
		sql = sql & " where t.anoletivo = " & Session("strAnoLetivo")
		sql = sql & " and t.Cod_periodo = " & clng(intCodPeriodoATC)	'--ATC (Guapó: período achado pela sigla do curso)
		sql = sql & " and t.Cod_Empresa = " & Session("CodEmpresa")
		rs.open sql, cnn,3,3		
		while not rs.eof
			strDataIngresso 	= formatadataBD(request.Form("txtDataIngresso" & rs("cod_turma")))
			intCodTurma			= request.Form("chkTurma" & rs("cod_turma"))
			if intCodTurma<>"" then

				sql = "Insert Into SCA_ALUNO_TIPO_ATENDIMENTO (cod_empresa, ano_letivo, cod_aluno, cod_turma, tipo_atendimento, data_ingresso, cod_situacao_aluno, usuario_incl, data_hora_incl)"
				sql = sql & " Values ("
				sql = sql & "" & intCodEmp & ","
				sql = sql & "" & strAnoLetivo & ","
				sql = sql & "" & intCodAluno & ","
				sql = sql & "" & intCodTurma & ","
				sql = sql & "'" & strTipoAtendimento & "',"
				sql = sql & "'" & strDataIngresso & "',"			
				sql = sql & "" & intCodSituacaoAluno & ","			
				sql = sql & "'" & session("usuarioWeb") & "',"			
				sql = sql & "getdate())"
				cnn.execute sql
				
			end if
			rs.movenext
		wend
		rs.close
		
		
	elseif acao="E" then
		
		strMensagem = "Registro Excluido com sucesso"
		
		sql = " Delete from SCA_ALUNO_TIPO_ATENDIMENTO"
		sql = sql & " Where cod_aluno = " & intCodAluno
		sql = sql & " and cod_empresa = " & intCodEmp
		sql = sql & " and ano_letivo = " & strAnoLetivo
		cnn.execute sql
	
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='sca_alocar_tipo_Atendimento.asp?txtMatricula=<%=strMatricula%>&cmbTipoAtendimento=<%=strTipoAtendimento%>';
		</script>
		<%
		response.end
	else
		cnn.rollbackTrans
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			alert('<%=replace(err.description,"'","")%>');
			window.history.back();
		</script>
		<%
	end if
%>