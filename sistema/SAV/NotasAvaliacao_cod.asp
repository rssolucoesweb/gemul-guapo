	<!--
	::	DESENVOLVIDO POR Gemul - Gestor de Município"
	::	Data de Criação...: 23/03/2015
	::	Desenvolvedores...: Asced
	::	Objetivo Pagina...: Cadastro Avaliacao Institucional
	-->
	<!--#include file="../../includes/inc_verificaSession.asp"-->
	<!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../../includes/inc_replaceRequest.asp"-->
	<!--#include file="../../includes/inc_log.asp"-->
	<%
	
	strAcao							= Trim(Request.QueryString("acao"))
	intCodAvaliacao				 	= Trim(Request.form("cmbAvaliacaoInstitucional"))
	strCodItemAvaliacao				= Trim(Request.form("chkAvaliacao"))
	
	sql = "SELECT Codigo, Cod_empresa, Descricao, Ano_Letivo, Semestre, Tipo_Avaliacao, Tipo_Consulta"
	sql = sql & " FROM SAV_AVALIACAO_INSTITUCIONAL"
	sql = sql & " Where Codigo = " & intCodAvaliacao
	sql = sql & " And cod_empresa = " & Session("CodEmpresa")			
	rs.open sql, cnn
		
	if rs.eof = false then
		intTipoAvaliacao		= rs("Tipo_Avaliacao")
		intTipoConsulta			= rs("Tipo_Consulta")
	end if 
	rs.close

	if intTipoAvaliacao =  1 and intTipoConsulta = 1 or intTipoAvaliacao =  2 and intTipoConsulta = 1 then
		intCodTurma  = Trim(Request.form("cmbTurma"))
	end if	
	
	if intCodTurma 						= "" then intCodTurma 					= "0"
	if intCodDisciplina 	 			= "" then intCodDisciplina 				= "0"

	
	if strCodItemAvaliacao <> "" then   
		vetCodItemAvaliacao = split(strCodItemAvaliacao,",")			 
	end if

	on error resume next
	cnn.begintrans

	if strAcao = "I" then  
		
		strMensagem = "Avaliação cadastrada com sucesso!"
		
		for intContador = 0 to ubound(vetCodItemAvaliacao)
			
			strConceito			= ""
			intCodDisciplina	= Trim(Request.Form("txtCodDisciplina_" & intContador))
			intCodItemPergunta 	= trim(vetCodItemAvaliacao(intContador))
			strConceito		 	= Trim(Request.Form("optConceito_" & intContador))
			strResposta		 	= Trim(Request.Form("txtResposta_" & intContador))
			
			if strConceito = "" then 
				strConceito = "N"
			end if
			
			sql = " Insert into SAV_AVALIACAO_PERGUNTA_NOTA (CodAvaliacao, Cod_Turma, Cod_Disciplina, CodItemPergunta,"
			sql = sql & " Cod_aluno, Conceito, Resposta )"
			sql = sql & " VALUES ("
			sql = sql & " " & intCodAvaliacao & ","
			if intCodTurma <> "" then 
			   sql = sql & " " & intCodTurma & ","
			else
				sql = sql & " null,"
			end if
			if intCodDisciplina <> "" then 
			   sql = sql & " " & intCodDisciplina & ","
			else
				sql = sql & " 0,"
			end if
			sql = sql & " " & intCodItemPergunta & ","
			if intCodAluno <> "" then 
				sql = sql & " " & intCodAluno & ","
			else
				sql = sql & " 0,"
			end if
			
			sql = sql & " '" & strConceito & "',"
			
			if strResposta <> "" then 
				sql = sql & " '" & strResposta & "')"
			else
				sql = sql & " null)"
			end if
			cnn.execute sql
			GravarLog sql	
		next
	
	elseif strAcao = "E"then 
		
		strMensagem = "Avaliação realizada não poderá ser excluída. Procure seu Suporte"
				
		For intContador = 0 to ubound(vetCodItemAvaliacao)	 
			
			intCodAluno 		= Trim(Request.Form("txtCodAluno_" & intContador))
			intCodItemPergunta 	= trim(vetCodItemAvaliacao(intContador))
			
			'sql = " Delete From SAV_AVALIACAO_PERGUNTA_NOTA"
			'sql = sql & " WHERE CodAvaliacao = " & intCodAvaliacao
			'sql = sql & " AND Cod_Turma = " & intCodTurma
			'sql = sql & " AND Cod_Disciplina = " & intCodDisciplina
			'cnn.execute sql
			'GravarLog sql
			
		next	 	

	end if 
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='NotasAvaliacao_cad.asp';
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