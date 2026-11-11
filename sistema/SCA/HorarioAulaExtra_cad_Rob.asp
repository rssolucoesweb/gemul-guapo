<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 28/07/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Horario de Aula
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link type="text/css" rel="stylesheet" href="../../Estilo/css.css">
<script type="text/JavaScript">
<!--



function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}
//-->
</script></head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%=session("strCaminhoRaiz")%>/images/botao_verde_over.gif')">
<script src="../../js/js_funcoes_gerais.js"></script>
<script type="text/javascript" src="../../js/js_dragdrop.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
<script>
	function resultadoConsulta(intCodigo){
	
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}

	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.txtData.value == ""){
			alert("A Data deve ser informada.");
			frm.txtData.focus();
			return false;
		}

		if (frm.cmbTurma.value == 0){
			alert("A Turma deve ser informada.");
			frm.cmbTurma.focus();
			return false;
		}

		if (frm.cmbHorario.value == 0){
			alert("Horário deve ser informada.");
			frm.cmbHorario.focus();
			return false;
		}
	
		if (frm.cmbSequenciaAula.value == 0){
			alert("A seuencia deve ser informada.");
			frm.cmbSequenciaAula.focus();
			return false;
		}

		if (frm.cmbSequenciaAula.value == 0){
			alert("A sequencia deve ser informada.");
			frm.cmbSequenciaAula.focus();
			return false;
		}

		if (frm.cmbDiaSemana.value == 0){
			alert("Dia da Semana deve ser informado.");
			frm.cmbDiaSemana.focus();
			return false;
		}

		if (frm.cmbTempoAula.value == 0){
			alert("Tempo deve ser informado.");
			frm.cmbTempoAula.focus();
			return false;
		}
		if (frm.cmbProfessor.value == 0){
			alert("Professor deve ser informado.");
			frm.cmbProfessor.focus();
			return false;
		}
		
		frm.action="HorarioAulaExtra_cod.asp?acao="+acao;
		frm.submit();
		return true;
 	}
