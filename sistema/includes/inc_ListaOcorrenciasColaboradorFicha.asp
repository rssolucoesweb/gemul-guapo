<!--
	::	RSIMOBNET
	::	Data de Criação...: 25/02/2008
	::	Desenvolvedores...: sergio borges - sergiob76@hotmail.com
	::	Motivo............: mostra ocorrencias
-->
<%
	IF intCodigo <> "" THEN
		sql = "SELECT CODIGO, OCORRENCIA, DATA_INCL, USUARIO_INCL"
		sql = sql & " FROM SRH_COLABORADOR_OCORRENCIA"
		sql = sql & " WHERE COD_COLABORADOR = " & intCodigo
		sql = sql & " order by DATA_INCL desc "			
		RS.OPEN SQL, CNN
		IF NOT RS.EOF THEN
		%>
		<style type="text/css">
        <!--
        .style1 {color: #CC0000}
        -->
        </style>
 
		<table width="99%" border="0" cellspacing="0" cellpadding="0">
		  <tr style="cursor:hand">
			<td height="18"  align="center"  width="1%"><a href="javascript:showTr(21)"><strong><span class="style1">[+]</span></strong></a></td>
			<td width="99%" align="left"  class="celula">&nbsp;<a href="javascript:showTr(21)"><strong><span class="style1">Ocorrências colaborador</span></strong></a></td>
		  </tr>
		  <tr id="tr21" style="display:none">
			<td>&nbsp;</td>
			<td>
				<table width = "100%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
					<tr bgcolor="#E5E5E5"> 
					  <td width="55%" bgcolor="#F0F0F0" class="celula"><strong>Ocorrência</strong></td>
					  <td width="17%" class="celula"><strong>Usu&aacute;rio</strong></td>
					  <td width="13%" class="celula"><strong>Data</strong></td>
				   </tr>
					<%
					WHILE NOT RS.EOF
						%>
						<tr bgcolor="#FFFFCC"> 
						  <td class="celula"><%=RS("OCORRENCIA")%>&nbsp;</td>
						  <td class="celula"><%=RS("USUARIO_INCL")%>&nbsp;</td>
						  <td class="celula"><%=RS("DATA_INCL")%></td>
						</tr>
						<%
						RS.MOVENEXT
					WEND
				%>
				</table>	
			</td>
		  </tr>
		</table>
		<%
		END IF
		RS.CLOSE
	END IF
%>