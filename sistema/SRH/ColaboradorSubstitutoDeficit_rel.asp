<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<%
Response.AddHeader "Content-Type", "text/html; charset=utf-8"
Response.AddHeader "Pragma", "no-cache"
response.Charset="utf-8"
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 15/03/2010
	::	Objetivo Pagina...: Ficha Individual do Colaborador
-->
<html>
<head>
<title><%=session("Titulo")%> - Ficha Individual do Aluno</title>
<meta http-equiv="Content-Type" content="text/html">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
</head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%
	strorigem				= Trim(Request.QueryString("origem"))
	strTipo					= Trim(Request.QueryString("Tipo"))
	strTipoModSub			= Trim(Request.QueryString("TipoModSub")) 'C - contrato | P - periodo | S - Substituicao
	
	if strTipoModSub = "P" then strTituloRelatorio  	= "SUBSTITUIÇÃO DIRETRIZ OU DÉFICIT"
	if strTipoModSub = "S" then strTituloRelatorio  	= "SUBSTITUIÇÃO"
	if strTipoModSub = "C" then strTituloRelatorio  	= "MODULAÇÃO"

%>
<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
<%
	strCod_empresa 			= Session("CodEmpresa")
	strCodColaborador		= Trim(Request.QueryString("CodColaborador"))
	strCodigo				= Trim(Request.QueryString("Codigo"))
	strAnoLetivo			= Trim(Request.QueryString("AnoLetivo"))
	strStatus				= Trim(Request.QueryString("Status"))
	intSemestre 			= Session("strSemestre")
	
	sql = "select dd.Codigo, dd.Situacao_disciplinar, p.Descricao as periodo, t.desc_turno as turno, tur.desc_turno as Desc_turno_opcional, dd.Cod_Colaborador, "
	sql = sql & " dd.Total_Aulas, dd.tipo_contratacao, dd.periodo_inicial, dd.periodo_final, dd.DataInicial, dd.DataFinal, SC.NOME, SC.Codigo as Matricula, sc.CodFuncional, "
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
	sql = sql & " LEFT JOIN SRH_COLABORADOR sc ON SC.codigo = DD.Cod_Colaborador"
	sql = sql & " where dd.Cod_Colaborador = " & strCodColaborador
	sql = sql & " and dd.ano_letivo = " & strAnoLetivo
	if strStatus = "A" then
		sql = sql & " and dd.tipo_contratacao = '" & strOrigem & "'"
	end if
	sql = sql & " and dd.status = '" & strStatus & "'"
	sql = sql & " order by dd.tipo_contratacao desc, dd.codigo"
	if ucase(session("usuarioWeb")) = "SERGIO"  THEN
		'response.write "<hr>"
		'response.end	
	end if
	rs.open sql, cnn
	if rs.eof = false then

		intCodColaboradorSubstituto	= Trim(rs("Cod_Colaborador"))
		intCodColaboradorSubstituido	= Trim(rs("Cod_Colaborador"))
		
		sql = " SELECT c.Codigo, C.nome, se.RAZAOSOCIAL, se.MANTENEDORA "
		sql = sql & " FROM SRH_COLABORADOR C"
		sql = sql & " INNER JOIN SEG_EMPRESA se ON se.codigo = C.codLotacao "
		sql = sql & " Where C.Codigo  = " & rs("Cod_Colaborador")
		rsAux.open sql, cnn
		if rsAux.eof = false then
			strLotado = trim(rsAux("RAZAOSOCIAL"))
			strMantenedora = trim(rsAux("MANTENEDORA"))
		end if
		rsAux.close

		%>
        <br>
        <br>
        <br>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td colspan="2">
			
			<p>
			  <span class="textoRelatorio"><br>
			  <strong>DE: <%=strMantenedora%></strong><br>
			<br>
			<strong>PARA: <%=trim(rs("RAZAOSOCIAL"))%></strong><br>
			
            <%if strorigem = "A" then
				
				strDataTitulo  = "Data Final"
				
				 %>
            	
            <br>
            Estamos encaminhando o (a) Senhor (a) <strong><%=trim(rs("NOME"))%></strong> matrícula <strong><%=trim(rs("CodFuncional"))%></strong>, lotado 
        
            na <strong><%=trim(strLotado)%></strong>, para que o (a) 
            
            mesmo (a) possa exercer a(s) funções de déficit realacionadas abaixo:  </strong> <br><br>
            
            <%end if %>
           
            <%if strorigem = "C" then 
				
				strDataTitulo  = "Data Inicial / Final"
			%>
            	
            <br>
            Estamos encaminhando o (a) Senhor (a) <strong><%=trim(rs("NOME"))%></strong> matrícula <strong><%=trim(rs("CodFuncional"))%></strong>, lotado 
        
            na <strong><%=trim(strLotado)%></strong>, para que o (a) 
            
            mesmo (a) possa exercer a(s) funções realacionadas abaixo:  </strong>
            
            <%end if %>
            
           </span>
           
           </p>
          
			<span class="textoRelatorio">
     		<%     
	 
			rs.close
            strTipoModulacao = "I"
	
	
		  if trim(intCodColaboradorSubstituto) <> "" then
		  
				sql = "select dd.Codigo, dd.Situacao_disciplinar, isnull(dd.Total_Aulas,0) as Total_Aulas, dd.Ano_letivo, dd.Semestre, e.RAZAOSOCIAL, f.Desc_Funcao as funcao, "
				sql = sql & " t.desc_turno as turno, tur.desc_turno as Desc_turno_opcional, dd.periodo_inicial, dd.periodo_Final, dd.DataInicial, dd.DataFinal, "
				sql = sql & " c.descricao as curso, p.descricao as periodo, d.Desc_Disciplina as disciplina, dd.status, isnull(dd.Cod_Substituicao_Deficit,'') as Cod_Substituicao_Deficit "
				sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE dd"
				sql = sql & " inner join SEG_EMPRESA e on e.CODIGO = dd.Cod_empresa "
				sql = sql & " LEFT join SCA_CURSO c on c.cod_curso = dd.cod_curso "
				sql = sql & " left join SCA_periodo p on p.cod_periodo = dd.cod_periodo "
				sql = sql & " left join SRH_FUNCAOCOLABORADOR f on f.cod_funcao = dd.cod_funcao"
				sql = sql & " left join SCA_disciplina d on d.cod_disciplina = dd.cod_disciplina "
				sql = sql & " left join SRH_TURNO t on t.cod_turno = dd.cod_turno"
				sql = sql & " left join SRH_TURNO tur on tur.cod_turno = dd.cod_turno_opcional "
				sql = sql & " where dd.Cod_Colaborador = " & intCodColaboradorSubstituto
				sql = sql & " and dd.ano_letivo = " & strAnoLetivo
				sql = sql & " and isnull(cod_substituicao_deficit,'0') = '0' "	

				if strTipoModSub = "A" then
					sql = sql & " and isnull(dd.Cod_Substituicao,'0')=0" 'somente modulação
					sql = sql & " and dd.tipo_contratacao = 'A'" 'por periodo
				end if
				if strTipoModSub = "C" then
					sql = sql & " and isnull(dd.Cod_Substituicao,'0')=0" 'somente modulação
				end if
				if strTipoModSub = "S" then
					sql = sql & " and isnull(dd.Cod_Substituicao,'0')<>0" 'somente substituicao
				end if
				
				sql = sql & " and dd.status = '" & strStatus & "'" 
				
	if ucase(session("usuarioWeb")) = "SERGIO"  THEN
		'response.write "<hr>" & sql
		'response.write "<hr>"
		'response.end	
	end if
				rs.open sql, cnn
				if rs.eof = false then
					%>
					<table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
					<tr bgcolor="#E5E5E5" class="celula">
					  <td height="26" colspan="11" align="center" bgcolor="#FFFFFF" class="celula"><strong class="TituloFormulario">Modula&ccedil;&atilde;o (Substituto)</strong></td>
				    </tr>
					<tr bgcolor="#E5E5E5" class="celula">
					  <td class="celula">Unidade</td>
                      <td class="celula">Função</td>
                      <%if strorigem = "A" then%>
					  <td class="celula">Data Inicial</td>
                      <%END IF%>
                      <%if strTipo = "" then%>
					<td class="celula">Curso</td>
					<td width="90" class="celula">Per&iacute;odo</td>
                    <%END IF%>
					<td width="231" class="celula"><%=strDataTitulo%></td>
					<td width="133" height="26" class="celula">Turno</td>
					<td width="36" class="celula">Ano</td>
                     <%if strTipo = "" then%>
					<td class="celula">Sit. Disciplinar</td>
					<td class="celula">Disciplina</td>
                    <%END IF%>
					<td width="41" class="celula">Aulas</td>
					<td width="38" class="celula">Sit.</td>
					</tr>
					<%
					while not rs.eof
					   cont = cont + 1	
					   
					   turno = rs("turno")
					
						if not isnull(rs("Desc_turno_opcional")) then
							turno = rs("Desc_turno_opcional")
						end if
						
						if strorigem = "A"  then
							strDataFinal  = formataDataAP(trim(rs("periodo_Final")))
							if trim(rs("DataFinal")) <> "" then
								strDataFinal  = formataDataAP(rs("DataFinal"))
							end if
						else
						
							if trim(rs("DataInicial")) <> "" then 
								strDataInicial  = formataDataAP(rs("DataInicial"))
							end if
							
							if trim(rs("DataFinal")) <> "" then
								strDataFinal  = formataDataAP(rs("DataFinal"))
							end if
							
							strDataFinal  = strDataInicial & "-" & strDataFinal
							
						end if 
						
						
					
					   strSituacaoDisciplinar = rs("Situacao_disciplinar")
					   if strSituacaoDisciplinar = "D" then strSituacaoDisciplinar = "Disciplinar"
					   if strSituacaoDisciplinar = "I" then strSituacaoDisciplinar = "Interdisciplinar"
					   strMsgSemestre = trim(rs("Semestre"))
					   if strMsgSemestre = "3" then strMsgSemestre = "Anual"
					   Total_Aulas = Total_Aulas + rs("Total_Aulas")
					   
					   if rs("Cod_Substituicao_Deficit") = "0" then
						   %>
						   <tr class="celula" >
							 <td width="341" class="celula9">&nbsp;<%=trim(rs("RAZAOSOCIAL"))%></td>
                             <td width="341" class="celula9">&nbsp;<%=trim(rs("funcao"))%></td>
                             <%if strorigem = "A" then%>
							 <td width="80" class="celula9">&nbsp;<%=formataDataAP(trim(rs("periodo_inicial")))%></td>
                             <%END IF%>
                             <%if strTipo = "" then%>
                               <td width="122" class="celula9">&nbsp;<%=trim(rs("curso"))%></td>
                               <td class="celula9"><%=trim(rs("periodo"))%></td>
                                <%END IF%>
					   		<td class="celula9"><%=strDataFinal%></td>
                          
						   <td height="26" class="celula9"><%=trim(turno)%>&nbsp;</td>
						   <td height="26" class="celula9"><%=trim(rs("Ano_letivo"))%></td>
						   
                           <%if strTipo = "" then%>
                             <td width="90" class="celula9">&nbsp;<%=strSituacaoDisciplinar%></td>
                             
						   <td width="95" height="26" class="celula9">&nbsp;<%=trim(rs("disciplina"))%></td>
                           <%END IF%>
						   <td height="26" class="celula9">&nbsp;<%=trim(rs("Total_Aulas"))%></td>
						   <td height="26" class="celula9"><%=trim(rs("status"))%></td>
						   </tr>
					   <%
					   else
					   %>
						   <tr bgcolor="#FFFFFF" class="celula">
							 <td width="341" class="celula9">&nbsp;<%=trim(rs("RAZAOSOCIAL"))%></td>
							 <td width="80" class="celula9">&nbsp;<%=trim(rs("Funcao"))%></td>
						   <td width="122" class="celula9">&nbsp;<%=trim(rs("curso"))%></td>
						   <td class="celula9"><%=trim(rs("periodo"))%></td>
						   <td class="celula9">&nbsp;</td>
						   <td height="26" class="celula9">&nbsp;</td>
                            <%if strTipo = "" then%>
						   <td height="26" class="celula9"><%=trim(rs("Ano_letivo"))%></td>
						   <td width="90" class="celula9">&nbsp;<%=strSituacaoDisciplinar%></td>
						   <td width="95" height="26" class="celula9">&nbsp;<%=trim(rs("disciplina"))%></td>
                           <%END IF%>
						   <td height="26" class="celula9">&nbsp;<%=trim(rs("Total_Aulas"))%></td>
						   <td height="26" class="celula9"><%=trim(rs("status"))%></td>
						   </tr>
        				<% 
					   end if				
					   rs.movenext
					wend
					%>
						   <tr bgcolor="#FFFFFF" class="celula">
                           	 <%if strTipo = "" then%>
						     <td height="26" colspan="<%if strorigem = "A" then%>10<%else%>9<%end if%>" align="right" class="celula9">(Total de Registros: <%=cont%>)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Total&nbsp;&nbsp; </td>
                             <%else%>
                              <td height="26" colspan="<%if strorigem = "A" then%>6<%else%>5<%end if%>" align="right" class="celula9">(Total de Registros: <%=cont%>)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Total&nbsp;&nbsp; </td>
                               <%end if%>
						     <td height="26" class="celula9">&nbsp;<%=Total_Aulas%></td>
						     <td height="26" class="celula9">&nbsp;</td>
				      </tr>
					
					<%
				end if
				rs.close
			 end if	
			 %>
			</table>   
			   
            <br>
	    <%
			sql = "select dd.Codigo, dd.Situacao_disciplinar, dd.Total_Aulas, dd.Ano_letivo, dd.Semestre, e.RAZAOSOCIAL, f.Desc_Funcao as funcao, "
			sql = sql & " c.descricao as curso, p.descricao as periodo, dd.DataInicial, dd.DataFinal, d.Desc_Disciplina as disciplina, dd.status, isnull(dd.Cod_Substituicao_Deficit,'') as Cod_Substituicao_Deficit "
			sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE dd"
			sql = sql & " inner join SEG_EMPRESA e on e.CODIGO = dd.Cod_empresa "
			sql = sql & " inner join SCA_CURSO c on c.cod_curso = dd.cod_curso "
			sql = sql & " left join SRH_FUNCAOCOLABORADOR f on f.cod_funcao = dd.cod_funcao"
			sql = sql & " left join SCA_periodo p on p.cod_periodo = dd.cod_periodo "
			sql = sql & " left join SCA_disciplina d on d.cod_disciplina = dd.cod_disciplina "
			sql = sql & " where dd.Cod_Colaborador = " & intCodColaboradorSubstituto	
			sql = sql & " and isnull(cod_substituicao_deficit,'0') <> '0' "	
			sql = sql & " and dd.tipo_contratacao = '" & strOrigem & "'"
			rs.open sql, cnn
			if rs.eof = false then
		        %>
			  <table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
	            <tr bgcolor="#E5E5E5" class="celula">
	              <td height="21" colspan="9" align="center" bgcolor="#FFFFFF" class="TituloFormulario">Modula&ccedil;&atilde;o (D&eacute;ficit)</td>
	              </tr>
	            <tr bgcolor="#E5E5E5" class="celula">
	              <td height="26" class="celula">Unidade</td>
		          <td class="celula">Curso</td>
		          <td class="celula">Per&iacute;odo</td>
		          <td class="celula">Data Inicial / Final</td>
		          <td class="celula">Ano</td>
		        <td class="celula">Sit. Disciplinar</td>
		        <td class="celula">Disciplina</td>
		        <td class="celula">Aulas</td>
		        <td width="26" class="celula">Sit.</td>
	            </tr>
			    <%
			    while not rs.eof
				   cont = cont + 1	
				   %>
				   <tr bgcolor="#FFFFFF" class="celula" >
				     <td width="223" class="celula9">&nbsp;<%=trim(rs("RAZAOSOCIAL"))%></td>
				     <td width="220" class="celula9">&nbsp;<%=trim(rs("curso"))%></td>
				     <td width="96" class="celula9"><%=trim(rs("periodo"))%></td>
				     <td width="96" class="celula9"><%=trim(rs("DataInicial"))%> / <%=trim(rs("DataFinal"))%></td>
				     <td width="35" class="celula9"><%=trim(rs("Ano_letivo"))%></td>
				   <td width="83" class="celula9">&nbsp;<%=strSituacaoDisciplinar%></td>
				   <td width="90" class="celula9">&nbsp;<%=trim(rs("disciplina"))%></td>
				   <td width="42" height="26" class="celula9">&nbsp;<%=trim(rs("Total_Aulas"))%></td>
				   <td height="26" class="celula9" align="center"><%=trim(rs("status"))%></td>
				   </tr>
				   <%				
				   rs.movenext
			    wend
			    %>
            </table>
                <br>
			    <%
		    end if
            %>        
            
            <br>
			</span>
			<div align="right" class="textoRelatorio"><%=Session("CidadeEmpresaWeb")%>, <%=day(date)%> de <%=monthName(month(date))%> de <%=year(date)%>.</div>
            <br>
            <span class="textoRelatorio">Atenciosamente, <br>
            </span><span class="textoRelatorio"><br>
			<br>
			<br>
			<br>
			<br>
			</span>
			<div align="center" class="textoRelatorio">
			___________________________________________
			<br>
			Ass. do Funcionário do RH - SME
			</div>
			<span class="textoRelatorio"><br>
			<br>
			<br>
			<br>
			</span>
			<div align="center" class="textoRelatorio">
			___________________________________________
			<br>
			Servidor / Gestor da Unidade
		  </div>
			
			</td>
		  </tr>
		</table>
	<%
	end if
	%>			
</body>
</html>