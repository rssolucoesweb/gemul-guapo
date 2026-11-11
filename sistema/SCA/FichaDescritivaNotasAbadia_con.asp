aaa<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 10/01/2011
	::	Desenvolvedores...: Roberto Barbosa - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Ficha descritiva - Consulta Alunos
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../estilo/css.css" rel="stylesheet" type="text/css"></head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script src="../../js/js_funcoes_gerais.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurmaTodasSituacoes.asp"-->
<script>

	function resultadoConsulta(intCodAluno){
		
		var frm = document.getElementById("frm");
		
		if (frm.txtAnoLetivo.value == ""){
			alert("O Ano Letivo deve ser informado.");
			frm.txtAnoLetivo.focus();
			return false;
		}
		
		if (frm.cmbSemestre.value == "0"){
			alert("O Semestre deve ser informado.");
			frm.cmbSemestre.focus();
			return false;
		}
		
		if (frm.cmbBimestre.value == "0"){
			alert("O Bimestre deve ser informado.");
			frm.cmbBimestre.focus();
			return false;
		}
		
		if (frm.cmbProfessor.value == "0"){
			alert("O Professor deve ser informado.");
			frm.cmbProfessor.focus();
			return false;
		}
		
		if (frm.cmbTurmaProfessor.value == "0"){
			alert("A Turma do Professor deve ser informada.");
			frm.cmbTurmaProfessor.focus();
			return false;
		}
		
	<%if session("CodGrupo") = "7" then%>		
		if (frm.cmbTurnoRH.value == "0"){
			alert("O turno deve ser informado.");
			frm.cmbTurnoRH.focus();
			return false;
		}
	<%end if%>					

		if (frm.cmbFichaDescritiva.value == "0"){
			alert("A Ficha Descritiva deve ser informada.");
			frm.cmbFichaDescritiva.focus();
			return false;
		}
		
		window.open("FichaDescritivaNotasAbadia_cad.asp?CodAluno="+intCodAluno + "&CodFichaDescritiva="+ frm.cmbFichaDescritiva.value  + "&AnoLetivo="+ frm.txtAnoLetivo.value + "&Semestre="+ frm.cmbSemestre.value + "&cmbTurma="+ frm.cmbTurmaProfessor.value + "&cmbDisciplinaDoProfessor="+ frm.cmbDisciplinaDoProfessor.value + "&cmbBimestre=" + frm.cmbBimestre.value + "&cmbProfessor=" + frm.cmbProfessor.value + "&cmbTurnoRH=" + frm.cmbTurnoRH.value,"consulta", "top=0,left=0,height=600,width=800,menubar=no,toolbar=no,scrollbars=yes,status=yes");
		return true;
	}
</script>
<%
	strExecutarSubmit	  					= "S"
	strExecutarSubmitCurso	  				= "S"
	strExecutarSubmitPeriodo  				= "S"
	strExecutarSubmitSemestre 				= "S"
	strExecutarSubmitTurno	  				= "S"
	strExecutarSubmitTurnoRH				= "S"
	strExecutarSubmitProfessor				= "S"
	strExecutarSubmitTurma	  				= "S"
	strExecutarSubmitDisciplinaDoProfessor  = "S"
	strPaginaTitulo = "FichaDescritivaNotasAbadia_con.asp"
	strExecutarSubmitSemestre = "S"

	if trim(request("txtAnoLetivo")) = "" then 
		strAnoLetivo = session("strAnoLetivo")
		intAnoLetivo = session("strAnoLetivo")
	else
		strAnoLetivo = request.Form("txtAnoLetivo")
		intAnoLetivo = request.Form("txtAnoLetivo")
	end if
	if trim(request("cmbSemestre")) = "0" or trim(request("cmbSemestre")) = ""  then 
		intSemestre = session("strSemestre")
	    strSemestre = session("strSemestre")
	else
		intSemestre = request.Form("cmbSemestre")
	    strSemestre = request.Form("cmbSemestre")
	end if

	intCodBimestre				= Trim(Request.Form("cmbBimestre"))
 	intCodFichaDescritiva	    = Trim(Request.form("cmbFichaDescritiva"))

    intCodColaboradorProfessor 	= Trim(Request("cmbProfessor"))
	intCodProfessor 	        = Trim(Request("cmbProfessor"))
	intCodTurmaProfessor 	    = Trim(Request("cmbTurmaProfessor"))

	intCodCurso	 			    = Trim(Request("cmbCurso"))
	intCodPeriodo 			    = Trim(Request("cmbPeriodo"))
	intCodGrade				    = Trim(Request("cmbGrade"))
	intCodTurno		 		    = Trim(Request("cmbTurno"))
	intCodTurnoRH		 		= Trim(Request("cmbTurnoRH"))
	intCodPlanoPagamento	    = Trim(Request("cmbPlanoPagamento"))
	strSala		 			    = Trim(Request("txtSala"))
	intAno		 			    = Trim(Request("txtAno"))
	intAnoLetivo 			    = Trim(Request("txtAnoLetivo"))
	intCodDisciplina            = trim(request("cmbDisciplinaDoProfessor"))
	strDataInicial              = formatadataAP(date)'Trim(Request("txtData"))
	strDataFinal                = formatadataAP(date)'Trim(Request("txtData"))
    strMes		 		        = Trim(Request("cmbMes"))


	strFiltroSerie = "0"
	strFiltroTurno = "0"

	if intCodComp = "" then intCodComp = "0"
	if intCodSerie = "" then intCodSerie = "0"
	if intCodTurno = "" then intCodTurno = "0"
	if intCodColaboradorProfessor = "" then intCodColaboradorProfessor = "0"
	if intCodTurmaProfessor = "" then intCodTurmaProfessor = "0"
	if intCodSemestre = "" then intCodSemestre = "0"
	if intCodTipoLancamento = "" then intCodTipoLancamento = "0"
	if intCodDisciplina= "" then intCodDisciplina = "0"

	'if trim(Session("CodColaboradorContrato")) = "" then
