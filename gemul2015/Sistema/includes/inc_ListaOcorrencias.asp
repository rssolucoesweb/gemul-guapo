<!--
	::	RSIMOBNET
	::	Data de Criação...: 25/02/2008
	::	Desenvolvedores...: sergio borges - sergiob76@hotmail.com
	::	Motivo............: mostra ocorrencias
-->
<%
	IF intCodAluno <> "" THEN
		sql = "SELECT O.DATAOCORRENCIA, O.OCORRENCIA, U.USUA_NOME_COMPLETO AS USUARIO_INCL"
		sql = sql & " FROM SCA_OCORRENCIA O"
		sql = sql & " LEFT JOIN seg_usuarios_sistema U ON U.USUA_CODG = O.USUARIO_INCL"
		sql = sql & " WHERE O.COD_EMPRESA = " & intCodEmpresa
		sql = sql & " AND 	O.Cod_Aluno=" & intCodAluno
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
		  <tr style="cursor:hand" onClick="AbreFecha(L,F)">
			<td height="18"  align="center"  width="1%"><span class="TextoForm" style="cursor:hand"><img id="F" src="<%=session("strCaminhoRaiz")%>/images/minus.bmp" ></span></td>
			<td width="99%" bgcolor="#F5F5F5"  align="center"  class="celula"><strong><span class="style1">Ocorr&ecirc;ncias</span>&nbsp;</strong></td>
		  </tr>
		  <tr id="L" style="display:none">
			<td>&nbsp;</td>
			<td>
				<table width = "100%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
					<tr bgcolor="#E5E5E5"> 
					  <td width="50%" bgcolor="#F0F0F0" class="celula"><strong>Ocorrência</strong></td>
					  <td width="30%" class="celula"><strong>Usu&aacute;rio</strong></td>
					  <td width="15%" class="celula"><strong>Data</strong></td>
				   </tr>
					<%
					WHILE NOT RS.EOF
						%>
						<tr bgcolor="#FFFFCC"> 
						  <td class="celula"><%=RS("OCORRENCIA")%>&nbsp;</td>
						  <td class="celula"><%=RS("USUARIO_INCL")%>&nbsp;</td>
						  <td class="celula">
								<%if RS("OCORRENCIA") = "Incluído pela ficha do aluno / decisão judicial" then%>
									<%if  (UCASE(session("usuarioWeb")) = "SERGIO" OR UCASE(session("usuarioWeb")) = "FERNANDO.DOMINGOS") then%>
										<%=RS("DATAOCORRENCIA")%>
									<%else%>
										&nbsp;
									<%end if%>
								<%else%>
									<%=RS("DATAOCORRENCIA")%>
								<%end if%>
						  </td>
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