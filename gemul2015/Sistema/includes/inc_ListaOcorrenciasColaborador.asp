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
		sql = sql & " WHERE O.COD_EMPRESA = " & Session("CodEmpresa")		
		sql = sql & " and O.COD_COLABORADOR = " & intCodigo
		sql = sql & " order by O.DATAOCORRENCIA desc "	
'response.write sql		
		RS.OPEN SQL, CNN
		IF NOT RS.EOF THEN
		%>
<style type="text/css">
<!--
.style1 {color: #CC0000}
-->
</style>
 
		<table width="99%" border="0" cellspacing="0" cellpadding="0">
		  <tr style="cursor:hand" onClick="AbreFechaOcorrencia()">
			<td height="18"  align="center"  width="1%"><span class="TextoForm" style="cursor:hand"><img id="IMAGEM_OCORRENCIA" src="<%=session("strCaminhoRaiz")%>/images/minus.bmp" ></span></td>
			<td width="99%" bgcolor="#F5F5F5"  align="center"  class="celula"><strong><span class="style1">Ocorr&ecirc;ncias</span>&nbsp;</strong></td>
		  </tr>
		  <tr >
			<td>&nbsp;</td>
			<td>
				<table width = "100%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela" id="LINHA_OCORRENCIA" style="display:none">
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