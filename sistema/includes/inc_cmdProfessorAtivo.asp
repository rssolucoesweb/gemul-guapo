<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 28/07/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Consulta de Colaborador - Professor
-->

<!--#include file="../includes/inc_CompartilharDadosCadastrais.asp"-->
<%	
	if strExecutarSubmitProfessor = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	
	if Session("CodGrupo") = 2 then 
	
		sql = " SELECT Codigo, Nome, codFuncional"
		sql = sql & " FROM SRH_COLABORADOR"
		if strCompartilharDados = "S" then 
			SQL = SQL & " WHERE CodLotacao = " & Session("CodEmpresa")
		else	
			SQL = SQL & " WHERE cod_empresa=" & Session("CodEmpresa")
		end if	
		SQL = SQL & " AND (CodCategoria = 1 or CodCategoria = 8)"'professor
		SQL = SQL & " AND SITUACAO = 'A'"'professor
		sql = sql & " Order by Nome"
		RS.OPEN SQL, CNN
	
	else
		
		if intCodPeriodo = "" then intCodPeriodo =0 
		if intCodTurnoRH = "" then intCodTurnoRH =0 
		if intCodDisciplinaGrade = "" then intCodDisciplinaGrade =0 
		
		sql = " Select  DISTINCT dd.Cod_Colaborador as Codigo , C.nome, C.codFuncional"
		sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE dd "
		sql = sql & " inner join SRH_COLABORADOR C on c.codigo = dd.Cod_Colaborador "
		sql = sql & " inner join SRH_TURMA_MODULACAO_FUNCAO TM ON TM.Cod_Funcao = dd.Cod_Funcao"
		sql = sql & " where dd.Cod_empresa = " & Session("CodEmpresa")
		sql = sql & " and dd.ano_letivo = " & strAnoLetivo
		sql = sql & " AND dd.Cod_periodo = " & intCodPeriodo
		sql = sql & " AND dd.Cod_Turno = " & intCodTurnoRH
		sql = sql & " and dd.status = 'A'"
		sql = sql & " AND dd.Cod_Substituicao IS NULL"
		
		sql = sql & " UNION "
		
		sql = sql & " select  DISTINCT dd.Cod_Colaborador as Codigo  , C.nome, C.codFuncional"
		sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE dd "
		sql = sql & " inner join SRH_COLABORADOR C on c.codigo = dd.Cod_Colaborador "
		sql = sql & " inner join SCA_GRADECURRICULARDISCIPLINA G ON G.Cod_Funcao  = dd.Cod_Funcao"
		sql = sql & " where dd.Cod_empresa = " & Session("CodEmpresa")
		sql = sql & " and dd.ano_letivo  = " & strAnoLetivo
		sql = sql & " AND dd.Cod_periodo = " & intCodPeriodo
		sql = sql & " AND dd.Cod_Turno  = " & intCodTurnoRH
		sql = sql & " And dd.status = 'A' "
		
		if intCodDisciplinaGrade <> 0 then
			sql = sql & " AND dd.Cod_Disciplina = " & intCodDisciplinaGrade 
		end if
		
		sql = sql & " AND dd.Cod_Substituicao IS NULL order by C.nome"

		RS.OPEN SQL, CNN
	
	end if
%>
<select name="cmbProfessor" id="cmbProfessor" style="width:230pt" class="form-control" <%=strFuncao%> >
	<option value="0">Deficit...</option>
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