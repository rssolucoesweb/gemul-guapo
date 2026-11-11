<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 15/03/2010
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Ficha Individual do Colaborador
-->
<html>
<head>
<title><%=session("Titulo")%> - Ficha Individual do Aluno</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
</head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%
	strTituloRelatorio  	= "SUBSTITUI&Ccedil;&Atilde;O MODULA&Ccedil;&Atilde;O"
%>
<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
<%
	strCod_empresa 					= Session("CodEmpresa")
	strCodSubstituicao				= Trim(Request.QueryString("CodSubstituicao"))

	sql = " SELECT MD.Codigo, Ano_letivo "  
	sql = sql & " FROM SRH_MODULACAO_DISCIPLINAR_DOCENTE MD "
	sql = sql & " WHERE MD.Codigo = " & strCodSubstituicao
	rs.open sql, cnn
	if rs.eof = false then
		strAnoLetivo 		    = rs("Ano_letivo")
		'	
	else
		rs.close
		%>
		<script>
			alert("Não foram encontrados para esse relatório.");
			window.history.back();
		</script>
		<%
		response.End()
	end if 
	rs.close

	sql = " SELECT MD.Codigo, MD.Cod_Empresa as CodEmpresaSubstituto, MDD.Cod_Empresa as CodEmpresaSubstituido, CS.CodFuncional as CodFuncionalSubstituto, CSS.CodFuncional as CodFuncionalSubstituido,"
	sql = sql & " CS.Codigo as CodColaboradorSubstituto, CSS.Codigo as CodColaboradorSubstituido, CS.Nome as NomeColaboradorSubstituto, "
	sql = sql & " CSS.Nome as NOmeColaboradorSubstituido, ES.RAZAOSOCIAL as Empresa_Substituto, ESS.MANTENEDORA, ESS.RAZAOSOCIAL as Empresa_Substituido, "
	sql = sql & " MD.DataInicial, MD.DataFinal, MD.Status, MD.Total_Aulas, isnull(JF.Descricao,'--') AS TipoFalta, d.Desc_Disciplina as disciplina, p.descricao as periodo, f.Desc_Funcao as funcao, MD.Ano_letivo, MD.Semestre "
	sql = sql & " FROM SRH_MODULACAO_DISCIPLINAR_DOCENTE MD "
	sql = sql & " INNER JOIN SRH_MODULACAO_DISCIPLINAR_DOCENTE MDD ON MDD.CODIGO = MD.Cod_Modulacao_Substituicao "
	sql = sql & " INNER JOIN SRH_COLABORADOR CS ON CS.CODIGO = MD.Cod_Colaborador "
	sql = sql & " INNER JOIN SRH_COLABORADOR CSS ON CSS.CODIGO = MDD.Cod_Colaborador "
	sql = sql & " LEFT JOIN SEG_EMPRESA ES on ES.CODIGO = MD.Cod_Empresa "
	sql = sql & " LEFT JOIN SEG_EMPRESA ESS on ESS.CODIGO = MDD.Cod_Empresa "
	sql = sql & " LEFT JOIN SRH_JUSTIFICATIVAFALTAS JF ON JF.Codigo = MD.Cod_JustificativaFaltas "
	sql = sql & " left join SRH_FUNCAOCOLABORADOR f on f.cod_funcao = MD.cod_funcao "
	sql = sql & " left join SCA_disciplina d on d.cod_disciplina = MD.cod_disciplina "
	sql = sql & " left join SCA_periodo p on p.cod_periodo = MD.cod_periodo "
	sql = sql & " left join SRH_TURNO t on t.cod_turno = MD.cod_turno "
	sql = sql & " WHERE MD.Codigo = " & strCodSubstituicao
	'response.write sql
	rs.open sql, cnn
	if rs.eof = false then
		strCodSubstituto = rs("CodColaboradorSubstituto")   
		intCodColaboradorSubstituto = rs("CodColaboradorSubstituto")   
		intCodColaboradorSubstituido = rs("CodColaboradorSubstituido")   
		if intCodColaboradorSubstituto = "" then intCodColaboradorSubstituto = "0"
		if intCodColaboradorSubstituido = "" then intCodColaboradorSubstituido = "0"
		%>
        <br>
        <br>
        <br>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td colspan="2">
			
			<p align="justify">
			  <span class="textoRelatorio"><br>
			  <strong>DE: <%=UCASE(rs("MANTENEDORA"))%></strong><br>
			<br>
			<strong>PARA: <%=rs("Empresa_Substituido")%></strong><br>
			<br>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Estamos encaminhando o (a) Senhor (a)<strong> <%=rs("NomeColaboradorSubstituto")%></strong> matr&iacute;cula <strong><%=rs("CodFuncionalSubstituto")%></strong>, 
            lotado no (a) <strong><%=rs("Empresa_Substituto")%></strong>, para que o (a) 
            mesmo (a) possa exercer a fun&ccedil;&atilde;o descrita na modula&ccedil;&atilde;o abaixo, 
            do (a)<strong> <%=rs("NOmeColaboradorSubstituido")%></strong> matr&iacute;cula <strong><%=rs("CodFuncionalSubstituido")%></strong>, da fun&ccedil;&atilde;o <strong><%=rs("funcao")%></strong>, com 
            in&iacute;cio em <strong><%=formatadataAP(rs("dataInicial"))%></strong> &agrave; <strong><%=formatadataAP(rs("dataFinal"))%></strong>.<br>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br>
			  </span>
            <br>
			<%
			rs.close
			
		  if trim(intCodColaboradorSubstituido) <> "" then
				sql = "select dd.Codigo, dd.Situacao_disciplinar, dd.Total_Aulas, dd.Ano_letivo, dd.Semestre, e.RAZAOSOCIAL,  t.desc_turno as turno, "
				sql = sql & " c.descricao as curso, p.descricao as periodo, d.Desc_Disciplina as disciplina, dd.status, "
				sql = sql & " isnull(dd.Cod_Substituicao_Deficit,'') as Cod_Substituicao_Deficit "
				sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE dd"
				sql = sql & " inner join SEG_EMPRESA e on e.CODIGO = dd.Cod_empresa "
				sql = sql & " left join SCA_CURSO c on c.cod_curso = dd.cod_curso "
				sql = sql & " left join SCA_periodo p on p.cod_periodo = dd.cod_periodo "
				sql = sql & " left join SCA_disciplina d on d.cod_disciplina = dd.cod_disciplina "
				sql = sql & " left join SRH_TURNO t on t.cod_turno = dd.cod_turno"
				sql = sql & " where dd.Cod_Colaborador = " & intCodColaboradorSubstituido	
				sql = sql & " and dd.ano_letivo = " & strAnoLetivo
				sql = sql & " and dd.Status = 'A'" 
				rs.open sql, cnn
				if rs.eof = false then
					%>
  				<table width = "95%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
					<tr bgcolor="#E5E5E5" class="celula">
					  <td height="26" colspan="9" align="center" bgcolor="#FFFFFF" class="celula"><strong class="TituloFormulario">Modula&ccedil;&atilde;o (Substitu&iacute;do)</strong></td>
				    </tr>
					<tr bgcolor="#E5E5E5" class="celula">
					  <td class="celula">Unidade</td>
					<td class="celula">Curso</td>
					<td width="142" height="26" class="celula">Per&iacute;odo</td>
					<td width="41" class="celula">Ano</td>
					<td width="64" class="celula">Semestre</td>
					<td class="celula">Sit. Disciplinar</td>
					<td class="celula">Disciplina</td>
					<td width="43" class="celula">Aulas</td>
					<td width="29" class="celula">Sit.</td>
					</tr>
					<%
					while not rs.eof
					   cont = cont + 1	
					   strSituacaoDisciplinar = rs("Situacao_disciplinar")
					   if strSituacaoDisciplinar = "D" then strSituacaoDisciplinar = "Disciplinar"
					   if strSituacaoDisciplinar = "I" then strSituacaoDisciplinar = "Interdisciplinar"
					   strMsgSemestre = trim(rs("Semestre"))
					   if strMsgSemestre = "3" then strMsgSemestre = "Anual"
					   if rs("Cod_Substituicao_Deficit") = "0" then
						   %>
				      <tr bgcolor="#FFFFFF" class="celula"  style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"  onClick="return resultadoConsulta('<%=rs("codigo")%>')">
							 <td width="407" class="celula9">&nbsp;<%=trim(rs("RAZAOSOCIAL"))%></td>
						   <td width="300" class="celula9">&nbsp;<%=trim(rs("curso"))%></td>
						   <td height="26" class="celula9">&nbsp;<%=trim(rs("periodo"))%></td>
						   <td height="26" class="celula9"><%=trim(rs("Ano_letivo"))%></td>
						   <td height="26" class="celula9"><%=trim(strMsgSemestre)%></td>
						   <td width="102" class="celula9">&nbsp;<%=strSituacaoDisciplinar%></td>
						   <td width="115" height="26" class="celula9">&nbsp;<%=trim(rs("disciplina"))%></td>
						   <td height="26" class="celula9">&nbsp;<%=trim(rs("Total_Aulas"))%></td>
						   <td height="26" class="celula9"><%=trim(rs("status"))%></td>
			      </tr>
