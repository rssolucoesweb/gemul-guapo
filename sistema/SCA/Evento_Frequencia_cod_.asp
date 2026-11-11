<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 28/01/2008
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Vicula Aluno a Rota
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	acao 					= Trim(Request.QueryString("acao"))
	intCodEmpresa 			= Session("CodEmpresa")
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodEventoSeminario	= Trim(Request.Form("cmbEventoSeminario"))
	strSemestre 			= session("strSemestre")
	strCodAluno				= Trim(Request("txtCodAluno"))
	strMatricula 		    = Trim(Request("txtMatricula"))
	strDataInicial			= formatadataBD(Trim(Request.Form("txtDataInicial")))
	strDataFinal			= formatadataBD(Trim(Request.Form("txtDataFinal")))



	if strCodAluno = "" then
		strCodAluno			=	Trim(Request.form("chkAluno"))
	end if

	if acao="I" then 
	
		'sql = " Delete from SCA_SEMINARIO_EVENTO_FREQUENCIA"
		'sql = sql & " Where Cod_Seminario_Evento = " & intCodEventoSeminario
		'if trim(strMatricula) <> "" then
  		'   sql = sql & " and Cod_aluno = " & strCodAluno
		'end if
		'cnn.execute sql
		'GravarLog sql

		strMensagem = "Frequencia Vincula com sucesso..."
		
		if strCodAluno <> "" then   
			vetCodAluno = split(strCodAluno,",")			 
		end if
		
		intConTipo = 0
			 
		for intContador = 0 to ubound(vetCodAluno)
				
			i = i + 1
			
			strCodAluno			= trim(vetCodAluno(intContador))
			strFrequenciaCH 	= request.form("txtCargaHoraria"&i) 
			strDescricaoEvento  = Trim(Request.Form("txtDescricaoEvento"))
			
			sql = "Insert Into SCA_SEMINARIO_EVENTO_FREQUENCIA (Cod_aluno, Cod_Turma, Cod_Seminario_Evento, FrequenciaCH, Descricao_Evento, DataInicial, DataFinal)"
			sql = sql & " Values ("
			sql = sql & " " & strCodAluno & ","
			sql = sql & " " & intCodTurma & ","
			sql = sql & "" & intCodEventoSeminario & ","
			sql = sql & "" & strFrequenciaCH & ","
			if trim(strDescricaoEvento) <> "" then
			   sql = sql & "'" & strDescricaoEvento & "',"
			else   
			   sql = sql & " null,"
			end if   
			if trim(strDataInicial) <> "" then
			   sql = sql & "'" & strDataInicial & "',"
			else   
			   sql = sql & " null,"
			end if   
			if trim(strDataFinal) <> "" then
			   sql = sql & "'" & strDataFinal & "')"
			else   
			   sql = sql & " null)"
			end if   
			cnn.execute sql
			GravarLog sql
	
		next

	elseif acao="A" then
		
		sql = " Delete from SCA_SEMINARIO_EVENTO_FREQUENCIA"
		sql = sql & " Where Cod_Seminario_Evento = " & intCodEventoSeminario
		if trim(strMatricula) <> "" then
  		   sql = sql & " and Cod_aluno = " & strCodAluno
		end if
		cnn.execute sql
		
		GravarLog sql

		strMensagem = "Frequencia Alterada com sucesso..."
		
		if strCodAluno <> "" then   
			vetCodAluno = split(strCodAluno,",")			 
		end if
		
		intConTipo = 0
			 
		for intContador = 0 to ubound(vetCodAluno)
			
			i = i + 1
			
			strCodAluno			= trim(vetCodAluno(intContador))
			strFrequenciaCH 	= request.form("txtCargaHoraria"&i) 
			strDescricaoEvento  = Trim(Request.Form("txtDescricaoEvento"))
			
			sql = "Insert Into SCA_SEMINARIO_EVENTO_FREQUENCIA (Cod_aluno, Cod_Turma, Cod_Seminario_Evento, FrequenciaCH, Descricao_Evento, DataInicial, DataFinal)"
			sql = sql & " Values ("
			sql = sql & " " & strCodAluno & ","
			sql = sql & " " & intCodTurma & ","
			sql = sql & "" & intCodEventoSeminario & ","
			sql = sql & "" & strFrequenciaCH & ","
			if trim(strDescricaoEvento) <> "" then
			   sql = sql & "'" & strDescricaoEvento & "',"
			else   
			   sql = sql & " null,"
			end if   
			if trim(strDataInicial) <> "" then
			   sql = sql & "'" & strDataInicial & "',"
			else   
			   sql = sql & " null,"
			end if   
			if trim(strDataFinal) <> "" then
			   sql = sql & "'" & strDataFinal & "')"
			else   
			   sql = sql & " null)"
			end if   
			cnn.execute sql
			GravarLog sql
	
		next
			
	elseif acao="E" then
		
		sql = " Delete from SCA_SEMINARIO_EVENTO_FREQUENCIA"
		sql = sql & " Where Cod_Seminario_Evento = " & intCodEventoSeminario
		if trim(strMatricula) <> "" then
  		   sql = sql & " and Cod_aluno = " & strCodAluno
		end if
		cnn.execute sql
		
		if trim(strMatricula) <> "" then
		   %>
		   <script>
		      alert("Atenção! Foi EXCLUÍDO somente a MATRÍCULA informada ");
		   </script>
		   <%
		else   
		   %>
		   <script>
		      alert("Atenção! Foram EXCLUÍDOS TODOS os alunos relacionado ao evento ");
		   </script>
		   <%
        end if
		strMensagem = "Frequencia Excluida com sucesso..."
		
	end if
	
if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.navigate('Evento_Frequencia_cad.asp');
		</script>
		<%
		response.end
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>