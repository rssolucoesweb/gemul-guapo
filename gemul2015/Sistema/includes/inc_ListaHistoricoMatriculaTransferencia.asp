		<table width="99%" border="0" cellspacing="0" class="tabela" cellpadding="0">
		  <tr bgcolor="#FFFFCC">
			<td height="18"  align="center"  class="celula"  width="3%"><a href="javascript:mostraLinhaOcorr(10)">[ + ]</a></td>
			<td width="97%"  align="center"  class="celula"><strong><span class="style1">Hist&oacute;rico de Alterações </span></strong></td>
		  </tr>
		  <tr id="tr10" style="display:none">
			<td height="96" colspan="2"  class="celula" align="center">
            <br />
			<%
            sql = " SELECT *"
            sql = sql & " FROM MAT_configura_transferencia_log  "
            sql = sql & " ORDER BY codigo_log DESC "
            RS.OPEN SQL, CNN
            IF NOT RS.EOF THEN
            %>

                <table width = "96%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                  <tr bgcolor="#E5E5E5">
                    <td width="17%" align="center" class="celula"><strong>Parecer integral</strong></td>
                    <td width="14%" align="center" class="celula"><strong>Travar região</strong></td>
                    <td width="42%" class="celula"><strong>Alterado por</strong></td>
                  </tr>
                  <%cor = "bgcolor='#FFFFCC'"
                        WHILE NOT RS.EOF
                            %>
                              <tr <%=cor%>>
                                <td align="center" class="celula"><%=RS("parecer_integral")%>&nbsp;</td>
                                <td align="center" class="celula"><%=RS("travar_regiao")%>&nbsp;</td>
                                <td class="celula"><%=RS("usuario_log")%>&nbsp;<%=RS("data_log")%></td>
                              </tr>
                              <%
							  codigo_log = rs("codigo_log")
                            RS.MOVENEXT
							if not rs.eof then
								if trim(codigo_log)<>trim(rs("codigo_log")) then
									if cor = "bgcolor='#FFFFF2'" then
										cor = "bgcolor='#FFFFCC'"
									else
										cor = "bgcolor='#FFFFF2'"
									end if
								end if
							end if
							
                        WEND
                    %>
              </table>
            
			<%
            END IF
            RS.CLOSE
            %>

            </td>
		  </tr>
		</table>
<br />
