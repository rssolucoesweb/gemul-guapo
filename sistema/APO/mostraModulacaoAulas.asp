<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 16/09/2007
	::	Desenvolvedores...: Sérgio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Consulta Empresa
-->
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
</form>
</body>
</html>