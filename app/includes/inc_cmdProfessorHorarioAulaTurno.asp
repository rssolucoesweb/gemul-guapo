<!--
	::	DESENVOLVIDO POR "RS SOLU��ES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 28/07/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Consulta de Colaborador - Professor
-->
<%	
	if strExecutarSubmitProfessor = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	if intCodProfessor = "" then intCodProfessor = 0
	if intCodTurnoRH = "" then intCodTurnoRH = 0
	
	sql = " SELECT distinct c.nome as professor, HA.Cod_Colaborador as codProfessor, c.codFuncional "
	sql = sql & " FROM SCA_HORARIO_AULA HA "
	sql = sql & " INNER JOIN SCA_HORARIO H ON H.codigo = HA.COD_HORARIO "
	sql = sql & " INNER JOIN SRH_COLABORADOR C ON C.codigo = HA.Cod_Colaborador "
	sql = sql & " INNER JOIN SRH_TURNO TU ON TU.Cod_Turno = H.CodTurno "
	sql = sql & " WHERE HA.COD_EMPRESA = " & Session("CodEmpresa")
	sql = sql & " AND HA.ANOLETIVO = " & strAnoLetivo 
	if intCodTurnoRH <> "0" then
		sql = sql & " AND tu.Cod_Turno = " & intCodTurnoRH
	end if
	if intCodProfessor <> "0" then
		sql = sql & " AND HA.Cod_Colaborador = " & intCodProfessor 
	end if
	sql = sql & " order by professor"
	rs.open sql, cnn
%>
<select name="cmbProfessor" id="cmbProfessor" class="form-control" <%=strFuncao%> >
<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodProfessor) = trim(rs("codProfessor")) then
				strSelecionado = " selected"
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("codProfessor")& " " & strSelecionado &">" & ucase(rs("professor")) & " (" & ucase(rs("codFuncional")) & ")" & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>