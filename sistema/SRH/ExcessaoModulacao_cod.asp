<!--
    ::	DESENVOLVIDO POR Asced"
    ::	Data de Criação...: 25/05/2015
    ::	Desenvolvedores...: Roberto Barbosa Silva - roberto@superawebx.com.br
    ::	Objetivo Pagina...: Excessões Modulação
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_log.asp"-->

<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	'cnn.begintrans
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmpresa		= session("codEmpresa")
	intCodGrupo 		= Session("CodGrupo")
	intCodigo	 		= Trim(Request.Form("txtCodigo"))
	strTipoLancamento	= Trim(Request.Form("cmbTipoLancamento"))
	strDataLancamento	= Trim(Request.Form("txtDataLancamento"))
	strDataReferencia	= Trim(Request.Form("txtDataReferencia"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
	strModularGrupo		= Trim(Request("GerarGrupo"))

	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	if intSemestre = "" then 	intSemestre  = session("strSemestre")
			
	if acao="I" then
	
		strMensagem = "Registro Salvo com sucesso..."
		
		if strModularGrupo = "" then 
		
			sql = "Insert Into SRH_EXCESSOES_PERIODOMODULACAO(Cod_Empresa, Tipo_Lancamento, Data_Lancamento, Data_Referencia, descricao, ano_letivo, semestre)"
			sql = sql & " Values ("
			sql = sql & "" & intCodEmpresa & ","
			sql = sql & "'" & strTipoLancamento & "',"
			sql = sql & "'" & formatadataBD(trim(strDataLancamento)) & "',"
			
			if strDataReferencia = "" then
				sql = sql & "null,"
			else
				sql = sql & "'" & formatadataBD(trim(strDataReferencia)) & "',"
			end if
			
			sql = sql & "'" & strDescricao & "',"
			sql = sql & "" & strAnoLetivo & ","
			sql = sql & "" & intSemestre & ")"
			cnn.execute sql
			GravarLog sql
						
		else
			
			sql = "SELECT Codigo as CodEmpresa "
			sql = sql & " FROM SEG_EMPRESA"
			sql = sql & " where COD_GRUPO = " & intCodGrupo		
			sql = sql & " Order by Codigo"
			rs.open sql, cnn
			if rs.eof = false then
				while not rs.eof
				
					
					sql = "Insert Into SRH_EXCESSOES_PERIODOMODULACAO(Cod_Empresa, Tipo_Lancamento, Data_Lancamento, Data_Referencia, descricao, ano_letivo, semestre)"
					sql = sql & " Values ("
					sql = sql & "" & trim(rs("CodEmpresa")) & ","
					sql = sql & "'" & strTipoLancamento & "',"
					sql = sql & "'" & formatadataBD(trim(strDataLancamento)) & "',"
					
					if strDataReferencia = "" then
						sql = sql & "null,"
					else
						sql = sql & "'" & formatadataBD(trim(strDataReferencia)) & "',"
					end if
					
					sql = sql & "'" & strDescricao & "',"
					sql = sql & "" & strAnoLetivo & ","
					sql = sql & "" & intSemestre & ")"
					cnn.execute sql
					'GravarLog sql
			
				
				rs.movenext
				wend
			
			end if
			rs.close
		
		end if

	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		
		sql = "Update SRH_EXCESSOES_PERIODOMODULACAO Set"
		sql = sql & " Tipo_Lancamento = '" & strTipoLancamento & "',"
		sql = sql & " Data_Lancamento = '" & formatadataBD(trim(strDataLancamento)) & "',"
		
		if strDataReferencia = "" then
			sql = sql & " Data_Referencia = null,"
		else		
			sql = sql & " Data_Referencia = '" & formatadataBD(trim(strDataReferencia)) & "',"
		end if
		sql = sql & " descricao = '" & strDescricao & "'"
		sql = sql & " where CODIGO = " & intCodigo
		
		cnn.execute sql
		GravarLog sql

	elseif acao="E" then
	

		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SRH_EXCESSOES_PERIODOMODULACAO_UNIDADE "
		sql = sql & " where Cod_SRH_EXCESSOES_PERIODOMODULACAO = " & intCodigo
		cnn.execute sql
		GravarLog sql

		sql = "Delete from SRH_EXCESSOES_PERIODOMODULACAO "
		sql = sql & " where CODIGO = " & intCodigo		
		cnn.execute sql
		GravarLog sql
	end if
	
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		'cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='ExcessaoModulacao_cad.asp';
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