<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_log.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<%
	cnn.begintrans

	acao 				= Trim(Request.QueryString("acao"))
	strCodEmpresaTransferencia			= Session("CodEmpresa")
	strSemestre 		= Trim(Request("cmbSemestre"))
	strAnoLetivoAtual	= session("strAnoLetivo")
	strSemestreAtual	= session("strSemestre")
	
	cod_aluno			 = request("cod_aluno")
	ano_letivo			 = request("ano_letivo")
	cod_empresa			 = request("cod_empresa")
	
	if cod_empresa = "" then cod_empresa = "111"
	if ano_letivo = "" then ano_letivo = year(date)
	
	sql = "SET NoCount ON insert into SCA_ALUNO_TRANSFERENCIA ("
	sql = sql & " COD_EMPRESA"
	sql = sql & ",COD_ALUNO"
	sql = sql & ",ANO_LETIVO"
	sql = sql & ",ANO_LETIVO_TRANSFERENCIA"
	sql = sql & ",SEMESTRE_TRANSFERENCIA"	
	sql = sql & ",COD_EMPRESA_TRANSFERENCIA"	
	sql = sql & ",USUARIO_INCL"
	sql = sql & ",DATA_HORA_INCL"
	sql = sql & ",EFETIVADO"
	sql = sql & ",USUARIO_EFETIVACAO"
	sql = sql & ",DATA_HORA_EFETIVACAO) VALUES ("
	sql = sql & "" & cod_empresa & "," 
	sql = sql & "" & cod_aluno & "," 
	sql = sql & "" & ano_letivo & "," 
	sql = sql & "" & strAnoLetivoAtual & "," 
	sql = sql & "" & strSemestreAtual & "," 
	sql = sql & "" & strCodEmpresaTransferencia & ","
	sql = sql & "'" & session("usuarioWeb") & "',"
	sql = sql & "getdate()," 
	sql = sql & "'I'," 
	sql = sql & "'" & session("usuarioWeb") & "',"
	sql = sql & "getdate());SELECT @@IDENTITY "
	'response.write sql & "<hr>"		
	Set rs = cnn.Execute(sql)
	cod_aluno_transferencia = rs(0)
	rs.close
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("Foi iniciado o processo de transferência do aluno! \n\nVocê será direcionado para a ficha para concluir a tranferência. Não saia da ficha sem preencher todas as informações e finalize clicando em 'Alterar'.");
			window.location="<%=session("urlRaizLocalSistema")%>/app/sca_aluno.asp?receberPorTransferencia=S&cod_aluno_transferencia=<%=cod_aluno_transferencia%>&txtCodEmpresaTransf=<%=session("codEmpresa")%>&txtCodAlunoTransf=<%=cod_aluno%>&txtAnoLetivoTransf=<%=ano_letivo%>";
		</script>
		<%
		response.end
	else
		cnn.rollbackTrans
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			alert('<%=replace(err.description,"'","")%>');
			window.history.back();
		</script>
		<%
	end if
%>