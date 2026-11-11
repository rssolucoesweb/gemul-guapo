<!--#include file="inc_CompartilharDadosCadastrais.asp"-->
<%	
if intCodTurnoRH = "0" or  intCodTurnoRH = "" then
%>
    <select name="cmbProfessor" id="cmbProfessor" class="form-control" <%=strFuncao%> >
		<option value="0">Selecione...</option>
    </select>        
<%
else

	if strExecutarSubmitProfessor = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	
	'sql = " SELECT Codigo, Nome, codFuncional"
	'sql = sql & " FROM SRH_COLABORADOR"
	'if strCompartilharDados = "S" then 
	'	SQL = SQL & " WHERE CodLotacao = " & Session("CodEmpresa")
	'else	
	'	SQL = SQL & " WHERE cod_empresa=" & Session("CodEmpresa")
	'end if	
	'SQL = SQL & " AND (CodCategoria = 1 or CodCategoria = 8)"'professor
	'SQL = SQL & " AND SITUACAO = 'A'"'professor
	'sql = sql & " Order by Nome"
	
	if intCodPeriodo = "" then intCodPeriodo =0 
	if intCodTurnoRH = "" then intCodTurnoRH =0 
	if intCodDisciplinaGrade = "" then intCodDisciplinaGrade =0 
	
	sql = " Select  DISTINCT dd.Cod_Colaborador as Codigo , C.nome, C.codFuncional"
	sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE dd "
	sql = sql & " inner join SRH_COLABORADOR C on c.codigo = dd.Cod_Colaborador "
	sql = sql & " inner join SRH_DIRETRIZES D ON D.CodFuncao = dd.Cod_Funcao AND D.Cod_Periodo = DD.Cod_periodo AND D.Cod_Empresa = DD.Cod_empresa AND D.Cod_Turno = DD.Cod_Turno"
	sql = sql & " where dd.Cod_empresa = " & Session("CodEmpresa")
	sql = sql & " and dd.ano_letivo = " & strAnoLetivo
	sql = sql & " AND dd.Cod_periodo = " & intCodPeriodo
	sql = sql & " AND dd.Cod_Turno = " & intCodTurnoRH
	sql = sql & " and dd.status = 'A'"
	sql = sql & " AND dd.Cod_Modulacao_Substituicao IS NULL"
	
	sql = sql & " UNION "
	
	sql = sql & " select  DISTINCT dd.Cod_Colaborador as Codigo  , C.nome, C.codFuncional"
	sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE dd "
	sql = sql & " inner join SRH_COLABORADOR C on c.codigo = dd.Cod_Colaborador "
	sql = sql & " where dd.Cod_empresa = " & Session("CodEmpresa")
	sql = sql & " and dd.ano_letivo  = " & strAnoLetivo
	sql = sql & " AND dd.Cod_periodo = " & intCodPeriodo
	sql = sql & " AND dd.Cod_Turno  = " & intCodTurnoRH
	sql = sql & " And dd.status = 'A' "
	
	if intCodDisciplinaGrade <> 0 then
		sql = sql & " AND dd.Cod_Disciplina = " & intCodDisciplinaGrade 
	end if
	
	sql = sql & " AND dd.Cod_Modulacao_Substituicao IS NULL "
	
	sql = sql & " union select C.codigo, C.Nome, codFuncional "
	sql = sql & " from SRH_COLABORADOR C"
	sql = sql & " WHERE c.codigo = " & intCodDefictRH 'intCodDefictRH VENDA INC_CNN

	sql = sql & " Order by Nome"
	RS.OPEN SQL, CNN
%>
<select name="cmbProfessor" id="cmbProfessor" class="form-control" <%=strFuncao%> >
	<option value="0">Selecione...</option>
	<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodProfessor) = trim(rs("Codigo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codigo")& " " & strSelecionado &">" & ucase(rs("nome")) & " - " & ucase(rs("codFuncional"))  & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>
<%
end if
%>