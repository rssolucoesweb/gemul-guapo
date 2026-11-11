<!--
    ::	DESENVOLVIDO POR Asced"
    ::	Data de Criação...: 25/05/2015
    ::	Desenvolvedores...: Roberto Barbosa Silva - roberto@superawebx.com.br
    ::	Objetivo Pagina...: Eventos do Dossiê
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<!--#include file="../includes/inc_CompartilharDadosCadastrais.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmp			= Session("CodEmpresa")
	intCodGrupo			= Session("CodGrupo")
	intCodigo	 		= Trim(Request.Form("txtCodigo"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
			
	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
		
		sql = "SELECT Codigo" 
		sql = sql & " FROM SRH_COLABORADOR_EVENTO_DOSSIE"
		if strCompartilharDados = "S" then
			sql = sql & " WHERE Cod_grupo = " & Session("CodGrupo")	
		else   
			sql = sql & " WHERE cod_empresa=" & Session("CodEmpresa")
		end if   
		sql = sql & " AND Desc_EventoDossie = '" & strDescricao & "'"
		rs.open sql, cnn
		if RS.EOF then

			sql = "Insert Into SRH_COLABORADOR_EVENTO_DOSSIE( Cod_Empresa, Cod_grupo, Desc_EventoDossie)"
			sql = sql & " Values ("
			sql = sql & "" & intCodEmp & ","
		    sql = sql & "" & intCodGrupo & ","
			sql = sql & "'" & strDescricao & "')"
			cnn.execute sql
			GravarLog sql
			
        else
			rs.close
			cnn.rollbackTrans
			%>
			<script>
				alert("ATENÇÃO: Esse evento Dossie já está cadastrada.");
				window.location='ColaboradorEventoDossie_cad.asp';
			</script>
			<%
			response.End()
		end if
		rs.close

	elseif acao="A" then

		strMensagem = "Registro Alterado com sucesso..."

		sql = "Update SRH_COLABORADOR_EVENTO_DOSSIE Set"
		sql = sql & " Desc_EventoDossie = '" & strDescricao & "'"
		sql = sql & " where Codigo = " & intCodigo

		cnn.execute sql
		GravarLog sql
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		
		sql = "Delete from SRH_COLABORADOR_EVENTO_DOSSIE "
		sql = sql & " where Codigo = " & intCodigo

		cnn.execute sql
		GravarLog sql
		
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='ColaboradorEventoDossie_cad.asp';
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