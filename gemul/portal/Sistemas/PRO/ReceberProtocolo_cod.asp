<!--
	::	IMOB
	::	Data de Criação...: 22/08/2011
	::	Desenvolvedores...: Sergio Dias Borges - sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: Incluir grupo
	::	Data Atualizacao..: 
-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_formatadata.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	acao 					= Trim(Request.QueryString("acao"))
	intCodEmpresa			= session("codEmpresa")	
	intCodigo 				= Trim(Request.Form("txtCodigo"))
	intCodProtocolos		= Trim(Request.Form("chkProtocolo"))
	vetCodProtocolo			= split(intCodProtocolos,",")

	intCodDepartamento		= session("codDepartamentoAtual") 
	
	' Dados do Usuario
	strUsuario_incl   		= session("strNomeUsuario")
	strData_hora_incl 		= formatadataBD(date) & " " & time 
	strUsuario_altr   		= session("strNomeUsuario")
	strData_hora_altr 		= formatadataBD(date) & " " & time 

	if acao="I" then

		for i=0 to ubound(vetCodProtocolo)
			intCodProtocolo = vetCodProtocolo(i)
			if trim(intCodProtocolo)<>"" then
				'acessa o cadastra de senha
				sql = " SELECT cod_departamentoAtual"
				sql = sql & " FROM PRO_protocolo" 
				sql = sql & " WHERE codigo =" & intCodProtocolo
				rs.open sql , cnn		
				if not rs.eof then	
					intCodDepartamentoAtual = rs("cod_departamentoAtual")
				end if
				rs.close		
			end if
	
			strMensagem = "Registro salvo com sucesso..."
			
			sql = "Insert Into PRO_Protocolo_Andamento (Cod_Empresa, codigo_PRO_protocolo, cod_departamentoAtual, cod_departamentoDestino, tipoAndamento, "
			sql = sql & " usuario_incl, data_hora_incl, usuario_altr, data_hora_altr)"          
			sql = sql & " Values ("
	
			sql = sql & "" & intCodEmpresa & ","
			sql = sql & "'" & intCodProtocolo & "',"
			sql = sql & "'" & intCodDepartamentoAtual & "',"
			sql = sql & "'" & intCodDepartamento & "',"
			sql = sql & "'R',"
	
			' Usuario do Sistema
			sql = sql & "'" & strUsuario_incl & "',"
			sql = sql & "'" & strData_hora_incl & "',"
			
			' Campos nulos para campo Usuario Alteracao e data Alteracao'
			sql = sql & "" & "null, null" & ")"
			cnn.execute sql
			GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))
			
			sql = "Update PRO_protocolo Set"
			sql = sql & " cod_departamentoAtual = '" & intCodDepartamento & "',"
			sql = sql & " tipoAndamento = 'R',"
			sql = sql & " usuario_altr = '" & strUsuario_altr & "',"
			sql = sql & " data_hora_altr = '" & strData_hora_altr & "'"
			sql = sql & " Where Codigo = " & intCodProtocolo 
			sql = sql & " And Cod_Empresa = " & intCodEmpresa 
			cnn.execute sql
			GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))
		next
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='ReceberProtocolo_cad.asp';
		</script>
		<%
		response.end
	else
		cnn.rollbacktrans
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
	end if
%>