'	
'		' Consulta a Categoria	
'		sql = "select codigo "
'		sql = sql & " from SRH_COLABORADOR"
'		sql = sql & " where codigo_SEG_USUARIOS_SISTEMA = '" & trim(session("usuarioWeb")) & "'"
'		sql = sql & " and CodCategoria = 1 "'professor
'		sql = sql & " and Situacao = 'A'" 'Ativo
'		rs.open sql, cnn
'		if rs.EOF = false then	
'			strVerificaCategoria 		= "Professor"
'			intCodColaboradorProfessor 	= rs("codigo")
'			intCodProfessor 	      	= rs("codigo")
'		else
'			strVerificaCategoria = ""
'		end if
'		rs.close
'	
'	end if

    strFichaDescritivaInterDisciplinar = "S"
	sql = "SELECT SCA_TURMA.cod_turma, SCA_TURMA.cod_Semestre , SCA_PERIODO.Cod_Curso, SCA_PERIODO.Cod_Periodo, SCA_TURMA.cod_turno, SCA_TURMA.Sala, SCA_TURMA.NomeTurma, SCA_TURMA.Cod_FichaDescritiva, isnull(SCA_PERIODO.tipo,'I') as TipoFicha,  TRH.cod_turno as Turno_RH"
	sql = sql & " FROM SCA_TURMA "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
	sql = sql & " INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo"
	sql = sql & " INNER JOIN SCA_TURNO TU ON TU.Cod_Turno = SCA_TURMA.Cod_Turno "  
	sql = sql & " INNER JOIN SRH_TURNO TRH ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3) and TRH.Cod_Grupo = " & Session("CodGrupo")	  
	SQL = SQL & " WHERE SCA_TURMA.cod_empresa=" & Session("CodEmpresa")
	sql = sql & " AND SCA_TURMA.Cod_Turma= " & intCodTurmaProfessor
	RS.OPEN SQL, CNN
	IF not RS.EOF THEN

		intCodCurso 		= rs("cod_curso")
		intCodPeriodo 		= rs("cod_periodo")
		intCodTurno 		= rs("cod_turno")
		intSemestre 		= rs("cod_Semestre")
		strTurnoNomeTurma 	= mid(rs("NomeTurma"),6,1)
		if Trim(Request("cmbTurnoRH")) = "" or Trim(Request("cmbTurnoRH")) = "0" then
			intCodTurnoRH 	    = rs("Turno_RH")
		end if		
		if trim(rs("Cod_FichaDescritiva")) <> "0" or not isnull(rs("Cod_FichaDescritiva")) then
		   intCodFichaDescritiva = rs("Cod_FichaDescritiva")
		end if  
		if trim(rs("TipoFicha")) = "D" then
		   strFichaDescritivaInterDisciplinar = "N"
		else
		   strFichaDescritivaInterDisciplinar = "S"
		end if   
	END IF
	rs.close
	intCodigo 		    = Trim(Request.Form("txtCodigo"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
		
	if trim(intCodigo) <> "" then
	
		sql = "SELECT *"
		sql = sql & " FROM sca_conteudo"
		sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
		sql = sql & " and codigo = " & intCodigo
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodHorario	 		  = rs("codigo")
			strDescricao			  = rs("conteudo")
			strAnoLetivo	 		  = rs("anoletivo")
			intSemestre				  = rs("semestre")
			intCodColaboradorProfessor= rs("Cod_Colaborador")
			intCodTurmaProfessor	  = rs("cod_turma")
			intCodDisciplina		  = rs("cod_disciplina")
			strData					  = rs("data")
			strDesabilitaIncluir	  = "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	  = "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	  = "" 'Desabilita o botão Excluir

		end if 
		rs.close
	else
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	end if 
	strDesabilitaConsultar = " disabled "
%>
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td>
	<table width="100%"  height="325" border="0" cellspacing="0" cellpadding="0">
      <tr valign="top">
        <td colspan="2" align="center">
		<form id="frm" method="post" action="FichaDescritivaNotasAbadia_con.asp">
		<input name="txtCodigo" value="<%=intCodigo%>" type="hidden">
		  <table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr valign="top">
              <td align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
          </table>
		  <br>
		  <table width="98%" border="0" cellspacing="0" cellpadding="0" >
		    <tr>
		      <td height="26" width="146" class="texto1">Ano Letivo:</td>
		      <td width="832"><input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
		      </tr>
		    <tr>
		      <td height="26" class="texto1">Semestre:</td>
		      <td><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
		      </tr>
            <tr>
              <td height="26" class="texto1">Bimestre:</td>
              <td colspan="2"><!--#include file="../includes/inc_cmdBimestre.asp"--></td>
            </tr>
		      <td height="26" class="texto1">Professor:</td>
		      <td><!--#include file="../includes/inc_cmdProfessor.asp" --></td>
		      </tr>
		    <tr>
		      <td height="26" class="texto1">Turma:</td>
		      <td><!--#include file="../includes/inc_cmdTurmaProfessorFichaDescritiva.asp"--></td>
		    </tr>
            <% if strTurnoNomeTurma = "I" then %>
                <tr>
                  <td height="26" class="texto1">Turno do Regente:</td>
                  <td><!--#include file="../includes/inc_cmbTurnoRH_FichaDescritiva.asp"--></td>
                </tr>
            <% else %>
            	<input name="cmbTurnoRH" value="<%=intCodTurnoRH%>" type="hidden">
            <% end if %>
                <tr>
                  <td height="26" class="texto1">Disciplina:</td>
                  <td><!--#include file="../includes/inc_cmdDisciplinaDoProfessorDescritiva.asp"--></td>
                </tr>
		    <tr>
		      <td height="26" class="texto1">Ficha Descritiva:</td>
		      <td><span class="texto1">
		        <!--#include file="../includes/inc_cmdFichaDescritiva.asp" -->
		        </span></td>
		      </tr>
		    <tr>
		      <td colspan="2"  class="texto1">&nbsp;</td>
		      </tr>
		    <tr>
		      <td colspan="2"  class="texto1"><!--#include file="../../includes/inc_botoes_consulta.asp"--></td>
		      </tr>
		    <tr>
		      <td colspan="2">&nbsp;</td>
		      </tr>
		    <tr>
		      <td colspan="2"><%
			if intCodTurma <> "0" OR strMatricula <> "" then%>
            
        <table class="tabela" width="98%" align="center" border="1" cellpadding="0" cellspacing="0">
          <tr bgcolor="#CCCCCC" class="CabecalhoConsulta">
            <td class="celula"><strong>Matr&iacute;cula</strong></td>
            <td width="764" class="celula"><strong>Nome</strong></td>
            <td width="149" class="celula"><strong>Situa&ccedil;&atilde;o</strong></td>
          </tr>
          <%					

			buscaHistorico = "N"
			if trim(intSemestre) = "3" then
			   if trim(strAnoLetivo) <> trim(session("strAnoLetivo"))  then
				  buscaHistorico = "S"
			   end if
			else
			   if trim(strAnoLetivo) <> trim(session("strAnoLetivo"))  or trim(intSemestre) <> trim(session("strSemestre")) then
				  buscaHistorico = "S"
			   end if	   
			end if
			if buscaHistorico = "N" then
			
			   sql = " SELECT DISTINCT"
			   sql = sql & " AD.COD_ALUNO AS CODIGO, " 
			   sql = sql & " AD.COD_TURMA_REMANEJAMENTO AS COD_TURMA, "
			   sql = sql & " A.NOMEALUNO, "
			   sql = sql & " A.MATRICULA, "
			   sql = sql & " '' AS SEQUENCIA, "
			   sql = sql & " SA.DESC_SITUACAOALUNO "
			   sql = sql & " FROM SCA_ALUNO_DISCIPLINA AD INNER JOIN " 
			   sql = sql & " SCA_ALUNO A ON A.CODIGO = AD.COD_ALUNO  INNER JOIN "
			   sql = sql & " SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = A.COD_SITUACAOALUNO AND SA.Cod_Empresa = A.COD_EMPRESA INNER JOIN "
			   sql = sql & " SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricularDisciplina = AD.COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO"
			   sql = sql & " WHERE AD.COD_EMPRESA = " & Session("CodEmpresa") 
			   if intCodDisciplina <> "0" then
			   	 sql = sql & " AND GCD.COD_DISCIPLINA= " & intCodDisciplina
			   end if
			   sql = sql & " AND AD.COD_TURMA_REMANEJAMENTO= " & intCodTurmaProfessor
			   if strAtivos = "A" then	
				  sql = sql & "AND (SA.Desc_SituacaoAluno = 'ATIVO' OR SA.Desc_SituacaoAluno = 'PRÉ-MATRÍCULA') " 
			   end if	  
			   sql = sql & " ORDER BY A.NOMEALUNO "
			   
			
			else   
			   'seleciona os alunos pelo ano e semestres do histórico 			
			   sql = " select DISTINCT A.CODIGO, AT.COD_TURMA, A.NOMEALUNO, A.MATRICULA,  '' AS SEQUENCIA, SA.DESC_SITUACAOALUNO "
			   sql = sql & " from SCA_HISTORICO_ESCOLAR_DISCIPLINA HED "
			   sql = sql & " INNER JOIN SCA_HISTORICO_ESCOLAR HE ON HE.CODIGO = HED.COD_HISTORICO_ESCOLAR "
			   sql = sql & " INNER JOIN SCA_ALUNO A ON A.CODIGO = HE.COD_ALUNO AND A.COD_EMPRESA = HE.COD_EMPRESA "
			   sql = sql & " INNER JOIN SCA_SITUACAOALUNO SA ON SA.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO AND SA.COD_EMPRESA = A.COD_EMPRESA " 
			   sql = sql & " INNER JOIN SCA_ALUNO_TURMA AT ON  AT.COD_ALUNO=A.CODIGO AND AT.COD_EMPRESA = A.COD_EMPRESA "
			   sql = sql & " WHERE A.COD_EMPRESA = " & Session("CodEmpresa")
			   sql = sql & " AND AT.COD_TURMA = " & intCodTurmaProfessor	
			   sql = sql & " AND HE.ANO_LETIVO = " & strAnoLetivo
			   sql = sql & " AND HE.SEMESTRE = " & intSemestre 
			   if intCodDisciplina <> "0" then
				   sql = sql & " AND HED.COD_DISCIPLINA= " & intCodDisciplina
			   end if
			   sql = sql & " ORDER BY NOMEALUNO "
			end if
			'seleciona os alunos da turma'					
			'sql = sqlAlunoTurma(intCodTurmaProfessor, "")
			
			
			
			rs.open sql, cnn
			if rs.eof = false then
				selecionado = "checked"
				while not rs.eof
					strCodigoAluno        			= rs("codigo")
					strMatricula		  			= rs("MATRICULA")
					%>
               	<tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("CODIGO")%>')">
            <td height="21" class="celula">&nbsp;<%=strMatricula%></td>
            <td class="celula"><%=rs("NOMEALUNO")%>&nbsp;</td>
            <td class="celula"><%=rs("Desc_SituacaoAluno")%>&nbsp;</td>
          </tr>
          <%			selecionado = ""
						rs.movenext
					wend
				else
					%>
          <tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)">
            <td colspan="3" align="center" class="celula"><%=session("strMensagemRelatorioNaoEncontrado")%></td>
          </tr>
          <%
					end if
					rs.close
			end if
					%>
        </table>                </td>
		      </tr>
		    <tr>
		      <td colspan="2">&nbsp;</td>
		      </tr>
		    </table>
		</form>
		</td>
      </tr>
    </table>
	</td>
  </tr>
</table>
<!--#include file="../rodape.asp"-->
</body>
</html>