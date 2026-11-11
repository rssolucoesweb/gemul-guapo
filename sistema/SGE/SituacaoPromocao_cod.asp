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
	
	paginaRetorno			= "Situacao_cad.asp"
	strAcao 				= Request.QueryString("acao")
	intCodEmp				= Session("CodEmpresa")

	intCodigo				= Trim(Request.Form("txtCodigo"))
	strDescricao 			= Trim(Request.Form("txtDescricao"))
	strDescricaoaAntiga		= Trim(Request.Form("txtDescricaoAntiga"))
	strDescAbreviada		= Trim(Request.Form("txtDescAbreviada"))
	strCriterio				= Trim(Request.Form("cmbCriterio"))

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

			sql = "SELECT descricao " 
			sql = sql & " FROM SCA_SITUACAO_PROMOCAO"
			sql = sql & " where cod_empresa = " & intCodEmp
			sql = sql & " and descricao = '" & strDescricaoaAntiga & "'"
			rs.open sql, cnn
			if not RS.EOF then
				bolExiste = true
			end if
			rs.close
		
			if bolExiste=false then
			
				strMensagem = "Registro Salvo com sucesso..."
			
				sql = "SELECT Max(codigo) as MaiorCodigo" 
				sql = sql & " FROM SCA_SITUACAO_PROMOCAO"
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
		
				sql = "Insert Into SCA_SITUACAO_PROMOCAO(Cod_Empresa, codigo, descricao, Desc_Abreviada, Criterio)"
				sql = sql & " Values ("
				sql = sql & "" & intCodEmp & ","
				sql = sql & "" & intCodigo & ","
				sql = sql & "'" & strDescricao & "',"
				sql = sql & "'" & strDescAbreviada & "',"
				sql = sql & "'" & strCriterio & "')"
				cnn.execute sql
				
			else
			
				strMensagem = "Registro Alterado com sucesso..."
				sql = "Update SCA_SITUACAO_PROMOCAO Set"
				sql = sql & " descricao = '" & strDescricao & "',"
				sql = sql & " criterio = '" & strCriterio & "',"
				sql = sql & " Desc_Abreviada = '" & strDescAbreviada & "'"
				sql = sql & " where cod_empresa = " & intCodEmp
				sql = sql & " and descricao = '" & strDescricaoaAntiga & "'"
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
			window.location='SituacaoPromocao_cad.asp';
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