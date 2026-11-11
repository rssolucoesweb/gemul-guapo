<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
SESSION.Timeout = 1200
Server.ScriptTimeout = 1200
%>
<html>
<head>
<title>Calendário Escolar</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet" href="css_rel/Estilo_Impressao.css">
<script src="js/js_funcoes_gerais.js"></script>
<script src="js_app/js_barra_movel.js"></script>
</head>
<body>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="includes/inc_Botoes_relatorio.asp"-->
<!--#include file="includes/inc_aguarde.asp"-->
<%
sub montaCalendario (MesCal, AnoCal, codCal)

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
                        sql="select e.cod_calendario_evento, e.cor, d.detalhes from sca_calendario_dia_ue d inner join sca_calendario_evento e on e.cod_calendario_evento = d.cod_calendario_evento "
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
	intCodCalendario 			= Trim(Request("cmbCalendarioEscolar"))
	
	if trim(intCodCalendario) <> "" then
		sql = "SELECT c.ano_letivo,c.nome_calendario,e.razaosocial as unidade,c.cod_calendario_geral "
		sql = sql & " FROM SCA_CALENDARIO_UE c inner join seg_empresa e on e.codigo = c.cod_empresa"
		sql = sql & " Where c.cod_calendario_ue = " & intCodCalendario
		sql = sql & " and c.cod_empresa = " & Session("CodEmpresa")
		rs.open sql, cnn
		if rs.eof = false then
			strAno					= rs("ano_letivo")
			strNome		 			= rs("nome_calendario")
			strUnidade 				= rs("unidade")
			intCodCalendarioGeral				= rs("cod_calendario_geral")
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

	<!--#include file="includes/inc_cabecalhoRelatorio.asp"-->
	<br>	
		<h2>
        	<div align="center">
			<span class="titulo"><font size="+1"><%=strNome%> - <%=strAno%></font></span>
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
                montaCalendario MesCalendario, strAno, intCodCalendario
    			%>
          	</td>
    	     <td height="130" valign="top">
    			<%
                montaCalendario MesCalendario1, strAno, intCodCalendario
    			%>
          	</td>
	      	<td height="130" valign="top">
    			<%
                montaCalendario MesCalendario2, strAno, intCodCalendario
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
		
		SQL = "select cor, nome, letivo from SCA_CALENDARIO_EVENTO"
		SQL = SQL & " where cod_grupo ="&session("codGrupo")
		SQL = SQL & " order by 2"
		rs.open sql, cnn
		if not rs.eof then
			%>
			<table width="80%" border="0" cellspacing="0" cellpadding="0" class="tabela">
			  <tr>
				<td class="celula" align="center" colspan="3"><font size="1"><strong>LEGENDA</strong></font></td>
			  </tr>
			  <tr>
				<td class="celula" align="center" colspan="2"><font size="1"><strong>Evento</strong></font></td>
				<td class="celula" align="center" ><font size="1"><strong>Letivo</strong></font></td>
			  </tr>
              <%
			  while not rs.eof
				letivo = "&nbsp;"
				if rs("letivo") = "S" then
					letivo = "Sim"
				end if
				%>
				<tr>
                    <td  height="15" class="celula" bgcolor="<%=rs("cor")%>" width="20">&nbsp;</td>
                    <td class="celula">&nbsp;&nbsp;<%=rs("nome")%></td>
					<td class="celula" align="center"><%=letivo%></td>
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
		SQL = SQL & " FROM SCA_CALENDARIO_DIA_ue d"
		SQL = SQL & " inner join sca_calendario_ue c on c.cod_calendario_ue = d.cod_calendario_ue "
		SQL = SQL & " inner join sca_calendario_evento e on e.cod_calendario_evento = d.cod_calendario_evento "
		SQL = SQL & " where c.cod_empresa = " & Session("CodEmpresa")		
		SQL = SQL & " and e.cod_calendario_evento=24"'FERIADO
		SQL = SQL & " and c.cod_calendario_geral=" & intCodCalendarioGeral				
		SQL = SQL & " and d.ano = " & strAno 
		SQL = SQL & " and d.cod_calendario_ue = " & intCodCalendario
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
		SQL = SQL & " from sca_calendario_dia_ue d "
		SQL = SQL & " inner join sca_calendario_ue c on c.cod_calendario_ue = d.cod_calendario_ue "
		SQL = SQL & " inner join sca_calendario_evento e on e.cod_calendario_evento = d.cod_calendario_evento "
		SQL = SQL & " where c.cod_empresa = " & session("CodEmpresa")
		SQL = SQL & " and d.ano = " & strAno & " and e.letivo = 'S'"
		SQL = SQL & " and d.cod_calendario_ue = " & intCodCalendario
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
		SQL = " select Descricao, periodo  "
		SQL = SQL & " from sca_bimestre"
		SQL = SQL & " where Ano_letivo=" & strAno
		SQL = SQL & " order by Descricao"
		rs.open sql, cnn
		if not rs.eof then
		%>
			<br>
			<table width="80%" border="1" cellspacing="0" cellpadding="0" class="tabela">
			  <tr>
				<td colspan="2"  class="celula" align="center"><font size="1"><strong>TABELA BIMESTRAL</strong></font></td>
			  </tr>
			  <%
			 while not rs.eof
				%>
				<tr>
					<td align="center" class="celula"><%=rs("Descricao")%></td>
					<td align="center" class="celula"><%=rs("periodo")%></td>
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
  </tr>
</table>

</body>
<script>
	aguarde.style.display="none";
</script>
</html>