</script>
<%
	strPaginaTitulo = "HorarioAulaExtra_cad.asp"

	strExecutarSubmitSemestre = "S"
	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitTurma	  = "S"
	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	if intSemestre = "" or intSemestre = "0" then 	intSemestre  = session("strSemestre")
	
	intCodigo	 			= Trim(Request.Form("txtCodigo"))
	intCodCurso				= Trim(Request("cmbCurso"))
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodProfessor		 	= Trim(Request.Form("cmbProfessor"))
	intCodSequenciaAula	 	= Trim(Request.Form("cmbSequenciaAula"))
	intCodDiaSemana			= Trim(Request.Form("cmbDiaSemana"))
	intCodGrade				= Trim(Request.Form("cmbGrade"))
	intCodDisciplinaGrade	= Trim(Request.Form("cmbDisciplinaGrade"))
	intCodTempoAula			= Trim(Request.Form("cmbTempoAula"))
	intCodProfessor			= Trim(Request.Form("cmbProfessor"))
	intCodHorario			= Trim(Request.Form("cmbHorario"))
	intCodTurmaJuncao 		= Trim(Request.Form("cmbTurmaJuncao"))
    strData                 = formatadataAP(Trim(Request.Form("txtData")))
    if strData = "" then strdata = formatadataAP(date)
	intCodDiaSemana			= WeekDay(strData)
	
	if strDataDia = "" then strDataDia = formatadataAP(date)
	
	
	if trim(intCodigo) <> "" then
	
		sql = "SELECT	HA.COD_TURMA, P.COD_CURSO, P.COD_PERIODO, T.COD_TURNO, HA.TEMPO, HA.DIASEMANA, "
		sql = sql & " HA.COD_COLABORADOR, HA.COD_DISCIPLINA, G.COD_GRADECURRICULAR, HA.COD_HORARIO, HA.SEQUENCIA, HA.TEMPO, Turma_Juncao, Data "
		sql = sql & " FROM	SCA_HORARIO_AULA HA"
		sql = sql & " INNER JOIN SCA_HORARIO H ON H.COD_EMPRESA=HA.COD_EMPRESA AND H.CODIGO=HA.COD_HORARIO"
		sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_EMPRESA=HA.COD_EMPRESA AND T.COD_TURMA=HA.COD_TURMA"
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.COD_EMPRESA=T.COD_EMPRESA AND G.COD_GRADECURRICULAR=T.COD_GRADECURRICULAR"
		sql = sql & " INNER JOIN SCA_PERIODO P ON P.COD_EMPRESA=T.COD_EMPRESA AND P.COD_PERIODO=G.COD_PERIODO"
		sql = sql & " INNER JOIN SRH_COLABORADOR C ON C.COD_EMPRESA=HA.COD_EMPRESA AND C.CODIGO=HA.COD_COLABORADOR"
		sql = sql & " LEFT JOIN SCA_DISCIPLINA D ON D.COD_EMPRESA=HA.COD_EMPRESA AND D.COD_DISCIPLINA=HA.COD_DISCIPLINA"
		sql = sql & " WHERE	HA.COD_EMPRESA	= " & Session("CodEmpresa")	
		sql = sql & " AND	HA.CODIGO		= " & intCodigo
		rs.open sql, cnn
		if rs.eof = false then
			
		   	intCodTurma 			= Trim(rs("cod_Turma"))
		   	intCodProfessor		 	= Trim(rs("COD_COLABORADOR"))
			intCodSequenciaAula	 	= Trim(rs("Sequencia"))
			intCodDiaSemana			= Trim(rs("DiaSemana"))
			intCodDisciplinaGrade	= Trim(rs("COD_DISCIPLINA"))
			intCodTempoAula			= Trim(rs("Tempo"))
			intCodHorario			= Trim(rs("COD_HORARIO"))
			intCodTurmaJuncao 		= Trim(rs("Turma_Juncao"))
			strData      		 	= Trim(rs("Data"))
            intCodDiaSemana         = WeekDay(rs("Data"))
			
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
		else
			strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
		end if 
		rs.close
	else
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	end if 

	if intCodTurma 		= "" then intCodTurma 		= "0"
	
	if trim(intCodTurma) <> "0" then
		sql = "SELECT SCA_GRADECURRICULAR.Cod_GradeCurricular, SCA_TURMA.cod_turma, SCA_TURMA.cod_Semestre , SCA_PERIODO.Cod_Curso, SCA_PERIODO.Cod_Periodo, SCA_TURMA.cod_turno, SCA_TURMA.Sala, SCA_TURMA.NomeTurma"
		sql = sql & " FROM SCA_TURMA "
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
		sql = sql & " INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo"
		SQL = SQL & " WHERE SCA_TURMA.cod_empresa=" & Session("CodEmpresa")
		sql = sql & " AND SCA_TURMA.Cod_Turma= " & intCodTurma
		RS.OPEN SQL, CNN
		IF not RS.EOF THEN
			intCodCurso 	= rs("cod_curso")
			intCodPeriodo = rs("cod_periodo")
			intCodTurno = rs("cod_turno")
			'intSemestre = rs("cod_Semestre")
			intCodGrade = rs("Cod_GradeCurricular")
		END IF
		rs.close
	end if
	
	if intCodProfessor 	= "" then intCodProfessor 	= "0"
	

