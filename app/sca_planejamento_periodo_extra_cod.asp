<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 14/10/2020
	::	Desenvolvedores...: Sergio Borges - sergio@rssolucoesweb.com.br
-->
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_log.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->

<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 							= request("acao")
	
	intCodEmp					= Trim(Request.Form("cmbEmpresaGrupo"))
	cod_planejamento_periodo	= Trim(Request.Form("cod_planejamento_periodo"))
	quinzena						= Trim(Request.Form("quinzena"))
	motivo						= replace(Trim(Request.Form("motivo")),"'","")
	data_expira					= formatadataBD(Trim(Request.Form("data_expira")))
	intCodColaboradores     	= "0," & request.Form("cmdColaboradorUsuario")
	vetColaborador = split(intCodColaboradores,",")
	
	if acao="I" then
		strMensagem = "Liberação incluída com sucesso..."

		for i=0 to ubound(vetColaborador)
			intCodColaborador = vetColaborador(i)
			if intCodColaborador <> "0" then
				sql = "insert into SCA_PLANEJAMENTO_PERIODO_EXTRA (cod_planejamento_periodo,quinzena,cod_empresa,cod_colaborador,motivo,data_expira,situacao,usuario_incl,data_hora_incl) values ("
				sql = sql & cod_planejamento_periodo & ","
				sql = sql & quinzena & ","
				sql = sql & intCodEmp & ","
				sql = sql & intCodColaborador & ","
				sql = sql & "'" & motivo & "',"
				sql = sql & "'" & data_expira & "',"
				sql = sql & "'A',"
				sql = sql & "'" & session("usuarioWeb") & "',GETDATE())"
				cnn.execute sql
				GravarLog sql
			end if
		next
		
		sql = "update SCA_PLANEJAMENTO_PERIODO_EXTRA set situacao = 'I', usuario_altr = 'sistema', data_hora_altr = getdate()   where data_expira <= getdate()"
		cnn.execute sql
	elseif acao="E" then
		strMensagem = "Liberação excluída com sucesso..."
		cod_planejamento_periodo_extra 	= request("cod_planejamento_periodo_extra")
		cod_planejamento_periodo		= request("cod_planejamento_periodo")
		quinzena						= request("quinzena")

		sql = "delete SCA_PLANEJAMENTO_PERIODO_EXTRA where cod_planejamento_periodo_extra = " & cod_planejamento_periodo_extra
		cnn.execute sql
		GravarLog sql
	end if
	
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		if acao="I" then
		%>
		<script>
			alert("<%=strMensagem%>");
			window.opener.frm.submit();
			window.close();
		</script>
		<%
		elseif acao="E" then
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location="sca_planejamento_periodo_extra.asp?cod_planejamento_periodo=<%=cod_planejamento_periodo%>&quinzena=<%=quinzena%>";
		</script>

		<%
		end if
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