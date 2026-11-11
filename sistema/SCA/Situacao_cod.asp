<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 29/08/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Cadastro de Situacao 
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->

<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 					= Trim(Request.QueryString("acao"))
	intCodEmp				= Session("CodEmpresa")
	intCodigo	 			= Trim(Request.Form("txtCodigo"))
	strDescricao 			= Trim(Request.Form("txtDescricao"))
	intVinculoAlunoCenso    = Trim(Request.Form("cmbVinculoAlunoCenso"))
	strSituacao				= Trim(Request.Form("cmbSituacao"))

	if acao="I" then
		
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
		
		'REGRA PARA INCLUSAO DE SITUACAO - ATIVO E PRE-MATRICULA
		sql = "SELECT Desc_SituacaoAluno" 
		sql = sql & " FROM SCA_SITUACAOALUNO"
		sql = sql & " WHERE COD_EMPRESA = " & intCodEmp
		rs.open sql, cnn
		if RS.EOF then
			sql = "SELECT Max(Cod_SituacaoAluno) as MaiorCodigo" 
			sql = sql & " FROM SCA_SITUACAOALUNO"
			rs1.open sql, cnn
			if not rs1.EOF then
				if rs1("MaiorCodigo") <> "" then
					intCodNovo = cstr(rs1("MaiorCodigo")) + 1
					intCodigo = intCodNovo
				else
					intCodigo = 1	
				end if
			end if
			rs1.close
		
			sql = "Insert Into SCA_SITUACAOALUNO(COD_EMPRESA, Cod_SituacaoAluno, Cod_Vinculo_Inep, Desc_SituacaoAluno, status)"
			sql = sql & " Values ("
			sql = sql & "" & intCodEmp & ","
			sql = sql & "" & intCodigo & ","
			sql = sql & "" & intVinculoAlunoCenso & ","
			sql = sql & "'ATIVO',"
			sql = sql & "'A')"
			cnn.execute sql
			GravarLog sql			

			sql = "SELECT Max(Cod_SituacaoAluno) as MaiorCodigo" 
			sql = sql & " FROM SCA_SITUACAOALUNO"
			rs1.open sql, cnn
			if not rs1.EOF then
				if rs1("MaiorCodigo") <> "" then
					intCodNovo = cstr(rs1("MaiorCodigo")) + 1
					intCodigo = intCodNovo
				else
					intCodigo = 1	
				end if
			end if
			rs1.close

			sql = "Insert Into SCA_SITUACAOALUNO(COD_EMPRESA, Cod_SituacaoAluno, Cod_Vinculo_Inep, Desc_SituacaoAluno, status)"
			sql = sql & " Values ("
			sql = sql & "" & intCodEmp & ","
			sql = sql & "" & intCodigo & ","
			sql = sql & "" & intVinculoAlunoCenso & ","
			sql = sql & "'PRÉ-MATRÍCULA',"
			sql = sql & "'A')"
			cnn.execute sql
			GravarLog sql			

			sql = "SELECT Max(Cod_SituacaoAluno) as MaiorCodigo" 
			sql = sql & " FROM SCA_SITUACAOALUNO"
			rs1.open sql, cnn
			if not RS1.EOF then
				if rs1("MaiorCodigo") <> "" then
					intCodNovo = cstr(rs1("MaiorCodigo")) + 1
					intCodigo = intCodNovo
				end if
			end if
			rs1.close
			
			strDescricao = "ATIVO"
			%>
			<script>
				alert("ATENÇÃO: As primeiras situações a serem incluídas serão: ATIVO e PRÉ-MATRÍCULA.");
			</script>
			<%
		else
			strDescricaoAnterior = rs("Desc_SituacaoAluno")
		end if
		rs.close

		sql = "SELECT Cod_SituacaoAluno" 
		sql = sql & " FROM SCA_SITUACAOALUNO"
		sql = sql & " WHERE COD_EMPRESA = " & intCodEmp
		sql = sql & " AND 	Desc_SituacaoAluno = '" & strDescricao & "'"
		rs.open sql, cnn
		if RS.EOF then

			sql = "Insert Into SCA_SITUACAOALUNO(COD_EMPRESA, Cod_SituacaoAluno, Cod_Vinculo_Inep, Desc_SituacaoAluno, status)"
			sql = sql & " Values ("
			sql = sql & "" & intCodEmp & ","
			sql = sql & "" & intCodigo & ","
			sql = sql & "" & intVinculoAlunoCenso & ","
			sql = sql & "'" & strDescricao & "',"
			sql = sql & "'" & strSituacao & "')"
	
			cnn.execute sql
			GravarLog sql

		end if
		rs.close

	elseif acao="A" then
		'REGRA PARA INCLUSAO DE SITUACAO - ATIVO
		sql = "SELECT Desc_SituacaoAluno" 
		sql = sql & " FROM SCA_SITUACAOALUNO"
		sql = sql & " where Cod_SituacaoAluno = " & intCodigo
		sql = sql & " AND COD_EMPRESA = " & intCodEmp
		rs.open sql, cnn
		if not RS.EOF then
			if ucase(rs("Desc_SituacaoAluno")) = "ATIVO" OR ucase(rs("Desc_SituacaoAluno")) = "PRÉ-MATRÍCULA" then
				strDescricao = ucase(rs("Desc_SituacaoAluno"))
				rs.close
				%>
				<script>
					alert("ATENÇÃO: Somente o Campo Descricao da Situação não poderá ser alterado.");
				</script>
				<%
			end if
		else
			rs.close
		end if
		strMensagem = "Registro Alterado com sucesso..."
		sql = "Update SCA_SITUACAOALUNO Set"
		sql = sql & " Cod_Vinculo_Inep = '" & intVinculoAlunoCenso & "',"
		sql = sql & " status = '" & strSituacao & "'"
		sql = sql & " where Cod_SituacaoAluno = " & intCodigo
		sql = sql & " AND COD_EMPRESA = " & intCodEmp

		cnn.execute sql
		GravarLog sql
		
	else
		'REGRA PARA INCLUSAO DE SITUACAO - ATIVO
		sql = "SELECT Desc_SituacaoAluno" 
		sql = sql & " FROM SCA_SITUACAOALUNO"
		sql = sql & " where Cod_SituacaoAluno = " & intCodigo
		sql = sql & " AND COD_EMPRESA = " & intCodEmp
		rs.open sql, cnn
		if not RS.EOF then
			if ucase(rs("Desc_SituacaoAluno")) = "ATIVO" OR ucase(rs("Desc_SituacaoAluno")) = "PRÉ-MATRÍCULA" then
				strDescricao = ucase(rs("Desc_SituacaoAluno"))
				rs.close
				cnn.rollbackTrans
				%>
				<script>
					alert("ATENÇÃO: Essa situação não pode ser excluído.");
					window.history.back();
				</script>
				<%
				response.End()
			end if
		else
			rs.close
		end if
	
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SCA_SITUACAOALUNO "
		sql = sql & " where Cod_SituacaoAluno = " & intCodigo
		sql = sql & " AND COD_EMPRESA = " & intCodEmp

		cnn.execute sql
		GravarLog sql
		
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