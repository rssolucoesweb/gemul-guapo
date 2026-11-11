	<!--
	::	DESENVOLVIDO POR Gemul - Gestor de Município"
	::	Data de Criação...: 23/03/2015
	::	Desenvolvedores...: Asced
	::	Objetivo Pagina...: Cadastro de Departamento
	-->
	<!--#include file="../../includes/inc_verificaSession.asp"-->
	<!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../../includes/inc_replaceRequest.asp"-->
	<!--#include file="../../includes/inc_log.asp"-->
	<%
	
	paginaRetorno			= "Regime_cad.asp"
	strAcao 				= Request.QueryString("acao")
	intCodEmp				= Session("CodEmpresa")

	intCodigo			= Trim(Request.Form("txtCodigo"))
	strDescricao 		= Trim(Request.Form("txtDescDepto"))
	strDescricaoAntiga	= Trim(Request.Form("txtDescDeptoAntiga"))
	strSigla			= Trim(Request.Form("txtSigla"))
	strSituacao			= Trim(Request.Form("cmbSituacao"))

	'on error resume next
	
	cnn.begintrans

	if strAcao = "I" then  
		
		strMensagem = "Registro Salvo com sucesso..."
	
		'*****************************************************************
		'todas unidades
		vetCodTodasEmpresa	= split(Session("CodTodasEmpresaGrupo"),",")
		
		'percorre todas unidades
		for i=0 to ubound(vetCodTodasEmpresa)
		
			intCodEmp = vetCodTodasEmpresa(i)
			bolExiste = false
	
			sql = "SELECT DESCRICAO "
			sql = sql & " FROM SEG_DEPARTAMENTO"
			sql = sql & " Where cod_empresa = " & intCodEmp		
			sql = sql & " AND DESCRICAO= '" & strDescricaoAntiga & "'"
			rs.open sql, cnn
			if not RS.EOF then
				bolExiste = true
			end if
			rs.close
	
			if bolExiste=false then
				sql = "SELECT Max(CODIGO) as MaiorCodigo" 
				sql = sql & " FROM SEG_DEPARTAMENTO"
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
		
				sql = "Insert Into SEG_DEPARTAMENTO(COD_EMPRESA, CODIGO, DESCRICAO, SIGLA, SITUACAO)"
				sql = sql & " Values ("
				sql = sql & "" & intCodEmp & ","
				sql = sql & "" & intCodigo & ","
				sql = sql & "'" & strDescricao & "',"
				sql = sql & "'" & strSigla & "',"
				sql = sql & "'" & strSituacao & "')"
				cnn.execute sql
	
			else 
	
				strMensagem = "Registro Alterado com sucesso..."
				sql = "Update SEG_DEPARTAMENTO Set"
				sql = sql & " DESCRICAO = '" & strDescricao & "',"
				sql = sql & " SITUACAO = '" & strSituacao & "',"
				sql = sql & " SIGLA = '" & strSigla & "'"
				sql = sql & " Where cod_empresa = " & intCodEmp		
				sql = sql & " AND DESCRICAO= '" & strDescricaoAntiga & "'"
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
			window.location='Departamento_cad.asp';
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