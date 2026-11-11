<!--
	::	Data de Criação...: 25/05/2010
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Cadastro de AcervoVirtual
	::	Data Atualizacao..: 
	::	Motivo Atualizacao: 
-->
<!--#include file="PatUpload.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formataData.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<%
	dim oUpload, i
	dim caminho
	set oUpload  		= new PatUpload
	
	'Cria a pasta de acordo com codigo da Empresa
	PastaArquivo = Server.MapPath("../../MaterialAluno") & "/" & Session("CodEmpresa")
	
	Set objFSO = CreateObject("Scripting.FileSystemObject")
		
	IF Not objFSO.FolderExists(PastaArquivo) THEN
		objFSO.CreateFolder(PastaArquivo)
	END IF
	
	oUpload.SetData Request, PastaArquivo, 1	
	
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans

	acao 				= Trim(Request.QueryString("acao"))
	intCodEmp			= Session("CodEmpresa")
	strCategoria		= Trim(oUpload.Form("txtCategoria"))

	
	if trim(strCategoria) = "Nao" then
		intCodTurma						= Trim(oUpload.Form("cmbTurma"))
		intCodDisciplinaTurma 			= Trim(oUpload.Form("cmbDisciplinaTurma"))
	else
		intCodTurma						= Trim(oUpload.Form("cmbTurmaProfessor"))
		intCodDisciplinaTurma 			= Trim(oUpload.Form("cmbDisciplinaDoProfessor"))
	end if
	
	strData 			= formataDataBD(Trim(oUpload.Form("txtData")))
	strDescricao 		= Trim(oUpload.Form("txtDescricao"))
	strNomeArquivo		= oUpload.file("Arq1")
			
	if acao="I" then
		
		strMensagem = "Arquivo enviada com sucesso"	
		
		sql = "Insert Into SCA_MaterialAluno (Cod_empresa, CodTurma, CodDisciplinaTurma, Data, Descricao, NomeArquivo)"          
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & intCodTurma & ","
		sql = sql & "" & intCodDisciplinaTurma & ","
		sql = sql & "'" & strData & "',"
		sql = sql & "'" & strDescricao & "',"
		sql = sql & "'" & strNomeArquivo & "')"
		cnn.execute sql
		GravarLog sql
	
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='MaterialAula_cad.asp';
		</script>
		<%
		response.end
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>