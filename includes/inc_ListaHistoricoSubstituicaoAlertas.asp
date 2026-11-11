<script>
	function gerarImpressaoModulacao(Cod_Substituicao, TipoModSub, Status, AnoLetivo, codColaborador, origem){
		var frm = document.getElementById("frm");
		window.open("../SRH/ColaboradorSubstituto_rel.asp?CodSubstituicao="+Cod_Substituicao+"&TipoModSub="+TipoModSub+"&Status="+Status+"&AnoLetivo="+AnoLetivo+"&CodColaborador="+codColaborador +"&origem="+ origem,"abreConsulta","top=5,left=5,height=600,width=800,menubar=no,toolbar=no,scrollbars=yes,status=yes");
 		return false	
	}
</script>
<%
	IF codEmpresaHistorico<>"" THEN

		sql = "select dd.tipoModulacao, dd.Codigo, dd.Situacao_disciplinar, p.Descricao as periodo, t.desc_turno as turno, "
		sql = sql & " dd.Total_Aulas, dd.tipo_contratacao, dd.periodo_inicial, case	when ss.DataFinal is not null then ss.DataFinal else dd.periodo_final end as periodo_final, dd.status, "
		sql = sql & " dd.Ano_letivo, dd.Semestre, e.RAZAOSOCIAL, dd.DataInicial, case	when ss.DataFinal is not null then ss.DataFinal else dd.DataFinal end as DataFinal, "
		sql = sql & " f.Desc_Funcao as funcao, isnull(dd.Cod_Substituicao,'0') as Cod_Substituicao, cc.nome as colaborador, dd.Cod_Colaborador,"
		sql = sql & " d.Desc_Disciplina as disciplina, dd.status, e.CodTipoEmpresa "
		sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE dd "
		sql = sql & " inner join SEG_EMPRESA e on e.CODIGO = dd.Cod_empresa "
		sql = sql & " inner join srh_colaborador cc on cc.CODIGO = dd.Cod_Colaborador "
		sql = sql & " left join SRH_FUNCAOCOLABORADOR f on f.cod_funcao = dd.cod_funcao"
		sql = sql & " left join SCA_disciplina d on d.cod_disciplina = dd.cod_disciplina"
		sql = sql & " left join SRH_TURNO t on t.cod_turno = dd.cod_turno"
		sql = sql & " left join SCA_periodo p on p.cod_periodo = dd.cod_periodo"
		sql = sql & " left join SRH_COLABORADOR_SUBSTITUTO ss on ss.codColaboradorSubstituto = dd.Cod_Colaborador and ss.codigo = dd.Cod_Substituicao"
		sql = sql & " where dd.ano_letivo = " & strAno
		sql = sql & " and e.codigo = " & codEmpresaHistorico
		'sql = sql & " and dd.status = 'A'"
		sql = sql & " and isnull(dd.Cod_Substituicao,'0')<>0" 'somente substituicao
		sql = sql & " order by cc.nome, dd.ano_letivo desc , dd.tipoModulacao desc, Cod_Substituicao, dd.tipo_contratacao desc, dd.codigo"
		RS.OPEN SQL, CNN
		IF NOT RS.EOF THEN
		%>
            <div class="panel panel-grey">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-tasks"></i> Históricos das Substituições do ano <strong><%=strAno%></strong>
                </h3>
            </div>
            <div class="panel-body">
            <table class="table table-bordered" >
		  		<thead>
			  <tr  bgcolor="#E2E2E2">
						<th width="40%">Colaborador</th>
						<th width="30%" >Fun&ccedil;&atilde;o</th>
                        <th width="5%" align="center"><strong>Per&iacute;odo</strong></td>
                        <th width="10%"><strong>Turno</strong></td>
                        <th width="20%"><strong>Data Inicial / Final</strong></td>
                        <th width="2%" align="center" ><strong>Aulas<br>Ent.</strong></td>
                        <th width="2%" align="center" ><strong>Origem</strong></td>
					</tr>
				</thead>
				<%
				
				Total_Aulas = 0
			    while not rs.eof
				   cont = cont + 1	
				   intCodColaborador =  rs("Cod_Colaborador")
				   strSituacaoDisciplinar = rs("Situacao_disciplinar")
				   if strSituacaoDisciplinar = "D" then strSituacaoDisciplinar = "Disciplinar"
				   if strSituacaoDisciplinar = "I" then strSituacaoDisciplinar = "Interdisciplinar"
				   codigo = rs("codigo")
				   if rs("Cod_Substituicao") = "0" then 
					   strorigem = "CONTRATUAL"	
					   TipoModSub = "C"
				   else				
					   strorigem = "SUBSTITUICAO"	
					   TipoModSub = "S"
				   end if
				   
				   link = "onClick='return resultadoConsulta(" & rs("codigo") & ")'"
				   strStatus = "Ativo"
				   if trim(rs("status")) <> "A" then 
						cor = "#C0C0C0"
						link = ""
						strStatus = "Inativo"
				   end if
				   
				   periodo = ""
				   tipo = "Contratual"
				   cor = "#FFFFFF"
				   if rs("tipo_contratacao") = "A" then 
				   		periodo = "&nbsp;(" & formatadataAP(rs("periodo_inicial")) & " a " & formatadataAP(rs("periodo_final")) & ")"
						tipo = "Adicional"
						cor = "#C6E2FF"
						strorigem = "PERÍODO"	
						link = ""
					    TipoModSub = "P"						
					end if
					link = "onClick='return resultadoConsulta(" & rs("codigo") & ")'"
					if rs("Cod_Substituicao") <> "0" then 
						cor = "#C0C0C0"
						link = ""
					end if
					if rs("Situacao_disciplinar") = "I" then  
						if trim(ucase(rs("turno"))) = "INTEGRAL" then
							if session("codGrupo") = "7" then
								intTAulas = rs("Total_Aulas")*42
							else
								intTAulas = rs("Total_Aulas")*42
							end if
						else
							intTAulas = rs("Total_Aulas")*21
                        end if                        
					else
						intTAulas = rs("Total_Aulas")
					end if
                    
					turno = rs("turno")
					
					if rs("Cod_Substituicao") <> "0" then
					    cor = "#6699FF"
					end if
					if strStatus = "Inativo" then
					    cor = "#C0C0C0"
					end if
					if not isnull(rs("periodo_final")) then
						strPeriodoFinalComparar = replace(formataDataCalc(rs("periodo_final")),"/","")
						strDataAtualComparar 	= replace(formataDataCalc(date),"/","")
						
						if cCur(strPeriodoFinalComparar)<cCur(strDataAtualComparar) then 
							sql = "update SRH_MODULACAO_DISCIPLINAR_DOCENTE set status = 'I' where codigo = " & rs("codigo") 
							cnn.execute sql
							strStatus = "Inativo" 
							cor = "#C0C0C0"
						end if
					end if
					if not isnull(rs("DataInicial")) then
						periodoMod = formatadataAP(rs("DataInicial"))
					end if
					if not isnull(rs("DataFinal")) then
						periodoMod = periodoMod & " - " & formatadataAP(rs("DataFinal"))
					end if
					acesso = "style='cursor:hand' onMouseOver='return linhaMouseOver(this)' onMouseOut='return linhaMouseOut(this)' "
					
					if rs("tipoModulacao") = "FUNCIONARIO" and cor<>"#C0C0C0"  then
						cor = "#C99494"
						link = ""
						acesso = ""
					end if
					if rs("tipoModulacao") = "FUNCIONARIO" and cor="#C0C0C0"  then
						link = ""
						acesso = ""
					end if
					%>
					<tr>
						<td><%=RS("colaborador")%></td>
						<td><%=trim(rs("funcao"))%><%=periodo%></td>
			    		<td align="left" class="celula"><%=trim(rs("periodo"))%>&nbsp;</td>
                        <td class="celula"><%=trim(turno)%>&nbsp;</td>
                        <td class="celula"><%=periodoMod%>&nbsp;</td>
                         <td class="celula"><%=trim(intTAulas)%>&nbsp;</td>
                        <td align="center" class="celula"><button class="btn-u btn-u-sea" onclick="gerarImpressaoModulacao('<%=rs("Cod_Substituicao")%>','<%=TipoModSub%>','<%=left(strStatus,1)%>','<%=rs("Ano_letivo")%>','<%=intCodColaborador%>','<%=trim(rs("tipo_contratacao"))%>')" type="button"><i class="fa fa-file-text-o"></i></button></td>
					</tr>
					<%				
						if rs("status") = "A" then
							Total_Aulas = Total_Aulas + intTAulas
						end if
						rs.movenext
					wend
    			%>
    		</table>
  			<br>
			  <table align="center" width="40%" border="0" cellspacing="0" cellpadding="0" class="tabela">
                  <tr>
                    <td class="celula" width="17%" bgcolor="#COCOCO">&nbsp;</td>
                    <td class="celula" width="83%">&nbsp;Substituição Inativa</td>
                  </tr>
                  <tr>
                    <td class="celula" bgcolor="#C99494">&nbsp;</td>
                    <td class="celula">&nbsp;Substituição de Funcion&aacute;rio</td>
                  </tr>
                </table>            
			</div>
    	</div>
		<%
		END IF
		RS.CLOSE
	END IF
%> 