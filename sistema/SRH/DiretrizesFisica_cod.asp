<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 						= Trim(Request.QueryString("acao"))	
	intCodEmpresa				= session("codEmpresa")
	intCodigo	 				= Trim(Request.Form("txtCodigo"))
	intAnoLetivo 				= Trim(Request.Form("txtAnoLetivo"))
	intCodDependencia			= Trim(Request.Form("cmbDependenciasFisicas"))
	intCodTipoDependencia		= Trim(Request.Form("cmbTipoDependenciasFisicas"))
	intComprimento 				= replace(Trim(Request.Form("txtComprimento")),",",".")
	intLargura	 				= replace(TRIM(Request.Form("txtLargura")),",",".")
	intArea		 				= replace(TRIM(Request.Form("txtArea")),",",".")
	strSituacao	 				= TRIM(Request.Form("cmbSituacao"))
    
	if acao="I" then

		intId = "1"
		sql = "SELECT max(isnull(id,0))+1 as id"
		sql = sql & " FROM SRH_DIRETRIZES_ESTRUTURA_FISICA"
		sql = sql & " where Cod_Empresa = " & intCodEmpresa
		rs.open sql, cnn
		if rs.eof = false then
			intId = rs("id")
			if isnull(intId) then intId = 1
			if intId = "" then intId = 1
		end if
		rs.close
		
		strMensagem = "Registro Salvo com sucesso..."
		
		sql = "Insert Into SRH_DIRETRIZES_ESTRUTURA_FISICA(cod_Empresa, ano_letivo,cod_dependencias_fisicas,id,cod_tipo_dependencias_fisicas,comprimento,largura,area,situacao,usuario_incl,data_hora_incl)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmpresa & ","
		sql = sql & "" & intAnoLetivo & ","
		sql = sql & "" & intCodDependencia & ","
		sql = sql & "" & intId & ","
		sql = sql & "" & intCodTipoDependencia & ","
		sql = sql & "" & intComprimento & ","
		sql = sql & "" & intLargura & ","
		sql = sql & "" & intArea & ","
		sql = sql & "'" & strSituacao & "',"
		sql = sql & "'" & session("usuarioWeb") & "',getdate())"
	elseif acao="A" then

		strMensagem = "Registro Alterado com sucesso..."
		
		sql = "Update SRH_DIRETRIZES_ESTRUTURA_FISICA Set"
		sql = sql & " cod_dependencias_fisicas = " & intCodDependencia & ","
		sql = sql & " cod_tipo_dependencias_fisicas = " & intCodTipoDependencia & ","
		sql = sql & " comprimento = " & intComprimento & ","
		sql = sql & " largura = " & intLargura & ","
		sql = sql & " area = " & intArea & ","
		sql = sql & " usuario_altr = '" & session("usuarioWeb") & "',"
		sql = sql & " data_hora_altr = getdate()"
		sql = sql & " Where Codigo = " & intCodigo

	else
	
		strMensagem = "Registro Excluido com sucesso..."
		
		sql = "Delete From SRH_DIRETRIZES_ESTRUTURA_FISICA "
		sql = sql & " Where Codigo = " & intCodigo

	end if
	cnn.execute sql
	GravarLog sql

	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='DiretrizesFisica_cad.asp';
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