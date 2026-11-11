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
	
	acao 					= Trim(Request.QueryString("acao"))
	intCodigo	 			= Trim(Request.Form("txtCodigo"))
	titulo		 			= Trim(Request.Form("titulo"))
	descricao	 			= Trim(Request.Form("descricao"))
	cod_tipo_link			= Trim(Request.Form("cmbTipoLink"))
	cod_tipo_atividade		= Trim(Request.Form("cmbTipoAtividade"))
	link		 			= Trim(Request.Form("link"))
	cod_turma	 			= Trim(Request.Form("turma"))
	cod_disciplina 			= Trim(Request.Form("disciplina"))
	situacao	 			= Trim(Request.Form("cmbSituacao"))
	intCodProfessor			= Trim(Request.Form("cmbProfessor"))
	
	' Dados do Usuario
	strUsuario_incl   	=	session("usuarioWeb")
	strData_hora_incl 	= 	formatadataBD(date) & " " & time 
	strUsuario_altr   	=	session("usuarioWeb")
	strData_hora_altr 	= 	formatadataBD(date) & " " & time 
			
	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
		
		vetTurma = split(trim(cod_turma),",")
		
		sql = "SET NoCount ON Insert Into EAD_ATIVIDADE_PAI(cod_colaborador, cod_tipo_atividade, titulo, descricao, cod_tipo_link, link, data_hora_agendamento, situacao, usuario_incl, data_hora_incl, usuario_altr, data_hora_altr)"
		sql = sql & " Values ("
		sql = sql & "" & intCodProfessor  & ","
		sql = sql & "" & cod_tipo_atividade  & ","
		sql = sql & "'" & titulo & "',"
		
		IF descricao="" THEN
			sql = sql & "null,"
		ELSE
			sql = sql & "'" & descricao & "',"
		END IF
		
		IF cod_tipo_link="0" THEN
			sql = sql & "null,"
		ELSE
			sql = sql & "" & cod_tipo_link & ","
		END IF
		
		IF link="" THEN
			sql = sql & "null,"
		ELSE
			sql = sql & "'" & link & "',"
		END IF
		IF data_hora_agendamento="" THEN
			sql = sql & "null,"
		ELSE
			sql = sql & "'" & data_hora_agendamento & "',"
		END IF
		
		sql = sql & "'" & situacao & "',"

		sql = sql & "'" & strUsuario_incl & "',GETDATE(),"
		sql = sql & "'" & strUsuario_incl & "',GETDATE()); SELECT @@IDENTITY"
		Set rs = cnn.Execute(sql)
		intCodAtividadePai = rs(0)
		rs.close
		SQL = REPLACE(sql,"SET NoCount ON ","")
		SQL = REPLACE(sql," ; SELECT @@IDENTITY","")
		GravarLog SQL
		
		for i=0 to ubound(vetTurma)
			cod_turma = vetTurma(i)
			vetDisciplina = split(trim(cod_disciplina),",")
			
			if trim(cod_disciplina) = "" then
				
				sql = "Insert Into EAD_ATIVIDADE(cod_atividade_pai, cod_turma, usuario_incl, data_hora_incl)"
				sql = sql & " Values ("
				sql = sql & "" & intCodAtividadePai  & ","
				sql = sql & "" & cod_turma  & ","
				sql = sql & "'" & strUsuario_incl & "',GETDATE())"
				cnn.execute sql
				GravarLog SQL
				
			else
				for j=0 to ubound(vetDisciplina)
					cod_disciplina_vetor = vetDisciplina(j)
				
					sql = "Insert Into EAD_ATIVIDADE(cod_atividade_pai, cod_turma, cod_disciplina, usuario_incl, data_hora_incl)"
					sql = sql & " Values ("
					sql = sql & "" & intCodAtividadePai  & ","
					sql = sql & "" & cod_turma  & ","
					sql = sql & "" & cod_disciplina_vetor  & ","
					sql = sql & "'" & strUsuario_incl & "',GETDATE())"
					cnn.execute sql
					GravarLog SQL
				next
			end if
		next	
		GravarLog sql
	elseif acao="A" then
		strMensagem = "Registro alterado com sucesso..."
		cod_atividade_pai = Trim(Request.Form("cod_atividade_pai"))
		
		sql = "update EAD_ATIVIDADE_PAI set "
		sql = sql & "  cod_colaborador = " & intCodProfessor
		sql = sql & " ,cod_tipo_atividade = " & cod_tipo_atividade
		sql = sql & " ,titulo = '" & titulo & "'"
		sql = sql & " ,descricao = '" & descricao & "'"
		IF cod_tipo_link="0" THEN
			sql = sql & ",cod_tipo_link= null"
		ELSE
			sql = sql & ",cod_tipo_link = " & cod_tipo_link 
		END IF
		IF link="" THEN
			sql = sql & ",link = null,"
		ELSE
			sql = sql & ",link = '" & link & "'"
		END IF
		IF data_hora_agendamento="" THEN
			sql = sql & ",data_hora_agendamento=null"
		ELSE
			sql = sql & ",data_hora_agendamento = '" & data_hora_agendamento & "'"
		END IF
		sql = sql & " ,situacao = '" & situacao & "'"
		sql = sql & " ,usuario_altr = '" & strUsuario_incl & "'"
		sql = sql & " ,data_hora_altr = getdate()"
		sql = sql & " WHERE cod_atividade_pai =" & intCodigo
		cnn.execute sql
		GravarLog sql	
	elseif acao="E" then
		strMensagem = "Registro removido com sucesso..."
		
		cod_atividade_pai = Trim(Request.Form("cod_atividade_pai"))
		
		sql = "delete from EAD_ATIVIDADE "
		sql = sql & " WHERE cod_atividade_pai =" & cod_atividade_pai
		cnn.execute sql
		GravarLog sql		

		sql = "delete from EAD_ATIVIDADE_pai "
		sql = sql & " WHERE cod_atividade_pai =" & cod_atividade_pai
		cnn.execute sql
		GravarLog sql		

	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='atividade_cad.asp';
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