<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<html>
<head>
<link href="../../estilo/css.css" rel="stylesheet" type="text/css">
<title>Consulta</title>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formataData.asp"--> 
<%
	codColaborador	 			= Trim(Request("codColaborador"))
	dataInicial			= Trim(Request("dataInicial"))
	datafinal			= Trim(Request("datafinal"))

%>
<form method="POST" id="frm" action="#">
  <div align="center"></div>
  <table width="100%" align="left" class="CorFundo" >
    <tr>
      <td width="100%" height="85" align="center">
	  <table width="101%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td colspan="2" class="tituloPrincipal" align="center">Consulta Parcial</td>
          </tr>
	    <%
					
			 
			sql = "select"
			sql = sql & " case "
			sql = sql & " 	when DataInicial >= '" & formatadataBD(dataInicial) & "' and DataFinal <= '" & formatadataBD(datafinal) & "' then "
			sql = sql & " 		case "
			sql = sql & " 			when (DATEDIFF(day,DataInicial, DataFinal)+1) < 30 then "
			sql = sql & " 				((cast(total_aulas as float)*4.0)/30) * (DATEDIFF(day,DataInicial, DataFinal)+1)"
			sql = sql & " 			else "
			sql = sql & " 				0 "
			sql = sql & " 			end "
			sql = sql & " 	when DataInicial <= '" & formatadataBD(dataInicial) & "' and DataFinal >= '" & formatadataBD(datafinal) & "' then "
			sql = sql & " 		case "
			sql = sql & " 			when (DATEDIFF(day,'" & formatadataBD(dataInicial) & "', '" & formatadataBD(datafinal) & "')+1) < 30 then "
			sql = sql & " 				((cast(total_aulas as float)*4.0)/30) * (DATEDIFF(day,'" & formatadataBD(dataInicial) & "', '" & formatadataBD(datafinal) & "')+1)"
			sql = sql & " 			else "
			sql = sql & " 				0 "
			sql = sql & " 			end 		"
			sql = sql & " 	when DataInicial <= '" & formatadataBD(dataInicial) & "' and DataFinal <= '" & formatadataBD(datafinal) & "' then "
			sql = sql & " 		case "
			sql = sql & " 			when (DATEDIFF(day,'" & formatadataBD(dataInicial) & "', DataFinal)+1) < 30 then "
			sql = sql & " 				((cast(total_aulas as float)*4.0)/30) * (DATEDIFF(day,'" & formatadataBD(dataInicial) & "', DataFinal)+1)"
			sql = sql & " 			else "
			sql = sql & " 				0 "
			sql = sql & " 			end "
			sql = sql & " 	when DataInicial >= '" & formatadataBD(dataInicial) & "' and DataFinal >= '" & formatadataBD(datafinal) & "' then "
			sql = sql & " 		case "
			sql = sql & " 			when (DATEDIFF(day,DataInicial, '" & formatadataBD(datafinal) & "')+1) < 30 then"
			sql = sql & " 				((cast(total_aulas as float)*4.0)/30) * (DATEDIFF(day,DataInicial, '" & formatadataBD(datafinal) & "')+1)"
			sql = sql & " 			else "
			sql = sql & " 				0 "
			sql = sql & " 			end "
			sql = sql & " 	else"
			sql = sql & " 		999999"
			sql = sql & "  end as aulas"
			sql = sql & " ,dataInicial, dataFinal, total_aulas"
			sql = sql & "  from SRH_MODULACAO_DISCIPLINAR_DOCENTE "
			sql = sql & "  where Cod_Colaborador = " & codColaborador
			sql = sql & "  and Situacao_disciplinar = 'D' "
			sql = sql & "  and ( "
			sql = sql & " 		(DataInicial BETWEEN '" & formatadataBD(dataInicial) & "' AND '" & formatadataBD(datafinal) & "' or DataFinal BETWEEN '" & formatadataBD(dataInicial) & "' AND '" & formatadataBD(datafinal) & "') "
			sql = sql & " 		or "
			sql = sql & " 		('" & formatadataBD(dataInicial) & "' BETWEEN DataInicial AND DataFinal   or '" & formatadataBD(datafinal) & "' BETWEEN DataInicial AND DataFinal) "
			sql = sql & " 	)"
			'response.write sql
			rs.open sql, cnn
			if rs.eof = false then
			   	  
			%>
	   		<table width = "98%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
          	<tr bgcolor="#E5E5E5">
				<td class="celula"><strong>Inicial </strong></td>
				<td width="49%" height="21" class="celula"><strong>Final</strong></td>
				<td width="36%" height="21" class="celula"><strong>Aulas</strong></td>
			</tr>
			<%
		 	while not rs.eof
			%>
			  <tr> 
				<td width="49%" class="texto3">&nbsp;<%=formatadataAP(trim(rs("dataInicial")))%></td>
				<td class="texto3">&nbsp;<%=formatadataAP(trim(rs("dataFinal")))%></td>
				<td width="10%" class="texto3">&nbsp;<%=trim(rs("aulas"))%></td>
			  </tr>
			<%	
				aulas = aulas + rs("aulas")
			rs.movenext
			wend
			%>
			 <tr> 
				<td  colspan="2"><strong>Total</strong></td>
				<td  class="texto3">&nbsp;<strong><%=aulas%></strong></td>
			  </tr>
			<%
		end if
		rs.close
	%>
	
	Calculo: total_aulas * 4 /30 * totalDias
	
	</td> 
    </tr>
  </table>
  
  
  <br>

  <%
  if trim(codColaborador) <> "" then
		  
			sql = "select dd.Codigo, dd.Situacao_disciplinar, p.Descricao as periodo, t.desc_turno as turno, tur.desc_turno as Desc_turno_opcional, "
			sql = sql & " dd.Total_Aulas, dd.tipo_contratacao, dd.periodo_inicial, dd.periodo_final, dd.status, "
			sql = sql & " dd.Ano_letivo, dd.Semestre, e.RAZAOSOCIAL, dd.DataInicial,  dd.DataFinal, "
			sql = sql & " f.Desc_Funcao as funcao, isnull(dd.Cod_Substituicao,'0') as Cod_Substituicao, "
			sql = sql & " d.Desc_Disciplina as disciplina, dd.status, e.CodTipoEmpresa "
			sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE dd "
			sql = sql & " inner join SEG_EMPRESA e on e.CODIGO = dd.Cod_empresa "
			sql = sql & " left join SRH_FUNCAOCOLABORADOR f on f.cod_funcao = dd.cod_funcao"
			sql = sql & " left join SCA_disciplina d on d.cod_disciplina = dd.cod_disciplina"
			sql = sql & " left join SRH_TURNO t on t.cod_turno = dd.cod_turno"
			sql = sql & " left join SRH_TURNO tur on tur.cod_turno = dd.cod_turno_opcional "
			sql = sql & " left join SCA_periodo p on p.cod_periodo = dd.cod_periodo"
			sql = sql & " where dd.Cod_Colaborador = " & codColaborador	
			sql = sql & " and dd.ano_letivo = " & session("strAnoLetivo")
			'sql = sql & " or dd.ano_letivo = " & strAnoLetivo - 1 & ")"
			''sql = sql & " and dd.status = 'A'"
			sql = sql & " order by dd.ano_letivo desc ,dd.tipo_contratacao desc, dd.codigo"
			rs.open sql, cnn
			if rs.eof = false then 
		        %>
			  <table width = "100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
	            <tr bgcolor="#E5E5E5" class="celula">
	              <td height="26" colspan="11" align="center" class="celula"><strong>MODULAÇÃO</strong></td>
                </tr>
	            <tr bgcolor="#E5E5E5" class="celula">
	              <td height="26" class="celula">Unidade</td>
		        <td class="celula">Fun&ccedil;&atilde;o</td>
		        <td class="celula">Ano</td>
		        <td class="celula">Situa&ccedil;&atilde;o</td>
		        <td align="center" class="celula">Data Inicial / Final</td>
		        <td class="celula">Per&iacute;odo</td>
		        <td class="celula">Turno</td>
		        <td class="celula">Sit. Disciplinar</td>
		        <td class="celula">Disciplina</td>
		        <td width="94" class="celula">Aulas/Entrada</td>
		        <td class="celula">Origem</td>
	            </tr>
			    <%
				Total_Aulas = 0
			    while not rs.eof
				   cont = cont + 1	
				   strSituacaoDisciplinar = rs("Situacao_disciplinar")
				   if strSituacaoDisciplinar = "D" then strSituacaoDisciplinar = "Disciplinar"
				   if strSituacaoDisciplinar = "I" then strSituacaoDisciplinar = "Interdisciplinar"
				   
				   if rs("Cod_Substituicao") = "0" then 
					   strorigem = "CONTRATUAL"	
				   else				
					   strorigem = "SUBSTITUICAO"	
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
					end if
					link = "onClick='return resultadoConsulta(" & rs("codigo") & ")'"
					if rs("Cod_Substituicao") <> "0" then 
						cor = "#C0C0C0"
						link = ""
					end if
					if rs("Situacao_disciplinar") = "I" then  
						if rs("CodTipoEmpresa") = "4" then 
							intTAulas = rs("Total_Aulas")*42
						else
							intTAulas = rs("Total_Aulas")*21
						end if
						if trim(ucase(rs("turno"))) = "INTEGRAL" then
							if rs("CodTipoEmpresa") = "4" then 
								intTAulas = rs("Total_Aulas")*42
							else
								intTAulas = rs("Total_Aulas")*21
							end if
                        end if                        
					else
						intTAulas = rs("Total_Aulas")
					end if
                    
					turno = rs("turno")
					
                    if not isnull(rs("Desc_turno_opcional")) then
                       	turno = rs("Desc_turno_opcional")
					end if
					
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

					   %>
					   <tr  bgcolor="<%=cor%>" class="celula"  >
                           <td style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"  <%=link%> width="196" class="celula9">&nbsp;<%=trim(rs("RAZAOSOCIAL"))%></td>
                           <td width="293" class="celula9">&nbsp;<%=trim(rs("funcao"))%><%=periodo%></td>
                           <td width="51" class="celula9"><div align="center">&nbsp;<%=trim(rs("Ano_letivo"))%></div></td>
                           <td width="61" class="celula9">&nbsp;<%=strStatus%></td>
                           <td width="192" align="center" class="celula9"><%=trim(rs("DataInicial"))%> / <%=trim(rs("DataFinal"))%>&nbsp;</td>
                           <td width="63" class="celula9">&nbsp;<%=trim(rs("periodo"))%></td>
                           <td width="62" class="celula9">&nbsp;<%=trim(turno)%>                           </td>
                           <td width="93" class="celula9">&nbsp;<%=strSituacaoDisciplinar%></td>
                           <td width="73" height="26" class="celula9">&nbsp;<%=trim(rs("disciplina"))%></td>
                           <td height="26" align="center" class="celula9">&nbsp;<%=trim(intTAulas)%></td>
                         <td width="79" class="celula">&nbsp;<%=trim(strorigem)%></td>
	            </tr>
                   <% 
				   	if rs("status") = "A" then
				   		Total_Aulas = Total_Aulas + intTAulas
					end if
				   rs.movenext
			    wend
			    %>
			    <tr> 

			    <td height="21" class="celula"><span class="texto"><strong>Total Registros :</strong></span> <strong><%=cont%></strong></td>
			    <td height="21" class="celula">&nbsp;</td>
			    <td height="21" colspan="7" align="right" class="celula"><span class="texto"><strong>Total:</strong></span></td>
			    <td height="21" align="center" class="celula"><strong><%=Total_Aulas%></strong></td>
			    <td height="21" class="celula">&nbsp;</td>
			    <%
		    end if
		    rs.close
			 %>
              </table> 
			  <%	
		 end if	
		 %>
</form>
</body>
</html>