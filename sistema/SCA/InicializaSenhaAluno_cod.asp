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
<!--#include file="../../includes/cripto.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	acao 					= Trim(Request.QueryString("acao"))
	intCodEmpresa 			= Session("CodEmpresa")
	strMatricula 			= Trim(Request("txtMatricula"))
	
	if Trim(Request.Form("txtCodAluno")) <> "" then
		intCodAluno	= Trim(Request.Form("txtCodAluno"))
	else
		intCodAluno	= Trim(Request.Form("chkAluno"))
	end if
	
	if acao="I" then 

	elseif acao="A" then
		
		vetAluno = split(intCodAluno,",")
		
		for i=0 to ubound(vetAluno)
		
			intCodAluno	= vetAluno(i)
		
			sql = "Select DataNascimento "
			sql = sql & " From sca_aluno"
			sql = sql & " where cod_empresa = " & intCodEmpresa
			sql = sql & " and Codigo = " & intCodAluno
			rs.open sql, cnn
			
			if rs.eof = false then
				strDatanascimento   = formatadataAP(Trim(rs("DataNascimento")))
			end if  
			rs.close
			
			strSenha = FormatCripto(replace(strDatanascimento,"/",""),True)	
			
			sql = "Update sca_aluno set senha = '" & strSenha & "'"
			sql = sql & " where cod_empresa = " & intCodEmpresa
			sql = sql & " and Codigo = " & intCodAluno
			cnn.execute sql
			GravarLog sql			
		
		next
		
		strMensagem = "Senha Inicializada com sucesso..."
				
	elseif acao="E" then
	
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='InicializaSenhaAluno_con.asp';
		</script>
		<%
		response.end
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>