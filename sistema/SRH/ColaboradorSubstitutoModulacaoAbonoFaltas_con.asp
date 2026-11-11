<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formataData.asp"--> 
<!--#include file="../../includes/inc_replaceRequest.asp"-->
   <!--=== Breadcrumbs ===-->
	  
<!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
       
	intCodColaboradorSubstituido	 = Trim(Request("CodColaboradorSubstituido"))
    
    %>

    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Rela&ccedil;&atilde;o de Abonos de Faltas - Substitu&iacute;do</h3>
        </div>
       <!--Table Bordered-->
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-body">
                <table width="98%" class="table table-bordered">
                    <thead>
                    <tr>
                    <th width="7%" bgcolor="#95A5A6"><strong>Lan&ccedil;amento</strong></th>
                    <th width="8%" bgcolor="#95A5A6"><strong>Tipo </strong></th>
                    <th width="10%" bgcolor="#95A5A6"><strong>Exerc&iacute;cio</strong></th>
                    <th width="10%" bgcolor="#95A5A6"><strong>Turma</strong></th>
                    <th width="14%" bgcolor="#95A5A6"><strong>Turno</strong></th>
                    <th width="18%" bgcolor="#95A5A6"><strong>Disciplina</strong></th>
                    <th width="4%" bgcolor="#95A5A6"><strong>Falta</strong></th>
                    <th width="17%" bgcolor="#95A5A6"><strong>Per&iacute;odo Lan&ccedil;amento</strong></th>
                    <th width="6%" bgcolor="#95A5A6"><strong>Situa&ccedil;&atilde;o</strong></th>
                    <th width="6%" bgcolor="#95A5A6"><strong>Falta Enviada</strong></th>
                    <th width="2%" bgcolor="#95A5A6"><strong><div align="center">A&ccedil;&atilde;o</div></strong></th>
                    </tr>
                    </thead>
 					<%
					cont = 0
					sql = "SELECT top 10 (SELECT TOP 1 CODIGO from SRH_COLABORADOR_FREQUENCIA where ANO_LETIVO = CF.ANO_LETIVO and SEMESTRE_LETIVO = CF.SEMESTRE_LETIVO and Cod_JustificativaFaltas = CF.Cod_JustificativaFaltas and codReferencia = CF.CodReferencia and DATALANCAMENTO = CF.DATALANCAMENTO and DATALANCAMENTOFINAL = CF.DATALANCAMENTOFINAL and DataDiaLancamento = CF.DataDiaLancamento and COD_COLABORADOR = CF.COD_COLABORADOR and COD_TURMA = CF.COD_TURMA and ISNULL(COD_DISCIPLINA,'0') = ISNULL(CF.COD_DISCIPLINA,'0')) AS CODIGO, CF.ANO_LETIVO, CF.SEMESTRE_LETIVO, CF.Cod_JustificativaFaltas, CF.CodReferencia, CF.DATALANCAMENTO, CF.DATALANCAMENTOFINAL, CF.DataDiaLancamento, CF.COD_COLABORADOR, CF.TIPO_COLABORADOR, CF.COD_TURMA, T.NOMETURMA, C.NOME, D.DESC_DISCIPLINA , isnull(CF.COD_DISCIPLINA,'0') as COD_DISCIPLINA , CS.NOME AS COLABORADOR_SUBSTITUTO, CF.NUMERO_AULA, CF.CONTEUDO_SUBSTITUICAO, CF.COD_TURNO, TUR.DESC_TURNO AS TURNO, CF.SITUACAO as STATUS, isnull(CF.fechamento,'') as fechamento, SUM(CONVERT(INT, CF.NUMERO_FALTA)) AS NUMERO_FALTA from SRH_COLABORADOR_FREQUENCIA CF LEFT JOIN SCA_TURMA T ON T.COD_TURMA=CF.COD_TURMA INNER JOIN SRH_COLABORADOR C ON C.CODIGO = CF.COD_COLABORADOR LEFT JOIN SCA_DISCIPLINA D ON D.COD_DISCIPLINA = CF.COD_DISCIPLINA LEFT JOIN SRH_COLABORADOR CS ON CS.CODIGO = CF.COD_COLABORADORSUBSTITUTO LEFT JOIN SCA_TURNO TUR ON TUR.Cod_Turno = CF.Cod_Turno" 
					sql = sql & " WHERE CF.COD_COLABORADOR = " & intCodColaboradorSubstituido
					sql = sql & " and CF.SITUACAO='S'"
					sql = sql & " and CF.fechamento='S'"
					sql = sql & " group by ANO_LETIVO, SEMESTRE_LETIVO, CF.Cod_JustificativaFaltas, CF.CodReferencia, CF.DATALANCAMENTO, CF.DATALANCAMENTOFINAL, CF.DataDiaLancamento, CF.COD_COLABORADOR, CF.TIPO_COLABORADOR, CF.COD_TURMA, T.NOMETURMA, C.NOME, D.DESC_DISCIPLINA , CF.COD_DISCIPLINA , CS.NOME, CF.NUMERO_AULA, CF.CONTEUDO_SUBSTITUICAO, CF.COD_TURNO, TUR.DESC_TURNO , CF.SITUACAO , CF.fechamento order by NOME, CF.CodReferencia desc"
		
					rs.open sql, cnn
					if rs.eof = false then					
						while not rs.eof
					
							cont = cont + 1	
							strDataLancamento          = formatadataAp(rs("DATALANCAMENTO"))
							strDataLancamentoFinal     = formatadataAp(rs("DATALANCAMENTOFINAL"))
							strDataDiaLancamento	   = formatadataAp(rs("DataDiaLancamento"))
							
							strTipoColaborador         = rs("TIPO_COLABORADOR")
							strNomeTurma 			   = rs("NOMETURMA")
							if not isnull(rs("DESC_DISCIPLINA")) then
								strDescDisciplina          = rs("DESC_DISCIPLINA")
							else
								strDescDisciplina          = "Interdisciplinar"
							end if			
							intNumeroFalta             = rs("NUMERO_FALTA")
							strNumeroAula              = rs("NUMERO_AULA") 
							strConteudoSubstituicao    = rs("CONTEUDO_SUBSTITUICAO")
							if trim(rs("STATUS")) = "S" then
								strSituacao = "ABONO"
							else
								strSituacao = "-----"
							end if
							if trim(strTipoColaborador) = "P" then
							   DescricaoTipoColaborador = "Prof."
							else  
							   DescricaoTipoColaborador = "Func."
							end if   
							AnoLetivo = rs("ANO_LETIVO")
							if rs("SEMESTRE_LETIVO") = "3" then
							   nomeSemestre = "Anual"
							else  
							   nomeSemestre = intSemestre
							end if  
							if trim(rs("fechamento")) = "S" then
								strEnviouFalta = "<strong>Sim</strong>"
								strCorlinha = "C1FFC1"
							else
								strEnviouFalta = "Não"
								strCorlinha = "FFFFFF"
							end if
							%>
							<tbody>
								  <tr bgcolor="#<%=strCorlinha%>" style="cursor:hand" onmouseover="return linhaMouseOver(this)" onmouseout="return linhaMouseOut(this)">
									<td class="celula">&nbsp;<%=strDataDiaLancamento%></td>
									<td class="celula">&nbsp;<%=DescricaoTipoColaborador%></td>
									<td height="20" class="celula">&nbsp;<%=AnoLetivo%>/<%=nomeSemestre%></td>
									<td height="20" class="celula">&nbsp;<%=strNomeTurma%></td>
									<td height="20" class="celula">&nbsp;<%=rs("TURNO")%></td>
									<td height="20" class="celula">&nbsp;<%=strDescDisciplina%></td>
									<td height="20" class="celula">&nbsp;<%=intNumeroFalta%></td>
									<td height="20" class="celula">&nbsp;<%=strDataLancamento%> - <%=strDataLancamentoFinal%></td>
									<td height="20" align="center"><%=strSituacao%></td>
									<td align="center" class="celula"><%=strEnviouFalta%></td>
									<td align="center">
                                    <% if session("strAnoLetivo") = AnoLetivo then %>
                                    	<button class="btn-u btn-u-sea" onClick="resultadoConsultaJustificativa('<%=strDataLancamento%>','<%=strDataLancamentoFinal%>','<%=rs("Cod_JustificativaFaltas")%>')" type="button"><i class="fa fa-file-text-o"></i></button>
                                    <% else %>
                                    	----
                                    <% end if %> 
                            		</td> 
								  </tr>
							</tbody>
							<%				
                        rs.movenext
                        wend
                    end if
                    rs.close
                %>
                  <tr bgcolor="#<%=strCorlinha%>" style="cursor:hand" onmouseover="return linhaMouseOver(this)" onmouseout="return linhaMouseOut(this)">
                    <td height="20" colspan="11" class="celula"><div align="center">
                      <input type="button" name="Fechar" style="cursor:hand"   value="Fechar" class="btn-u float-shadow" onclick="window.close()" />
                    </div></td>
                 </tr>
                </table>
          </div>                      
        </div>
        <!--End Table Bordered-->	
       <!-- Fecha o Painel do Formulario -->    
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
      
	  <div id="divRetorno"></div>
       <!-- Fecha o Painel do Formulario -->    
       
       	<script>
			function resultadoConsultaJustificativa(strDataLancamento, strDataLancamentoFinal,strCodJustificativaFaltas){
				window.opener.document.getElementById('txtDataLancamentoJustificativa').value = strDataLancamento;
				window.opener.document.getElementById('txtDataLancamentoJustificativaFinal').value = strDataLancamentoFinal;
				window.opener.document.getElementById('txtCodJustificativaFaltas').value = strCodJustificativaFaltas; 
				window.opener.document.getElementById('frm').submit();
				window.close();
			}
        
    	</script>
           
<!--#include file="../jsModulo.asp"-->
</body>
</html> 