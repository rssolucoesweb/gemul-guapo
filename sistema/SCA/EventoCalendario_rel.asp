<!--#include file="../../includes/inc_cnn.asp"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <script src="js/jquery-1.7.2.min.js" type="text/javascript"></script>
    <link href="css/calendario.css" rel="stylesheet" type="text/css" />
	<link href="css/impressaoCalendario.css?v1" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $("div.sis").hide();

        $(document).ready(function () {
            $("div.sis").show();
            $(".bottom").css("margin-bottom", $("#legenda").height());

        });
    </script>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
</head>

<body>


<%
sub montaCalendario (MesCal, AnoCal)

	PrimeiroDiaMes = DateSerial(AnoCal,MesCal,1)
	UltimoDiaMes   = DateSerial(AnoCal,MesCal+1,1-1)
	Inicio         = ABS(1 - WeekDay(PrimeiroDiaMes))
	Fim            = 7 - WeekDay(UltimoDiaMes)
	Start          = 1 - Inicio
	TheEnd         = Day(UltimoDiaMes) + Fim 
	J=1
				
	%>

             <table width="80%" border="1" cellpadding="0" cellspacing="0" class="tabela">
                    <tr>
                      <td width="20%" class="celula" align="center" colspan="7"><font size="1"><strong><%=ucase(monthname(MesCal))%></strong></font></td>
                    </tr>
                    <tr>
                      <td align="center" class="celula"><strong>Dom</strong></td>
                      <td align="center" class="celula"><strong>Seg</strong></td>
                      <td align="center" class="celula"><strong>Ter</strong></td>
                      <td align="center" class="celula"><strong>Qua</strong></td>
                      <td align="center" class="celula"><strong>Qui</strong></td>
                      <td align="center" class="celula"><strong>Sex</strong></td>
                      <td align="center" class="celula"><strong>Sab</strong></td>
                    </tr>
                    <%
                    controle = 0
                    posicao = 0
                    For i= Start to TheEnd
                        cod_calendario_evento = ""
                        Data = DateSerial(AnoCal,MesCal,i)
                        bloqueio = ""
                        sql="select e.cod_calendario_evento, e.cor, d.detalhes from sca_calendario_dia d inner join sca_calendario_evento e on e.cod_calendario_evento = d.cod_calendario_evento "
                        sql=sql & " where ("
                        sql=sql & " 	dia_mes =" & day(DateSerial(AnoCal,MesCal,i)) 
                        sql=sql & " 	and mes =" & month(DateSerial(AnoCal,MesCal,i))
                        sql=sql & " 	and ano =" & year(DateSerial(AnoCal,MesCal,i))
                        sql=sql & " )"	
                        rs.open sql, cnn
                        if rs.eof = false then
                            corFundo = rs("cor")
                            strDetalhe = rs("detalhes")
                        else
                            corFundo = ""
                            strDetalhe = ""
                        end if
                        rs.close
                        if trim(i) = trim(day(now)) and trim(MesCal)=trim(Month(now)) and trim(AnoCal) = trim(year(now)) Then
                            'Dia Hoje
                            IF corFundo = "" THEN corFundo = "#ffffff"
                            posicao = posicao + 1	
                            Response.Write "<TD align='center' height='15' width='10' bgcolor='" & corFundo & "'  class='celula'><FONT COLOR=BLUE><strong>"& Day(DateSerial(AnoCal,MesCal,i)) & "</strong></font></TD>"

                        Elseif (i<1) or (i > Day(UltimoDiaMes)) Then
                            'mes anterior e posterior
                            if (Weekday(DateSerial(AnoCal,MesCal,i)) = 7 or Weekday(DateSerial(AnoCal,MesCal,i))=1) and corFundo="" then corFundo = "#COCOCO"
                            if corFundo="" then corFundo="#fff"
                            Response.Write "<TD align='center' height='15' width='10'  class='celula'>&nbsp;</TD>"
                        Else
                            if (Weekday(DateSerial(AnoCal,MesCal,i)) = 7 or Weekday(DateSerial(AnoCal,MesCal,i))=1) and corFundo="" then corFundo = "#COCOCO"
                            'Dias do m&ecirc;s
                            posicao = posicao + 1	
                            Response.Write "<TD align='center' height='15' width='10' bgcolor='" & corFundo & "'  class='celula'><FONT COLOR='#000'>"& Day(DateSerial(AnoCal,MesCal,i)) & "</font></TD>"
                            
                        End if
                        
                        If j = 7 then
                             J = 0
                             Response.Write "</tr><TR>"
                        end if
                        J = j + 1	
                    NEXT%>
           </tr>
      </table>
