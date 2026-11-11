<!--
    ::	DESENVOLVIDO POR Asced"
    ::	Data de Criação...: 28/05/2015
    ::	Desenvolvedores...: Roberto Barbosa Silva - roberto@superawebx.com.br
    ::	Objetivo Pagina...: Dependências Físicas
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	acao 					= Trim(Request.QueryString("acao"))
	intCodGrupo				= Session("CodGrupo")
	intCodigo	 			= Trim(Request.Form("txtCodigo"))
	strDescricao 			= Trim(Request.Form("txtDescricao"))
			
	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
		
		sql = "SELECT CODIGO" 
		sql = sql & " FROM SRH_DEPENDENCIAS_FISICAS"
		sql = sql & " WHERE Cod_Grupo=" & Session("CodGrupo")
		sql = sql & " AND DESCRICAO = '" & strDescricao & "'"
		rs.open sql, cnn
		
		if RS.EOF then

			sql = "Insert Into SRH_DEPENDENCIAS_FISICAS(Cod_Grupo, DESCRICAO)"
			sql = sql & " Values ("
			sql = sql & "" & intCodGrupo & ","
			sql = sql & "'" & strDescricao & "')"
			cnn.execute sql
			GravarLog sql
			
        else
			rs.close
			cnn.rollbackTrans
			%>
			<script>
				alert("ATENÇÃO: Dependência já está cadastrada.");
				window.navigate("DependenciasFisicas_cad.asp");
			</script>
			<%
			response.End()
		end if
		rs.close

	elseif acao="A" then

		strMensagem = "Registro Alterado com sucesso..."

		sql = "Update SRH_DEPENDENCIAS_FISICAS Set"
		sql = sql & " DESCRICAO = '" & strDescricao & "'"
		sql = sql & " where CODIGO = " & intCodigo
		cnn.execute sql
		GravarLog sql
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SRH_DEPENDENCIAS_FISICAS "
		sql = sql & " where CODIGO = " & intCodigo
		cnn.execute sql
		GravarLog sql
		
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='DependenciasFisicas_cad.asp';
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