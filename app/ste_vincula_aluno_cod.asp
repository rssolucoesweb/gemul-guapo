<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_log.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<%
'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	acao 					= Trim(Request.QueryString("acao"))
	intCodAluno				= Trim(Request.QueryString("CodAluno"))
	
	strCod_empresa 			= Trim(Request.Form("cmbEmpresaGrupo"))
	intAnoLetivo	 		= Trim(Request.Form("txtAnoLetivo"))
	
	intCodRota				= Trim(Request.Form("cmbRota"))
	intCodTurno				= Trim(Request.Form("cmbTurno"))
	strCodAluno				= Trim(Request("txtCodAluno"))
	
	
	if strCodAluno = "" then
		strCodAluno			=	Trim(Request.form("chkAluno"))
	end if
	
	if acao="I" then
		
		sql = " Delete From SCA_ROTA_VICULA_ALUNO"
		sql = sql & " Where Cod_Rota = " & intCodRota
		sql = sql & " and ano_letivo = " & intAnoLetivo
		sql = sql & " and cod_empresa = " & strCod_empresa
		cnn.execute sql
		GravarLog sql

		strMensagem = "Alunos Vinculados com sucesso..."
	
		if strCodAluno <> "" then   
			vetCodAluno = split(strCodAluno,",")			 
		end if
		
		intConTipo = 0

		for intContador = 0 to ubound(vetCodAluno)
			
			strCodAluno			= trim(vetCodAluno(intContador))
			intCodTurma 		= Trim(Request.Form("txtTurma_" & strCodAluno))

			sql = " Insert into SCA_ROTA_VICULA_ALUNO (cod_empresa, cod_aluno, codTurma, ano_letivo, Cod_Rota, usuario_incl, data_hora_incl)"
			sql = sql & " VALUES ("
			sql = sql & " " & strCod_empresa & ","
			sql = sql & " " & strCodAluno & ","
			sql = sql & " " & intCodTurma & ","
			sql = sql & " " & intAnoLetivo & ","
			sql = sql & " " & intCodRota & ","
			sql = sql & " '" & session("usuarioweb") & "',"
			sql = sql & " getdate())"
			cnn.execute sql
			GravarLog sql

		next
			
	elseif acao="E" then
		
		strMensagem = "Alunos Desvinculado com sucesso..."
		
		sql = " Delete from SCA_ROTA_VICULA_ALUNO"
		sql = sql & " Where Cod_rota = " & intCodRota
		sql = sql & " and cod_empresa = " & strCod_empresa
		sql = sql & " and cod_aluno = " & intCodAluno
		sql = sql & " and ano_letivo = " & intAnoLetivo
		cnn.execute sql
		GravarLog sql
	
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='ste_vincula_alunoCon.asp?txtAnoLetivo=<%=intAnoLetivo%>&cmbEmpresaGrupo=<%=strCod_empresa%>&cmbRota=<%=intCodRota%>&cmbTurno=<%=intCodTurno%>';
		</script>
		<%
		response.end
	else
		response.redirect "erro.asp?strNumErro=" & err.number & "&strDescErro=" & err.description 
		cnn.rollbacktrans
	end if
%>
