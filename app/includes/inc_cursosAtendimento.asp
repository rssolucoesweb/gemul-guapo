<%
	'Guapó: códigos do curso/período de AEE e ATC (em Anápolis são fixos 4/15 e 5/16).
	'Em Guapó o curso 4 é EJA; AEE e ATC são achados pela sigla do curso: AE e AT.
	'Script do banco: banco/scripts/2026-11-17_turma_aee_atc.sql
	if trim(Session("intCodCursoAEE") & "") = "" or trim(Session("intCodCursoAEE") & "") = "0" or trim(Session("intCodCursoATC") & "") = "0" then
		Session("intCodCursoAEE") = "0" : Session("intCodPeriodoAEE") = "0"
		Session("intCodCursoATC") = "0" : Session("intCodPeriodoATC") = "0"
		set rsCursoAtend = Server.CreateObject("ADODB.Recordset")
		rsCursoAtend.open "SELECT c.Sigla, c.Cod_curso, MIN(p.Cod_Periodo) AS Cod_Periodo FROM SCA_CURSO c LEFT JOIN SCA_PERIODO p ON p.Cod_Curso = c.Cod_curso WHERE c.Sigla IN ('AE','AT') GROUP BY c.Sigla, c.Cod_curso", cnn
		while not rsCursoAtend.eof
			if trim(rsCursoAtend("Sigla")) = "AE" then
				Session("intCodCursoAEE") = cstr(rsCursoAtend("Cod_curso")) : Session("intCodPeriodoAEE") = cstr(rsCursoAtend("Cod_Periodo") & "")
			else
				Session("intCodCursoATC") = cstr(rsCursoAtend("Cod_curso")) : Session("intCodPeriodoATC") = cstr(rsCursoAtend("Cod_Periodo") & "")
			end if
			rsCursoAtend.movenext
		wend
		rsCursoAtend.close
		set rsCursoAtend = nothing
	end if
	intCodCursoAEE   = Session("intCodCursoAEE")
	intCodPeriodoAEE = Session("intCodPeriodoAEE")
	intCodCursoATC   = Session("intCodCursoATC")
	intCodPeriodoATC = Session("intCodPeriodoATC")
	if intCodPeriodoAEE = "" then intCodPeriodoAEE = "0"
	if intCodPeriodoATC = "" then intCodPeriodoATC = "0"
%>
