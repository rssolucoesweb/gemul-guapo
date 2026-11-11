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
	function abrePaginaListaMatricula(idade, sexo, cod_empresa, turno, situacaoaluno, curso){
		var caminho = "sca_rel_quantitativo_detalhado_rel_matriculas.asp?idade="+idade+"&sexo="+sexo+"&cod_empresa="+cod_empresa+"&turno="+turno+"&situacaoaluno="+situacaoaluno+"&curso="+curso;
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
	
	sql = "exec [dbo].[SP_SCA_QuantAlunoPorIdadeSexo_idades] " & session("codGrupo") & "," & strAnoLetivo & ",'" &strTipoCurso& "','" & strDescTurno & "','" & situacaoAluno & "'," & intCodEmpresa
	if session("usuarioWeb") = "SERGIO" THEN
		response.write sql
	END IF
	vetIdades = null
	rs.open sql, cnn
	if not rs.eof then
		vetIdades = rs.getRows
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
	
	
	sub mostraCabecalho(vetIdades)
	%>
	<!--#include file="includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <%
	  if strSubTitulo <> "" then
	     %>
	     <tr bgcolor="#CCCCCC">
	     <td colspan="4" class="<%=strclasse%>"><div ="center"><%=strSubTitulo%>&nbsp;</div></td>
         </tr>
		 <%
	  end if	
	  %> 
      <tr bgcolor="#CCCCCC">
        <td width="25%" rowspan="2" class="<%=strclasse%>"><div ="center"><strong>Unidade de Ensino</strong></div></td>
	       <td width="5%" rowspan="2" class="<%=strclasse%>"><div ="center"><strong>Turno</strong></div></td>
           <%for i=0 to ubound(vetIdades,2)%>
	       <td colspan="2" ="center" class="<%=strclasse%>"><strong><%=vetIdades(0,i)%><br>anos</strong></td>
           <%next%>
           <td colspan="3" ="center" class="<%=strclasse%>"><strong>Total</strong></td>
      </tr>
      <tr bgcolor="#CCCCCC">
		<%for i=0 to ubound(vetIdades,2)%>
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
	mostraCabecalho vetIdades
	cont = 0
	empresa = ""
	turno = ""
	total_M_linha = 0
	total_F_linha = 0
	total_linha = 0
	cod_escola = 0
		
	sql = "exec [dbo].[SP_SCA_QuantAlunoPorIdadeSexo_resultado] " & session("codGrupo") & "," & strAnoLetivo & ",'" & strTipoCurso & "','" & strDescTurno & "','" & situacaoAluno & "'," & intCodEmpresa
	if session("usuarioWeb") = "SERGIO" THEN
		response.write sql
	END IF	
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
			%>
			  <tr <%=corLinha%>>
              	<%if trim(rs("cod_escola")) <> trim(cod_escola) then%>
				<td <%=corLinha%> <%=rs("linhas")%> class="<%=strclasse%>" ="left"><%=rs("EMPRESA")%>&nbsp;</td>
              	<%end if%>
                
                <td <%=corLinha%> class="<%=strclasse%>" ="left"><%=rs("TURNO")%>&nbsp;</td>
                <%for i=0 to ubound(vetIdades,2)%>
                    <td <%=corLinha%> style="cursor:pointer" onClick="return abrePaginaListaMatricula('<%=vetIdades(0,i)%>','M','<%=rs("cod_escola")%>','<%=rs("turno")%>','<%=situacaoAluno%>','<%=strTipoCurso%>')" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" align="center" class="<%=strclasse%>"><%=rs("M_"& vetIdades(0,i))%></td>
                    <td <%=corLinha%>  style="cursor:pointer" onClick="return abrePaginaListaMatricula('<%=vetIdades(0,i)%>','F','<%=rs("cod_escola")%>','<%=rs("turno")%>','<%=situacaoAluno%>','<%=strTipoCurso%>')" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" align="center" class="<%=strclasse%>"><%=rs("F_"& vetIdades(0,i))%></td>
                	<%
					if rs("M_"& vetIdades(0,i))<>"" and not isnull(rs("M_"& vetIdades(0,i))) then
						total_M_linha = total_M_linha + rs("M_"& vetIdades(0,i))
						total_linha = total_linha + rs("M_"& vetIdades(0,i))
					end if
					if rs("F_"& vetIdades(0,i))<>"" and not isnull(rs("F_"& vetIdades(0,i))) then
						total_F_linha = total_F_linha + rs("F_"& vetIdades(0,i))
						total_linha = total_linha + rs("F_"& vetIdades(0,i))
					end if
				next%>
                <td <%=corLinha%> class="<%=strclasse%>" align="center"><%=total_M_linha%></td>
                <td <%=corLinha%> class="<%=strclasse%>" align="center"><%=total_F_linha%></td>
                <td <%=corLinha%> class="<%=strclasse%>" align="center"><%=total_linha%></td>
			  </tr>
			<%
			total_M_linha = 0
			total_F_linha = 0
			total_linha   = 0
			cod_escola    = rs("cod_escola")
			rs.movenext
		wend
		rs.close
		
		sql = "exec [dbo].[SP_SCA_QuantAlunoPorIdadeSexo_resultado_total] " & session("codGrupo") & "," & strAnoLetivo & ",'" & strTipoCurso & "','" & strDescTurno & "','" & situacaoAluno & "'," & intCodEmpresa
	if session("usuarioWeb") = "SERGIO" THEN
		response.write sql
	END IF		
		total_geral_M_linha = 0
		total_geral_F_linha = 0
		total_geral_linha = 0
		rs.open sql, cnn
		if not rs.eof then 
			While not rs.eof
			%>
			  <tr>
				<td class="<%=strclasse%>" ="right" colspan="2"><strong>Total Geral</strong></td>
				<%for i=0 to ubound(vetIdades,2)%>
					<td align="center" class="<%=strclasse%>"><strong><%=rs("M_"& vetIdades(0,i))%></strong></td>
					<td align="center" class="<%=strclasse%>"><strong><%=rs("F_"& vetIdades(0,i))%></strong></td>
                    <%
					if rs("M_"& vetIdades(0,i))<>"" and not isnull(rs("M_"& vetIdades(0,i))) then
						total_geral_M_linha = total_geral_M_linha + rs("M_"& vetIdades(0,i))
					end if
					if rs("F_"& vetIdades(0,i))<>"" and not isnull(rs("F_"& vetIdades(0,i))) then
						total_geral_F_linha = total_geral_F_linha + rs("F_"& vetIdades(0,i))
					end if
					total_geral_linha = total_geral_linha + rs("F_"& vetIdades(0,i)) + rs("M_"& vetIdades(0,i))
				  next%>
                <td class="<%=strclasse%>" align="center"><strong><%=total_geral_M_linha%></strong></td>
                <td class="<%=strclasse%>" align="center"><strong><%=total_geral_F_linha%></strong></td>
                <td class="<%=strclasse%>" align="center"><strong><%=total_geral_linha%></strong></td>
			  </tr>
			<%
				rs.movenext
			wend
		end if
		rs.close
	else
		%>
		  <tr>
			<td colspan="7" class="<%=strclasse%>" ="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
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
