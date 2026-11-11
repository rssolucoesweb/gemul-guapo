<!--
	::	Data de Criação...: 11/04/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Cadastro de Empresa
	::	Data Atualizacao..: 
	::	Motivo Atualizacao: 
-->
<!--#include file="../includes/inc_cnn.asp"-->
<!--#include file="../includes/inc_replaceRequest.asp"-->
<!--#include file="../includes/inc_formataData.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	acao 					= Trim(Request.QueryString("acao"))
	intCodigo				= replace(request.Form("txtCodEmpresa"),"'","")
	intCodGrupo				= session("codGrupo")
	strRazaoSocial 			= replace(request.Form("txtRazaoSocial"),"'","")
	strNomeFantazia			= replace(request.Form("txtNomeFantazia"),"'","")
	strCNPJ					= replace(request.Form("txtCNPJ"),"'","")
	strInscricaoMunicipal	= replace(request.Form("txtInscricaoMunicipal"),"'","")
	strCreci				= replace(request.Form("txtCreci"),"'","")
	strEndereco				= replace(request.Form("txtEndereco"),"'","")
	strCep					= replace(request.Form("txtCep"),"'","")
	strBairro				= replace(request.Form("txtBairro"),"'","")
	strCidade				= ucase(replace(request.Form("txtCidade"),"'",""))
	strUF					= replace(request.Form("txtUF"),"'","")
	strFone1				= replace(request.Form("txtFone1"),"'","")
	strFone2				= replace(request.Form("txtFone2"),"'","")
	strFax					= replace(request.Form("txtFax"),"'","")
	strCelular1				= replace(request.Form("txtCelular1"),"'","")
	strCelular2				= replace(request.Form("txtCelular2"),"'","")
	strEmail				= replace(request.Form("txtEmail"),"'","")
	strSite					= replace(request.Form("txtSite"),"'","")
	strNomeContato			= replace(request.Form("txtNomeContato"),"'","")
	strFoneContato			= replace(request.Form("txtFoneContato"),"'","")
	strLogin				= request.Form("txtLogin")
	strSenha				= request.Form("txtSenha")
	strSituacao 			= "A"
	
	' Dados do Usuario
	strUsuario_incl   		= session("strNomeUsuario")
	strData_hora_incl 		= formatadataBD(date) & " " & time 
	strUsuario_altr   		= session("strNomeUsuario")
	strData_hora_altr 		= formatadataBD(date) & " " & time 

	if acao="I" then
		
		strMensagem  = "Empresa cadastrada com sucesso, agora vincule a logo da empresa"
		
		sql = "SELECT Max(codigo) as MaiorCodigo" 
		sql = sql & " FROM SEG_empresa"
		rs.open sql, cnn
		
		if not RS.EOF then
		
			if rs("MaiorCodigo") <> "" then
				intCodNovo = cstr(rs("MaiorCodigo")) + 1
				intCodigo = intCodNovo
			else
				intCodigo = 1	
			end if
		
		end if
		rs.close

		sql = "Insert Into SEG_empresa(Codigo, CodGrupo, RazaoSocial, NomeFantazia, CNPJ, InscricaoMunicipal,"
		sql = sql & " Endereco, Cep, Bairro, Cidade, UF, Fone1, Fone2, Fax, Celular1, Celular2, Email, "
		sql = sql & " Site, NomeContato, FoneContato, Situacao, "  
		sql = sql & " usuario_incl, data_hora_incl, usuario_altr, data_hora_altr)"         
		sql = sql & " Values ("
		sql = sql & "" & intCodigo & ","
		sql = sql & "" & intCodGrupo & ","
		sql = sql & "'" & strRazaoSocial & "',"
		sql = sql & "'" & strNomeFantazia & "',"
		sql = sql & "'" & strCNPJ & "',"
		sql = sql & "'" & strInscricaoMunicipal & "',"
		sql = sql & "'" & strEndereco & "',"
		sql = sql & "'" & strCep & "',"
		sql = sql & "'" & strBairro & "',"
		sql = sql & "'" & strCidade & "',"
		sql = sql & "'" & strUF & "',"
		sql = sql & "'" & strFone1 & "',"
		
		if strFone2 <> "" then
			sql = sql & "'" & strFone2 & "',"
		else
			sql = sql & "null,"
		end if
		
		if strFax <> "" then
			sql = sql & "'" & strFax & "',"
		else
			sql = sql & "null,"
		end if
		
		if strCelular1 <> "" then
			sql = sql & "'" & strCelular1 & "',"
		else
			sql = sql & "null,"
		end if
		
		if strCelular2 <> "" then
			sql = sql & "'" & strCelular2 & "',"
		else
			sql = sql & "null,"
		end if
		
		if strEmail <> "" then
			sql = sql & "'" & strEmail & "',"
		else
			sql = sql & "null,"
		end if
		
		if strSite <> "" then
			sql = sql & "'" & strSite & "',"
		else
			sql = sql & "null,"
		end if

		sql = sql & "'" & strNomeContato & "',"
		sql = sql & "'" & strFoneContato & "',"
		sql = sql & "'" & strSituacao & "',"
		
		' Usuario do Sistema
		if strUsuario_incl <> "" then
			sql = sql & "'" & strUsuario_incl & "',"
		else
			sql = sql & "null,"
		end if
		
		if strData_hora_incl <> "" then
			sql = sql & "'" & strData_hora_incl & "',"
		else
			sql = sql & "null,"
		end if
		
		'Campos nulos para campo Usuario Alteracao e data Alteracao
		sql = sql & "" & "null, null" & ")"
		cnn.execute sql

	elseif acao = "A" then
			
		strMensagem  = "Empresa alterada com sucesso, agora altere a logo da empresa"
		
		sql = "update SEG_empresa set "
		sql = sql & " CodGrupo = " & intCodGrupo & ","
		sql = sql & " RazaoSocial = '" & strRazaoSocial & "',"
		sql = sql & " NomeFantazia = '" & strNomeFantazia & "',"
		sql = sql & " CNPJ = '" & strCNPJ & "',"
		sql = sql & " InscricaoMunicipal = '" & strInscricaoMunicipal & "',"
		sql = sql & " Endereco = '" & strEndereco & "',"
		sql = sql & " Cep = '" & strCep & "',"
		sql = sql & " Bairro = '" & strBairro & "',"
		sql = sql & " Cidade = '" & strCidade & "',"
		sql = sql & " UF = '" & strUF & "',"
		sql = sql & " Fone1 = '" & strFone1 & "',"
		
		if strFone2 <> "" then
			sql = sql & " Fone2 = '" & strFone2 & "',"
		else
			sql = sql & " Fone2 = null,"
		end if
		
		if strFax <> "" then
			sql = sql & " Fax = '" & strFax & "',"
		else
			sql = sql & " Fax = null,"
		end if
		
		if strCelular1 <> "" then
			sql = sql & " Celular1 = '" & strCelular1 & "',"
		else
			sql = sql & " Celular1 = null,"
		end if
		
		if strCelular2 <> "" then
			sql = sql & " Celular2 = '" & strCelular2 & "',"
		else
			sql = sql & " Celular2 = null,"
		end if
		
		if strEmail <> "" then
			sql = sql & " Email = '" & strEmail & "',"
		else
			sql = sql & " Email = null,"
		end if
		
		if strSite <> "" then
			sql = sql & " Site = '" & strSite & "',"
		else
			sql = sql & " Site = null,"
		end if

		sql = sql & " NomeContato = '" & strNomeContato & "',"
		sql = sql & " FoneContato = '" & strFoneContato & "',"
		sql = sql & " Situacao = '" & strSituacao & "',"
		sql = sql & " usuario_altr = '" & strUsuario_incl & "',"
		sql = sql & " data_hora_altr = '" & strData_hora_incl & "'"
		sql = sql & " where codigo = " & intCodigo
		
		cnn.execute sql		
	
	elseif acao = "E" then
		strMensagem  = "Empresa excluida com sucesso"
		sql = "delete from SEG_empresa"
		sql = sql & " where codigo = " & intCodigo
		cnn.execute sql		
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		if acao = "E" then
			%>
			<script>
				alert("<%=strMensagem%>");
				window.location = 'Empresa_cad.asp';
			</script>
			<%
		else
			%>
			<script>
				alert("<%=strMensagem%>");
				window.location = 'Empresa_ViculaFoto.asp?CodEmpresa=<%=intCodigo%>&CodGrupo=<%=intCodGrupo%>';
			</script>
			<%
		end if
		response.end
	else
		cnn.rollbacktrans
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
	end if
%>