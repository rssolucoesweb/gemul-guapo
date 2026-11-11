<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 29/08/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Cadastro de Regime 
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->

<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 						= Trim(Request.QueryString("acao"))
	intCodEmp					= Session("CodEmpresa")
	intCodigo	       		    = Trim(Request.Form("txtCodigo"))
	intCodCurso     			= Trim(Request.Form("cmbCurso"))
	intCodDisciplinaCurso     	= Trim(Request.Form("cmbDisciplinaCurso"))
	strCargaHoraria	        	= Trim(Request.Form("txtCargaHoraria"))
	intCodGradeagrupamento 		= Trim(Request.Form("cmbGradeagrupamento"))
			
	if acao="I" then
	  
		sql = "SELECT CODIGO"
		sql = sql & " FROM SCA_EVENTO_DISCIPLINA"
		sql = sql & " WHERE COD_EMPRESA = " & Session("CodEmpresa")			
		sql = sql & " AND COD_CURSO = " & intCodCurso		
		sql = sql & " AND COD_AGRUPAMENTO = " & intCodGradeagrupamento		
		rs.open sql, cnn
		if rs.eof = false then
		  	strMensagem = "Registro já Cadastrado. Verifique!"
			%>
			<script>
				alert("<%=strMensagem%>");
				window.location='Evento_Disciplina_cad.asp';
			</script>
			<%
			response.end
		end if 
		rs.close
		
		strMensagem = "Registro Salvo com sucesso..."
		
		sql = "Insert Into SCA_EVENTO_DISCIPLINA(COD_EMPRESA, COD_CURSO, COD_AGRUPAMENTO,COD_DISCIPLINA, CARGA_HORARIA)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & intCodCurso & ","
		sql = sql & "" & intCodGradeagrupamento & ","
		sql = sql & "" & intCodDisciplinaCurso & ","
		sql = sql & "" & strCargaHoraria & ")"

	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		sql = "Update SCA_EVENTO_DISCIPLINA Set"
		sql = sql & " COD_CURSO = " & intCodCurso & ","
		sql = sql & " COD_AGRUPAMENTO = " & intCodGradeagrupamento & ","
		sql = sql & " COD_DISCIPLINA = " & intCodDisciplinaCurso & ","
		sql = sql & " CARGA_HORARIA = " & strCargaHoraria & ""
		sql = sql & " where CODIGO = " & intCodigo
	    sql = sql & " AND COD_CURSO = " & intCodCurso		
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SCA_EVENTO_DISCIPLINA "
		sql = sql & " where CODIGO = " & intCodigo

		
	end if
	cnn.execute sql
	GravarLog sql
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='Evento_Disciplina_cad.asp';
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