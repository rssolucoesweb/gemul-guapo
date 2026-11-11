<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação.....: 12/04/2009
     ::	Data de Alteração...: 30/09/2009
	::	Desenvolvedores.....: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina.....: Cadastro Avaliação Notas
-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="topo.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%

	SQL=" SELECT TOP 1 "
	SQL=SQL & " T.COD_TURMA, "
	SQL=SQL & " T.NOMETURMA,"
	SQL=SQL & " A.MATRICULA "
	SQL=SQL & " FROM SCA_ALUNO A "
	SQL=SQL & " INNER JOIN SCA_ALUNO_TURMA AT ON AT.COD_ALUNO = A.CODIGO AND A.COD_EMPRESA = AT.COD_EMPRESA "
	SQL=SQL & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = AT.COD_TURMA AND T.COD_EMPRESA = AT.COD_EMPRESA "
	SQL=SQL & " WHERE A.CODIGO = " & trim(Session("CodSeguranca"))
	SQL=SQL & " Order BY AT.CODIGO DESC "
	rsAux.OPEN SQL, CNN
	if rsAux.EOF = FALSE THEN 
	   	intCodTurma 	= rsAux("COD_TURMA")
		strNomeTurma	= rsAux("NOMETURMA")
		strMatricula    = rsAux("MATRICULA")
	else
	 	%>
	  	<script>
			alert("A T E N Ç Ã O! Matrícula não Alocada, verifique junto a Secretaria.");
			window.history.back();
	 	</script>
	 	<%
	  	rsAux.close
	 	response.end
	end if   	   
	rsAux.close

	strAnoLetivo 						= session("strAnoLetivo")   	
	intSemestre 						= session("strSemestre")
	
	strAcao							= Trim(Request.QueryString("acao"))
	intCodAvaliacao				 	= Trim(Request.form("cmbAvaliacaoInstitucional"))
	strCodItemAvaliacao				= Trim(Request.form("chkAvaliacao"))
	intColunas						= Trim(Request.form("txtColunas"))
	intCodAluno						= trim(Session("CodSeguranca"))
	cont = 0
	
	if Trim(Request.form("txtColunas")) = "" then intColunas = 1
	
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

	if intCodTurma 						= "" then intCodTurma 					= "0"
	if intCodDisciplina 	 			= "" then intCodDisciplina 				= "0"

	
	if strCodItemAvaliacao <> "" then   
		vetCodItemAvaliacao = split(strCodItemAvaliacao,",")			 
	end if
	
	'on error resume next
	cnn.begintrans
	
	if strAcao = "I" then  
		inseriuResposta = false
		
		strMensagem = "Avaliação cadastrada com sucesso!"
		
		for intContador = 0 to ubound(vetCodItemAvaliacao)
			
			strResposta		 	= Trim(Request.Form("txtResposta"))
			strConceito			= ""


  			if Trim(Request.form("txtColunas")) = "" then
				intCodDisciplina	= Trim(Request.Form("txtCodDisciplina_" & intContador))
				intCodItemPergunta 	= trim(vetCodItemAvaliacao(intContador))
				strConceito		 	= Trim(Request.Form("optConceito_" & intContador))
				strResposta		 	= Trim(Request.Form("txtResposta_" & intContador))
			end if	

			for i = 1 to intColunas

                if Trim(Request.form("txtColunas")) <> "" then
				   intCodDisciplina	= Trim(Request.Form("txtCodDisciplina_" & intContador & "_" & i))
				   intCodItemPergunta 	= trim(vetCodItemAvaliacao(intContador))
				   strConceito		 	= Trim(Request.Form("optConceito_" & intContador & "_" & i))
				end if   

				if strConceito = "" then 
					strConceito = "N"
				end if
				
				if inseriuResposta = false then
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
					
					if strResposta <> "" and intCodDisciplina = "" then 
						sql = sql & " '" & strResposta & "')"
					else
						sql = sql & " null)"
					end if
					
					if Trim(Request.form("txtColunas")) <> "" then
						if intCodDisciplina = "" then
							inseriuResposta = true
						end if
					end if	
					cnn.execute sql
				end if
			next
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
			window.location = 'PortalAluno_NotasAvaliacaoInstitucional_cad.asp';
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