<!--
	::	RSIMOBNET
	::	Data de Criação...: 25/02/2008
	::	Desenvolvedores...: sergio borges - sergiob76@hotmail.com
	::	Motivo............: mostra ocorrencias
-->
<%
	IF intCodigo <> "" THEN
		sql = "SELECT O.COD_OCORRENCIA, O.COD_DEPARTAMENTO, A.CODIGO, A.NOME, O.DATAOCORRENCIA, O.DATAVALIDADE, O.OCORRENCIA, O.USUARIO_INCL"
		sql = sql & " FROM SRH_OCORRENCIA O"
		sql = sql & " LEFT JOIN SRH_COLABORADOR A ON A.CODIGO = O.COD_COLABORADOR AND A.COD_EMPRESA = O.COD_EMPRESA"
		sql = sql & " WHERE O.COD_COLABORADOR = " & intCodigo
		sql = sql & " order by O.DATAOCORRENCIA desc "
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
			<td height="18"  align="center"  width="1%"><a href="javascript:showTr(20)">[+]</a></td>
			<td width="99%" bgcolor="#F5F5F5"  align="center"  class="celula"><strong><span class="style1"><a href="javascript:showTr(20)">Ocorrências</a></span>&nbsp;</strong></td>
		  </tr>
		  <tr id="tr20" style="display:none">
			<td>&nbsp;</td>
			<td>
				<table width = "100%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
					<tr bgcolor="#E5E5E5"> 
					  <td width="45%" bgcolor="#F0F0F0" class="celula"><strong>Ocorrência</strong></td>
					  <td width="19%" class="celula"><strong>Usu&aacute;rio</strong></td>
					  <td width="17%" class="celula"><strong>Data</strong></td>
				   </tr>
					<%
					WHILE NOT RS.EOF
						%>
						<tr bgcolor="#FFFFCC"> 
						  <td class="celula"><%=RS("OCORRENCIA")%>&nbsp;</td>
						  <td class="celula"><%=RS("USUARIO_INCL")%>&nbsp;</td>
						  <td class="celula"><%=RS("DATAOCORRENCIA")%></td>
						</tr>
						<%
						RS.MOVENEXT
					WEND
				%>
				</table>	
			</td>
		  </tr>
		</table>
		<br />
		<%
		END IF
		RS.CLOSE
	END IF
%>