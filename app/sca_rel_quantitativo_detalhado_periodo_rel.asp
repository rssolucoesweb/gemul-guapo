<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
SESSION.Timeout = 1200
Server.ScriptTimeout = 1200
%>
<html>
<head>
<title>GEMUL - Quantitativos</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet" href="css_rel/Estilo_Impressao.css">
<script src="js/js_funcoes_gerais.js"></script>
<script src="js_app/js_barra_movel.js"></script>
<script>
	function abrePaginaListaMatricula(Periodo, sexo, cod_empresa, turno, situacaoaluno, curso){
		var caminho = "sca_rel_quantitativo_detalhado_periodo_rel_matriculas.asp?Periodo="+Periodo+"&sexo="+sexo+"&cod_empresa="+cod_empresa+"&turno="+turno+"&situacaoaluno="+situacaoaluno+"&curso="+curso;
		window.open(caminho,"abreConsulta","top=50,left=50,height=600,width=600,menubar=no,toolbar=no,scrollbars=yes,status=yes");
	}
</script>
</head>
<body>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="includes/inc_Botoes_relatorio.asp"-->
<!--#include file="includes/inc_aguarde.asp"-->
<br>
<%

	dim intPagina
	
	if Trim(Request("txtAnoLetivo")) <> "" then
	   strAnoLetivo 			= Trim(Request("txtAnoLetivo"))
	else
	   strAnoLetivo = session("strAnoLetivo")   
	end if   

	strlpp 					= Trim(Request.Form("cmblpp"))
	strclasse               = "celula" 'Trim(Request.Form("cmbTamanhoFonteArial"))
	strTipoCurso 			= Trim(Request.Form("cmbTipoCurso"))
	intCodEmpresa 			= Trim(Request.Form("cmbEmpresaGrupo"))
	codSituacaoAluno		= Trim(Request.Form("cmbSituacaoAluno"))
	intCodTurno				= Trim(Request.Form("cmbTurnoRH"))
	
	sql = "SELECT COD_TURNO, DESC_TURNO"
	sql = sql & " FROM SRH_TURNO"
	SQL = SQL & " WHERE cod_turno = " & intCodTurno & " and Cod_Grupo=" & Session("CodGrupo")
	rs.open sql, cnn
	if NOT rs.eof then
		strDescTurno = rs("DESC_TURNO")
	else
		strDescTurno = "0"
	end if
	rs.close

    
	
	sql = "SELECT DESC_SITUACAOALUNO"
	sql = sql & " FROM SCA_SITUACAOALUNO where COD_SITUACAOALUNO = " & codSituacaoAluno
	rs.open sql, cnn
	if NOT rs.eof then
		situacaoAluno = rs("DESC_SITUACAOALUNO")
	end if
	rs.close
	strTituloRelatorio  	= "QUANTITAVOS DE ALUNOS - DETALHADO<br><strong>" & strTipoCurso & " - " & strAnoLetivo & "<br>" & situacaoAluno & "</strong>"
	
	sql = "exec [dbo].[SP_SCA_QuantAlunoPorPeriodoSexo_periodos] " & session("codGrupo") & "," & strAnoLetivo & ",'" &strTipoCurso& "','" & strDescTurno & "','" & situacaoAluno & "'," & intCodEmpresa

	vetPeriodos = null
	rs.open sql, cnn
	if not rs.eof then
		vetPeriodos = rs.getRows
		rs.close			
	else
		rs.close	
		%>
		<script>
			alert("Não foi encontrado registros para o Curso informado!");
			window.location='sca_rel_quantitativo_detalhadoCon.asp';
		</script>
		<%
		response.end
	end if
	
	
	sub mostraCabecalho(vetPeriodos)
	%>
	<!--#include file="includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <%
	  if strSubTitulo <> "" then
	     %>
	     <tr bgcolor="#CCCCCC">
	     <td colspan="4" class="<%=strclasse%>"><div align="center"><%=strSubTitulo%></div></td>
         </tr>
		 <%
	  end if	
	  %> 
      <tr bgcolor="#CCCCCC">
        <td width="25%" rowspan="2" class="<%=strclasse%>"><div align="center"><strong>Unidade de Ensino</strong></div></td>
	       <td width="5%" rowspan="2" class="<%=strclasse%>"><div align="center"><strong>Turno</strong></div></td>
           <%for i=0 to ubound(vetPeriodos,2)%>
	       <td colspan="2" align="center" class="<%=strclasse%>"><strong><%=vetPeriodos(0,i)%></strong></td>
           <%next%>
           <td colspan="3" align="center" class="<%=strclasse%>"><strong>Total</strong></td>
      </tr>
      <tr bgcolor="#CCCCCC">
		<%for i=0 to ubound(vetPeriodos,2)%>
		<td width="1%" align="center" class="<%=strclasse%>"><strong>M</strong></td>
		<td width="1%" align="center" class="<%=strclasse%>"><strong>F</strong></td>
        <%next%>
		<td width="1%" align="center" class="<%=strclasse%>"><strong>M</strong></td>
		<td width="1%" align="center" class="<%=strclasse%>"><strong>F</strong></td>
        <td width="1%" align="center" class="<%=strclasse%>"><strong>M+F</strong></td>
	  </tr>
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub
%>
<%
	intPagina = 1
	mostraCabecalho vetPeriodos
	cont = 0
	empresa = ""
	turno = ""
	total_M_linha = 0
	total_F_linha = 0
	total_linha = 0
	
	sql = "exec [dbo].[SP_SCA_QuantAlunoPorPeriodoSexo_resultado] " & session("codGrupo") & "," & strAnoLetivo & ",'" & strTipoCurso & "','" & strDescTurno & "','" & situacaoAluno & "'," & intCodEmpresa
	'response.write sql
	corLinha = "bgcolor='#CCCCCC'"
	rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof
            if trim(rs("cod_escola")) <> trim(cod_escola) then
				if trim(corLinha) = "" then
					corLinha = "bgcolor='#CCCCCC'"		
				else
					corLinha = ""		
				end if
			end if
			
			linhas = rs("linhas")
			%>
			  <tr <%=corLinha%>>
              	<%if trim(rs("cod_escola")) <> trim(cod_escola) or (isnull(rs("cod_escola"))) then%>
				<td <%=corLinha%> <%=linhas%> class="<%=strclasse%>" align="left"><%=rs("EMPRESA")%></td>
              	<%end if%>
                <td <%=corLinha%> class="<%=strclasse%>" align="left"><%=rs("TURNO")%></td>
                <%for i=0 to ubound(vetPeriodos,2)%>
                    <td <%=corLinha%> style="cursor:pointer" onClick="return abrePaginaListaMatricula('<%=vetPeriodos(0,i)%>','M','<%=rs("cod_escola")%>','<%=rs("turno")%>','<%=situacaoAluno%>','<%=strTipoCurso%>')" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" align="center" class="<%=strclasse%>"><%=rs("M_"& vetPeriodos(0,i))%></td>
                    <td <%=corLinha%> style="cursor:pointer" onClick="return abrePaginaListaMatricula('<%=vetPeriodos(0,i)%>','F','<%=rs("cod_escola")%>','<%=rs("turno")%>','<%=situacaoAluno%>','<%=strTipoCurso%>')" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" align="center" class="<%=strclasse%>"><%=rs("F_"& vetPeriodos(0,i))%></td>
                	<%
					if rs("M_"& vetPeriodos(0,i))<>"" and not isnull(rs("M_"& vetPeriodos(0,i))) then
						total_M_linha = total_M_linha + rs("M_"& vetPeriodos(0,i))
						total_linha = total_linha + rs("M_"& vetPeriodos(0,i))
					end if
					if rs("F_"& vetPeriodos(0,i))<>"" and not isnull(rs("F_"& vetPeriodos(0,i))) then
						total_F_linha = total_F_linha + rs("F_"& vetPeriodos(0,i))
						total_linha = total_linha + rs("F_"& vetPeriodos(0,i))
					end if
				  next%>
                <td <%=corLinha%> class="<%=strclasse%>" align="center"><%=total_M_linha%></td>
                <td <%=corLinha%> class="<%=strclasse%>" align="center"><%=total_F_linha%></td>
                <td <%=corLinha%> class="<%=strclasse%>" align="center"><%=total_linha%></td>
			  </tr>
			<%
			total_M_linha = 0
			total_F_linha = 0
			total_linha = 0
			cod_escola    = rs("cod_escola")
			rs.movenext
		wend
		rs.close
		
	else
		%>
		  <tr>
			<td colspan="7" class="<%=strclasse%>" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
		  </tr>
		<%
		rs.close
	end if
	
%>
</table>
</body>
<script>
	aguarde.style.display="none";
</script>
</html>
