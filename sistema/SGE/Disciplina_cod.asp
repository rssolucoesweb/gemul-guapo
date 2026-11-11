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
	
	intCodigo			= Trim(Request.Form("txtCodigo"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
	strDescricaoAntiga	= Trim(Request.Form("txtDescricaoAntiga"))
	strDescAbreviada	= Trim(Request.Form("txtDescAbreviada"))
	strDescHistorico	= Trim(Request.Form("txtDescHistorico"))

	'on error resume next
	
	cnn.begintrans

	if strAcao = "I" then  
		
		strMensagem = "Registro salvo com sucesso para todas unidades do grupo..."
			
		'*****************************************************************
		'todas unidades
		vetCodTodasEmpresa	= split(Session("CodTodasEmpresaGrupo"),",")
		
		'percorre todas unidades
		for i=0 to ubound(vetCodTodasEmpresa)
		
			intCodEmp = vetCodTodasEmpresa(i)
			bolExiste = false

			sql = "SELECT DESC_Disciplina " 
			sql = sql & " FROM SCA_DISCIPLINA"
			sql = sql & " where DESC_Disciplina = '" & strDescricaoAntiga & "'"
			rs.open sql, cnn
			if not RS.EOF then
				bolExiste = true
			end if
			rs.close
			
			if bolExiste=false then
	
				sql = "SELECT Max(COD_Disciplina) as MaiorCodigo" 
				sql = sql & " FROM SCA_DISCIPLINA"
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
		
				strMensagem = "Registro Salvo com sucesso..."

				sql = "Insert Into SCA_DISCIPLINA(COD_Disciplina, DESC_Disciplina, Desc_Abreviada, Desc_Historico)"
				sql = sql & " Values ("
				sql = sql & "" & intCodigo & ","
				sql = sql & "'" & strDescricao & "',"
				sql = sql & "'" & strDescAbreviada & "',"
				sql = sql & "'" & strDescHistorico & "')"
				cnn.execute sql
			else
				strMensagem = "Registro Alterado com sucesso..."
				sql = "Update SCA_DISCIPLINA Set"
				sql = sql & " DESC_Disciplina = '" & strDescricao & "',"
				sql = sql & " Desc_Abreviada = '" & strDescAbreviada & "',"
				sql = sql & " Desc_Historico = '" & strDescHistorico & "' "
				sql = sql & " where DESC_Disciplina = '" & strDescricaoAntiga & "'"
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
			window.location='Disciplina_cad.asp';
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