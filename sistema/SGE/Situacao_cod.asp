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
	intCodigo	 			= Trim(Request.Form("txtCodigo"))
	strDescricao 			= Trim(Request.Form("txtDescricao"))
	strDescricaoAntiga 		= Trim(Request.Form("txtDescricaoAntiga"))

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

			sql = "SELECT Desc_SituacaoAluno " 
			sql = sql & " FROM SCA_SITUACAOALUNO"
			sql = sql & " where cod_empresa = " & intCodEmp
			sql = sql & " and Desc_SituacaoAluno = '" & strDescricaoAntiga & "'"
			rs.open sql, cnn
			if not RS.EOF then
				bolExiste = true
			end if
			rs.close
	
			if bolExiste=false then
			
				strMensagem = "Registro Salvo com sucesso..."
				
				sql = "SELECT Max(Cod_SituacaoAluno) as MaiorCodigo" 
				sql = sql & " FROM SCA_SITUACAOALUNO"
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
	
				sql = "Insert Into SCA_SITUACAOALUNO(COD_EMPRESA, Cod_SituacaoAluno, Desc_SituacaoAluno)"
				sql = sql & " Values ("
				sql = sql & "" & intCodEmp & ","
				sql = sql & "" & intCodigo & ","
				sql = sql & "'" & strDescricao & "')"
				cnn.execute sql
			else

				strMensagem = "Registro Salvo com sucesso..."
	
				sql = "Update SCA_SITUACAOALUNO Set"
				sql = sql & " Desc_SituacaoAluno = '" & strDescricao & "'"
				sql = sql & " WHERE COD_EMPRESA = " & intCodEmp
				sql = sql & " AND Desc_SituacaoAluno = '" & strDescricaoAntiga & "'"
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
			window.location='Situacao_cad.asp';
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