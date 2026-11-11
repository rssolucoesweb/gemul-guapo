<%IF intCodAluno <> "" THEN

		sql = "SELECT O.DATAOCORRENCIA, O.OCORRENCIA, TP.DESC_Tipo, DA.PARCELA, DA.ReferenciaMensal, O.USUARIO_INCL"
		sql = sql & " FROM SCA_OCORRENCIA O"
		sql = sql & " LEFT JOIN SCF_DEBITOALUNO DA ON DA.CODIGO = O.COD_DEBITOALUNO AND O.COD_EMPRESA = DA.COD_EMPRESA"
		sql = sql & " LEFT JOIN SCF_TIPOPARCELA TP ON TP.COD_TIPO = O.COD_TIPOPARCELA AND TP.COD_EMPRESA = O.COD_EMPRESA"
		sql = sql & " WHERE O.COD_EMPRESA = " & intCodEmpresa
		sql = sql & " AND 	O.Cod_Aluno=" & intCodAluno
		sql = sql & " order by O.DATAOCORRENCIA desc "			
		RS.OPEN SQL, CNN
		IF NOT RS.EOF THEN
		%>
        
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i> Lista de Ocorrências</h3>
            </div>
            <div class="panel-body">
            	
                <table class="table table-bordered">
                <thead>
                  <tr>
                    <td width="71"><div align="center"><a href="javascript:showTr(1)">[+]</a></div></td>
                    <td width="745"><div align="center">Dados Ocorrências</div></td>
                  </tr>
                  <tr id="tr1" style="display:none;">
                    <td colspan="2" align="center">
                    
                        <table class="table table-bordered table-highlight">
                          <thead>
                            <tr >
                              <th>Ocorr&ecirc;ncia</th>
                              <th>Tipo Parcela</th>
                              <th>Usu&aacute;rio</th>
                              <th>Data</th>
                            </tr>
                          </thead>
                          <%
								WHILE NOT RS.EOF
								%>
								<tr>
								<td><%=RS("OCORRENCIA")%></td>
								<td><%=RS("DESC_Tipo")%></td>
								<td><%=RS("USUARIO_INCL")%></td>
								<td><%=RS("DATAOCORRENCIA")%></td>
								</tr>
							  <%
								RS.MOVENEXT
								WEND
                            %>
                        </table>
                    </td>
                  </tr>
              </thead>
            </table>
                 
            </div>                      
        </div>
       <%
		END IF
		RS.CLOSE
	END IF
%>
<script>
	function showTr(id){
		
		var elemento = document.getElementById("tr" + id);
		if(elemento.style.display == ''){
			elemento.style.display = 'none';
		}else{
			elemento.style.display = '';
		}
	}
</script>