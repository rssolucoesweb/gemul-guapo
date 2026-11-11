<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/09/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Consulta de Curso 
-->
<%	
	if strSubmitFuncao = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if
	sql = " SELECT DISTINCT D.CodFuncao, F.desc_funcao " 
	sql = sql & "   FROM SRH_DIRETRIZES D " 
	sql = sql & "   INNER JOIN SRH_FUNCAOCOLABORADOR F ON F.cod_funcao = D.CodFuncao " 
	'sql = sql & "   LEFT JOIN SRH_TURNO TU ON TU.cod_Turno = D.Cod_turno " 
	sql = sql & "   LEFT JOIN SCA_DISCIPLINA DI ON DI.Cod_Disciplina = D.Cod_Disciplina " 
	sql = sql & "   LEFT JOIN SCA_CURSO CU ON CU.Cod_Curso = D.Cod_Curso " 
	sql = sql & "   INNER JOIN SEG_EMPRESA E ON E.CODIGO = D.Cod_Empresa " 
	sql = sql & "   LEFT JOIN SEG_GRUPO GR ON GR.CODIGO = E.COD_GRUPO " 
	sql = sql & "   WHERE GR.Codigo = " & Session("CodGrupo") 
	sql = sql & " 	AND D.Ano_Letivo = " & strAnoLetivo
	sql = sql & "	AND D.Semestre = " & intSemestre 
	sql = sql & "   AND F.Tipo_Funcao = 'FUNCIONARIO' "  
	sql = sql & "   AND F.Modular = 'S' "  
	sql = sql & "   AND ((SELECT ISNULL(SUM(D1.VagasOferecidas),'0') "   
	sql = sql & "   		FROM SRH_DIRETRIZES D1 "  
	sql = sql & "   		INNER JOIN SEG_EMPRESA E1 ON E1.CODIGO = D1.Cod_Empresa "  
	sql = sql & "   		INNER JOIN SEG_GRUPO GR1 ON GR1.CODIGO = E1.COD_GRUPO " 
	sql = sql & "   		WHERE GR1.Codigo = " & Session("CodGrupo")
	sql = sql & " 			AND D1.Ano_Letivo = " & strAnoLetivo
	sql = sql & "			AND D1.Semestre = " & intSemestre & " )"
	sql = sql & "   	- " 
	sql = sql & "   	(SELECT ISNULL(SUM(M2.Total_Aulas),'0') "   
	sql = sql & "   		FROM SRH_MODULACAO_DISCIPLINAR_DOCENTE M2 "  
	sql = sql & "   		INNER JOIN SEG_EMPRESA E2 ON E2.CODIGO = M2.Cod_Empresa  " 
	sql = sql & "   		INNER JOIN SEG_GRUPO GR2 ON GR2.CODIGO = E2.COD_GRUPO " 
	sql = sql & "   		WHERE GR2.Codigo = " & Session("CodGrupo")  
	sql = sql & "   		AND M2.Ano_Letivo = " & strAnoLetivo
	sql = sql & "   		AND M2.Semestre = " & intSemestre
	sql = sql & "   		AND M2.STATUS = 'A' "
	sql = sql & "   		AND M2.tipoModulacao = 'FUNCIONARIO')) > 0 "	
	sql = sql & " 	ORDER BY F.desc_funcao"
		
	RS.OPEN SQL, CNN
%>
<select name="cmbFuncao" id="cmbFuncao" style="width:250pt" class="form-control" <%=strFuncao%> >
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodFuncao) = trim(rs("CodFuncao")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("CodFuncao")& " " & strSelecionado &">" &  rs("desc_funcao") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>