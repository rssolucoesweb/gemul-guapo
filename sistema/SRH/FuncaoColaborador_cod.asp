<!--
    ::	DESENVOLVIDO POR Asced"
    ::	Data de Criação...: 25/05/2015
    ::	Desenvolvedores...: Roberto Barbosa Silva - roberto@superawebx.com.br
    ::	Objetivo Pagina...: Cadastro de Situacao 
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
	strCategoriaFuncao	= Trim(Request.Form("cmbCategoriaFuncao"))
	strPeriodoFuncao	= Trim(Request.Form("cmbPeriodoFuncao"))
	strSituacaoDisciplinar	= Trim(Request.Form("cmbSituacaoDisciplinar"))
	strModular				= Trim(Request.Form("cmbModular"))
	intCodFuncaoCategoria	= Trim(Request.Form("cmbFuncaoCategoria"))
	strSituacao 				= Trim(Request.Form("cmbSituacao"))
			lancamento_falta_por 				= Trim(Request.Form("lancamento_falta_por"))
	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
		
		sql = "SELECT COD_FUNCAO" 
		sql = sql & " FROM SRH_FUNCAOCOLABORADOR"
		sql = sql & " where 	DESC_FUNCAO = '" & strDescricao & "'"
		rs.open sql, cnn
		if RS.EOF then
			rs.close
			
			sql = "SET NoCount ON Insert Into SRH_FUNCAOCOLABORADOR(COD_GRUPO,lancamento_falta_por ,DESC_FUNCAO, Tipo_Funcao, situacao, Periodo, Situacao_Disciplinar, cod_FuncaoCategoria, Modular)"
			sql = sql & " Values ("
			sql = sql & "" & intCodGrupo & ","
			sql = sql & "'" & lancamento_falta_por & "',"
			sql = sql & "'" & strDescricao & "',"
			sql = sql & "'" & strCategoriaFuncao & "',"
			sql = sql & "'" & strSituacao & "',"
			if strCategoriaFuncao <> "FUNCIONARIO" then
				sql = sql & "'" & strPeriodoFuncao & "',"
			else	
				sql = sql & "null,"
			end if	
			
			if strSituacaoDisciplinar <> "" then
				sql = sql & "'" & strSituacaoDisciplinar & "',"
			else	
				sql = sql & "null,"
			end if	
			
			if intCodFuncaoCategoria <> "0" then
				sql = sql & "'" & intCodFuncaoCategoria & "',"
			else	
				sql = sql & "null,"
			end if
			
			if strModular <> "" then
				sql = sql & "'" & strModular & "')"
			else	
				sql = sql & "null)"
			end if	
			SQL=SQL & ";SELECT @@IDENTITY "		
			Set rs = cnn.Execute(sql)
			intCodFuncao = rs(0)
			rs.close
			
        else
			rs.close
			cnn.rollbackTrans
			%>
			<script>
				alert("ATENÇÃO: Essa Função já está cadastrada.");
				window.location='FuncaoColaborador_cad.asp';
			</script>
			<%
			response.End()
		end if

	elseif acao="A" then

		strMensagem = "Registro Alterado com sucesso..."

		sql = "Update SRH_FUNCAOCOLABORADOR Set"
		sql = sql & " DESC_FUNCAO = '" & strDescricao & "',"
		sql = sql & " Tipo_Funcao = '" & strCategoriaFuncao & "',"
		
		if strCategoriaFuncao <> "FUNCIONARIO" then
			sql = sql & " Periodo = '" & strPeriodoFuncao & "',"
		else
			sql = sql & " Periodo = null,"
		end if
		if intCodFuncaoCategoria <> "0" then
			sql = sql & " cod_FuncaoCategoria = '" & intCodFuncaoCategoria & "',"
		else
			sql = sql & " cod_FuncaoCategoria = null,"
		end if
		if strModular <> "" then
			sql = sql & " Modular = '" & strModular & "',"
		else
			sql = sql & " Modular = null,"
		end if
		if strSituacao <> "0" then
			sql = sql & " situacao = '" & strSituacao & "',"
		else
			sql = sql & " situacao = null,"
		end if
		sql = sql & " lancamento_falta_por = '" & lancamento_falta_por & "',"
		if strSituacaoDisciplinar <> "" then
			sql = sql & " Situacao_Disciplinar = '" & strSituacaoDisciplinar & "'"
		else
			sql = sql & " Situacao_Disciplinar = null"
		end if
		
		sql = sql & " where COD_FUNCAO = " & intCodigo

		cnn.execute sql
		GravarLog sql
		
		
	elseif acao="E" then

		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SRH_FUNCAOCOLABORADOR "
		sql = sql & " where COD_FUNCAO = " & intCodigo

		cnn.execute sql
		GravarLog sql
		
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='FuncaoColaborador_cad.asp';
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