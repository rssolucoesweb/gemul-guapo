<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 29/08/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Cadastro de Turno 
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
	intCodigo	 		= Trim(Request.Form("txtCodigo"))
	intCodCurso	        = Trim(Request("cmbCursoPrimeiraOpcao"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
	
	if acao="I" or acao="A" then

		sql = "SELECT COD_TURNO" 
		sql = sql & " FROM SCA_TURNO_VESTIBULAR"
		sql = sql & " where cod_empresa= " & session("CodEmpresa")
		sql = sql & " and COD_CURSO = " & intCodCurso
		sql = sql & " and DESC_TURNO = '" & strDescricao & "'"
		rs.open sql, cnn
		if not RS.EOF then
			cnn.commitTrans
			strMensagem = "Registro já Cadastrado. Verifique!"
			%>
			<script>
				alert("<%=strMensagem%>");
				window.location='TurnoVestibular_cad.asp';
			</script>
			<%
			response.end
		
		end if
		rs.close

	end if
			
	if acao="I" then
		
		strMensagem = "Registro Salvo com sucesso..."
		
		sql = "SELECT Max(COD_TURNO) as MaiorCodigo" 
		sql = sql & " FROM SCA_TURNO_VESTIBULAR"
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

		sql = "Insert Into SCA_TURNO_VESTIBULAR(Cod_Empresa, COD_TURNO, DESC_TURNO, COD_CURSO )"
		sql = sql & " Values ("
		sql = sql & "" & intCodEmp & ","
		sql = sql & "" & intCodigo & ","
		sql = sql & "'" & strDescricao & "',"
		sql = sql & "" & intCodCurso & ")"

	elseif acao="A" then
		
		strMensagem = "Registro Alterado com sucesso..."
		sql = "Update SCA_TURNO_VESTIBULAR Set"
		sql = sql & " DESC_TURNO = '" & strDescricao & "',"
		sql = sql & " COD_CURSO = " & intCodCurso & ""
		sql = sql & " where COD_TURNO = " & intCodigo
		
	else

		strMensagem = "Registro Excluido com sucesso..."
		sql = "Delete from SCA_TURNO_VESTIBULAR "
		sql = sql & " where COD_TURNO = " & intCodigo
		
	end if
	
	cnn.execute sql
GravarLog sql
if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='TurnoVestibular_cad.asp';
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