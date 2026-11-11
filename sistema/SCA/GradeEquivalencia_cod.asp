<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 04/02/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.brs
	::	Objetivo Pagina...: Cadastro Grade Equivalencia 
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<%
	'on error resume next
	
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 								= Trim(Request.QueryString("acao"))
	intCodEmp							= Session("CodEmpresa")
	intCodigo	 						= Trim(Request.Form("txtCodigo"))
	intCodGradeCurricularDisciplina 	= Trim(Request.Form("txtCodGradeCurricularDisciplina"))
	
	' Origem
	intCodDisciplinaGrade	 			= Trim(Request("cmbDisciplinaGrade")) 

	' Destino
	intCodGradeEquivalente  			= Trim(Request("cmbGradeEquivalente"))
	intCodDisciplinaGradeEquivalente  	= Trim(Request("cmbDisciplinaGradeEquivalente"))  
			
	if acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		
		sql = "Update SCA_GRADECURRICULARDISCIPLINA Set "
		
		if intCodGradeEquivalente <> "0" then 
			sql = sql & "Cod_GradeCurricularDisciplina_Equivalente = " & intCodGradeEquivalente & " ,"
		else
			sql = sql & "Cod_GradeCurricularDisciplina_Equivalente = null , "
		end if
		
		if intCodDisciplinaGradeEquivalente <> "0" then 
			sql = sql & "Cod_Disciplina_Equivalente = " & intCodDisciplinaGradeEquivalente
		else
			sql = sql & "Cod_Disciplina_Equivalente = null "
		end if
		
		sql = sql & " WHERE Cod_GradeCurricularDisciplina = " & intCodGradeCurricularDisciplina
	
	end if

	if acao="E" then
		
		strMensagem = "Registro Excluído com sucesso..."
		
		sql = " Update SCA_GRADECURRICULARDISCIPLINA Set "
		sql = sql & " Cod_GradeCurricularDisciplina_Equivalente = null , "
		sql = sql & " Cod_Disciplina_Equivalente = null "
		sql = sql & " WHERE Cod_GradeCurricularDisciplina = " & intCodGradeCurricularDisciplina
	
	end if
	
	cnn.execute sql
	GravarLog sql
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='GradeEquivalencia_cad.asp';
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