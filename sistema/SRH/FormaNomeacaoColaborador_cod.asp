<!--
    ::	DESENVOLVIDO POR Asced"
    ::	Data de Criação...: 25/05/2015
    ::	Desenvolvedores...: Roberto Barbosa Silva - roberto@superawebx.com.br
    ::	Objetivo Pagina...: Cadastro Forma de Nomeação
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
	intCodFormaNomeacaoVinculo  = Trim(Request.Form("cmbVinculo")) 
	
	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
		
		
		sql = "SELECT COD_FORMANOMEACAO" 
		sql = sql & " FROM SRH_FORMANOMEACAOCOLABORADOR"
		sql = sql & " WHERE Cod_grupo = " & Session("CodGrupo")	
		sql = sql & " AND 	DESC_FORMANOMEACAO = '" & strDescricao & "'"
		rs.open sql, cnn
		if RS.EOF then

			sql = "Insert Into SRH_FORMANOMEACAOCOLABORADOR(COD_GRUPO, Cod_formanomeacaovinculo, DESC_FORMANOMEACAO)"
			sql = sql & " Values ("
			sql = sql & "" & intCodGrupo & ","
			sql = sql & "" & intCodFormaNomeacaoVinculo & ","
			sql = sql & "'" & strDescricao & "')"
			cnn.execute sql
			GravarLog sql
        else
			rs.close
			cnn.rollbackTrans
			%>
			<script>
				alert("ATENÇÃO: Essa Forma de Nomeacao já está cadastrada.");
				window.location='FormaNomeacaoColaborador_cad.asp';
			</script>
			<%
			response.End()
		end if
		rs.close

	elseif acao="A" then

		strMensagem = "Registro Alterado com sucesso..."

		sql = "Update SRH_FORMANOMEACAOCOLABORADOR Set"
		sql = sql & " Cod_formanomeacaovinculo = " & intCodFormaNomeacaoVinculo
		sql = sql & " ,DESC_FORMANOMEACAO = '" & strDescricao & "'"
		sql = sql & " where COD_FORMANOMEACAO = " & intCodigo

		cnn.execute sql
		GravarLog sql
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SRH_FORMANOMEACAOCOLABORADOR "
		sql = sql & " where COD_FORMANOMEACAO = " & intCodigo

		cnn.execute sql
		GravarLog sql
		
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='FormaNomeacaoColaborador_cad.asp';
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