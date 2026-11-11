<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="JSON_2.0.4.asp"-->
<!--#include file="JSON_UTIL_0.1.1.asp"-->
<%

	'on error resume next
	
    strTipoAcao	= trim(Request("tipoAcao"))
    strFiltro   = request("term")
    strTipoOpcao = trim(Request("strOpcaoEnvio"))
	strAnoLetivo = trim(Request("AnoLetivoAtual"))
	
	select case ucase(strTipoAcao)
        case "CARREGA_PERIODO"
            intCodCurso = trim(Request("intCodCurso"))
			sql = "SELECT Cod_Periodo as codigo, Descricao as nome"
			sql = sql & " FROM SCA_PERIODO"
			sql = sql & " where cod_curso = " & intCodCurso
			sql = sql & " Order by Sequencia"
	
        case "CARREGA_TURMA"
            intCodPeriodo = trim(Request("intCodPeriodo"))
			intCodTurno = trim(Request("intCodTurno"))
			
			sql = "SELECT Cod_turma as codigo, NomeTurma + ' - ' + TurmaAluno as nome"
			sql = sql & " FROM SCA_TURMA"
			sql = sql & " where cod_empresa = " & Session("CodEmpresa")
			sql = sql & " and anoLetivo = " &  strAnoLetivo
			if 	intCodPeriodo <> "" and intCodPeriodo <> "0" then	
				sql = sql & " and cod_periodo = " & intCodPeriodo
			end if
			if 	intCodTurno <> "" and intCodTurno <> "0" then	
				sql = sql & " and cod_turno = " & intCodTurno
			end if
			sql = sql & " and situacao = 'A'"
			sql = sql & " Order by 2"
		case "MOSTRA_VAGAS"
            intCodTurma = trim(Request("intCodTurma"))

			sql = "select '0' as codigo, isnull(capacidade,0) - isnull(VagasMatriculasUtilizadas,0) - isnull(VagasReservadas,0) as nome"
			sql = sql & " FROM SCA_TURMA"
			sql = sql & " where cod_empresa = " & Session("CodEmpresa")
			sql = sql & " and cod_turma = " &  intCodTurma
	end select
	QueryToJSON(cnn, sql).Flush

%>