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
	colSpan = "5"
	if intCodDisciplina <> "0" then
		colSpan = "6"
	end if	
	if strDataInicial<>"" and strDataInicial<>"" then
		strTituloRelatorio  	= "Devolução de Conteúdo Programático - Devolução no Período: " &  strDataInicial & " à " & strDataFinal 
	else
		strTituloRelatorio  	= "Devolução de Conteúdo Programático"
	end if
	
	sub mostraCabecalho()
	%>
	<!--#include file="includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<div class="table-responsive-lg">
	<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
	  <% if intCodDisciplina <> "0" then %>
	     <tr bgcolor="#CCCCCC">
	     	<td height="15" colspan="<%=colSpan%>" class="<%=strclasse%>"><strong>Disciplina: <%=ucase(rs("Desc_Disciplina"))%></strong></td>
         </tr>
	  <% end if %>	 
	  <tr bgcolor="#CCCCCC">
	    <td width="8%" class="<%=strclasse%>"><div align="center"><strong>Turma</strong></div></td>
  		<% if intCodDisciplina = "0" then %>
	       <td width="10%" class="<%=strclasse%>"><div align="center"><strong>Disciplina</strong></div></td>
		<% end if %>   
	    <td width="10%" class="<%=strclasse%>"><div align="center"><strong>Data</strong></div></td>
        <td width="25%" height="15" class="<%=strclasse%>"><div align="center"><strong>Conte&uacute;do</strong></div></td>
	    <td width="25%" align="center" class="<%=strclasse%>"><strong>Motivo da Devolu&ccedil;&atilde;o</strong></td>
	    <td width="15%" align="center" class="<%=strclasse%>"><strong>Usu&aacute;rio Devolu&ccedil;&atilde;o</strong></td>
	    <td width="15%" align="center" class="<%=strclasse%>"><strong>Data hora Devolu&ccedil;&atilde;o</strong></td>
      </tr>
	  
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table></div>")
	end Sub

	intPagina = 1
	cont = 0

	sql = "SELECT t.nometurma, t.turmaaluno, c.dataInicial, c.conteudo, d.Desc_Disciplina, p.nome as colaborador_conteudo, case when dd.nome_colaborador_devolveu is null then u.USUA_NOME_COMPLETO else dd.nome_colaborador_devolveu end as nome_colaborador_devolveu, dd.Conteudo_devolucao, dd.data_hora_incl"
	sql = sql & " FROM SCA_Conteudo c"
	sql = sql & " inner join sca_turma t on t.cod_turma = c.cod_turma and t.cod_empresa = c.cod_empresa"
	sql = sql & " inner join sca_disciplina d on d.Cod_Disciplina = c.Cod_Disciplina and d.cod_empresa = c.cod_empresa"
	sql = sql & " inner join sca_conteudo_devolucao dd on dd.Cod_Conteudo = c.codigo "
	sql = sql & " left join SRH_COLABORADOR p on p.codigo = c.cod_colaborador "
	sql = sql & " left join SEG_USUARIOS_SISTEMA u on u.USUA_CODG = dd.codigo_seg_usuario_sistema_devolveu"
	sql = sql & " where c.cod_empresa = " & Session("CodEmpresa")			
	sql = sql & " and c.anoletivo = " & intAnoLetivo		
	sql = sql & " and c.semestre in (" & intSemestre & ")"
	if intCodColaboradorProfessor <> "0" then
		sql = sql & " and c.cod_colaborador = " & intCodColaboradorProfessor
	end if
	if intCodTurma <> "0" then
		sql = sql & " and c.cod_turma = " & intCodTurma
	end if	
	if intCodDisciplina <> "0" then
       sql = sql & " and c.Cod_Disciplina = " & intCodDisciplina
	end if  
	if strDataInicial<>"" and strDataFinal<>"" then
		sql = sql & " and convert(datetime,convert(varchar, dd.data_hora_incl, 103),103) >=  convert(datetime, ' " & strDataInicial & "',103)"
		sql = sql & " and convert(datetime,convert(varchar, dd.data_hora_incl, 103),103) <=  convert(datetime, ' " & strDataFinal & "',103)"
	end if
	sql = sql & " Order by c.anoletivo, c.semestre, t.nometurma, d.Desc_Disciplina, c.datainicial, dd.data_hora_incl "

	rs.open sql, cnn
	if not rs.eof then 
	    mostraCabecalho
		total=0
		While not rs.eof 
			if isnull(rs("colaborador_conteudo")) then
				strProfessor = "PROFESSOR(A) NÃO INFORMADO NO HORÁRIO DE AULA"
			else
				strProfessor = rs("colaborador_conteudo")
			end if
			%>
			  <tr height="28">
			    <td align="left" class="<%=strclasse%>"><div align="center"><%=rs("Turmaaluno")%>&nbsp;&nbsp;<%=rs("nometurma")%></div></td>
				<% if intCodDisciplina = "0" then %>
			    	<td align="left" class="<%=strclasse%>">&nbsp;<%=rs("Desc_Disciplina")%></td>
				<% end if %>	
			    <td align="left" class="<%=strclasse%>"><div align="center"><%=trim(formatadataAP(rs("datainicial")))%>&nbsp;</div></td>
			    <td align="left" class="<%=strclasse%>"><%=rs("conteudo")%></td>
                <td align="left" class="<%=strclasse%>"><%=rs("Conteudo_devolucao")%>&nbsp;</td>
                <td align="left" class="<%=strclasse%>"><%=rs("nome_colaborador_devolveu")%>&nbsp;</td>
                <td align="left" class="<%=strclasse%>"><%=rs("data_hora_incl")%>&nbsp;</td>
		      </tr>
			<%
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
			rs.movenext
		wend
		contPeriodo = contPeriodo + 1
	else
		%>
		  <tr>
			<td colspan="7" class="<%=strclasse%>" align="center"><br><br>
			  <font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
		  </tr>
		<%
	end if
	rs.close
%>
</table>
</div>
<br>
<%
coordenador = ""
sql = "select c.nome"
sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE m"
sql = sql & " inner join SRH_FUNCAOCOLABORADOR f on f.cod_funcao = m.cod_funcao"
sql = sql & " inner join SRH_COLABORADOR c on c.codigo = m.cod_colaborador"
sql = sql & " where f.desc_funcao = 'COORDENADOR(A) PEDAGOGICO(A)'"
sql = sql & " and m.status = 'A'"
sql = sql & " and m.cod_empresa = " & Session("CodEmpresa")
rs.open sql, cnn
if not rs.eof then
	coordenador = ucase(rs("nome"))
end if
rs.close
%>
<div class="table-responsive-lg">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  
  <tr>
    <td colspan="2" align="left"><strong>&nbsp;&nbsp;&nbsp;&nbsp;<%=day(date)%> de <%=monthname(month(date))%> de <%=year(date)%>. </strong></td>
  </tr>
  <tr>
    <td height="21" colspan="2" align="center">&nbsp;</td>
  </tr>
  <tr>
    <td width="51%" align="center">______________________________________</td>
    <td width="49%" align="center">______________________________________</td>
  </tr>
  <tr>
    <td align="center" valign="top"><strong><%=strProfessor%></strong></td>
    <td align="center" valign="top"><%=coordenador%></td>
  </tr>
  <tr>
    	<td align="center" valign="top">Professor(a)</td>
    <td align="center" valign="top">Coordenador(a)</td>
  </tr>
</table>
</div>