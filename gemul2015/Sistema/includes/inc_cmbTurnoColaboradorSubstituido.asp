<%
sql = " select DISTINCT t.DESC_TURNO " 
sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE MD " 
sql = sql & " inner join SRH_TURNO t on t.COD_TURNO = md.COD_TURNO "
sql = sql & " where MD.Cod_Colaborador = " & intCodColaboradorSubstituido
sql = sql & " and MD.ano_letivo = " & strAnoLetivo
sql = sql & " and MD.Status='A' "
sql = sql & " and T.Desc_Turno = 'INTEGRAL' "
RS.OPEN SQL, CNN
IF RS.EOF = FALSE THEN
	SubstituidoIntegral = "SIM"
else
	SubstituidoIntegral = "NAO"
END IF
rs.close

if SubstituidoIntegral = "NAO" then
	sql = " select DISTINCT t.COD_TURNO, t.DESC_TURNO, t.TURNO_SIGLA " 
	sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE MD " 
	sql = sql & " inner join SRH_TURNO t on t.COD_TURNO = md.COD_TURNO "
	sql = sql & " where MD.Cod_Colaborador = " & intCodColaboradorSubstituido
	sql = sql & " and MD.ano_letivo = " & strAnoLetivo
	sql = sql & " and MD.Status='A' "
else	
	sql = " SELECT COD_TURNO, DESC_TURNO, TURNO_SIGLA " 
	sql = sql & " FROM SRH_TURNO " 
	sql = sql & " WHERE COD_GRUPO = " & session("codGrupo")
	sql = sql & " AND DESC_TURNO <> 'INTEGRAL' "
end if	
RS.OPEN SQL, CNN
%>
<select name="cmbTurnoColaboradorSubstituido" id="cmbTurnoColaboradorSubstituido" style="width:130pt" class="combo" onchange='submit()'>
<option  value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof
			if trim(intCodTurnoColaboradorSubstituido) = trim(rs("COD_TURNO")) then
				strSelecionado = " selected"
				strSiglaTurno = trim(rs("TURNO_SIGLA")) 
			else
				strSelecionado = ""
			end if
			response.write "<option value=" & rs("COD_TURNO")& " " & strSelecionado &">" & rs("DESC_TURNO") & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>