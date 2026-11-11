<!--
    ::	DESENVOLVIDO POR Asced"
    ::	Data de Criação...: 25/05/2015
    ::	Desenvolvedores...: Roberto Barbosa Silva - roberto@superawebx.com.br
    ::	Objetivo Pagina...: Cadastro Lotação
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
		
		sql = "SELECT COD_LOTACAO" 
		sql = sql & " FROM SRH_LOTACAOCOLABORADOR"
		if strCompartilharDados = "S" then
			sql = sql & " WHERE Cod_grupo = " & Session("CodGrupo")	
		else   
			sql = sql & " WHERE cod_empresa=" & Session("CodEmpresa")
		end if   
		sql = sql & " AND 	DESC_LOTACAO = '" & strDescricao & "'"
		rs.open sql, cnn
		if RS.EOF then

			sql = "Insert Into SRH_LOTACAOCOLABORADOR( COD_EMPRESA, COD_GRUPO,DESC_LOTACAO)"
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
				alert("ATENÇÃO: Essa Lotação já está cadastrada.");
				window.location='LotacaoColaborador_cad.asp';
			</script>
			<%
			response.End()
		end if
		rs.close

	elseif acao="A" then

		strMensagem = "Registro Alterado com sucesso..."

		sql = "Update SRH_LOTACAOCOLABORADOR Set"
		sql = sql & " DESC_LOTACAO = '" & strDescricao & "'"
		sql = sql & " where COD_LOTACAO = " & intCodigo

		cnn.execute sql
		GravarLog sql
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SRH_LOTACAOCOLABORADOR "
		sql = sql & " where COD_LOTACAO = " & intCodigo

		cnn.execute sql
		GravarLog sql
		
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='LotacaoColaborador_cad.asp';
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