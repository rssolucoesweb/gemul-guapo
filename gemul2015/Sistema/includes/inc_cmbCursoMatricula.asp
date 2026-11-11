<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 08/03/2013
	::	Desenvolvedores...: Sergio Borges - sergio@rsslucoesweb.com.br
	::	Objetivo Pagina...: Preenche combo cmbAgrupamento
-->
<%	
	
sql = " select DISTINCT"
sql = sql & " 	case"
sql = sql & " 		when S.DESCRICAO = 'ENSINO FUNDAMENTAL 2ª FASE' then 'ENSINO FUNDAMENTAL'"
sql = sql & " 	ELSE S.DESCRICAO "
sql = sql & " 	END AS CURSO,"
sql = sql & " 	case"
sql = sql & " 		when S.DESCRICAO = 'ENSINO FUNDAMENTAL 2ª FASE' then  'ENSINO_FUNDAMENTAL'"
sql = sql & " 	ELSE REPLACE(S.DESCRICAO,' ','_') "
sql = sql & " 	END AS cod_CURSO"
sql = sql & " from [dbo].[sca_periodo] P"
sql = sql & " INNER JOIN SCA_CURSO S ON S.COD_CURSO = P.COD_CURSO"
sql = sql & " WHERE S.DESCRICAO in ('ENSINO FUNDAMENTAL','ENSINO FUNDAMENTAL 2ª FASE','EDUCAÇÃO INFANTIL')"
'sql = sql & " WHERE S.DESCRICAO in ('EDUCAÇÃO INFANTIL')"
sql = sql & " ORDER BY curso"
RS.OPEN SQL, CNN
%><select name="cmbCurso" id="cmbCurso" style="width:150pt" class="combo" onchange="submit()">
	<option value="0" >Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			selecionado = "  "
			if trim(strCurso) = trim(rs("cod_curso")) then
				selecionado = " selected "
			end if
			response.write "<option " & selecionado & " value=" & rs("cod_curso")& " >" & trim(rs("curso")) & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>