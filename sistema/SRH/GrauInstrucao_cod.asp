<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
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
	
		strMensagem = "Registro salvo com sucesso..."
		
		sql = "SELECT Max(CODIGO) as MaiorCodigo" 
		sql = sql & " FROM SCA_GRAUINSTRUCAO"
		rs.open sql, cnn
		
		if not RS.EOF then
		
			if rs("MaiorCodigo") <> "" then
				intCodNovo = cstr(rs("MaiorCodigo")) + 1
				intCodigo = intCodNovo
			else
				intCodigo = 1	
			end if
		
		end if
		rs.close

		sql = "Insert Into SCA_GRAUINSTRUCAO(COD_GRUPO, CODIGO, DESCRICAO)"
		sql = sql & " Values ("
		sql = sql & "" & intCodGrupo & ","
		sql = sql & "" & intCodigo & ","
		sql = sql & "'" & strDescricao & "')"

	elseif acao="A" then
		
		strMensagem = "Registro saldo com sucesso..."
		
		sql = "Update SCA_GRAUINSTRUCAO Set"
		sql = sql & " DESCRICAO = '" & strDescricao & "'"
		sql = sql & " where CODIGO = " & intCodigo
		
	else
	
		strMensagem = "Registro excluido com sucesso..."
		
		sql = "Delete from SCA_GRAUINSTRUCAO "
		sql = sql & " where CODIGO = " & intCodigo
		
	end if
	
	cnn.execute sql
	GravarLog sql

	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='GrauInstrucao_cad.asp';
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