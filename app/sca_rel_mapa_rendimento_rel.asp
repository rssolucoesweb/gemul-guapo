<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
response.Expires=0
Server.ScriptTimeOut = 5000
response.Buffer = false
%>
<html>
<head>
<title>GEMUL - Mapa rendimento</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet" href="css_rel/Estilo_Impressao.css">
<body>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="includes/inc_Botoes_relatorio.asp"-->	
<!--#include file="includes/inc_aguarde.asp"-->	
<br>
<%
	dim intPagina

	intAnoLetivoAtual	 	= Trim(Request.Form("txtAnoLetivo"))
	intSemestreAtual	 	= Trim(Request.Form("cmbSemestre"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodSituacaoAluno     = Trim(Request.Form("cmbSituacaoAluno"))
	intDia  				= Trim(Request.Form("cmbDia"))
	strlpp 					= Trim(Request.Form("cmblpp"))
	strclasse               = Trim(Request.Form("cmbTamanhoFonteArial"))
	intCodTipoNota			= Trim(Request("cmbAvaliacao"))
	
	if intCodTipoNota = "" or intCodTipoNota = "0" then
	%>
		<script>
			alert("Avaliação não foi informada, selecione o curso e escolha a avaliação!");
			aguarde.style.display="none";
			window.location="Rel_MapaRendimento_con.asp"
		</script>	
	<%
		response.end
	end if
	
	strNomeTurma = ""
	if intCodTurma <> "0" then
		sql="SELECT nometurma, turmaaluno"
		sql=sql & " FROM  sca_turma"
		sql=sql & " WHERE	COD_turma = " & intCodTurma
		rs.open sql, cnn
		if rs.eof = false then
			if isnull(rs("turmaaluno")) then
				strNomeTurma			 	= "&nbsp;&nbsp;-&nbsp;&nbsp;" & rs("nometurma")
			else
				strNomeTurma			 	= "&nbsp;&nbsp;-&nbsp;&nbsp;" & rs("turmaaluno") & "(" & rs("nometurma") & ")"
			end if
		end if
		rs.close
	end if
		
	intCodEmpresaGrupo     = Trim(Request.Form("cmbEmpresaGrupo"))
	if intCodEmpresaGrupo = "" then intCodEmpresaGrupo = "0"
	
	strTituloRelatorio  	= "MAPA RENDIMENTO<br> Data referência: " 
	if len(intDia)=1 then 
		strTituloRelatorio  	= strTituloRelatorio & "0" & intDia & "/05/" & year(date)
		data_censo = "(até 0" & intDia & "/05/" & year(date) & ")"
	else 
		strTituloRelatorio  	= strTituloRelatorio & intDia & "/05/" & year(date)
		data_censo = "(até " & intDia & "/05/" & year(date) & ")"
	end if
		
	dim strAnoCab
	strAnoCab = intAnoLetivoAtual
	
	sub mostraCabecalho()
	%>
	<!--#include file="includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
	  <tr bgcolor="#CCCCCC">
	    <td width="22%" rowspan="2" class="<%=strclasse%>"><div align="center"><strong>Curso</strong></div></td>
	    <td width="12%" rowspan="2" class="<%=strclasse%>"><div align="center"><strong>Per&iacute;odo</strong></div></td>
	    <td rowspan="2" class="<%=strclasse%>"><div align="center"><strong>Disciplina(s)</strong></div></td>
	    <td width="7%" rowspan="2" class="<%=strclasse%>"><div align="center"><strong>Total de alunos na disciplina</strong></div></td>
	    <td colspan="2" class="<%=strclasse%>"><div align="center"><strong>Aprovados</strong></div></td>
	    <td colspan="2" class="<%=strclasse%>"><div align="center"><strong>Reprovados</strong>
	      </div>
        <div align="center"></div></td>
        <td colspan="2" class="<%=strclasse%>"><div align="center"><strong>Falta de Lan&ccedil;amento</strong></div></td>
	  </tr>
	  <tr bgcolor="#CCCCCC">
	    <td width="5%" class="<%=strclasse%>"><div align="center"><strong>Alunos</strong></div></td>
		<td width="5%" class="<%=strclasse%>"><div align="center"><strong>(%)</strong></div></td>
		<td width="6%" class="<%=strclasse%>"><div align="center"><strong>Alunos</strong></div></td>
	    <td width="6%" class="<%=strclasse%>"><div align="center"><strong>(%)</strong></div></td>
	    <td width="6%" class="<%=strclasse%>"><div align="center"><strong>Alunos</strong></div></td>
	    <td width="6%" class="<%=strclasse%>"><div align="center"><strong>(%)</strong></div></td>
	  </tr>
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub
	
	intPagina = 1
	mostraCabecalho


	sql="SELECT CODIGO, DESCRICAO, POSICAO"
	sql=sql & " FROM  SCA_CALCULO"
	sql=sql & " WHERE		CODIGO = " & intCodTipoNota

	rs.open sql, cnn
	if rs.eof = false then
		strNomeNota			 	= rs("DESCRICAO")
		strPosicao 				= ZeroLeft(rs("POSICAO"),2)
	end if
	rs.close
	
	strMediaProvacao = 6
	if intCodTurma = "" then intCodTurma = "0"
	
	sql = "exec [SP_mapa_rendimento] " & Session("CodGrupo") & "," & intCodEmpresaGrupo & "," & intAnoLetivoAtual & "," & intCodTurma & "," & strPosicao & "," & strMediaProvacao
	'response.write sql
	rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof
			if rs("empresa")<>"" and empresa<>rs("empresa") and intCodEmpresaGrupo <> "0" then
				%>
				<tr>
					<td height="22" align="center" colspan="10" class="<%=strclasse%>" bgcolor="#D7EBFF"><strong><%=rs("empresa")%><%=strNomeTurma%></strong></td>
				  </tr>
				<%
			end if
			%>
			  
			  <tr>
			    <td align="left" class="<%=strclasse%>"><%=rs("curso")%></td>
      		    <td align="left" class="<%=strclasse%>"><%=rs("periodo")%></td>
      		    <td align="left" class="<%=strclasse%>"><%=rs("disciplina")%></td>
      		    <td align="left" class="<%=strclasse%>"><div align="center"><%=rs("alunos")%></div></td>
      		    <td align="left" class="<%=strclasse%>"><div align="center"><%=rs("aprovados")%></div></td>
      		    <td align="left" class="<%=strclasse%>"><div align="center"><%=formatNumber((rs("aprovados")*100)/rs("alunos"),0)%></div></td>
      		    <td align="left" class="<%=strclasse%>"><div align="center"><%=rs("reprovados")%></div></td>
			    <td align="left" class="<%=strclasse%>"><div align="center"><%=formatNumber((rs("reprovados")*100)/rs("alunos"),0)%></div></td>
			    <td align="left" class="<%=strclasse%>"><div align="center"><%=rs("sem_lancamento")%></div></td>
			    <td align="left" class="<%=strclasse%>"><div align="center"><%=formatNumber((rs("sem_lancamento")*100)/rs("alunos"),0)%></div></td>
			  </tr>
			<%
			cont = cont + 1
			intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
			empresa = rs("empresa")
			rs.movenext
		wend
	else
		%>
		  <tr>
			<td colspan="10" class="<%=strclasse%>" align="center"><p>&nbsp;</p>
			  <p><br>
			        <font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></p></td>
		  </tr>
		<%
	end if
	rs.close

	strMatriculaInicial = 0 
	strMatriculaAposMaio = 0 
	strMatriculaTotal = 0 
	strMatriculaIngressantes = 0

	sql = "exec [SP_mapa_rendimento_situacao] " & Session("CodGrupo") & "," & intCodEmpresaGrupo & "," & intAnoLetivoAtual & "," & intCodTurma & "," & intDia

	rs.open sql, cnn
	if not rs.eof then
 		%>
      <tr>
        <td align="left" class="<%=strclasse%>">&nbsp;</td>
        <td colspan="3" align="left" bgcolor="#CCCCCC" class="<%=strclasse%>"><div align="center"><strong>Situa&ccedil;&otilde;es Acad&ecirc;micas</strong></div>			      <div align="center"></div></td>
        <td width="9%" align="left" bgcolor="#CCCCCC" class="<%=strclasse%>"><div align="center"><strong>Alunos</strong></div></td>
        <td width="10%" align="left" bgcolor="#CCCCCC" class="<%=strclasse%>"><div align="center"><strong>(%)</strong></div></td>
        <td colspan="7" align="left" class="<%=strclasse%>">&nbsp;</td>
      </tr>
       <%
		total = 0
		ja_imprimiu_total = ""
		While not rs.eof

			if rs("seq") = 3 and ja_imprimiu_total = "" then
				ja_imprimiu_total = "S"

				%>
				  <tr >
					<td align="left" class="<%=strclasse%>">&nbsp;</td>
					<td colspan="3" align="left" class="<%=strclasse%>"bgcolor="#CCCCCC" ><strong>TOTAL</strong></td>
					<td align="center" class="<%=strclasse%>" bgcolor="#CCCCCC" ><strong><%=total%></strong></div></td>
					<td align="center" class="<%=strclasse%>" bgcolor="#CCCCCC" >&nbsp;</div></td>
					<td colspan="7" align="left" class="<%=strclasse%>">&nbsp;</td>
				 </tr>
				<%
			end if

			percentual = (rs("alunos")*100) / rs("total_de_alunos")
			msm = ""
			if rs("situacao_aluno") = "MATRÍCULA INICIAL" then msm = data_censo
			%>
			  
              <tr>
                <td align="left" class="<%=strclasse%>">&nbsp;</td>
                <td colspan="3" align="left" class="<%=strclasse%>"><%=rs("situacao_aluno")%>&nbsp;<%=msm%></td>
                <td align="center" class="<%=strclasse%>" ><%=rs("alunos")%></div></td>
                <td align="center" class="<%=strclasse%>"><%=formatNumber(percentual,0)%></td>
                <td colspan="7" align="left" class="<%=strclasse%>">&nbsp;</td>
             </tr>
			  
			<%
			total = total + rs("alunos")
			rs.movenext
		wend
		%>
          <tr>
            <td height="120" colspan="13" align="left" class="<%=strclasse%>">
              <table width="100%" height="70" border="0" cellpadding="0" cellspacing="0">
                <tr>
                  <td height="70" align="center">________________________________________________<br>
COORDENADOR(A) PEDAG&Oacute;GICO</td>
                  <td align="center">________________________________________________<br>
DIRETOR(A)</td>
                </tr>
              </table>
              </td>            </tr>
        <%  
	end if
	rs.close
	
%>
</table>
<script>
	aguarde.style.display="none";
</script>
</body>
</html>
