<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/08/2007
	::	Desenvolvedores...: sergio borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Bloquear aluno
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->

<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans

    acao    			= Trim(Request.QueryString("acao"))
	intCodEmp			= Session("CodEmpresa")

    strAnoLetivo 		= session("strAnoLetivo")
	strSemestre 		= session("strSemestre")
	intcodigo			= Trim(Request("txtCodigo"))
	strCodAluno			= Trim(Request("txtCodAluno"))
	strMatricula 		= Trim(Request("txtMatricula"))
	strMotivo 		    = Trim(Request("txtMotivo"))
	strsituacao 		= Trim(Request("cmbSituacao"))
	strDataAtual		= FORMATADATABD(date) & " " & time
	

    if acao = "I" then
	   strMensagem = "Registro Salvo com sucesso..."
	   sql = "Insert Into SCA_BLOQUEIO_ALUNO (cod_empresa, ano_letivo, semestre_letivo, cod_aluno, cod_departamento, databloqueio, datadesbloqueio, situacao, descricao, usuario)"
	   sql = sql & " Values ("
	   sql = sql & "" & intCodEmp & ","
   	   sql = sql & "" & strAnoLetivo & ","
	   sql = sql & "" & strSemestre & ","
	   sql = sql & "" & strCodAluno & ","
	   sql = sql & "" & Session("CodDeptoUsuario") & ","
	   sql = sql & "'" & strDataAtual & "',"
	   sql = sql & "null,"
	   sql = sql & "'" & strSituacao & "',"
	   if strMotivo = "" then
		  sql = sql & "null,"
	   else
		  sql = sql & "'" & strMotivo & "',"
	   end if
	   sql = sql & "'" & Session("UsuarioWeb") & "')"
    end if 
	 
    if acao = "A" then
	    strMensagem = "Registro Alterado com sucesso..."
	   sql = "Update SCA_BLOQUEIO_ALUNO Set"
	   if strSituacao <> "D" then
	      sql = sql & " situacao = '" & strSituacao & "',"
	      sql = sql & " descricao = '" & strMotivo & "',"
		  sql = sql & " datadesbloqueio = null"
	   else	  
	      sql = sql & " situacao = '" & strSituacao & "',"
 	      sql = sql & " descricao = '" & strMotivo & "',"
	      sql = sql & " datadesbloqueio = '" & strDataAtual & "'"
	   end if	  
	   sql = sql & " where Codigo = " & intcodigo
	end if   

	cnn.execute sql
	GravarLog sql

	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='BloquearAluno_cad.asp';
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