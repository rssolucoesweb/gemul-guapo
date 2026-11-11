<%  
response.Charset = "ISO-8859-1" 
response.ContentType = "text/html" 

response.Expires = 60
response.Expiresabsolute = Now() - 1
response.AddHeader "pragma","no-cache"
response.AddHeader "cache-control","private"
response.CacheControl = "no-cache"

Server.ScriptTimeOut = 5000
%> 
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<%
acao			= Trim(Request("acao"))
strAnoLetivo			= Trim(Request.Form("txtAnoLetivo"))
strSemestre				= Trim(Request.Form("cmbSemestre"))
strAnoLetivoReplicacao	= Trim(Request.Form("txtAnoLetivoReplicacao"))
intCodEmpresa			= Trim(Request.Form("cmbEmpresaGrupo"))
id						= Trim(Request("id"))

if acao = "I" then
	sql = "exec SP_SCA_PromoveTurmaGrade " & session("codGrupo") & "," & intCodEmpresa & ",''," & strAnoLetivo & "," & strAnoLetivoReplicacao & "," & strSemestre & ",0,'" & session("usuarioWeb") & "'"
	'response.write sql
	'response.end
	rs.open sql, cnn
	if not RS.EOF then
		retorno = rs("retorno")
		rs.close
		if retorno = "FINALIZADO" then
		
			sql = "EXEC guapo.dbo.SP_MAT_AtualizaTurmaVagaMatricula " & strAnoLetivoReplicacao & ", 1"
			cnn.execute sql
			
			%>
			<script>
				alert("Processamento finalizado com sucesso!");
				window.location='promoverTurmaGrade_cad.asp';
			</script>
			<%
		elseif retorno = "NAO_FINALIZADO" then
			%>
			<script>
				alert("Processamento NÃO FOI FINALIZADO, verifique se esse procedimento já foi executado anteriomente!");
				window.location='promoverTurmaGrade_cad.asp';
			</script>
			<%
		else
			%>
			<script>
				alert("ATENÇÃO: \n\nO processamento não foi finalizado. Verifique com o suporte do GEMUL!");
				window.location='promoverTurmaGrade_cad.asp';
			</script>
			<%
			response.end
		end if
	else
		%>
		<script>
			alert("ATENÇÃO: \n\nO processamento não foi finalizado. Verifique com o suporte do GEMUL!");
			window.location='promoverTurmaGrade_cad.asp';
		</script>
		<%
		rs.close
	end if 
	rs.close
elseif acao = "E" then
	sql = "update MAT_aut_grade_turma_historico set situacao = 'C' where id_aut_grade_turma_historico=" & id
	cnn.execute sql
	sql = "delete SCA_turma where Cod_Turma in (select cod_turma_nova from [dbo].[MAT_aut_turma_historico] where id_aut_grade_turma_historico=" & id & ")"
	cnn.execute sql
	sql = "delete SCA_GRADECURRICULARDISCIPLINA where Cod_GradeCurricular in (select Cod_GradeCurricular_nova from [dbo].[MAT_aut_grade_historico] where id_aut_grade_turma_historico=" & id & ")"
	cnn.execute sql
	sql = "delete SCA_GRADECURRICULAR where Cod_GradeCurricular in (select Cod_GradeCurricular_nova from [dbo].[MAT_aut_grade_historico] where id_aut_grade_turma_historico=" & id & ")"
	cnn.execute sql
	
	%>
	<script>
		alert("O processamento foi CANCELADO com sucesso, todas as grade e turmas foram removidas!");
		window.location='promoverTurmaGrade_cad.asp';
	</script>
	<%
end if
%>