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
	
		if intCodFuncao = "" then intCodFuncao = "0"
		
		' Gera o saldo de vagas nas unidades
		sql = " SELECT distinct D.Cod_Empresa, E.RAZAOSOCIAL, GR.codigo AS CodGrupo " 
		sql = sql & "   FROM SRH_DIRETRIZES D " 
		sql = sql & "   INNER JOIN SRH_FUNCAOCOLABORADOR F ON F.cod_funcao = D.CodFuncao " 
		sql = sql & "   LEFT JOIN SRH_TURNO TU ON TU.cod_Turno = D.Cod_turno " 
		sql = sql & "   LEFT JOIN SCA_DISCIPLINA DI ON DI.Cod_Disciplina = D.Cod_Disciplina " 
		sql = sql & "   LEFT JOIN SCA_CURSO CU ON CU.Cod_Curso = D.Cod_Curso " 
		sql = sql & "   INNER JOIN SEG_EMPRESA E ON E.CODIGO = D.Cod_Empresa " 
		sql = sql & "   LEFT JOIN SEG_GRUPO GR ON GR.CODIGO = E.COD_GRUPO " 
		sql = sql & "   WHERE GR.Codigo = " & Session("CodGrupo")
		sql = sql & " 	AND D.Ano_Letivo = " & strAnoLetivo
		sql = sql & "	AND D.Semestre = " & intSemestre 
		sql = sql & " 	AND D.CodFuncao = " & intCodFuncao 
		sql = sql & "   AND F.Tipo_Funcao = 'FUNCIONARIO' "  
		sql = sql & "   AND F.Modular = 'S' "  
		sql = sql & "   AND"
		sql = sql & "   	("
		sql = sql & "   		("
		sql = sql & "   		SELECT ISNULL(SUM(D1.VagasOferecidas),'0') "
		sql = sql & "   		FROM SRH_DIRETRIZES D1 "
		sql = sql & "   		INNER JOIN SEG_EMPRESA E1 ON E1.CODIGO = D1.Cod_Empresa "
		sql = sql & "   		INNER JOIN SEG_GRUPO GR1 ON GR1.CODIGO = E1.COD_GRUPO "
		sql = sql & "   		WHERE GR1.Codigo = GR.Codigo "
		sql = sql & "   		AND D1.Ano_Letivo = D.Ano_Letivo	"
		sql = sql & "   		AND D1.Semestre = D.Semestre	"
		sql = sql & "   		AND D1.Cod_empresa = D.Cod_Empresa	"
		sql = sql & "   		AND D1.CodFuncao = D.CodFuncao "
		sql = sql & "   		) "
		sql = sql & "   		- "
		sql = sql & "   		( "
		sql = sql & "   		SELECT ISNULL(SUM(M2.Total_Aulas),'0') "
		sql = sql & "   		FROM SRH_MODULACAO_DISCIPLINAR_DOCENTE M2 "
		sql = sql & "   		INNER JOIN SEG_EMPRESA E2 ON E2.CODIGO = M2.Cod_Empresa "
		sql = sql & "   		INNER JOIN SEG_GRUPO GR2 ON GR2.CODIGO = E2.COD_GRUPO "
		sql = sql & "   		WHERE GR2.Codigo = GR.Codigo"
		sql = sql & "   		AND M2.Cod_Funcao = D.CodFuncao "
		sql = sql & "   		AND M2.Ano_Letivo = D.Ano_Letivo "
		sql = sql & "   		AND M2.Semestre = D.Semestre"
		sql = sql & "   		AND M2.Cod_empresa = D.Cod_Empresa "
		sql = sql & "   		AND M2.tipoModulacao = 'FUNCIONARIO'"
		sql = sql & "   		AND M2.Status = 'A'"
		sql = sql & "   		)"
		sql = sql & "   	)>0"
		sql = sql & " 	ORDER BY E.RAZAOSOCIAL"
		RS.OPEN SQL, CNN
%>
<select name="cmbEmpresaGrupo" id="cmbEmpresaGrupo" style="width:250pt" class="combo" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodEmpresaGrupo) = trim(rs("Cod_Empresa")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("Cod_Empresa")& " " & strSelecionado &">" &  rs("RAZAOSOCIAL") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>