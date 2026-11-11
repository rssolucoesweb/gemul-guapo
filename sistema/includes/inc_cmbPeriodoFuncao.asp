<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 23/03/2010
	::	Desenvolvedores...: Sergio Borges - sergio@rsslucoesweb.com.br
	::	Objetivo Pagina...: Preenche combo funcao
-->
<%	
	sql = "select distinct Periodo "
	sql = sql & " from SRH_DIRETRIZES_PADRAO"
	sql = sql & " WHERE Cod_grupo = " & Session("CodGrupo")	
	sql = sql & " Order by Periodo	"
	RS.OPEN SQL, CNN
%>
<select name="cmbPeriodoFuncao" id="cmbPeriodoFuncao" style="width:200pt" class="form-control">
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(strPeriodoFuncao) = trim(rs("Periodo")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("Periodo")& " " & strSelecionado &">" & rs("Periodo") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>