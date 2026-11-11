<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/08/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Cadastro de Perido
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->

<%
	on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 				= Trim(Request.QueryString("acao"))
	intCodEmp			= Session("CodEmpresa")
	intCodigo			= Trim(Request.Form("txtCodigo"))
	intCodCurso			= Trim(Request.Form("cmbCurso"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
	strSequencia 		= Trim(Request.Form("txtSequencia"))
	strTipo		 		= Trim(Request.Form("cmbTipo"))
	strMatricula		= Trim(Request.Form("cmbMatricula"))
	
	if acao="I" then
		strTemMesmaSequencia = false
		sql = "SELECT sequencia" 
		sql = sql & " FROM SCA_PERIODO"
		sql = sql & " where cod_empresa = " & intCodEmp
		sql = sql & " and cod_curso = " & intCodCurso
		sql = sql & " and sequencia = " & strSequencia
		rs1.open sql, cnn
		if not RS1.EOF then
			strTemMesmaSequencia = true
		end if
		rs1.close

		if strTemMesmaSequencia then
			%>
			<script>
				alert("ATENÇÃO: Já existe essa mesma sequencia para esse mesmo curso, favor verificar as informações cadastradas.\nUm período não pode ter a mesma sequencia em um mesmo curso.");
				window.history.back();
			</script>
			<%
			response.End()
		end if

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

		sql = "Insert Into SCA_PERIODO(Cod_Empresa, Cod_Periodo, Cod_Curso, Descricao, Sequencia, tipo, Matricula)"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & intCodigo & ","
		sql = sql & "" & intCodCurso & ","
		sql = sql & "'" & strDescricao & "',"
		sql = sql & "" & strSequencia & ","
		sql = sql & "'" & strTipo & "',"
		sql = sql & "'" & strMatricula & "')"
		cnn.execute sql

	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		sql = "Update SCA_PERIODO Set"
		sql = sql & " Sequencia = " & strSequencia & ","
		sql = sql & " Tipo = '" & strTipo & "',"
		sql = sql & " Matricula = '" & strMatricula & "',"
		sql = sql & " Descricao = '" & strDescricao & "'"
		sql = sql & " Where Cod_Periodo = " & intCodigo
		cnn.execute sql
		
	else
	
		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SCA_PERIODO "
		sql = sql & " where Cod_Periodo = " & intCodigo
		cnn.execute sql
		if trim(err.number)="-2147217873" then
			cnn.rollbackTrans
			%>
			<script>
				alert("ATENÇÃO: Registro não pode ser excluido, exite outros registro vinculado a ele.");
				window.history.back();
			</script>
			<%
			response.End()
		end if		
	end if
	
	
	GravarLog sql
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