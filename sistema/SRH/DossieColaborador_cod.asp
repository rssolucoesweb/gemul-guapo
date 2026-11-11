<!--
    ::	DESENVOLVIDO POR Asced"
    ::	Data de Criação...: 29/05/2015
    ::	Desenvolvedores...: Roberto Barbosa Silva - roberto@superawebx.com.br
    ::	Objetivo Pagina...: Dossie Coloaborador 
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 							= Trim(Request.QueryString("acao"))
	
	' Dados Colaboradors
	intCodEmp						= Session("CodEmpresa")
	intCodigo	 					= Trim(Request.Form("txtCodigo"))
	intCodFunc 						= Trim(Request.Form("txtCodFuncionario"))
	intCodCargo 	    			= TRIM(Request.Form("cmbCargo"))
	intcodLotacao 	   				= TRIM(Request.Form("cmbLotacao"))
	intCodDepartamento				= Trim(Request.Form("cmbDepartamento"))
	strdata_admissao  				= formataDataBd(Trim(Request.Form("txtdata_admissao")))
	strDatafastamento				= Trim(Request.Form("txtDatafastamento"))
	
	' Dados Dossie
	intCodColaboradorEventoDossie 	= Trim(Request.Form("cmbColaboradorEventoDossie"))
	strPeridoReferencia_Inicio 	= formataDataBd(Trim(Request.Form("txtPeridoReferencia_Inicio")))
	strPeridoReferencia_Final  	= formataDataBd(Trim(Request.Form("txtPeridoReferencia_Final")))
	strPeriodoAquisicao_Inicio  = formataDataBd(Trim(Request.Form("txtPeriodoAquisicao_Inicio")))
	strPeriodoAquisicao_Final  	= formataDataBd(Trim(Request.Form("txtPeriodoAquisicao_Final")))
	strAverbacoes				= Trim(Request.Form("txtAverbacoes"))
	strValor					= Replace(Replace(trim(Request.Form("txtValor")),".",""),",",".") 
			
	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
		
		sql = "Insert Into SRH_DOSSIE_COLABORADOR( Cod_Colaborador, Cod_empresa, Cod_ColaboradorEventoDossie, Cod_cargo, Cod_lotacao," 
		sql = sql & " Cod_departamento, Data_admissao, Data_afastamento,"
		sql = sql & " DataPeridoReferencia_Inicio, DataPeridoReferencia_Final, "
		sql = sql & " DataPeriodoAquisicao_Inicio, DataPeriodoAquisicao_Final, "
		sql = sql & " Averbacoes, Valor )"
		sql = sql & " Values ("
		sql = sql & "" & intCodFunc & ","
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & intCodColaboradorEventoDossie & ","
		
		if intCodCargo <> "0" then
			sql = sql & "" & intCodCargo & ","
		else
			sql = sql & "null, "
		end if 
		
		if intcodLotacao <> "0" then
			sql = sql & "" & intcodLotacao & ","
		else
			sql = sql & "null, "
		end if 
		
		if intCodDepartamento <> "0" then
			sql = sql & "" & intCodDepartamento & ","
		else
			sql = sql & "null, "
		end if 
			
		if strdata_admissao <> "" then
			sql = sql & "'" & strdata_admissao & "',"
		else
			sql = sql & "null, "
		end if 
		
		if strDatafastamento <> "" then
			sql = sql & "'" & strDatafastamento & "',"
		else
			sql = sql & "null, "
		end if 
		
		sql = sql & "'" & strPeridoReferencia_Inicio & "',"
		sql = sql & "'" & strPeridoReferencia_Final & "',"
		sql = sql & "'" & strPeriodoAquisicao_Inicio & "',"
		sql = sql & "'" & strPeridoReferencia_Final & "',"
			
		if strAverbacoes <> "" then
			sql = sql & "'" & strAverbacoes & "',"
		else
			sql = sql & "null, "
		end if 
		
		if strValor <> "" then
			sql = sql & "" & strValor & ")"
		else
			sql = sql & "null ) "
		end if 
		
		cnn.execute sql
		GravarLog sql
			

	elseif acao="A" then

		strMensagem = "Registro Alterado com sucesso..."

		sql = "Update SRH_DOSSIE_COLABORADOR Set"
		sql = sql & " Cod_ColaboradorEventoDossie = '" & intCodColaboradorEventoDossie & "',"
		
		if intCodCargo <> "0" then
			sql = sql & " Cod_cargo = " & intCodCargo & ","
		else
			sql = sql & " Cod_cargo = null, " 
		end if 
		
		if intcodLotacao <> "0" then
			sql = sql & " Cod_lotacao = " & intcodLotacao & ","
		else
			sql = sql & " Cod_lotacao = null, " 
		end if 
		
		if intCodDepartamento <> "0" then
			sql = sql & " Cod_departamento = " & intCodDepartamento & ","
		else
			sql = sql & " Cod_departamento = null, " 
		end if 
		
		if strdata_admissao <> "" then
			sql = sql & " Data_admissao = '" & strdata_admissao & "',"
		else
			sql = sql & " Data_admissao = null, " 
		end if 
		
		if strDatafastamento <> "" then
			sql = sql & " Data_afastamento = '" & strDatafastamento & "',"
		else
			sql = sql & " Data_afastamento = null, " 
		end if 

		sql = sql & " DataPeridoReferencia_Inicio = '" & strPeridoReferencia_Inicio & "',"
		sql = sql & " DataPeridoReferencia_Final = '" & strPeridoReferencia_Final & "',"
		sql = sql & " DataPeriodoAquisicao_Inicio = '" & strPeriodoAquisicao_Inicio & "',"
		sql = sql & " DataPeriodoAquisicao_Final = '" & strPeriodoAquisicao_Final & "',"
		
		if strAverbacoes <> "" then
			sql = sql & " Averbacoes = '" & strAverbacoes & "',"
		else
			sql = sql & " Averbacoes = null, " 
		end if 
		
		if strValor <> "" then
			sql = sql & " Valor = " & strValor & ""
		else
			sql = sql & " Valor = null" 
		end if 
		
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " AND Cod_Empresa = " & intCodEmp
		sql = sql & " AND Cod_Colaborador = " & intCodFunc

		cnn.execute sql
		GravarLog sql
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		
		sql = "Delete from SRH_DOSSIE_COLABORADOR "
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " AND Cod_Empresa = " & intCodEmp
		sql = sql & " AND Cod_Colaborador = " & intCodFunc
		
		cnn.execute sql
		GravarLog sql
		
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='DossieColaborador_cad.asp';
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