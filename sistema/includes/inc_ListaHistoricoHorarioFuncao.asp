<%
	IF intCodFuncao <> "0" THEN
		sql = " SELECT tuA.Desc_Turno as Desc_TurnoA, h.tipo as tipoA, n.tipo as tipoN, tuN.Desc_Turno as Desc_TurnoN,  h.Hora as HoraA, h.Minuto as MinutoA, n.Hora as HoraN, n.Minuto as MinutoN, o.usuario, o.datahora"
		sql = sql & " FROM APO_Ocorrencia o"
		sql = sql & " inner join APO_PONTOHORARIO h on h.Codigo = o.cod_pontoHorario_Anterior"
		sql = sql & " inner join APO_PONTOHORARIO n on n.Codigo = o.cod_pontoHorario_novo"
		sql = sql & " inner join SRH_TURNO tuA on tuA.Cod_Turno = h.cod_turno"
		sql = sql & " inner join SRH_TURNO tuN on tuN.Cod_Turno = n.cod_turno"
		sql = sql & " WHERE o.Cod_Funcao = " & intCodFuncao
		sql = sql & " ORDER BY o.datahora DESC "
		RS.OPEN SQL, CNN
		IF NOT RS.EOF THEN
		%>
        <br />
		<table width="99%" border="0" cellspacing="0" class="tabela" cellpadding="0">
		  <tr style="cursor:hand">
			<td height="18"  align="center"  class="celula"  width="1%"><a href="javascript:mostraLinhaTr(10)">[+]</a></td>
			<td width="99%" bgcolor="#F5F5F5"  align="center"  class="celula"><strong><span class="style1">Hist&oacute;rico de Alterações </span></strong></td>
		  </tr>
		  <tr id="tr10" style="display:none">
			<td height="96" colspan="2"  class="celula">
            <br />
            <table width = "96%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
			  <tr bgcolor="#E5E5E5">
			    <td width="26%" align="center" class="celula"><strong>Data Ocorr&ecirc;ncia</strong></td>
			    <td width="28%" class="celula"><strong>Horário Anterior</strong></td>
			    <td width="28%" class="celula"><strong>Horário Novo</strong></td>
			    <td width="18%" class="celula"><strong>Alterado</strong></td>
		      </tr>
			  <%
					WHILE NOT RS.EOF
						if trim(rs("tipoA")) = "E" then
							strNomeTipoA = "Entrada"
						else
							strNomeTipoA = "Saída"
						end if
						
						horaA = rs("HoraA")
						MinutoA = rs("MinutoA")
						
						if len(rs("HoraA")) <=1 then
							horaA = "0" & rs("HoraA")
						end if
						if len(rs("MinutoA")) <=1 then
							MinutoA = "0" & rs("MinutoA")
						end if
						'------------------------------------------------
						if trim(rs("tipoN")) = "E" then
							strNomeTipoN = "Entrada"
						else
							strNomeTipoN = "Saída"
						end if
						
						horaN = rs("HoraN")
						MinutoN = rs("MinutoN")
						
						if len(rs("HoraN")) <=1 then
							horaN = "0" & rs("HoraN")
						end if
						if len(rs("MinutoN")) <=1 then
							MinutoN = "0" & rs("MinutoN")
						end if
						anterior = horaA & MinutoA & strNomeTipoA 
						novo = horaN & MinutoN & strNomeTipoN 
						negritoI = ""
						negritoF = ""
						if anterior<>novo then 
							negritoI = "<strong>"
							negritoF = "</strong>"
						end if
						%>
			  <tr bgcolor="#FFFFCC">
			    <td align="center" class="celula"><%=RS("datahora")%>&nbsp;</td>
			    <td class="celula"><%=negritoI%><%=horaA%>:<%=MinutoA%> - <%=rs("Desc_TurnoA")%> - <%=strNomeTipoA%><%=negritoF%></td>
			    <td class="celula"><%=negritoI%><%=horaN%>:<%=MinutoN%> - <%=rs("Desc_TurnoN")%> - <%=strNomeTipoN%><%=negritoF%></td>
			    <td class="celula"><%=RS("usuario")%>&nbsp;</td>
		      </tr>
			  <%
						RS.MOVENEXT
					WEND
				%>
		    </table></td>
		  </tr>
		</table>
<br />
		<%
		END IF
		RS.CLOSE
	END IF
%>