<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 21/09/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Consulta de CDU
-->
<%

	if intCodCDU <> "0" then 
	
		sql = "SELECT Cod_cdu, Nome_cdu, Cod_AreaConhecimento"
		sql = sql & " FROM SCB_CDU"
		SQL = SQL & " WHERE cod_empresa=" & Session("CodEmpresa")
		sql = sql & " And Cod_cdu like '%" & intCodCDU & "%'"
		sql = sql & " Order by Cod_cdu"
		RS.OPEN SQL, CNN
	%>
	<select name="cmbCDU" id="cmbCDU" style="width:190pt" class="form-control" <%=strDisabilitaCombo%>>
	<option value="0">Selecione...</option>
	<%
		IF RS.EOF = FALSE THEN
			while not rs.eof
				if trim(intCodCDU) = trim(rs("Cod_cdu")) then
					strSelecionado = " selected"
				else
					strSelecionado = ""
				end if
				response.write "<option value='" & rs("Cod_cdu")& "' " & strSelecionado &">" & rs("Cod_cdu") & " | " & rs("Nome_cdu") & "</option> "  & vbcrlf
				rs.movenext
			wend
		END IF
		rs.close
	
	%>
	</select>
	<%else
		%>
		<select name="cmbCDU" id="cmbCDU" style="width:190pt" class="form-control" <%=strDisabilitaCombo%>>
		<option value="0">Selecione...</option>
		</select>
	<%
	end if
	
	%>