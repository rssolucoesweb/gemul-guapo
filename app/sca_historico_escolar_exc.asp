<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="includes/inc_log.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	
	intCodEmp			= Session("CodEmpresa")
	strMatricula		= Trim(Request("matricula"))
	intCodAluno			= Trim(Request("codAluno"))
	intCodHit			= Trim(Request("intCodHit"))

	sql="delete	"
	sql=sql & " from	sca_historico_escolar_disciplina"
	sql=sql & " where	cod_historico_escolar = " & intCodHit
	cnn.execute SQL
	GravarLog sql	

	sql=" delete"
	sql=sql & " from	sca_historico_escolar"
	sql=sql & " where	codigo = " & intCodHit
	sql=sql & " and		cod_aluno = " & intCodAluno
	sql=sql & " and	 	cod_empresa = " & Session("CodEmpresa") 
	cnn.execute SQL
	GravarLog sql	

	strMensagem = "Histórico excluído com sucesso..."
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='sca_historico_escolarCon.asp?txtMatricula=<%=strMatricula%>';
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