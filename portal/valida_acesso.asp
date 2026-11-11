<!--#include file="includes/inc_cnn_gemulEAD.asp"-->
<!--#include file="includes/inc_log_ead.asp"-->
<%
strUsuario 				=  Trim(Request.Form("txtLogin"))
strCodSeguranca 		=  Trim(Request.Form("txtCodSeguranca"))
strSenha 				=  Trim(Request.Form("txtSenha"))

response.Cookies("usuarioLoginGemulEAD") = strUsuario
response.Cookies("usuarioLoginGemulEAD").Expires = date + 10

response.Cookies("CodSegurancaLoginGemulEAD") = strCodSeguranca
response.Cookies("CodSegurancaLoginGemulEAD").Expires = date + 10

strUsuario 			= REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(strUsuario,"'",""),"-",""),"/",""),"*",""),"?",""),")",""),"(","")
strSenha 			= REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(strSenha,"'",""),"-",""),"/",""),"*",""),"?",""),")",""),"(","")
strCodSeguranca		= trim(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(strCodSeguranca,"'",""),"-",""),"/",""),"*",""),"?",""),")",""),"(",""))

if not isnumeric(strCodSeguranca) then strCodSeguranca = 0

' Testando o login de aluno
sql = " SELECT MATRICULA, CODIGO, SENHA" 
sql = sql & " FROM SCA_ALUNO " 
sql = sql & " Where CODIGO = " & strCodSeguranca
RsAux.Open SQL, cnn
if not  RsAux.EOF then

	'Existe senha
	if trim(RsAux("CODIGO")) <> trim(strCodSeguranca) then
		Session("PerfilUsuario")  	= ""
		Session("CodEmpresaAluno") 	= ""
		%>
		<script>
		  alert("Codigo incorreto!");
		  window.location = 'login.asp';
		</script>
		<%
		RsAux.close
		response.end()
	else
		
		strSenha		= right(strSenha,4) & "-" & mid(strSenha,3,2) & "-" & left(strSenha,2) 
		if len(strSenha) <> 10 then strSenha = "" 
		if IsDate(strSenha) = false then strSenha = "" 
		RsAux.close
		
		' Testando o login de aluno
		sql = "SELECT a.MATRICULA, a.CODIGO, at.COD_EMPRESA, a.NOMEALUNO,t.NomeTurma,t.TurmaAluno,"
		sql = sql & " case"
		sql = sql & " 	when t.TurmaAluno is null then t.NomeTurma"
		sql = sql & " 	else t.TurmaAluno"
		sql = sql & " end as Turma, tu.desc_turno as turno, at.COD_TURMA, e.razaosocial as empresa, p.descricao as periodo, p.cod_periodo, c.descricao as curso, e.COD_GRUPO, e.CodTipoEmpresa"
		sql = sql & " FROM SCA_ALUNO a "
		sql = sql & " inner join SCA_ALUNO_TURMA at on at.COD_ALUNO = a.codigo and at.SITUACAO = 'A'"
		sql = sql & " inner join SCA_TURMA t on t.cod_turma = at.cod_turma "
		sql = sql & " inner join SEG_EMPRESA e on e.codigo = (select top 1 CS.COD_EMPRESA"
		sql = sql & " from SCA_CONTROLE_SITUACAO_ALUNO CS"
		sql = sql & " inner JOIN SCA_SITUACAOALUNO SS ON SS.Cod_SituacaoAluno = CS.COD_SITUACAOALUNO "
		sql = sql & " where CS.COD_ALUNO = " & strCodSeguranca
		sql = sql & " and CS.ANO_LETIVO = " & year(date)
		sql = sql & " order by cs.codigo desc"
		sql = sql & " )"
		sql = sql & " inner join SCA_periodo p on p.cod_periodo = t.cod_periodo "
		sql = sql & " inner join SCA_curso c on p.cod_curso = c.cod_curso "
		sql = sql & " inner join SCA_Turno tu on tu.cod_turno = t.cod_turno" 
		sql = sql & " Where at.ano_letivo = " & year(date) 
		sql = sql & " And CONVERT(VARCHAR(20),a.CODIGO) = '" & strCodSeguranca & "'"
		sql = sql & " And CONVERT(VARCHAR(20),a.MATRICULA) = '" & trim(strUsuario) & "'"
		sql = sql & " And a.DATANASCIMENTO = '" & trim(strSenha) & "' order by at.codigo desc"
		'response.write sql
		'response.end
		RsAux.Open SQL, cnn
		if not  RsAux.EOF then
			' Permitindo acesso ao aluno
			Session("PerfilUsuario")  	= "31"
			Session("CodEmpresaAluno_GemulEad") 	= trim(RsAux("COD_EMPRESA"))
			Session("CodEmpresaGrupo_GemulEad") 	= trim(RsAux("COD_GRUPO"))
			Session("EmpresaAluno_GemulEad") 		= REPLACE(REPLACE(trim(RsAux("empresa")),"ESCOLA","E"),"MUNICIPAL","M")
			Session("LoginAluno_GemulEad") 			= strUsuario
			Session("CodSeguranca_GemulEad") 		= trim(strCodSeguranca)
			Session("CodAluno_GemulEad") 			= trim(RsAux("CODIGO"))
			Session("NomeAluno_GemulEad") 			= trim(RsAux("NOMEALUNO"))
			
			vetNome 							= split(trim(ucase(Session("NomeAluno_GemulEad")))," ")
			intPosicaoFinal 					= ubound(vetNome)
			if cInt(intPosicaoFinal) > 0 then
				Session("NomeAluno_GemulEad")   	= vetNome(0) & " " & vetNome(intPosicaoFinal)
			else
				Session("NomeAluno_GemulEad")   	= vetNome(0)
			end if
			Session("CodTurma_GemulEad") 			= trim(RsAux("COD_TURMA"))
			Session("Turma_GemulEad") 				= trim(RsAux("turma")) & " (" & rsAux("NomeTurma") & ")"
			Session("Periodo_GemulEad") 			= trim(RsAux("periodo"))
			Session("cod_periodo_GemulEad") 			= trim(RsAux("cod_periodo"))
			Session("Curso_GemulEad") 				= replace(trim(RsAux("curso")),"AGRUPAMENTO","AGRUP")
			Session("Turno_GemulEad") 				= ucase(trim(RsAux("turno")))
			
			if left(Session("Periodo_GemulEad"),11) = "AGRUPAMENTO" or left(Session("Periodo_GemulEad"),1) = "1" or left(Session("Periodo_GemulEad"),1) = "2" or left(Session("Periodo_GemulEad"),1) = "3" or left(Session("Periodo_GemulEad"),1) = "4" or left(Session("Periodo_GemulEad"),1) = "5"  then 
				Session("TipoInterDisciplinarOuDisciplinar") = "I"
			else
				Session("TipoInterDisciplinarOuDisciplinar") = "D"
			end if
			
			if trim(RsAux("CodTipoEmpresa"))="4" then
				Session("TipoInterDisciplinarOuDisciplinar") = "D"
			end if
			
			RsAux.close
			
			strImgAlunoSemFoto = "/app/img/aluno-sem-foto.jpg"

			SQL="SELECT BASE64 FROM SCA_ALUNO_FOTO WHERE COD_ALUNO=" & Session("CodAluno_GemulEad")
			rsAux.OPEN SQL, cnn
			IF rsAux.EOF = FALSE THEN
				session("strFotoAluno") = rsAux("BASE64")
			END IF
			rsAux.CLOSE

			if session("strFotoAluno") = "" OR ISNULL(session("strFotoAluno")) then session("strFotoAluno") = strImgAlunoSemFoto
			
			
			GravarLogEaD "Acesso ao AVAP",0,0,0,0
			%>
			<script>
				window.location = "painel.asp";
			</script>
			<%
		else
			%>
			<script>
			  alert("Senha incorreta!");
			  window.location = 'login.asp';
			</script>
			<%
			RsAux.close
			response.end()
		end if
	end if

else
	RsAux.close
	'Não achou o usuário 
	Session("PerfilUsuario")  	= ""
	%>
		<script>
			alert("Cod. Seguranca invalido, verifique!");
			window.location = 'login.asp';
		</script>
	<%
	response.end
end if	
%>