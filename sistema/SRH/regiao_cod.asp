<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<!--#include file="../includes/inc_CompartilharDadosCadastrais.asp"-->
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
		sql = sql & " FROM SEG_REGIAO"
		sql = sql & " WHERE Cod_grupo = " & Session("CodGrupo")	
		sql = sql & " AND 	DESCRICAO = '" & strDescricao & "'"
		rs.open sql, cnn
		
		if RS.EOF then

			sql = "Insert Into SEG_REGIAO(COD_GRUPO, DESCRICAO, USUARIO_INCL, DATA_HORA_INCL)"
			sql = sql & " Values ("
		    sql = sql & "" & intCodGrupo & ","
			sql = sql & "'" & strDescricao & "',"
			sql = sql & "'" & trim(session("usuarioWeb")) & "',"
			sql = sql & "GETDATE())"
			
			cnn.execute sql
			GravarLog sql
			
        else
			rs.close
			cnn.rollbackTrans
			%>
			<script>
				alert("ATENÇÃO: Esse região já está cadastrada.");
				window.location='regiao_cad.asp';
			</script>
			<%
			response.End()
		end if
		rs.close

	elseif acao="A" then

		strMensagem = "Registro Alterado com sucesso..."

		sql = "Update SEG_REGIAO Set"
		sql = sql & " DESCRICAO = '" & strDescricao & "',"
		sql = sql & " USUARIO_ALTR = '" & trim(session("usuarioWeb")) & "',"
		sql = sql & " DATA_HORA_ALTR = GETDATE() "
		sql = sql & " where CODIGO = " & intCodigo
		cnn.execute sql
		GravarLog sql
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SEG_REGIAO "
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
			window.location='regiao_cad.asp';
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