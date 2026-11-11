	<!--
	::	DESENVOLVIDO POR Gemul - Gestor de Município"
	::	Data de Criação...: 23/03/2015
	::	Desenvolvedores...: Asced
	::	Objetivo Pagina...: Cadastro de Regime
	-->
	<!--#include file="../../includes/inc_verificaSession.asp"-->
	<!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../../includes/inc_replaceRequest.asp"-->
	<!--#include file="../../includes/inc_log.asp"-->
	<%
	
	paginaRetorno			= "Regime_cad.asp"
	strAcao 				= Request.QueryString("acao")
	intCodEmp				= Session("CodEmpresa")

	intCodRegime 			= Trim(Request.Form("txtCodigo"))
	strDescricao 			= Trim(Request.Form("txtDescricao"))
	strDescricaoAntiga		= Trim(Request.Form("txtDescricaoAntiga"))
	strTipoSeriacao			= replace(replace(Trim(Request.Form("optTipo")),",","")," ","")

	'on error resume next
	
	cnn.begintrans

	if strAcao = "I" then  
		
		'*****************************************************************
		'todas unidades
		vetCodTodasEmpresa	= split(Session("CodTodasEmpresaGrupo"),",")
		
		'percorre todas unidades
		for i=0 to ubound(vetCodTodasEmpresa)
		
			intCodEmp = vetCodTodasEmpresa(i)
			bolExiste = false

			sql = "SELECT DESC_REGIME " 
			sql = sql & " FROM SCA_REGIME"
			sql = sql & " where cod_empresa = " & intCodEmp
			sql = sql & " and DESC_REGIME = '" & strDescricaoAntiga & "'"
			rs.open sql, cnn
			if not RS.EOF then
				bolExiste = true
			end if
			rs.close
			
			if bolExiste=false then
			
				strMensagem = "Registro Salvo com sucesso..."
				
				sql = "Insert Into SCA_REGIME(COD_EMPRESA, DESC_REGIME, Tipo_Seriacao)"
				sql = sql & " Values ("
				sql = sql & "" & intCodEmp & ","
				sql = sql & "'" & strDescricao & "',"
				sql = sql & "'" & strTipoSeriacao & "')"
				cnn.execute sql
            else
				strMensagem = "Registro Alterado com sucesso..."
				sql = "Update SCA_REGIME Set"
				sql = sql & " DESC_REGIME = '" & strDescricao & "',"
				sql = sql & " Tipo_Seriacao = '" & strTipoSeriacao & "'"
				sql = sql & " where cod_empresa = " & intCodEmp
				sql = sql & " and DESC_REGIME = '" & strDescricaoAntiga & "'"
				cnn.execute sql
 			end if
		
		next
		
	end if

	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='Regime_cad.asp';
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