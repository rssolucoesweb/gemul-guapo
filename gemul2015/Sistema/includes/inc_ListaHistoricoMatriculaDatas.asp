		<table width="99%" border="0" cellspacing="0" class="tabela" cellpadding="0">
		  <tr style="cursor:hand" bgcolor="#FFFFCC">
			<td height="18"  align="center"  class="celula"  width="3%"><a href="javascript:mostraLinhaOcorr(10)">[ + ]</a></td>
			<td width="97%"  align="center"  class="celula"><strong><span class="style1">Hist&oacute;rico de Alterações </span></strong></td>
		  </tr>
		  <tr id="tr10" style="display:none">
			<td height="96" colspan="2"  class="celula">
            <br />
			<%
            sql = " SELECT *"
            sql = sql & " FROM MAT_periodo_curso_log where codigo_log<>1 and year(data_log) = year(getdate()) "
            sql = sql & " ORDER BY codigo_log DESC "
            RS.OPEN SQL, CNN
            IF NOT RS.EOF THEN
            %>

                <table width = "96%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                  <tr bgcolor="#CCCCCC">
                    <td align="center" colspan="4" class="celula"><strong>Faixa etária para Matrícula</strong></td>
                  </tr>
                  <tr bgcolor="#E5E5E5">
                    <td width="27%" align="center" class="celula"><strong>Curso/S&eacute;rie</strong></td>
                    <td width="17%" align="center" class="celula"><strong>Data Inicial</strong></td>
                    <td width="14%" align="center" class="celula"><strong>Data Final</strong></td>
                    <td width="42%" class="celula"><strong>Alterado por</strong></td>
                  </tr>
                  <%cor = "bgcolor='#FFFFCC'"
                        WHILE NOT RS.EOF
                            %>
                              <tr <%=cor%>>
                                <td align="left" class="celula">&nbsp;<%=RS("curso")%>&nbsp;</td>
                                <td align="center" class="celula"><%=formatadataap(RS("dt_inicial"))%>&nbsp;</td>
                                <td align="center" class="celula"><%=formatadataap(RS("dt_final"))%>&nbsp;</td>
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
                        <br />
	    <%
            sql = " SELECT *"
            sql = sql & " FROM MAT_periodo_valido_matricula_log where codigo_log<>1 and codigo<>7 and year(data_log) = year(getdate()) "
            sql = sql & " ORDER BY codigo_log DESC "
            RS.OPEN SQL, CNN
            IF NOT RS.EOF THEN
            %>

                <table width = "96%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                  <tr bgcolor="#CCCCCC">
                    <td align="center" colspan="4" class="celula"><strong>Validação do Período</strong></td>
                  </tr>
                  <tr bgcolor="#E5E5E5">
                    <td width="27%" align="center" class="celula"><strong>Curso/S&eacute;rie</strong></td>
                    <td width="17%" align="center" class="celula"><strong>Data Inicial</strong></td>
                    <td width="14%" align="center" class="celula"><strong>Data Final</strong></td>
                    <td width="42%" class="celula"><strong>Alterado por</strong></td>
                  </tr>
                  <%cor = "bgcolor='#FFFFCC'"
                        WHILE NOT RS.EOF
							curso = replace(RS("curso"),"- 6ao9","- MÍNIMA")
							dt_final = RS("dt_final")
							dt_inicial = RS("dt_inicial")
							if rs("codigo") = "12" then dt_inicial = ""
							if rs("codigo") = "8" then dt_final = ""
                            %>
                              <tr <%=cor%>>
                                <td align="left" class="celula">&nbsp;<%=curso%>&nbsp;</td>
                                <td align="center" class="celula"><%=formatadataap(dt_inicial)%>&nbsp;</td>
                                <td align="center" class="celula"><%=formatadataap(dt_final)%>&nbsp;</td>
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
                                    <br />
			<%
            sql = " SELECT *"
            sql = sql & " FROM MAT_configuracoes_log where codigo_log<>1 and year(data_log) = year(getdate()) "
            sql = sql & " ORDER BY codigo_log DESC "
            RS.OPEN SQL, CNN
            IF NOT RS.EOF THEN
            %>

                <table width = "96%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                  <tr bgcolor="#CCCCCC">
                    <td align="center" colspan="2" class="celula"><strong>Período Dinâmico</strong></td>
                  </tr>
                  <tr bgcolor="#E5E5E5">
                    <td width="27%" align="center" class="celula"><strong>Marcou</strong></td>
                    <td width="42%" class="celula"><strong>Alterado por</strong></td>
                  </tr>
                  <%cor = "bgcolor='#FFFFCC'"
                        WHILE NOT RS.EOF
							marcou = RS("periodo_dinamico")
							if marcou = "S" then marcou = "SIM"
							if marcou = "N" then marcou = "NÃO"
                            %>
                              <tr <%=cor%>>
                                <td align="left" class="celula">&nbsp;<%=marcou%>&nbsp;</td>
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
