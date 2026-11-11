<%
response.Expires=0
SESSION.Timeout = 1200
Server.ScriptTimeout = 1200
%>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<%
	dim intPagina
	dim strInfoTurma
	
	intAnoLetivo 				= request.Form("txtAnoLetivo")
	intSemestre 				= request.Form("cmbSemestre")
    intCodColaboradorProfessor 	= Trim(Request("cmbProfessor"))
	intCodProfessor 	        = Trim(Request("cmbProfessor"))
	if  Trim(Request("cmbTurma")) <> "" then
		intCodTurma 			= Trim(Request("cmbTurma"))
		intCodTurmaProfessor	= Trim(Request("cmbTurma"))
	else
		intCodTurma				= Trim(Request("cmbTurmaProfessor"))
		intCodTurmaProfessor	= Trim(Request("cmbTurmaProfessor"))
	end if
	
	if  Trim(Request("cmbDisciplinaTurma")) <> "" then
		intCodDisciplina			= Trim(Request("cmbDisciplinaTurma"))
		intCodDisciplinaTurma		= Trim(Request("cmbDisciplinaTurma"))
	else
		intCodDisciplina			 = Trim(Request("cmbDisciplinaDoProfessor"))
		intCodDisciplinaTurma		 = Trim(Request("cmbDisciplinaDoProfessor"))
	end if
	strDataInicial         		= Trim(Request("txtDataInicial"))
	strDataFinal            	= Trim(Request("txtDataFinal"))
	intCodEstagio     			= Trim(Request.Form("cmbEstagio"))
	strlpp 						= Trim(Request.Form("cmblpp"))
	strclasse               	= Trim(Request.Form("cmbTamanhoFonteArial"))
	colSpan = "3"
	if intCodDisciplina <> "0" then
		colSpan = "2"
	end if	
	strTituloRelatorio  	= "Conteúdo Programático - Período: " &  strDataInicial & " à " & strDataFinal 
	sub mostraCabecalho()
	%>
	<!--#include file="includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<div class="table-responsive-lg">
	<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
	  <% if intCodDisciplina <> "0" then %>
	     <tr bgcolor="#CCCCCC">
	     	<td height="15" colspan="5" class="<%=strclasse%>"><strong>Disciplina: <%=ucase(rs("Desc_Disciplina"))%></strong></td>
         </tr>
	  <% end if %>	 
	  <tr bgcolor="#CCCCCC">
	    <td width="12%" class="<%=strclasse%>"><div align="center"><strong>Turma</strong></div></td>
		<% if intCodDisciplina = "0" then %>
	       <td width="12%" class="<%=strclasse%>"><div align="center"><strong>Disciplina</strong></div></td>
		<% end if %>   
		<td width="19%" class="<%=strclasse%>"><div align="center"><strong>Professor</strong></div></td>
	    <td width="5%" class="<%=strclasse%>"><div align="center"><strong>Data</strong></div></td>
        <td width="1%" class="<%=strclasse%>"><div align="center"><strong>Aulas</strong></div></td>
	    <td width="63%" height="15" class="<%=strclasse%>"><div align="center"><strong>Conte&uacute;do</strong></div></td>
      </tr>
	  
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table></div>")
	end Sub

	intPagina = 1
	cont = 0
	if intCodColaboradorProfessor = "" then intCodColaboradorProfessor = "0"
	if isnull(intCodColaboradorProfessor) then intCodColaboradorProfessor = "0"
	sql = "SELECT c.*, t.nometurma, t.turmaaluno, d.Desc_Disciplina,cc.nome, ccU.nome as nomeU"
	sql = sql & " FROM SCA_Conteudo c"
	sql = sql & " inner join sca_turma t on t.cod_turma = c.cod_turma and t.cod_empresa = c.cod_empresa"
	sql = sql & " inner join sca_disciplina d on d.Cod_Disciplina = c.Cod_Disciplina and d.cod_empresa = c.cod_empresa"
	sql = sql & " left join SRH_COLABORADOR cc on cc.codigo = c.cod_colaborador "
	sql = sql & " left join SRH_COLABORADOR ccU on ccU.codigo = c.Cod_Colaborador_ultima_interacao"
	sql = sql & " where c.cod_empresa = " & Session("CodEmpresa")			
	sql = sql & " and c.anoletivo = 2020"' & intAnoLetivo		
	sql = sql & " and c.semestre in (" & intSemestre & ")"
	if intCodColaboradorProfessor <> "0" then
		'sql = sql & " and c.cod_colaborador = " & intCodColaboradorProfessor
	end if
	if intCodTurma <> "0" then
		sql = sql & " and c.cod_turma = " & intCodTurma
	end if	
	if intCodDisciplina <> "0" then
       sql = sql & " and c.Cod_Disciplina = " & intCodDisciplina
	end if  
	sql = sql & " and c.Fechamento = 'S' "
    sql = sql & " and convert(datetime,convert(varchar, c.datainicial, 103),103) >=  convert(datetime, ' " & strDataInicial & "',103)"
    sql = sql & " and convert(datetime,convert(varchar, c.datainicial, 103),103) <=  convert(datetime, ' " & strDataFinal & "',103)"
	sql = sql & " Order by c.anoletivo, c.semestre, t.nometurma, d.Desc_Disciplina, c.datainicial "
	rs.open sql, cnn
	if not rs.eof then 
	    mostraCabecalho
		total=0
		Desc_Disciplina = ""
		While not rs.eof 
			'if isnull(rs("colaborador")) then
			'	strProfessor = "PROFESSOR(A) NÃO INFORMADO NO HORÁRIO DE AULA"
			'else
			'	strProfessor = rs("colaborador")
			'end if
			
			nomeU = ""
			if not isnull(rs("nomeU")) then nomeU = "<br>" & rs("nomeU")
			
			if rs("Cod_Colaborador_ultima_interacao") = "0" then nomeU = "<br>Deficit"
			
			nome = rs("nome")
			if isnull(nome) or nome = "" then nome = "Deficit"
			
			if rs("nome") = rs("nomeU") then nomeU = ""
			if rs("Cod_Colaborador_ultima_interacao") = rs("cod_colaborador") then nomeU = ""
			
			if trim(rs("Desc_Disciplina")) <> trim(Desc_Disciplina) and Desc_Disciplina<>"" then
			%>
				<tr height="28">
					<td colspan="<%=colSpan+1%>" class="<%=strclasse%>" align="right"><strong>Total de aulas&nbsp;</strong>&nbsp;</td>
					<td class="<%=strclasse%>" align="center"><strong><%=total%></strong></td>
					<td  class="<%=strclasse%>" align="right">&nbsp;</td>
				</tr>
				<tr height="28">
					<td colspan="<%=colSpan+3%>" align="left" class="<%=strclasse%>">
						<br>
						<br>
						
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
						  <tr>
							<td width="50%" align="center">______________________________________</td>
							<td width="50%" align="center">______________________________________</td>
						  </tr>
						  <tr>
							<td align="center" valign="top">Coordenador(a)</td>
							<td align="center" valign="top">Professor(a)</td>
						  </tr>
						</table>					
						<br>
					</td>
				</tr>
				</table>
				</div>
				<br>
				<br>
				<div class="table-responsive-lg">
				<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
				  <% if intCodDisciplina <> "0" then %>
					 <tr bgcolor="#CCCCCC">
						<td height="15" colspan="5" class="<%=strclasse%>"><strong>Disciplina: <%=ucase(rs("Desc_Disciplina"))%></strong></td>
					 </tr>
				  <% end if %>	 
				  <tr bgcolor="#CCCCCC">
					<td width="12%" class="<%=strclasse%>"><div align="center"><strong>Turma</strong></div></td>
					<% if intCodDisciplina = "0" then %>
					   <td width="12%" class="<%=strclasse%>"><div align="center"><strong>Disciplina</strong></div></td>
					<% end if %>   
					<td width="19%" class="<%=strclasse%>"><div align="center"><strong>Professor</strong></div></td>
					<td width="5%" class="<%=strclasse%>"><div align="center"><strong>Data</strong></div></td>
					<td width="1%" class="<%=strclasse%>"><div align="center"><strong>Aulas</strong></div></td>
					<td width="63%" height="15" class="<%=strclasse%>"><div align="center"><strong>Conte&uacute;do</strong></div></td>
				  </tr>
			<%
				total = 0
			end if
			%>
			  <tr height="28">
			    <td align="left" class="<%=strclasse%>"><div align="center"><%=rs("Turmaaluno")%>&nbsp;&nbsp;<%=rs("nometurma")%></div></td>
				<% if intCodDisciplina = "0" then %>
			    	<td align="left" class="<%=strclasse%>">&nbsp;<%=rs("Desc_Disciplina")%></td>
				<% end if %>	
				<td align="left" class="<%=strclasse%>"><%=nome & nomeU%></td>
			    <td align="left" class="<%=strclasse%>"><div align="center"><%=trim(formatadataAP(rs("datainicial")))%>&nbsp;</div></td>
			    <td class="<%=strclasse%>" align="center"><%=rs("total_aulas")%></td>
                <td align="left" class="<%=strclasse%>"><%=rs("conteudo")%></td>
		      </tr>
			<%
			total = total + rs("total_aulas")
			'quantidade de registros da página
			'if int(intQtdeRegistroPorPagina) = int(strlpp) - 1 then
			'	 intPagina = intPagina + 1
			'	 intQtdeRegistroPorPagina = 1
			'	 fimTabela
				%>
				<!--pre></pre-->				
				<%			
				'mostraCabecalho
			'end if	
			cont = cont + 1
			intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
			Desc_Disciplina = rs("Desc_Disciplina")
			rs.movenext
		wend
		contPeriodo = contPeriodo + 1
		%>
        <tr height="28">
			<td colspan="<%=colSpan+1%>" class="<%=strclasse%>" align="right"><strong>Total de aulas&nbsp;</strong>&nbsp;</td>
            <td class="<%=strclasse%>" align="center"><strong><%=total%></strong></td>
            <td  class="<%=strclasse%>" align="right">&nbsp;</td>
		  </tr>	
			<tr height="28">
				<td colspan="<%=colSpan+3%>" align="left" class="<%=strclasse%>">
					<br>
					<br>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr>
						<td width="50%" align="center">______________________________________</td>
						<td width="50%" align="center">______________________________________</td>
					  </tr>
					  <tr>
						<td align="center" valign="top">Coordenador(a)</td>
						<td align="center" valign="top">Professor(a)</td>
					  </tr>
					</table>					
					<br>
				</td>
			</tr>
		<%
	else
		%>
		  <tr>
			<td colspan="4" class="<%=strclasse%>" align="center"><br><br>
			  <font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
		  </tr>
		<%
	end if
	rs.close
%>
</table>
</div>
