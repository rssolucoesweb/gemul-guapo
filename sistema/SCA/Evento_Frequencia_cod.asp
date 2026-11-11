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
	
	acao 						= Trim(Request.QueryString("acao"))
	intCodEmpresa 				= Session("CodEmpresa")
    intCodFrequenciaSeminario	= Trim(Request("txtCodigoFrequenciaSeminario"))
	intCodigo		    		= Trim(Request.Form("txtCodigo")) 
	strCodAluno			    	= Trim(Request("txtIDAluno"))
    strMatricula 		   		= Trim(Request("txtMatricula"))
	intCodTurma			    	= Trim(Request("txtCodTurma"))
    intCodEventoSeminario		= Trim(Request.Form("cmbEventoSeminario"))
    strFrequenciaCH         	= Trim(Request.Form("txtCargaHoraria"))
	strDescricaoEvento      	= Trim(Request.Form("txtDescricaoEvento"))
	strDataInicial				= formatadataBD(Trim(Request.Form("txtDataInicial")))
	strDataFinal				= formatadataBD(Trim(Request.Form("txtDataFinal")))
	
	if acao="I" then 
	
		strMensagem = "Frequencia Vincula com sucesso..."
				
		sql = "Insert Into SCA_SEMINARIO_EVENTO_FREQUENCIA (Cod_aluno, Cod_Turma, Cod_Seminario_Evento, FrequenciaCH, Descricao_Evento, DataInicial, DataFinal)"
		sql = sql & " Values ("
		sql = sql & "" & strCodAluno & ","
		sql = sql & "" & intCodTurma & ","
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
	
	elseif acao="A" then

		strMensagem = "Frequencia Alterada com sucesso..."
		
		
		sql = "Update SCA_SEMINARIO_EVENTO_FREQUENCIA Set"
		sql = sql & " Cod_Turma = " & intCodTurma & ","
		sql = sql & " Cod_Seminario_Evento = " & intCodEventoSeminario & ","
		sql = sql & " FrequenciaCH = " & strFrequenciaCH & ","
		sql = sql & " Descricao_Evento = '" & strDescricaoEvento & "',"
		sql = sql & " DataInicial = '" & strDataInicial & "',"
		sql = sql & " DataFinal = '" & strDataFinal & "'"
		sql = sql & " where Codigo = " & intCodFrequenciaSeminario

	    cnn.execute sql
		GravarLog sql
			
	elseif acao="E" then
		
		strMensagem = "Frequencia Excluída com sucesso..."

		sql = " Delete from SCA_SEMINARIO_EVENTO_FREQUENCIA"
		sql = sql & " Where Codigo = " & intCodFrequenciaSeminario
 		cnn.execute sql
		GravarLog sql
		
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans

		strParametro = "Evento_Frequencia_cad.asp?txtMatricula=" & strMatricula   

		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='<%=strParametro%>';
		</script>
		<%
		response.end
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>