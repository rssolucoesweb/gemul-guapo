<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	acao 					= Trim(Request.QueryString("acao"))
	intCodGrupo				= Session("CodGrupo")
	intCodigo	 			= Trim(Request.Form("txtCodigo"))
	strDescricao 			= Trim(Request.Form("txtDescricao"))
	strItem 				= Trim(Request.Form("txtItem"))
	intCodArea			 	= Trim(Request.Form("cmbArea"))
	strPrioridade		 	= Trim(Request.Form("cmbPrioridade"))
	if strPrioridade = "" then strPrioridade = "0"
			
	' Dados do Usuario
	strUsuario_incl   	=	session("usuarioWeb")
	strData_hora_incl 	= 	formatadataBD(date) & " " & time 
	strUsuario_altr   	=	session("usuarioWeb")
	strData_hora_altr 	= 	formatadataBD(date) & " " & time 
			
	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
		
		sql = "SELECT CODIGO" 
		sql = sql & " FROM SOS_TIPO_SERVICO"
		sql = sql & " WHERE Cod_grupo = " & Session("CodGrupo")	
		sql = sql & " AND 	descricao = '" & strDescricao & "'"
		rs.open sql, cnn
		
		if RS.EOF then

			sql = "Insert Into SOS_TIPO_SERVICO (COD_GRUPO, COD_AREA , DESCRICAO, ITEM, cod_prioridade, usuario_incl, data_hora_incl, usuario_altr, data_hora_altr)"
			sql = sql & " Values ("
		    sql = sql & "" & intCodGrupo & ","
		    sql = sql & "" & intCodArea & ","
			sql = sql & "'" & strDescricao & "',"
			sql = sql & "'" & strItem & "',"
			if strPrioridade = "0" then
				sql = sql & "null,"
			else
				sql = sql & "'" & strPrioridade & "',"
			end if
			' Usuario do Sistema
			sql = sql & "'" & strUsuario_incl & "',"
			sql = sql & "'" & strData_hora_incl & "',"
			
			' Campos nulos para campo Usuario Alteracao e data Alteracao'
			sql = sql & "" & "null, null" & ")"
			cnn.execute sql
			GravarLog sql
			
        else
			rs.close
			cnn.rollbackTrans
			%>
			<script>
				alert("ATENÇÃO: Esse tipo serviço já está cadastrado.");
				window.location='tipoServicos_cad.asp';
			</script>
			<%
			response.End()
		end if
		rs.close

	elseif acao="A" then

		strMensagem = "Registro Alterado com sucesso..."

		sql = "Update SOS_TIPO_SERVICO Set"
		sql = sql & " descricao = '" & strDescricao & "',"
		sql = sql & " item = '" & strItem & "',"
		sql = sql & " cod_prioridade = '" & strPrioridade & "',"
		sql = sql & " usuario_altr = '" & strUsuario_altr & "',"
		sql = sql & " data_hora_altr = '" & strData_hora_altr & "',"
		sql = sql & " Cod_Area = " & intCodArea
		sql = sql & " where codigo = " & intCodigo
		cnn.execute sql
		GravarLog sql
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SOS_TIPO_SERVICO "
		sql = sql & " where codigo = " & intCodigo

		cnn.execute sql
		GravarLog sql
		
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='tipoServicos_cad.asp';
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