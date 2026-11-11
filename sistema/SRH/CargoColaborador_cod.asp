<!--
    ::	DESENVOLVIDO POR Asced"
    ::	Data de Criação...: 15/05/2015
    ::	Desenvolvedores...: Roberto Barbosa Silva - roberto@superawebx.com.br
    ::	Objetivo Pagina...: Cadastro de Cargo
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<!--#include file="../includes/inc_CompartilharDadosCadastrais.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	acao 					= Trim(Request.QueryString("acao"))
	intCodEmp				= Session("CodEmpresa")
	intCodGrupo				= Session("CodGrupo")
	intCodigo	 			= Trim(Request.Form("txtCodigo"))
	strDescricao 			= Trim(Request.Form("txtDescricao"))
	intCodCargoCategoria 	= Trim(Request.Form("cmbCargoCategoria"))
	strSituacao 				= Trim(Request.Form("cmbSituacao"))
	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
		
		sql = "SELECT COD_CARGO" 
		sql = sql & " FROM SRH_CARGOCOLABORADOR"
		sql = sql & " WHERE Cod_grupo = " & Session("CodGrupo")	
		
		sql = sql & " AND 	DESC_CARGO = '" & strDescricao & "'"
		rs.open sql, cnn
		
		if RS.EOF then

			sql = "Insert Into SRH_CARGOCOLABORADOR(COD_GRUPO, CodCargoCategoria, situacao, DESC_CARGO)"
			sql = sql & " Values ("
		    sql = sql & "" & intCodGrupo & ","
		    sql = sql & "" & intCodCargoCategoria & ","
		    sql = sql & "'" & strSituacao & "',"
			sql = sql & "'" & strDescricao & "')"
			
			cnn.execute sql
			GravarLog sql
			
        else
			rs.close
			cnn.rollbackTrans
			%>
			<script>
				alert("ATENÇÃO: Esse Cargo já está cadastrado.");
				window.location='CargoColaborador_cad.asp';
			</script>
			<%
			response.End()
		end if
		rs.close

	elseif acao="A" then

		strMensagem = "Registro Alterado com sucesso..."

		sql = "Update SRH_CARGOCOLABORADOR Set"
		sql = sql & " DESC_CARGO = '" & strDescricao & "',"
		sql = sql & " situacao = '" & strSituacao & "',"
		sql = sql & " CodCargoCategoria = " & intCodCargoCategoria 
		sql = sql & " where COD_CARGO = " & intCodigo
		cnn.execute sql
		GravarLog sql
		
	else
	

		colaboradores =""
		sql = "SELECT nome" 
		sql = sql & " FROM SRH_COLABORADOR"
		sql = sql & " where 	codCargo=" & intCodigo
		sql = sql & " ORDER BY NOME"
		rs.open sql, cnn
		if not RS.EOF then
			
			while not rs.eof 
				colaboradores = colaboradores & "\n" & rs("nome")
				rs.movenext
			wend
		end if
		RS.CLOSE
		IF colaboradores <>"" THEN
			cnn.rollbackTrans
			%>
			<script>
				alert("ATENÇÃO: Esse cargo não poderá ser excluído. Já está sendo utilizada pelo(s) colaborador(s):<%=colaboradores%>");
				window.history.back();
			</script>
			<%
			response.end
		end if

		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SRH_CARGOCOLABORADOR "
		sql = sql & " where COD_CARGO = " & intCodigo

		cnn.execute sql
		GravarLog sql
		
	end if
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='CargoColaborador_cad.asp';
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