<%end sub%>


	<% 
	intCodCalendario 			= Trim(Request("txtCodigo"))
	
	if trim(intCodCalendario) <> "" then
		sql = "SELECT *"
		sql = sql & " FROM SCA_CALENDARIO"
		sql = sql & " Where cod_calendario = " & intCodCalendario
		rs.open sql, cnn
		if rs.eof = false then
			strAno					= rs("ano_letivo")
			strNome		 			= rs("nome_calendario")
		end if 
		rs.close
	end if 
	
	mes = strMes
	ano = strAno	 
			 
	Session.LCID = 1046 'BRASIL
	Dim URL,Dia, Mes, Ano, PrimeiroDiaMes, UltimoDiaMes 
	Dim Inicio,Fim, Start, TheEnd,i, j
	
	URL= Request.ServerVAriables("SCRIPT_NAME")

	dia = day(now)
	
	%>
		<h2>
        	<div align="center">
			<span class="titulo"><font size="+1"><%=strNome%></font></span>
            </div>
		</h2>
    
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<%
	controleCal = 0
	for cal = 1 to 4
		controleCal = controleCal + 1
		MesCalendario  = controleCal
		MesCalendario1 = controleCal+1
		MesCalendario2 = controleCal+2
		controleCal = MesCalendario2
		%>
          <tr>
            <td height="130" valign="top">
    			<%
                montaCalendario MesCalendario, strAno
    			%>
          	</td>
    	     <td height="130" valign="top">
    			<%
                montaCalendario MesCalendario1, strAno
    			%>
          	</td>
	      	<td height="130" valign="top">
    			<%
                montaCalendario MesCalendario2, strAno
    			%>
          	</td>
  		</tr>
   
         
<%next%>

</table>

<br />

<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="33%" height="130" valign="top">
    
    	<%
		
		SQL = "select cor, nome from SCA_CALENDARIO_EVENTO"
		SQL = SQL & " where cod_grupo ="&session("codGrupo")
		SQL = SQL & " order by 1"
		rs.open sql, cnn
		if not rs.eof then
			%>
			<table width="80%" border="0" cellspacing="0" cellpadding="0" class="tabela">
			  <tr>
				<td class="celula" align="center" colspan="2"><font size="1"><strong>LEGENDA</strong></font></td>
			  </tr>
              <%
			  while not rs.eof
				%>
				<tr>
                    <td  height="15" class="celula" bgcolor="<%=rs("cor")%>" width="20">&nbsp;</td>
                    <td class="celula">&nbsp;&nbsp;<%=rs("nome")%></td>
                </tr>
				<%
			   	rs.movenext
			  wend
			  %>
			</table>
			<%
		end if
		rs.close
		%>
    
    </td>
    <td width="33%" valign="top">
    
<%
		SQL = "SELECT MES, DIA_MES, DETALHES  "
		SQL = SQL & " FROM SCA_CALENDARIO_DIA"
		SQL = SQL & " WHERE cod_calendario_evento=1"'FERIADO
		SQL = SQL & " ORDER BY ANO, MES, dia_mes"
		rs.open sql, cnn
		if not rs.eof then
			%>
			<table width="80%" border="0" cellspacing="0" cellpadding="0" class="tabela">
			  <tr>
				<td class="celula" colspan="3" align="center"><font size="1"><strong>FERIADOS</strong></font></td>
			  </tr>
              <%
			  while not rs.eof
				%>
				<tr>
					<td width="20%" height="15" align="center" class="celula"><%=left(ucase(monthname(RS("MES"))),3)%></td>
           	    <td align="center" class="celula"  width="5%"><%=RS("DIA_MES")%></td>
                    <td align="center" class="celula" width="75%"><%=RS("DETALHES")%></td>
                </tr>
				<%
			   	rs.movenext
			  wend
			  %>
			</table>
			<%
		end if
		rs.close
		%>
        
    </td>
    <td width="33%" valign="top">
    
    <%
		

		SQL = "SELECT MES, COUNT(*) AS QTDE "
		SQL = SQL & " FROM SCA_CALENDARIO_DIA"
		SQL = SQL & " WHERE cod_calendario_evento in (5,8,4)"'DIA LETIVO/conselho
		SQL = SQL & " GROUP BY MES"
		SQL = SQL & " order by 1"
		rs.open sql, cnn
		if not rs.eof then
			%>
			<table width="80%" border="0" cellspacing="0" cellpadding="0" class="tabela">
			  <tr>
				<td colspan="2"  class="celula" align="center"><font size="1"><strong>DIAS LETIVOS</strong></font></td>
			  </tr>
              <%
			  	total=0
				totalGeral=0
			  while not rs.eof
			  	IF CINT(rs("MES")) = 8 THEN
				%>
				<tr bgcolor="#CCCCCC">
                    <td height="15" align="center" class="celula"><strong>1º Semestre</strong></td>
                    <td align="center" class="celula"><strong><%=total%></strong></td>
                </tr>
				<%
					total=0
				END IF
				%>
				<tr>
                    <td align="center" class="celula"><%=ucase(monthname(RS("MES")))%></td>
                    <td align="center" class="celula"><%=rs("QTDE")%></td>
                </tr>
				<%
				total = total + rs("QTDE")
				totalGeral = totalGeral + rs("QTDE")
			   	rs.movenext
			  wend
			  
			  %>
				<tr bgcolor="#CCCCCC">
                    <td align="center" class="celula"><strong>2º Semestre</strong></td>
                    <td align="center" class="celula"><strong><%=total%></strong></td>
                </tr>
				<tr bgcolor="#CCCCCC">
                    <td align="center" class="celula"><strong>Total</strong></td>
                    <td align="center" class="celula"><strong><%=totalGeral%></strong></td>
                </tr>
                              
			</table>
			<%
		end if
		rs.close
		%>
    </td>
  </tr>
</table>
</body>
</html>
