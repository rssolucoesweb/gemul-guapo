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
	
	paginaRetorno				= "Situacao_cad.asp"
	strAcao 					= Request.QueryString("acao")

	intCodEmp					= Session("CodEmpresa")
	intCodCurso					= Trim(Request("cmbCurso"))
	intCodigo 					= Trim(Request.Form("txtCodigo"))
	strDescricao 				= Trim(Request.Form("txtDescricao"))
	strDescricaoAntiga 			= Trim(Request.Form("txtDescricaoAntiga"))
	strSigla					= Trim(Request.Form("txtSigla"))
	intCodAvaliacaoAgrupamento	= Trim(Request.Form("cmbTipoAvaliacaoAgrupamento"))
	strPosicao					= Trim(Request.Form("cmbPosicao"))
	strFormula					= Trim(Request.Form("txtFormula"))
	strDigitar					= Trim(Request.Form("txtDigitar"))
	
    sql = "SELECT Descricao as NomeCurso"
	sql = sql & " FROM SCA_CURSO "
	sql = sql & " WHERE Cod_curso = " & intCodCurso	
	rs.open sql, cnn
	if not RS.EOF then
	   strnovoNomeCurso				= rs("NomeCurso")
	else
		rs.close
		cnn.rollbackTrans
		%>
		<script>
			alert("ATENÇÃO: Não Existem Informações Consistentes para Gerar Grade, Verifique seu cadastro de Curso/Período.");
			window.history.back();
		</script>
		<%
		response.End()
	end if
	rs.close

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
			
				' Verifico se a empresa a ser incluída possui Curso
				sql = "SELECT COD_CURSO"
				sql = sql & " FROM SCA_CURSO "
				sql = sql & " WHERE DESCRICAO = '" & strnovoNomeCurso & "'"	
				rs.open sql, cnn
				if not rs.EOF then
					intNovoCodigoCurso 		= rs("COD_CURSO")
				else
					rs.close
					cnn.rollbackTrans
					%>
					<script>
						alert("ATENÇÃO: Curso inexistente, impossível incluir Tipo de Avaliação para empresa n. <%=intCodEmp%>");
						window.history.back();
					</script>
					<%
					response.End()
				end if
				rs.close
			
				sql = " SELECT SA.DESCRICAO, SA.COD_CURSO FROM  SCA_TIPO_AVALIACAO SA "
				sql = sql & " INNER JOIN SCA_CURSO C ON C.COD_CURSO = SA.COD_CURSO "
				sql = sql & " Where C.DESCRICAO = '" & strnovoNomeCurso & "'"
				sql = sql & " and SA.DESCRICAO = '" & strDescricaoAntiga & "'"
				rs.open sql, cnn
				if not RS.EOF then
					bolExiste = true
				end if
				rs.close
				
				if bolExiste=false then
				
					strMensagem = "Registro Salvo com sucesso..."
					
					sql = "SELECT Max(codigo) as MaiorCodigo" 
					sql = sql & " FROM SCA_TIPO_AVALIACAO"
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
					
					sql = "Insert Into SCA_TIPO_AVALIACAO( codigo, descricao, sigla, bimestre, posicao, formula, digitar, cod_curso)"
					sql = sql & " Values ("
					sql = sql & "" & intCodigo & ","
					sql = sql & "'" & strDescricao & "',"
					sql = sql & "'" & strSigla & "',"
					sql = sql & "" & intCodAvaliacaoAgrupamento & ","
					sql = sql & "" & strPosicao & ","
					sql = sql & "'" & strFormula & "',"
					sql = sql & "'" & strDigitar & "',"
					sql = sql & "" & intNovoCodigoCurso & ")"
					cnn.execute sql
					
				else
					strMensagem = "Registro Alterado com sucesso..."
					sql = "Update SCA_TIPO_AVALIACAO Set"
					sql = sql & " descricao = '" & strDescricao & "',"
					sql = sql & " sigla = '" & strSigla & "',"
					sql = sql & " posicao = " & strPosicao & ","
					sql = sql & " digitar = '" & strDigitar & "',"
					sql = sql & " cod_curso = " & intNovoCodigoCurso & ","
					sql = sql & " formula = '" & strFormula & "',"
					sql = sql & " bimestre = " & intCodAvaliacaoAgrupamento & ""
					sql = sql & " where cod_Curso = " & intNovoCodigoCurso
					sql = sql & " and descricao = '" & strDescricaoAntiga & "'"
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
			window.location='TipoAvaliacao_cad.asp?cmbCurso=<%=intCodCurso%>';
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