<%
					   else
					   %>
						   <tr bgcolor="#FFFFFF" class="celula">
							 <td width="407" class="celula9">&nbsp;<%=trim(rs("RAZAOSOCIAL"))%></td>
						   <td width="300" class="celula9">&nbsp;<%=trim(rs("curso"))%></td>
						   <td height="26" class="celula9">&nbsp;<%=trim(rs("periodo"))%></td>
						   <td height="26" class="celula9"><%=trim(rs("Ano_letivo"))%></td>
						   <td height="26" class="celula9"><%=trim(strMsgSemestre)%></td>
						   <td width="102" class="celula9">&nbsp;<%=strSituacaoDisciplinar%></td>
						   <td width="115" height="26" class="celula9">&nbsp;<%=trim(rs("disciplina"))%></td>
						   <td height="26" class="celula9">&nbsp;<%=trim(rs("Total_Aulas"))%></td>
						   <td height="26" class="celula9"><%=trim(rs("status"))%></td>
						   </tr>
			   <% 
					   end if				
					   rs.movenext
					wend
					
				end if
				rs.close
			 end if	
			 %>
			</table>   
			   
            <br><%
				
			sql = "select dd.Codigo, dd.Situacao_disciplinar, p.Descricao as periodo, t.desc_turno as turno, tur.desc_turno as Desc_turno_opcional,  "
			sql = sql & " dd.Total_Aulas, dd.tipo_contratacao, dd.periodo_inicial, dd.periodo_final, "
			sql = sql & " dd.Ano_letivo, dd.Semestre, e.RAZAOSOCIAL, "
			sql = sql & " f.Desc_Funcao as funcao, isnull(dd.Cod_Substituicao,'0') as Cod_Substituicao, "
			sql = sql & " d.Desc_Disciplina as disciplina, dd.status"
			sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE dd "
			sql = sql & " inner join SEG_EMPRESA e on e.CODIGO = dd.Cod_empresa "
			sql = sql & " left join SRH_FUNCAOCOLABORADOR f on f.cod_funcao = dd.cod_funcao"
			sql = sql & " left join SCA_disciplina d on d.cod_disciplina = dd.cod_disciplina"
			sql = sql & " left join SCA_periodo p on p.cod_periodo = dd.cod_periodo"
			sql = sql & " left join SRH_TURNO t on t.cod_turno = dd.cod_turno"
			sql = sql & " left join SRH_TURNO tur on tur.cod_turno = dd.cod_turno_opcional "
			sql = sql & " where dd.Cod_Colaborador = " & intCodColaboradorSubstituto	
			sql = sql & " and dd.ano_letivo = " & strAnoLetivo
			sql = sql & " and isnull(dd.Cod_Substituicao,'0') <> 0 "
			''sql = sql & " and dd.Status = 'A'" 
			sql = sql & " order by dd.tipo_contratacao desc, dd.codigo"
			rs.open sql, cnn
			if rs.eof = false then
		        %>
			  <table width = "95%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
	            
	              <td height="26" colspan="9" class="celula"><div align="center"><strong class="TituloFormulario">Modula&ccedil;&atilde;o (Substitu&iacute;&ccedil;&atilde;o)</strong></div></td>
                </tr>
	            <tr bgcolor="#E5E5E5" class="celula">
	              <td height="26" class="celula">Unidade</td>
		        <td class="celula">Fun&ccedil;&atilde;o</td>
		        <td class="celula">Per&iacute;odo</td>
		        <td class="celula">Turno</td>
		        <td class="celula"><div align="center">Início</div></td>
		        <td class="celula"><div align="center">Fim</div></td>
		        <td class="celula">Sit. Disciplinar</td>
		        <td class="celula">Disciplina</td>
		        <td width="42" class="celula">Aulas/Entrada</td>
		        </tr>
			    <%
			    while not rs.eof
				   cont = cont + 1	
				   
				   turno = rs("turno")
					
                    if not isnull(rs("Desc_turno_opcional")) then
                       	turno = rs("Desc_turno_opcional")
					end if
					
					
				   strSituacaoDisciplinar = rs("Situacao_disciplinar")
				   if strSituacaoDisciplinar = "D" then strSituacaoDisciplinar = "Disciplinar"
				   if strSituacaoDisciplinar = "I" then strSituacaoDisciplinar = "Interdisciplinar"
					   %>
					   <tr class="celula"  style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)">
                           <td width="371" class="celula9">&nbsp;<%=trim(rs("RAZAOSOCIAL"))%></td>
                           <td width="456" class="celula9">&nbsp;<%=trim(rs("funcao"))%><%=periodo%></td>
                           <td width="132" class="celula9">&nbsp;<%=trim(rs("periodo"))%></td>
                           <td width="132" class="celula9">&nbsp;<%=trim(turno)%></td>
                           <td width="132" class="celula9"><div align="center">&nbsp;<%=formatadataAp(trim(rs("periodo_inicial")))%></div></td>
                           <td width="132" class="celula9"><div align="center">&nbsp;<%=formatadataAp(trim(rs("periodo_final")))%></div></td>
                           <td width="132" class="celula9">&nbsp;<%=strSituacaoDisciplinar%></td>
                           <td width="150" height="26" class="celula9">&nbsp;<%=trim(rs("disciplina"))%></td>
                           <td height="26" class="celula9">&nbsp;<%=trim(rs("Total_Aulas"))%></td>
                       </tr>
                   <% 
				   rs.movenext
			    wend
			    %>
			    <tr> 

			    <td height="21" colspan="10" class="celula"><span class="texto">Total Registros :</span> <%=cont%></td>
			    <%
		    end if
		    rs.close
			 %>
	            </table>            
			  <span class="textoRelatorio">
			<div align="right" class="textoRelatorio"><%=Session("CidadeEmpresaWeb")%>, <%=day(date)%> de <%=monthName(month(date))%> de <%=year(date)%>.</div>
			<br>
			<span class="textoRelatorio">Atenciosamente, </span>
			<br>
			<br>
			<br>
            <br>
		    </span>			
            </p>
			<div align="center" class="textoRelatorio">
			___________________________________________
			<br>
			Ass. do Funcionário do RH - SME			</div>
			<span class="textoRelatorio"><br>
			<br>
			<br>
			<br>
			</span>
			<div align="center" class="textoRelatorio">
			___________________________________________
			<br>
			Servidor / Gestor da Unidade		  </div>			</td>
		  </tr>
		</table>
	<%
	end if
	%>			
</body>
</html>