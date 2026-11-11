<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%
	cnn.begintrans
	acao 				= Trim(Request.QueryString("acao"))
	intCodEscolas 		= Trim(Request("chkEscola"))
	intCodigo	 		= Trim(Request("codExcessao"))
	
	'altera hist disc
	SQL = "delete SRH_EXCESSOES_PERIODOMODULACAO_UNIDADE "
	SQL = SQL & " where Cod_SRH_EXCESSOES_PERIODOMODULACAO = " & intCodigo
	cnn.execute SQL
	GravarLog sql
	
	'altera hist disc
	SQL = "insert SRH_EXCESSOES_PERIODOMODULACAO_UNIDADE "
	SQL = SQL & " select " & intCodigo & ",codigo"
	SQL = SQL & " from SEG_EMPRESA "
	SQL = SQL & " where codigo in (" & intCodEscolas & ")"
	cnn.execute SQL
	GravarLog sql

	if err.number = 0 then
		'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			aguarde.style.display="none";
		</script>
		<script>
			alert("Registro incluído com sucesso.");
			window.close();
		</script>
		<%
		response.end
	else
		cnn.rollbackTrans
		%>
		<script>
			aguarde.style.display="none";
		</script>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			window.history.back();
		</script>
		<%
	end if
%>