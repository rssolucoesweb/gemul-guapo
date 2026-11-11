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

	intCodEmp			= Session("CodEmpresa")
	intCodigo			= Trim(Request.Form("txtCodigo"))
	intCodCurso			= REPLACE(Trim(Request.Form("cmbCurso")),"_"," ")
	strDescricao 		= Trim(Request.Form("txtDescricao"))
	strDescricaoAntiga	= Trim(Request.Form("txtDescricaoAntiga"))
	strSequencia 		= Trim(Request.Form("txtSequencia"))


    strDescricaoCurso = ""
	sql = " SELECT Descricao "
	sql = sql & " FROM SCA_CURSO "
	sql = sql & " where cod_empresa = " & intCodEmp
	sql = sql & " and Cod_Curso = " & intCodCurso
	rs.open sql, cnn
	if not rs.EOF then
       strDescricaoCurso = rs("Descricao")
	end if
	rs.close

	on error resume next
	
	cnn.begintrans

	if strAcao = "I" then  
		
		'*****************************************************************
		'todas unidades
		vetCodTodasEmpresa	= split(Session("CodTodasEmpresaGrupo"),",")
		
		'percorre todas unidades
		for i=0 to ubound(vetCodTodasEmpresa)
		
			intCodEmp = vetCodTodasEmpresa(i)
			
			sql = " SELECT COD_CURSO "
			sql = sql & " FROM SCA_CURSO "
			sql = sql & " where cod_empresa = " & intCodEmp
			sql = sql & " and DESCRICAO = '" & strDescricaoCurso & "'"
			rs.open sql, cnn
			if not rs.EOF then
			   intNovoCodCurso   	= rs("Cod_curso")	
			end if
			rs.close

           	'sql = "SELECT SCA_PERIODO.Cod_Periodo, SCA_PERIODO.Cod_Curso, SCA_PERIODO.Descricao " 
			'sql = sql & " FROM SCA_CURSO"
			'sql = sql & " INNER JOIN SCA_PERIODO ON SCA_CURSO.Cod_curso = SCA_PERIODO.Cod_Curso "
			'sql = sql & " AND SCA_CURSO.Cod_Empresa = SCA_PERIODO.Cod_Empresa "
			'sql = sql & " where SCA_PERIODO.cod_empresa = " & intCodEmp
			'sql = sql & " and SCA_PERIODO.Descricao = '" & strDescricaoAntiga & "'"
			'sql = sql & " and SCA_CURSO.DESCRICAO = '" & strDescricaoCurso & "'"

			bolExiste = false
			sql = " SELECT Cod_Periodo, Cod_Curso, Descricao "
			sql = sql & " FROM SCA_PERIODO "
			sql = sql & " WHERE cod_empresa = " & intCodEmp
			sql = sql & " AND Cod_Curso = " & intNovoCodCurso
			sql = sql & " AND SEQUENCIA = " & strSequencia
 			rs.open sql, cnn
			if not RS.EOF then
				bolExiste = true
			end if
			rs.close

			if bolExiste = false then
				
				strMensagem = "Registro Salvo com sucesso..."
			
				sql = "SELECT Max(Cod_Periodo) as MaiorCodigo" 
				sql = sql & " FROM SCA_PERIODO"
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
	
				sql = "Insert Into SCA_PERIODO(Cod_Empresa, Cod_Periodo, Cod_Curso, Descricao, Sequencia)"
				sql = sql & " Values ("
				sql = sql & "" & intCodEmp & ","
				sql = sql & "" & intCodigo & ","
				sql = sql & "'" & intNovoCodCurso & "',"
				sql = sql & "'" & strDescricao & "',"
				sql = sql & "" & strSequencia & ")"
				cnn.execute sql
	
			else
			
				strMensagem = "Registro Alterado com sucesso..."
				sql = "Update SCA_PERIODO Set"
				sql = sql & " Sequencia = " & strSequencia & ","
				sql = sql & " Descricao = '" & strDescricao & "'"
				sql = sql & " where cod_empresa = " & intCodEmp
				sql = sql & " and Descricao = '" & strDescricaoAntiga & "'"
				sql = sql & " and Cod_curso = " & intNovoCodCurso
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
			window.location='Periodo_cad.asp?cmbCurso=<%=intCodCurso%>';
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