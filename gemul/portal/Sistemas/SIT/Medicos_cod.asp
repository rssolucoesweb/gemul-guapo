<!--
	::	Empresa...........: RS Soluções web - www.rssolucoesweb.com.br
    ::	Data de Criação...: 19/05/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Cadastro de Medicos
	::	Data Atualizacao..: 
	::	Motivo Atualizacao: 
-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_formatadata.asp"-->

<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmpresa		= session("codEmpresa")	
	intCodCategoria 	= Trim(Request.Form("txtCodCategoria"))
	intCodMedico		= Trim(Request.Form("txtCodMedico"))
	strNomeMedico		= replace(Trim(Request.Form("txtNomeMedico")),"'", " ") 
	strFone				= replace(Trim(Request.Form("txtFone")),"'", " ") 
	strEspecialidade	= replace(Trim(Request.Form("txtEspecialidade")),"'", " ")
	strEndereco 		= replace(Trim(Request.Form("txtEndereco")),"'", " ") 

	' Dados do Usuario
	strUsuario_incl   	=	session("strNomeUsuario")
	strData_hora_incl 	= 	formatadataBD(date) & " " & time 
	strUsuario_altr   	=	session("strNomeUsuario")
	strData_hora_altr 	= 	formatadataBD(date) & " " & time 
	
	
	if acao="I" then
		
		strMensagem = "Médico salva com sucesso..."
		
		sql = "SELECT Max(Codigo) as MaiorCodigo" 
		sql = sql & " FROM SIT_Medicos"
		rs.open sql, cnn
		
		if not RS.EOF then
		
			if rs("MaiorCodigo") <> "" then
				intCodNovo = cstr(rs("MaiorCodigo")) + 1
				intCodMedico = intCodNovo
			else
				intCodMedico = 1	
			end if
		
		end if
		rs.close
		
		sql = "Insert Into SIT_Medicos (CodEmpresa, CodCategoria, Nome, Especialidade, Endereco, Fone, " 
		sql = sql & " Usuario, DataIncl, UsuarioAlt, DataAlt)"          
		sql = sql & " Values ("

		sql = sql & "" & intCodEmpresa & ","
		sql = sql & "" & intCodCategoria & ","
		sql = sql & "'" & strNomeMedico & "',"
		sql = sql & "'" & strEspecialidade & "',"
		sql = sql & "'" & strEndereco & "',"
		sql = sql & "'" & strFone & "',"
		
		' Usuario do Sistema
		sql = sql & "'" & strUsuario_incl & "',"
		sql = sql & "'" & strData_hora_incl & "',"
		
		' Campos nulos para campo Usuario Alteracao e data Alteracao'
		sql = sql & "" & "null, null" & ")"
		
			
	elseif acao="A" then
		
		strMensagem = "Médico Alterado com sucesso..."
		
		sql = "Update SIT_Medicos Set"
		sql = sql & " CodCategoria = " & intCodCategoria & ","
		sql = sql & " Nome = '" & strNomeMedico & "',"
		sql = sql & " Fone = '" & strFone & "',"
		sql = sql & " Especialidade = '" & strEspecialidade & "',"
		sql = sql & " Endereco = '" & strEndereco & "',"
		sql = sql & " UsuarioAlt = '" & strUsuario_incl  & "',"
		sql = sql & " DataAlt = '" & strData_hora_incl  & "'"
		sql = sql & " Where Codigo = " & intCodMedico
		sql = sql & " And CodEmpresa = " & intCodEmpresa
		
	else
	
		strMensagem = "Médico Excluido com sucesso..."
		
		sql = "Delete from SIT_Medicos "
		sql = sql & " Where Codigo = " & intCodMedico
		sql = sql & " And CodEmpresa = " & intCodEmpresa

	end if 

	cnn.execute sql
	GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='Medicos_cad.asp?CodCategoria=<%=intCodCategoria%>';
		</script>
		<%
		response.end
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>