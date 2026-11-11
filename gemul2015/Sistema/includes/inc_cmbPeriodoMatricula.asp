<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 08/03/2013
	::	Desenvolvedores...: Sergio Borges - sergio@rsslucoesweb.com.br
	::	Objetivo Pagina...: Preenche combo cmbAgrupamento
-->
<%	
	
	sql = " select DISTINCT"
	sql = sql & " replace(p.DESCRICAO,' ','_') as cod_periodo, "
	sql = sql & " P.DESCRICAO AS PERIODO"
	sql = sql & " from [dbo].[sca_periodo] P"
	sql = sql & " INNER JOIN SCA_CURSO S ON S.COD_CURSO = P.COD_CURSO"
	sql = sql & " WHERE S.DESCRICAO in ('ENSINO FUNDAMENTAL','ENSINO FUNDAMENTAL 2ª FASE','EDUCAÇÃO INFANTIL')"
	IF strCurso ="ENSINO_FUNDAMENTAL" then
		sql = sql & " and P.DESCRICAO in ('1º ANO','2º ANO','3º ANO','4º ANO','5º ANO','6º ANO','7º ANO','8º ANO','9º ANO') "
	else
		sql = sql & " and P.DESCRICAO LIKE '%AGRUPAMENTO%' "
	end if
	sql = sql & " ORDER BY P.DESCRICAO"	
	RS.OPEN SQL, CNN
%>
<select name="cmbPeriodo" id="cmbPeriodo" style="width:150pt" class="combo">
	<option value="0" >Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			selecionado = "  "
			if strPeriodo = rs("periodo") then
				selecionado = " selected "
			end if
			response.write "<option " & selecionado & " value=" & rs("cod_periodo")& " >" & rs("periodo") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>