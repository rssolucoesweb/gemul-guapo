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
	sql = sql & " WHERE S.DESCRICAO NOT LIKE 'EJA%'"
	IF strCurso ="ENSINO_FUNDAMENTAL" then
		sql = sql & " and S.DESCRICAO in ('ANOS INICIAIS FUNDAMENTAL','ANOS FINAIS FUNDAMENTAL') "
	else
		sql = sql & " and replace(S.DESCRICAO,' ','_') = '" & strCurso & "' "
	end if
	sql = sql & " ORDER BY P.DESCRICAO"	
	RS.OPEN SQL, CNN
%>
<select name="cmbPeriodo" id="cmbPeriodo" class="form-control">
	<option value="0" >Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			selecionado = "  "
			if trim(replace(strPeriodo,"_"," ")) = trim(rs("periodo")) then
				selecionado = " selected "
			end if
			response.write "<option " & selecionado & " value=" & rs("cod_periodo")& " >" & rs("periodo") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>