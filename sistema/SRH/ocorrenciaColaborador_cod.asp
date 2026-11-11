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
	acao 										= Trim(Request.QueryString("acao"))
	
	intCodEmp									= Session("CodEmpresa")
	intCodigo           	  					= Trim(Request.Form("txtCodigo"))
	intCodModulacaoReferencia 					= Trim(Request.form("cmbModulacaoReferencia"))
	intCodColaborador	         	 			= Trim(Request("cmbColaborador")) 
	strOcorrencia		         	 			= Trim(Request("txtOcorrencia")) 
	
	' Dados do Usuario
	strUsuario_incl   	= session("usuarioWeb")
	strData_hora_incl 	= formataDataBDAccess(date) & " " & time
	strUsuario_altr   	= session("usuarioWeb")
	strData_hora_altr 	= formataDataBDAccess(date) & " " & time
	
	if acao = "I" then
		
		strMensagem = "Registro Incluido com sucesso..."

		sql = "Insert Into SRH_COLABORADOR_OCORRENCIA_FOLHA(cod_empresa,Cod_Referencia,cod_colaborador,ocorrencia,usuario_incl,data_incl,usuario_altr,data_altr)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & intCodModulacaoReferencia & ","
		sql = sql & "" & intCodColaborador & ","
		sql = sql & "'" & strOcorrencia & "'," 
		sql = sql & "'" & strUsuario_incl & "',GETDATE(),'" & strUsuario_incl & "',GETDATE())"
		cnn.Execute(sql)
		GravarLog SQL
		
	elseif acao = "A" then
		
		strMensagem = "Registro Alterado com sucesso..."

		sql = "update SRH_COLABORADOR_OCORRENCIA_FOLHA set ocorrencia = '" & strOcorrencia & "'," 
		sql = sql & " usuario_altr = '" & strUsuario_incl & "',data_altr = GETDATE()"
		sql = sql & " where codigo = " & intCodigo
		cnn.Execute(sql)
		GravarLog SQL	
		
	elseif acao = "E" then
		sql = "delete SRH_COLABORADOR_OCORRENCIA_FOLHA "
		sql = sql & " where codigo = " & intCodigo
		cnn.Execute(sql)
		GravarLog SQL
		
		strMensagem = "Registro excluido com sucesso..."
	end if

	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------

		cnn.commitTrans
		
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location = "ocorrenciaColaborador_cad.asp?cmbModulacaoReferencia=<%=intCodModulacaoReferencia%>";
		</script>			
		<%
		
		response.end
		
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>