<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<!--#include file="../../includes/inc_formataData.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	acao 					= Trim(Request.QueryString("acao"))
	intCodigo	 			= Trim(Request.Form("txtCodigo"))
	assunto		 			= Trim(Request.Form("assunto"))
	texto		 			= Trim(Request.Form("texto"))
	cod_turma	 			= Trim(Request.Form("cmbTurmaProfessor"))
	cod_aluno	 			= Trim(Request.Form("cmbAlunoTurma"))
	if cod_aluno = "" then cod_aluno = "0"
	
	cod_colaborador			= Trim(Request.Form("cmbProfessor"))
	
	' Dados do Usuario
	strUsuario_incl   	=	session("usuarioWeb")
	strData_hora_incl 	= 	formatadataBD(date) & " " & time 
	strUsuario_altr   	=	session("usuarioWeb")
	strData_hora_altr 	= 	formatadataBD(date) & " " & time 
			
	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
		
		if cod_aluno<>"0" then
			sql = "Insert Into EAD_MENSAGEM(cod_empresa, cod_colaborador, cod_aluno, assunto, descricao, situacao, usuario_incl_aluno, usuario_incl_colaborador, usuario_logado, data_hora_incl)"
			sql = sql & " Values ("
			sql = sql & "" & Session("CodEmpresa")  & ","
			sql = sql & "" & cod_colaborador  & ","
			sql = sql & "" & cod_aluno  & ","
			sql = sql & "'" & assunto & "',"
			sql = sql & "'" & texto & "',"
			sql = sql & "'E',"
			sql = sql & "null,"
			sql = sql & "" & cod_colaborador  & ","
			' Usuario do Sistema
			sql = sql & "'" & strUsuario_incl & "',"
			sql = sql & "'" & strData_hora_incl & "')"
			
			cnn.execute sql
			GravarLog sql
		else

			sql = "Insert Into EAD_MENSAGEM(cod_empresa, cod_colaborador, cod_aluno, cod_turma, assunto, descricao, situacao, usuario_incl_aluno, usuario_incl_colaborador, usuario_logado, data_hora_incl)"
			sql = sql & " select distinct "
			sql = sql & "" & Session("CodEmpresa")  & ","
			sql = sql & "" & cod_colaborador  & ",cod_aluno,"
			sql = sql & "" & cod_turma  & ","
			sql = sql & "'" & assunto & "',"
			sql = sql & "'" & texto & "',"
			sql = sql & "'E',"
			sql = sql & "null,"
			sql = sql & "" & cod_colaborador  & ","
			' Usuario do Sistema
			sql = sql & "'" & strUsuario_incl & "',"
			sql = sql & "'" & strData_hora_incl & "'" 
			
			sql = sql & " from SCA_ALUNO_TURMA"
			sql = sql & " where COD_TURMA = " & cod_turma
			sql = sql & " and SITUACAO = 'A'"
response.write sql
			cnn.execute sql
			GravarLog sql
		end if
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='mensagem_cad.asp';
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