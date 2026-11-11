	<!--
	::	DESENVOLVIDO POR Gemul - Gestor de Município"
	::	Data de Criação...: 23/03/2015
	::	Desenvolvedores...: Asced
	::	Objetivo Pagina...: Cadastro de Situação
	-->
	<!--#include file="../../includes/inc_verificaSession.asp"-->
	<!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../../includes/inc_replaceRequest.asp"-->
	<!--#include file="../../includes/inc_log.asp"-->
	<%
	
	paginaRetorno		= "Situacao_cad.asp"
	strAcao 			= Request.QueryString("acao")
	
	intCodEmp			= Session("CodEmpresa")
	intCodigo	 		= Trim(Request.Form("txtCodigo"))
	strDescricao 		= Replace(Trim(Request("txtDescricao")),"'","")
	strDescricaoAntiga	= Replace(Trim(Request("txtDescricaoAntiga")),"'","")
	strDescAbreviada	= Replace(Trim(Request("txtDescAbreviada")),"'","") 
	strDescHistorico	= Replace(Trim(Request("txtDescHistorico")),"'","") 
	strSigla			= Replace(Trim(Request("txtSigla")),"'","")
	intCodGrau			= Trim(Request.Form("cmbGrau"))

	strhabilitacao		= Request.Form("txthabilitacao")
	strreconhecimento	= Request.Form("txtreconhecimento")
	strautorizacao		= Request.Form("txtautorizacao")
	strDataReconhecimento= formatadataBD(Request.Form("txtDataReconhecimento"))
	strDataAutorizacao	 = formatadataBD(Request.Form("txtDataAutorizacao"))
	strCHExigida		= Request.Form("txtCHExigida")
	strsimounao         = Request.Form("cmbSimouNao")

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

			sql = "SELECT Descricao " 
			sql = sql & " FROM SCA_CURSO"
			sql = sql & " where cod_empresa = " & intCodEmp
			sql = sql & " and Descricao = '" & strDescricaoAntiga & "'"
			rs.open sql, cnn
			if not RS.EOF then
				bolExiste = true
			end if
			rs.close
			
			if bolExiste=false then	
				sql = "SELECT Max(Cod_curso) as MaiorCodigo" 
				sql = sql & " FROM SCA_CURSO"
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
			
				sql = "Insert Into SCA_CURSO(Cod_Empresa, Cod_curso, Descricao, Desc_Abreviada, Desc_Historico, Sigla, Cod_Grau, habilitacao, reconhecimento, autorizacao, dataReconhecimento, DataAutorizacao, CH_Exigida, processo_seletivo)"
				sql = sql & " Values ("
				sql = sql & "" & intCodEmp & ","
				sql = sql & "" & intCodigo & ","
				sql = sql & "'" & strDescricao & "',"
				sql = sql & "'" & strDescAbreviada & "',"
				sql = sql & "'" & strDescHistorico & "',"
				sql = sql & "'" & strSigla & "',"
				sql = sql & "" & intCodGrau & ","
				sql = sql & "'" & strhabilitacao & "',"
				sql = sql & "'" & strreconhecimento & "',"
				sql = sql & "'" & strautorizacao & "',"
				sql = sql & "'" & strDataReconhecimento & "',"
				sql = sql & "'" & strDataAutorizacao & "',"
				if strCHExigida = "" then
					sql = sql & "null',"
				else
					sql = sql & "'" & strCHExigida & "',"
				end if
				sql = sql & "'" & strsimounao & "')"
				cnn.execute sql

			else

				strMensagem = "Registro Alterado com sucesso..."
				sql = "Update SCA_CURSO Set"
				sql = sql & " Descricao = '" & strDescricao & "',"
				sql = sql & " Desc_Abreviada = '" & strDescAbreviada & "',"
				sql = sql & " Desc_Historico = '" & strDescHistorico & "',"
				sql = sql & " Sigla = '" & strSigla & "',"
				sql = sql & " habilitacao = '" & strhabilitacao & "',"
				sql = sql & " reconhecimento = '" & strreconhecimento & "',"
				sql = sql & " autorizacao = '" & strautorizacao & "',"
				if strDataReconhecimento = "" then
					sql = sql & " datareconhecimento = null,"
				else
					sql = sql & " datareconhecimento = '" & strDataReconhecimento & "',"
				end if
				if strDataAutorizacao = "" then
					sql = sql & " dataautorizacao = null,"
				else
					sql = sql & " dataautorizacao = '" & strDataAutorizacao & "',"
				end if
				if strCHExigida = "" then
					sql = sql & " CH_Exigida = null,"
				else
					sql = sql & " CH_Exigida = '" & strCHExigida & "',"
				end if
				sql = sql & " Cod_Grau = " & intCodGrau & ","
				sql = sql & " Processo_Seletivo = '" & strsimounao & "'"
				sql = sql & " where cod_empresa = " & intCodEmp
				sql = sql & " and Descricao = '" & strDescricaoAntiga & "'"
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
			window.location='Curso_cad.asp';
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