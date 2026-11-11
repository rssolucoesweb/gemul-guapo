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
<title>GEMUL - Hoario aula</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet" href="css_rel/Estilo_Impressao.css">
<body>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="includes/inc_Botoes_relatorio.asp"-->	
<!--#include file="includes/inc_aguarde.asp"-->	
<!--#include file="includes/inc_CompartilharDadosCadastrais.asp"-->

<br>
<%
	dim intPagina
	dim strInfoTurma
	
	strSemestre 			= Trim(Request.Form("cmbSemestre"))
	strSemestreTitulo		= "/" & Trim(Request.Form("cmbSemestre"))
	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if strSemestreTitulo = "/3" then strSemestreTitulo = ""

	if strAnoLetivo = "" then strAnoLetivo = session("strAnoLetivo")
	if strSemestre = "" then strSemestre = "0"

	intCodTurma 			= Trim(Request.Form("cmbTurmaProfessor"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intCodColaborador 		= Trim(Request.Form("cmbProfessor"))
	intCodTurno		 		= Trim(Request.Form("cmbTurno"))
	intCodGrade				= Trim(Request.Form("cmbGrade"))
	strOmitirHorario        = Trim(Request.Form("txtOmitirHorario"))
	if intCodColaborador= "" then intCodColaborador 		= "0"
	if intCodCurso 		= "" then intCodCurso 		= "0"
	if intCodSerie 		= "" then intCodSerie 		= "0"
	if intCodTurno 		= "" then intCodTurno 		= "0"
	if intCodTurma 		= "" then intCodTurma 		= "0"
	if intCodColaborador= "" then intCodColaborador 		= "0"
	if intCodGrade 		= "" then intCodGrade 		= "0"

	strFiltroSerie = "0"
	strFiltroTurno = "0"


	strTituloRelatorio  	= "AULAS SEMANAIS POR TURMAS - ( Horário de Aula Extra ) <br> Referência: " & strAnoLetivo & strSemestreTitulo

	sub mostraCabecalho()
	%>
	<!--#include file="includes/inc_cabecalhoRelatorio.asp"-->
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	mostraCabecalho
	cont = 0
	totalCh_Semanal = 0
	totalCh_Mensal = 0
	totalCh_Anual = 0
	contPeriodo = 0

	cont =0
	sql = "SELECT	HA.CODIGO, P.DESCRICAO AS PERIODO, T.NOMETURMA, T.TURMAALUNO, H.HORARIO, HA.TEMPO, HA.DataLancamento, HA.SEQUENCIA, C.NOME AS PROFESSOR, "
	sql = sql & " D.DESC_DISCIPLINA, TJ.NOMETURMA AS TURMAJUNCAO, HA.TipoHorario"
	sql = sql & " FROM	SCA_HORARIO_AULA_EXTRA HA"
	sql = sql & " INNER JOIN SCA_HORARIO H ON H.COD_EMPRESA=HA.COD_EMPRESA AND H.CODIGO=HA.COD_HORARIO"
	sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_EMPRESA=HA.COD_EMPRESA AND T.COD_TURMA=HA.COD_TURMA"
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.COD_GRADECURRICULAR=T.COD_GRADECURRICULAR"
	sql = sql & " INNER JOIN SCA_PERIODO P ON P.COD_PERIODO=G.COD_PERIODO"
    sql = sql & " LEFT JOIN SRH_COLABORADOR C ON C.CODIGO=HA.COD_COLABORADOR"
	
	sql = sql & " LEFT  JOIN SCA_DISCIPLINA D ON D.COD_DISCIPLINA=HA.COD_DISCIPLINA"
	sql = sql & " LEFT JOIN SCA_TURMA TJ ON TJ.COD_EMPRESA=HA.COD_EMPRESA AND TJ.COD_TURMA=HA.TURMA_JUNCAO"
	sql = sql & " WHERE	1=1"
	
	if strCompartilharDados = "S" then
		sql = sql & " AND	HA.COD_EMPRESA	= " & Session("CodEmpresa")
	end if   
	
	sql = sql & " AND		HA.ANOLETIVO	= " & strAnoLetivo
	sql = sql & " AND		HA.SEMESTRE		in (" & strSemestre & ")"
	if intCodCurso <> "0" then
		sql = sql & " AND		P.COD_CURSO		= " & intCodCurso
	end if
	
	if intCodTurno <> "0" then
		sql = sql & " AND		T.COD_TURNO		= " & intCodTurno
	end if
	
	if intcodPeriodo <> "0" then
		sql = sql & " AND		G.COD_PERIODO	= " & intcodPeriodo
	end if

	if intCodTurma <> "0" then
		sql = sql & " AND		T.COD_TURMA		= " & intCodTurma
	end if

	if intCodColaborador <> "0" then
		sql = sql & " AND		C.CODIGO		= " & intCodColaborador
	end if
	
	sql = sql & " Order by HA.ANOletivo, HA.semestre, P.DESCRICAO, T.NOMETURMA, HA.DataLancamento, H.horario "

	rs.open sql, cnn
	if rs.eof = false then
	%>
        <table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
          <tr bgcolor="#E5E5E5">
            <td width="9%" class="celula"><strong>Per&iacute;odo  </strong></td>
            <td width="10%" class="celula"><strong><strong>Turma</strong></strong></td>
            <td width="15%" height="21" class="celula"><strong>Hor&aacute;rio<span class="TextoForm"></span></strong></td>
            <td width="8%" class="celula"><strong>Sequencia</strong></td>
            <td width="8%" class="celula"><strong>Tempo<span class="TextoForm"></span></strong></td>
            <td width="12%" class="celula"><strong>Data Lan&ccedil;amento <span class="TextoForm"></span></strong></td>
            <td width="15%" class="celula"><strong>Disciplina</strong></td>
            <td width="12%" class="celula"><strong>Professor(a)<span class="TextoForm"></span></strong></td>
          </tr>
          <%
		while not rs.eof
			cont = cont + 1	
			
			if trim(rs("TipoHorario")) = "E" then 'Horario Extra
				strCor =  "#C4E1FF"
			else
				strCor =  ""
			end if
		
			%>
          <tr bgcolor="<%=strCor%>">
            <td class="celula"><%=rs("periodo")%></td>
            <td class="celula"><%=rs("Turmaaluno")%>&nbsp;&nbsp;<%=rs("nometurma")%></td>
            <td height="20" class="celula"><%=trim(rs("horario"))%></td>
            <td class="celula"><%=trim(rs("sequencia"))%>&ordf; Aula </td>
            <td class="celula"><%=trim(rs("tempo"))%>&deg;</td>
            <td class="celula"><%=formataDataAP(trim(rs("DataLancamento")))%></td>
            <td class="celula"><%=trim(rs("DESC_DISCIPLINA"))%>&nbsp;</td>
            <% if isnull(rs("PROFESSOR")) then %>
            	<td class="celula"> ** Deficit **</td>
            <% else %>    
            	<td width="11%" class="celula"><%=trim(rs("PROFESSOR"))%>&nbsp;</td>
            <% end if %>    
          </tr>
          <%				
			rs.movenext
			wend
		  %>
          <tr>
            <td height="21" colspan="8" class="celula">Total Registros : <%=cont%></td>
          </table>
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
