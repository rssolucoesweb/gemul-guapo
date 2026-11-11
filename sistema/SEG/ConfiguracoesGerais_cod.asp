	<!--
		::	DESENVOLVIDO POR Asced"
		::	Data de Criação...: 26/12/2015
		::	Desenvolvedores...: Roberto Barbosa Silva - roberto@superawebx.com.br
		::	Objetivo Pagina...: Configurações Gerais.
	-->
	<!--#include file="../../includes/inc_verificaSession.asp"-->
	<!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../../includes/inc_replaceRequest.asp"-->
	<!--#include file="../../includes/inc_log.asp"-->
	<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 							= Trim(Request.QueryString("acao"))
	intCodEmp						= Session("CodEmpresa")
	intCodigo	 					= Trim(Request.Form("txtCodigo"))
	strMesPrimeiroSemestre			= Trim(Request.Form("txtMesPrimeiroSemestre"))
	strMesPrimeiroSegundo			= Trim(Request.Form("txtMesPrimeiroSegundo"))
	strFinanceiro					= Trim(Request.Form("cmbFinanceiro"))
		
	if acao="I" then
	
		strMensagem = "Registro Salvo com sucesso..."
		
		sql = "SELECT Max(Codigo) as MaiorCodigo" 
		sql = sql & " FROM SEG_CONFIGURACOESGERAIS"
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
		
		sql = "Insert Into SEG_CONFIGURACOESGERAIS(Codigo, cod_empresa, mes_encerra_primeiro_semestre, mes_encerra_segundo_semestre, checar_financeiro)"
		sql = sql & " Values ("
		sql = sql & "" & intCodigo & ","
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & strMesPrimeiroSemestre & ","
		sql = sql & "" & strMesPrimeiroSegundo & ","
		sql = sql & "'" & strFinanceiro & "')"

	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		
		sql = "Update SEG_CONFIGURACOESGERAIS Set"
		sql = sql & " mes_encerra_primeiro_semestre = " & strMesPrimeiroSemestre & ","
		sql = sql & " mes_encerra_segundo_semestre = " & strMesPrimeiroSegundo & ","
		sql = sql & " checar_financeiro = '" & strFinanceiro & "'"
		sql = sql & " where Codigo = " & intCodigo
		sql = sql & " And cod_empresa = " & intCodEmp
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		
		sql = "Delete from SEG_CONFIGURACOESGERAIS "
		sql = sql & " where Codigo = " & intCodigo
		sql = sql & " And cod_empresa = " & intCodEmp
		
	end if
	
	cnn.execute sql
	GravarLog sql


	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='ConfiguracoesGerais_cad.asp';
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