%>
<form method="post" id="frm" action="HorarioAulaExtra_cad.asp">
<input name="txtCodigo" type="hidden" id="txtCodigo" value="<%=intCodigo%>">
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
            <tr valign="top">
              <td  align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
		<tr valign="top">
		  <td align="center">
  <table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
    <tr>
      <td height="12"><span class="texto1">Ano Letivo:</span></td>
      <td><input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
    </tr>
    <tr> 
      <td width="16%" height="12"><span class="texto1">Semestre:</span></td>
      <td><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
    </tr>
    
    <tr>
      <td class="texto1">Data:</td>
      <td><input name="txtData" type="text" class="text" id="txtData" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strData%>"></td>
    </tr>
    <tr>
      <td class="texto1">Curso:</td>
      <td><span class="texto1">
        <!--#include file="../includes/inc_cmdCurso.asp"-->
      </span></td>
    </tr>
    <tr> 
      <td class="texto1">Turma: </td>
      <td><!--#include file="../includes/inc_cmdTurma.asp"--></td>
    </tr>
    <tr>
      <td class="texto1">Disciplina:</td>
      <td class="texto1"><!--#include file="../includes/inc_cmdDisciplinaGrade.asp"--></td>
    </tr>
    <tr>
      <td class="texto1">Hor&aacute;rio: </td>
      <td class="texto1"><!--#include file="../includes/inc_cmdHorario.asp"--></td>
    </tr>
    <tr>
      <td class="texto1">Sequ&ecirc;ncia: </td>
      <td><!--#include file="../includes/inc_cmdSequenciaAula.asp"--></td>
      </tr>
    <tr>
      <td class="texto1">Dia da Semana: </td>
      <td><!--#include file="../includes/inc_cmdDiaSemana.asp"--></td>
    </tr>
    <tr>
      <td class="texto1">Tempo: </td>
      <td><select name="cmbTempoAula" id="cmbTempoAula" class="combo" style="width:150pt">
        <option value="0">Selecione...</option>
        <option <%if intCodTempoAula="1" then response.Write("selected") %> value="1">1º tempo (antes do intervalo)</option>
        <option <%if intCodTempoAula="2" then response.Write("selected") %> value="2">2º tempo (depois do intervalo)</option>
      </select></td>
    </tr>
    <tr>
      <td class="texto1">Professor(a): </td>
      <td><!--#include file="../includes/inc_cmdProfessorAtivo.asp"--></td>
    </tr>
    <tr> 
      <td class="texto1">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="2"><hr size="1" color="#CCCCCC"></td>
    </tr>
    <tr> 
      <td colspan="2"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
    </tr>
    <tr> 
       	<td colspan="2" class="texto1">
		
		<% IF intCodCurso<> "0" OR intCodTurma<> "0" then
			cont =0
			
			sql = "SELECT	HA.CODIGO, P.DESCRICAO AS PERIODO, T.NOMETURMA, H.HORARIO, HA.TEMPO, HA.DIASEMANA, HA.SEQUENCIA, C.NOME AS PROFESSOR, D.DESC_DISCIPLINA, TJ.NOMETURMA AS TURMAJUNCAO, DATA "
			sql = sql & " FROM	SCA_HORARIO_AULA HA"
			sql = sql & " INNER JOIN SCA_HORARIO H ON H.COD_EMPRESA=HA.COD_EMPRESA AND H.CODIGO=HA.COD_HORARIO"
			sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_EMPRESA=HA.COD_EMPRESA AND T.COD_TURMA=HA.COD_TURMA"
			sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.COD_EMPRESA=T.COD_EMPRESA AND G.COD_GRADECURRICULAR=T.COD_GRADECURRICULAR"
			sql = sql & " INNER JOIN SCA_PERIODO P ON P.COD_EMPRESA=T.COD_EMPRESA AND P.COD_PERIODO=G.COD_PERIODO"
			sql = sql & " INNER JOIN SRH_COLABORADOR C ON C.COD_EMPRESA=HA.COD_EMPRESA AND C.CODIGO=HA.COD_COLABORADOR"
			sql = sql & " LEFT  JOIN SCA_DISCIPLINA D ON D.COD_EMPRESA=HA.COD_EMPRESA AND D.COD_DISCIPLINA=HA.COD_DISCIPLINA"
			sql = sql & " LEFT JOIN SCA_TURMA TJ ON TJ.COD_EMPRESA=HA.COD_EMPRESA AND TJ.COD_TURMA=HA.TURMA_JUNCAO"
			sql = sql & " WHERE		HA.COD_EMPRESA	= " & Session("CodEmpresa")
			sql = sql & " AND		HA.ANOLETIVO	= " & strAnoLetivo
			sql = sql & " AND		HA.SEMESTRE		in (" & intSemestre & ")"
			sql = sql & " AND		HA.TipoHorario 	= 'E'"
			sql = sql & " AND		P.COD_CURSO		= " & intCodCurso
			
			if intCodTurno <> "0" then
				sql = sql & " AND		T.COD_TURNO		= " & intCodTurno
			end if
			if intcodPeriodo <> "0" then
				sql = sql & " AND		G.COD_PERIODO	= " & intcodPeriodo
			end if
			if intCodTurma <> "0" then
				sql = sql & " AND		T.COD_TURMA		= " & intCodTurma
			end if
			sql = sql & " Order by HA.ANOletivo, HA.semestre, P.DESCRICAO, T.NOMETURMA, HA.DIASEMANA, H.horario "
			
			rs.open sql, cnn
			if rs.eof = false then
			%>
                <table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                  <tr bgcolor="#E5E5E5">
                    <td width="6%" class="celula"><strong>Data</strong></td>
                    <td width="6%" class="celula"><strong>Per&iacute;odo  </strong></td>
                    <td width="5%" class="celula"><strong><strong>Turma</strong></strong></td>
                    <td width="9%" height="21" class="celula"><strong>Hor&aacute;rio<span class="TextoForm"></span></strong></td>
                    <td width="7%" class="celula"><strong>Sequencia</strong></td>
                    <td width="5%" class="celula"><strong>Tempo<span class="TextoForm"></span></strong></td>
                    <td width="9%" class="celula"><strong>Dia Semana <span class="TextoForm"></span></strong></td>
                    <td width="19%" class="celula"><strong>Disciplina</strong></td>
                    <td width="24%" class="celula"><strong>Professor(a)<span class="TextoForm"></span></strong></td>
                    <td width="10%" align="center" class="celula"><strong>Situa&ccedil;&atilde;o </strong></td>
                  </tr>
                  <%
				while not rs.eof
					cont = cont + 1	
					
					if strDataDia > formatadataAP(rs("data")) then
						strCor = "#FF9D9D"
						strSituacao = "Inativo"
					else
						strCor = ""
						strSituacao = "Ativo"
					end if	
					%>
                  <tr bgcolor="<%=strCor%>" style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("codigo")%>')">
                    <td class="celula"><%=formatadataAP(rs("data"))%></td>
                    <td class="celula"><%=rs("periodo")%></td>
                    <td class="celula"><%=rs("nometurma")%></td>
                    <td height="20" class="celula"><%=trim(rs("horario"))%></td>
                    <td class="celula"><%=trim(rs("sequencia"))%>&ordf; Aula </td>
                    <td class="celula"><%=trim(rs("tempo"))%>º</td>
                    <td class="celula"><%=WeekDayName(trim(rs("diasemana")))%></td>
                    <td class="celula"><%=trim(rs("DESC_DISCIPLINA"))%>&nbsp;</td>
                    <td class="celula"><%=trim(rs("PROFESSOR"))%>&nbsp;</td>
                    <td class="celula"><div align="center"><%=trim(strSituacao)%>&nbsp;</div></td>
                  </tr>
                  <%				
					rs.movenext
					wend
				  %>
                  <tr>
                    <td height="21" colspan="10" class="celula">Total Registros : <%=cont%></td>
                  </table>
              <%
			  end if
			  rs.close
			  
			end if%>		</td>
    </tr>
  </table>
  		  </td>
		</tr>
  </table>
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>