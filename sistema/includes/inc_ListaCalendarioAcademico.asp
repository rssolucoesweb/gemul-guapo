<!--
	::	GEDU
	::	Data de Criação...: 09/02/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Motivo............: Mostra Calendario Academico
-->	
	<script>
    function AbreFecha(Linha,Figura){
            if (Linha.style.display == "block"){
                Linha.style.display = "none";
                Figura.src="<%=session("strCaminhoRaiz")%>/images/plus.bmp"
            }
            else{
                Linha.style.display = "block";
                Figura.src="<%=session("strCaminhoRaiz")%>/images/minus.bmp"
            }
        }	
    </script>
	<%
		sql = "SELECT Codigo, Ano, Semestre, Mes, Data, Data2, Descricao, Feriado"
		sql = sql & " FROM sca_CalendarioAcademico"
		sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
		sql = sql & " and ano = " & year(date)
		sql = sql & " and month(Data) = " & month(date)			
		sql = sql & " and semestre in (" & session("strSemestre") & ")"
		sql = sql & " ORDER BY Data desc "
		RS.OPEN SQL, CNN
		IF NOT RS.EOF THEN
		%>

		<table width="99%" border="0" cellspacing="0" cellpadding="0" class="tabela">
		  <tr style="cursor:hand" onClick="AbreFecha(L,F)">
			<td height="18"  align="center" class="celula" bgcolor="#999999"  width="3%"><img id="F" src="<%=session("strCaminhoRaiz")%>/images/minus.bmp" ></td>
			<td width="97%" bgcolor="#999999"  align="center"  class="celula"><div align="left"><strong><span class="style1">&nbsp;&nbsp;Calend&aacute;rio Acad&ecirc;mico</span>&nbsp;</strong></div></td>
		  </tr>
		  <tr id="L" style="display:none">
			<td class="celula">&nbsp;</td>
			<td>
				<table width = "100%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
					<tr bgcolor="#E5E5E5"> 
					  <td width="16%" bgcolor="#E5E5E5" class="celula"><strong>Per&iacute;odo</strong></td>
					  <td width="67%" class="celula"><strong>Descri&ccedil;&atilde;o</strong></td>
					  <td width="12%" class="celula"><strong>Situa&ccedil;&atilde;o</strong></td>
				   </tr>
					<%
					WHILE NOT RS.EOF
					
						 if  trim(rs("Feriado"))    = "S" then 
							  statusFeriado = "FERIADO"
						   else
							  statusFeriado = "DIA LETIVO"
						   end if  
		   
						%>
						<tr bgcolor="#FFFFCC"> 
						  <td bgcolor="#FFFFFF" class="celula"><%=trim(formataDataAP(rs("Data")))%>&nbsp;-&nbsp;<%=trim(formataDataAP(rs("Data2")))%>&nbsp;</td>
						  <td bgcolor="#FFFFFF" class="celula"><span class="celula  "><%=trim(rs("Descricao"))%></span>&nbsp;</td>
						  <td bgcolor="#FFFFFF" class="celula"><strong><%=statusFeriado%></strong></td>
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
%>