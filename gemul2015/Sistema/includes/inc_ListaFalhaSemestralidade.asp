<!--
	::	GEDU
	::	Data de Criação...: 09/02/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Motivo............: Mostra Calendario Academico
-->	
	<script>
    function AbreFecha1(Linha1,Figura1){
            if (Linha1.style.display == "block"){
                Linha1.style.display = "none";
                Figura1.src="<%=session("strCaminhoRaiz")%>/images/plus.bmp"
            }
            else{
                Linha1.style.display = "block";
                Figura1.src="<%=session("strCaminhoRaiz")%>/images/minus.bmp"
            }
        }	
    </script>
    <%
    intTotalParcelas = 0
    sql = " SELECT DISTINCT "
    sql = sql & " A.MATRICULA, A.NOMEALUNO, DA.ANO, PPD.CodSemestre, "
    sql = sql & " (SELECT COUNT(CODIGO)FROM SCF_PLANOPARCELA PP WHERE PP.Ano = DA.ANO AND PP.Cod_Plano=DA.Cod_Plano AND PP.CodSemestre=PPD.CodSemestre) - "
    sql = sql & " (SELECT COUNT(D.PARCELA) AS TOTAL FROM SCF_DEBITOALUNO D INNER JOIN SCF_PLANOPARCELA PP ON PP.CODIGO = D.COD_PLANOPARCELA "
    sql = sql & " 	WHERE D.COD_EMPRESA = " & Session("CodEmpresa") & " AND D.ANO = DA.ANO AND D.Cod_Aluno=DA.COD_ALUNO AND PP.CodSemestre=PPD.CodSemestre) AS DIFERENCA, "
    sql = sql & " A.DATAMATRICULA "
    sql = sql & " FROM SCF_DEBITOALUNO DA "
    sql = sql & " INNER JOIN SCF_PLANOPARCELA PPD ON PPD.Codigo = DA.Cod_PlanoParcela "
    sql = sql & " INNER JOIN SCA_ALUNO A ON A.CODIGO = DA.COD_ALUNO "
    sql = sql & " INNER JOIN SCA_SITUACAOALUNO ST ON ST.Cod_SituacaoAluno = A.COD_SITUACAOALUNO "
    sql = sql & " WHERE DA.COD_EMPRESA = " & Session("CodEmpresa")
    sql = sql & " AND DA.Parcela <> 999 "
    sql = sql & " AND DA.Ano = " & session("strAnoLetivo") 
    sql = sql & " AND PPD.CodSemestre = " & Session("strSemestre")
    sql = sql & " AND (SELECT COUNT(CODIGO)FROM SCF_PLANOPARCELA PP WHERE PP.Ano = DA.ANO AND PP.Cod_Plano=DA.Cod_Plano AND PP.CodSemestre=PPD.CodSemestre) > "
    sql = sql & " (SELECT COUNT(D.PARCELA) AS TOTAL FROM SCF_DEBITOALUNO D INNER JOIN SCF_PLANOPARCELA PP ON PP.CODIGO = D.COD_PLANOPARCELA WHERE D.COD_EMPRESA =  " & Session("CodEmpresa") & "  AND D.ANO = DA.ANO AND D.Cod_Aluno=DA.COD_ALUNO AND PP.CodSemestre=PPD.CodSemestre) "
    sql = sql & " AND ST.Desc_SituacaoAluno = 'ATIVO' "
    RS.OPEN SQL, CNN
    IF NOT RS.EOF THEN
        %>
        <style type="text/css">
        <!--
        .style1 {font-weight: bold}
        -->
        </style>

        <table width="99%" border="0" cellspacing="0" cellpadding="0" class="tabela">
          <tr style="cursor:hand" onClick="AbreFecha1(L1,F1)">
            <td height="18"  align="center" class="celula" bgcolor="#999999"  width="3%"><img id="F1" src="<%=session("strCaminhoRaiz")%>/images/minus.bmp" ></td>
            <td width="97%" bgcolor="#999999"  align="center"  class="celula"><div align="left"><strong><span class="style1">&nbsp;&nbsp;</span></strong></div></td>
          </tr>
          <tr id="L1" style="display:none">
            <td class="celula">&nbsp;</td>
            <td>
                <table width = "100%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                    <tr bgcolor="#E5E5E5"> 
                      <td width="6%"  class="celula"><strong>Matr&iacute;cula</strong></td>
                      <td width="66%" class="celula"><strong>Nome</strong></td>
                      <td width="14%" class="celula"><strong>Data Matr&iacute;cula</strong></td>
                      <td width="14%" class="celula"><strong>Parcela(s) n&atilde;o Gerada(s)</strong></td>
                  </tr>
                    <%
                    WHILE NOT RS.EOF
                        intTotalParcelas = intTotalParcelas + rs("DIFERENCA")
                        %>
                        <tr bgcolor="#FFFFCC">
                          <td bgcolor="#FFFFFF" class="celula" align="right"><%=rs("MATRICULA")%>&nbsp;</td>
                          <td bgcolor="#FFFFFF" class="celula"><%=trim(rs("NOMEALUNO"))%>&nbsp;</td>
                          <td bgcolor="#FFFFFF" class="celula" align="center"><%=formataDataAP(rs("DATAMATRICULA"))%>&nbsp;</td>
                          <td bgcolor="#FFFFFF" class="celula" align="center"><%=trim(rs("DIFERENCA"))%>&nbsp;</td>
                        </tr>
                        <%
                        RS.MOVENEXT
                    WEND
                %>
                <tr bgcolor="#FFFFCC"> 
                  <td colspan="4" align="right" bgcolor="#FFFFFF" class="celula"><div align="left"><strong>Parcela(s) ainda n&atilde;o gerada(s)</strong>:  <%=trim(intTotalParcelas)%> </div></td>
                </tr>
                </table>	
            </td>
          </tr>
        </table>
        <br />
        <%
        END IF
        RS.CLOSE

%>