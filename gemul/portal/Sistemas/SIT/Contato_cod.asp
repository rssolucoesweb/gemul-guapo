<!--
	::	Empresa...........: RS Soluções web - www.rssolucoesweb.com.br
    ::	Data de Criação...: 19/05/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Excluir Contato
	::	Data Atualizacao..: 
	::	Motivo Atualizacao: 
-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_formataData.asp"-->

<%
		'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
		
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmpresa		= session("codEmpresa")
	
	if acao = "E" then
		strCodContato =  Trim(Request.Form("chkSelecionar"))
	 	if strCodContato <> "" then   
	  		vetCodContato = split(strCodContato,",")    
	 	end if
 	end if 
		
	if acao = "E" then
		
		strMensagem = "Contatos Excluido com sucesso..."
		
		for intContador = 0 to ubound(vetCodContato)  
			sql = "Delete From SIT_Contatos "
			sql = sql & " WHERE Codigo = " &  vetCodContato(intContador)
			sql = sql & " And CodEmpresa = " &  intCodEmpresa
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
			window.location='Rel_Contatos_con.asp';
		</script>
		<%
		response.end
	else
		response.redirect "/stiuegnet/erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>