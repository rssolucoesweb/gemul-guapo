<%@LANGUAGE="VBSCRIPT"%>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<%
'On Error Resume Next

	dim disciplina, ch, situacao, media, omitir, codHistoricoEscolar

	disciplina = Request.Form("disciplina")
	ch = Request.Form("ch")
	situacao = Request.Form("situacao")
	media = replace(Request.Form("media"),",",".")
	omitir = Request.Form("omitir")
	codHistoricoEscolar = Request.Form("codHistoricoEscolar")
	codCurso = Request.Form("codCurso")
	codPeriodo = Request.Form("codPeriodo")
	anoHistorico = Request.Form("anoHistorico")
	semestreHistorico = Request.Form("semestreHistorico")

	if not isnumeric(disciplina) then
		Response.Write("ERRO: Disciplina inválida")
		Response.End
	end if

	incluir = "S"
	sql = "select codigo from SCA_HISTORICO_ESCOLAR_DISCIPLINA where cod_historico_escolar=" & codHistoricoEscolar
	sql = sql & " and ano_letivo = " & anoHistorico
	sql = sql & " and semestre = " & semestreHistorico
	sql = sql & " and cod_disciplina = " & disciplina
	rs.open sql, cnn
	if not rs.eof then
		incluir = "N"
		codHistoricoEscolarDisciplina = rs("codigo")
	end if
	rs.close

	if incluir = "S" then
	
		SQL = "SET NoCount ON INSERT INTO SCA_HISTORICO_ESCOLAR_DISCIPLINA (cod_historico_escolar, ano_letivo, cod_periodo, "
		SQL = SQL & " cod_curso, semestre, cod_disciplina, "
		SQL = SQL & " media, carga_horaria, situacao, mostraNota, data_inclusao) "
		SQL = SQL & "VALUES ("

		SQL = SQL & "" & codHistoricoEscolar & ","
		SQL = SQL & "" & anoHistorico & ","
		if codCurso="999999" or codCurso="0" or codCurso="" or isnull(codCurso) then
			SQL = SQL & "null,"
			SQL = SQL & "null,"
		else
			SQL = SQL & "" & codPeriodo & ","
			SQL = SQL & "" & codCurso & ","
		end if
		SQL = SQL & "" & semestreHistorico & ","
		SQL = SQL & "" & disciplina & ","
		if media = "" then
			SQL = SQL & " null,"
		else
			SQL = SQL & "'" & media & "',"
		end if
		if ch = "" then
			SQL = SQL & "null,"
		else
			SQL = SQL & "" & ch & ","
		end if
		SQL = SQL & "'" & situacao & "','" & omitir & "',getdate());SELECT @@IDENTITY "
		
		Set rs = cnn.Execute(sql)
		codHistoricoEscolarDisciplina = rs(0)
		rs.close
	else
		SQL = "update SCA_HISTORICO_ESCOLAR_DISCIPLINA set "
		if media = "" then
			SQL = SQL & "media = null,"
		else
			SQL = SQL & "media = '" & media & "',"
		end if
		if ch = "" then
			SQL = SQL & "carga_horaria = null,"
		else
			SQL = SQL & "carga_horaria = " & ch & ","
		end if
		SQL = SQL & " situacao = '" & situacao & "',mostraNota = '" & omitir & "'"
		SQL = SQL & " where codigo = " & codHistoricoEscolarDisciplina
		cnn.execute SQL
	end if

	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		Response.Write codHistoricoEscolarDisciplina
	else
		Response.Write("ERRO: " + err.number)
	end if



%>