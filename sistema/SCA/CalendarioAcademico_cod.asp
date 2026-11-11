<!--
	::	Data de Criação...: 12/06/2008
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@hotmail.com
	::	Objetivo Pagina...: Cadastro de Calendario Academico
	::	Data Atualizacao..: 
	::	Motivo Atualizacao: 
-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	strCodEmpresa       = Session("CodEmpresa")
	acao 				= Trim(Request.QueryString("acao"))
	intCodigo	 		= Trim(Request("txtCodigo"))
	strAno	 			= Trim(Request("txtAno"))
	strSemestre 		= Trim(Request("cmbSemestre"))
	intCodMes	 		= Trim(Request("cmbMes"))
	strData 			= formatadataBD(Trim(Request("txtData")))
	strData2 			= formatadataBD(Trim(Request("txtData2")))
	strDescricao 		= Trim(Request("txtDescricao"))
	strFeriado 			= Trim(Request("txtFeriado"))

	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
		

		sql = "Insert Into sca_CalendarioAcademico(Cod_empresa, Ano, Semestre, Mes, Data, Data2, Descricao, Feriado)"          
		sql = sql & " Values ("
		sql = sql & "" & strCodEmpresa & ","
		sql = sql & "" & strAno & ","
		sql = sql & "" & strSemestre & ","
		sql = sql & "" & intCodMes & ","
		sql = sql & "'" & strData & "',"
		sql = sql & "'" & strData2 & "',"
		sql = sql & "'" & strDescricao & "',"
		sql = sql & "'" & strFeriado & "')"
		
	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		
		sql = "Update sca_CalendarioAcademico Set"
		sql = sql & " Ano = " & strAno & ","
		sql = sql & " Semestre = " & strSemestre & ","
		sql = sql & " Mes = " & intCodMes & ","
		sql = sql & " Data = '" & strData & "',"
		sql = sql & " Data2 = '" & strData2 & "',"
		sql = sql & " Descricao = '" & strDescricao & "',"
		sql = sql & " Feriado = '" & strFeriado & "'"
		sql = sql & " Where Codigo = " & intCodigo 
		
	else

		strMensagem = "Registro Excluido com sucesso..."
		
		sql = "Delete from sca_CalendarioAcademico "
		sql = sql & " Where Codigo = " & intCodigo
	
	end if
	
	cnn.execute sql
    GravarLog sql
		
if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='CalendarioAcademico_cad.asp';
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