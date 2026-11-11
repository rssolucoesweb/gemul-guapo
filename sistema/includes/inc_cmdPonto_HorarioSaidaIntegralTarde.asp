<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 29/07/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Preenche combo horario
-->
<%	
	if strExecutarSubmitPontoHorario = "" then
		strFuncao = ""
	else
		strFuncao = "onchange='submit()'"
	end if

	sql = "SELECT PH.Codigo, PH.Tipo, PH.Hora, PH.Minuto, PH.Segundo, PH.Situacao, TU.Desc_Turno "
	sql = sql & " FROM APO_PONTOHORARIO PH"
	sql = sql & " INNER JOIN SRH_TURNO TU ON TU.COD_TURNO = PH.COD_TURNO "
	sql = sql & " WHERE PH.Cod_Grupo=" & Session("CodGrupo")
	sql = sql & " AND PH.Tipo = 'S' "
	sql = sql & " AND SUBSTRING(TU.Desc_Turno,1,1) = 'i' "
	sql = sql & " ORDER BY 	TU.Desc_Turno, PH.Tipo, PH.Hora, PH.Minuto"
	RS.OPEN SQL, CNN
%>
<select name="cmbPontoHorarioEntradaIntegralTarde" id="cmbPontoHorarioEntradaIntegralTarde" style="width:200pt"  class="form-control" <%=strFuncao%>>
	<option value="0">Selecione...</option>
<%
	IF RS.EOF = FALSE THEN
		while not rs.eof

			if trim(rs("tipo")) = "E" then
				strNomeTipo = "Entrada"
			else
				strNomeTipo = "Saída"
			end if
			if trim(intPontoHorarioEntradaIntegralTarde) = trim(rs("codigo")) then
				strSelecionado          = " selected"
			else
				strSelecionado = ""
			end if
			hora = rs("Hora")
			Minuto = rs("Minuto")
			Segundo = rs("Segundo")
			
			if len(rs("Hora")) <=1 then
				hora = "0" & rs("Hora")
			end if
			if len(rs("Minuto")) <=1 then
				Minuto = "0" & rs("Minuto")
			end if
			if len(rs("Segundo")) <=1 then
				Segundo = "0" & rs("Segundo")
			end if
			
			response.write "<option value=" & rs("codigo")& " " & strSelecionado &">" & hora & ":" & Minuto & ":" & Segundo  & " - " & rs("Desc_Turno") & " - " & strNomeTipo  & "</option> "  & vbcrlf
			rs.movenext
		wend
	END IF
	rs.close
%>
</select>