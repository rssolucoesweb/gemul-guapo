<!--
    ::	Data de Criação...: 15/02/2017
    ::	Desenvolvedores...: Sérgio Borges - sergio@rssolucoesweb.com.br
    ::	Objetivo Pagina...: Registro de Ponto
-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<%
	strMensagem = "Registro de ponto inválido!"
	
	intCodGrupo = request.Form("Grupo")
	intCodEmpresa = request.Form("Unidade")
	intMatricula = request.Form("txtMatricula")
	
	if not isnumeric(intCodGrupo) then intCodGrupo = "0"
	if not isnumeric(intCodEmpresa) then intCodGrupo = "0"
	
	strData = formataDataBD(DATE)
	strHora = TIME
	
	if trim(intCodGrupo) <> "0" and trim(intCodEmpresa) <> "0" and trim(intCodGrupo) <> "" and trim(intCodEmpresa) <> "" then
		if intCodGrupo = "7" then CodEMP=1
		strMensagem = "Registro salvo com sucesso..."
		
		sql = "Insert Into gemul5.dbo.COLETA (CODI_EMP,	CODI_FUNC, DATA, HORA, COLETOR, STCATRACA, STCOLETOR, STREGISTRO, STACESSO, MOTIVO, NSR, NFR, CODI_REF)"
		sql = sql & " Values ("
		sql = sql & "" & CodEMP & ","
		sql = sql & "" & intMatricula  & ","
		sql = sql & "'" & strData  & "',"
		sql = sql & "'" & strHora  & "',"
		sql = sql & "" & intCodEmpresa  & ","
		sql = sql & "1,null,null,null,null,0,null,null)"
		cnn.execute sql
		GravarLog sql
		
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='ponto.asp?Grupo=<%=intCodGrupo%>&Unidade=<%=intCodEmpresa%>';
		</script>
		<%
		response.end
	else
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			window.history.back();
		</script>
		<%
	end if
%>