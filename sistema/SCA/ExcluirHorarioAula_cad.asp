<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 18/08/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Excluir Horario de Aula
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
<!--#include file="../includes/inc_CompartilharDadosCadastrais.asp"-->
<script>
	
	function Descricao(tipo){
		if (document.all["mostraDescricao"+tipo].style.display =="none"){
			document.all["mostraDescricao"+tipo].style.display="block";
			document.all["imgDescricao"+tipo].src="../../images/up.jpg";
		}
		else{
			document.all["mostraDescricao"+tipo].style.display="none";
			document.all["imgDescricao"+tipo].src="../../images/down.jpg";
		}
	}	
	
	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}

	function salvar(acao){
		
		var frm = document.getElementById("frm");
				
		if (frm.cmbCurso.value == 0){
			alert("O Curso deve ser informado.");
			frm.cmbCurso.focus();
			return false;
		}

		if (frm.cmbTurma.value == 0){
			alert("Turma deve ser informada.");
			frm.cmbTurma.focus();
			return false;
		}
		
		if (frm.cmbDisciplinaGrade.value == 0){
			alert("A Disciplina deve ser informada.");
			frm.cmbDisciplinaGrade.focus();
			return false;
		}

		var men = 'ATENCAO: \nDeseja realmente excluir esse horario?';
		if (confirm(men)) {
			frm.action="ExcluirHorarioAula_cod.asp?acao="+acao;
			frm.submit();
			return true;
		} else {
			return false;
		}
 	}
</script>
<%
	strPaginaTitulo 				= "ExcluirHorarioAula_cad.asp"
	strCompartilharDados 			= "S"
	strExecutarSubmitSemestre 		= "S"
	strExecutarSubmitCurso	  		= "S"
	strExecutarSubmitTurma	  		= "S"
	strDisciplina_Disabled    		= "onchange='submit()'"
	
	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	if intSemestre = "" or intSemestre = "0" then 	intSemestre  = session("strSemestre")

	intCodEmpresa				= Session("CodEmpresa")
	intCodigo	 				= Trim(Request.Form("txtCodigo"))
	intCodCurso					= Trim(Request("cmbCurso"))
	intCodTurma 				= Trim(Request.Form("cmbTurma"))
	intCodDisciplinaGrade		= Trim(Request.Form("cmbDisciplinaGrade"))
	
	if intCodDisciplinaGrade = "" then intCodDisciplinaGrade = "0"
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
			intCodPeriodo 	= rs("cod_periodo")
			intCodTurno 	= rs("cod_turno")
			intCodGrade 	= rs("Cod_GradeCurricular")
		END IF
		rs.close
	
	end if
	
	strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
	strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
	strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
%>
<form method="post" id="frm" action="ExcluirHorarioAula_cad.asp">
<input name="txtCodigo" type="hidden" id="txtCodigo" value="<%=intCodigo%>">
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
            <tr valign="top">
              <td  align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
		<tr valign="top">
		  <td align="center">
  <table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
    
    <tr>
      <td class="texto1">Ano Letivo:</td>
      <td width="91%"><input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
    </tr>
    <tr>
      <td class="texto1">Semestre:</td>
      <td><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
    </tr>
    <tr>
      <td width="9%" class="texto1">Curso:</td>
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
      <td class="texto1"><!--#include file="../includes/inc_cmdDisciplinaGrade.asp"-->
      &nbsp;*</td>
    </tr>
    
    <%
	if trim(intCodTurma) <> "0" and  trim(intCodDisciplinaGrade) <> "0" then
	
		sql = " SELECT count(cod_turma) as total from SCA_HORARIO_AULA "
		sql = sql & " where cod_empresa = " & Session("CodEmpresa")
		sql = sql & " and cod_turma = " & intCodTurma
		sql = sql & " and anoLetivo = " & strAnoLetivo
		sql = sql & " and semestre = " & intSemestre
		sql = sql & " and Cod_Disciplina = " & intCodDisciplinaGrade
		sql = sql & " GROUP BY cod_turma "
		RSAUX.OPEN SQL, CNN
		IF NOT RSAUX.EOF THEN
			TotalHorario = RSAUX("total")
			if isnull(RSAUX("total")) then
			   TotalHorario = "0"
			end if   
		END IF
		RSAUX.CLOSE
		
		'BUSCA SE A TURMA POSSUI MATRIZ CADASTRADA
		Matriz = "NÃO"
		sql = " SELECT "
		sql = sql & " SUM(GD.Ch_Semanal) as total "
		sql = sql & " FROM SCA_TURMA T "
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.Cod_GRADECURRICULAR = T.COD_GRADECURRICULAR AND G.SITUACAO = 'A' "
		sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GD ON GD.Cod_GradeCurricular = G.Cod_GRADECURRICULAR "
		sql = sql & " WHERE T.COD_EMPRESA = " & Session("CodEmpresa")
		sql = sql & " AND COD_TURMA = " & intCodTurma
		sql = sql & " and Cod_Disciplina = " & intCodDisciplinaGrade
		RSAUX.OPEN SQL, CNN
		IF NOT RSAUX.EOF THEN
			TotalMatriz = RSAUX("total")
			if isnull(RSAUX("total")) then
			   TotalMatriz = "0"
			end if   
		END IF
		RSAUX.CLOSE
		SaldoAulas =  TotalHorario - TotalMatriz
		if SaldoAulas < 0 then StatusSaldo = "** Incompleto **"
		if SaldoAulas = 0 then StatusSaldo = "** OK! **"
		if SaldoAulas > 0 then StatusSaldo = "** Carga Horária Execedida, Verifique! **"
	else	
		if SaldoAulas = "" then StatusSaldo = ""
	end if
	%>
    <tr>
      <td colspan="2" class="texto1"><div align="center">Status do Lan&ccedil;amento</strong> ( Matriz Curricular:&nbsp;<span class="texto1"><strong><%=TotalMatriz%></strong></span>&nbsp;-&nbsp; Hor&aacute;rio de Aula:&nbsp;<span class="texto1"><strong><%=TotalHorario%></strong></span>&nbsp;) = Saldo:&nbsp;<span class="texto1"><strong><%=SaldoAulas%></strong></span>&nbsp; - <span class="texto1"><strong><%=StatusSaldo%></strong></span>&nbsp;</div></td>
      </tr>
    <tr> 
      <td colspan="2" class="texto1"><hr size="1" color="#CCCCCC"></td>
    </tr>
    <tr> 
       	<td colspan="2" class="texto1">
		
		<% IF intCodCurso<> "0" OR intCodTurma<> "0" then
			cont =0
			sql = "SELECT	HA.CODIGO, P.DESCRICAO AS PERIODO, T.NOMETURMA, H.HORARIO, HA.TEMPO, HA.DIASEMANA, HA.SEQUENCIA, C.NOME AS PROFESSOR, D.DESC_DISCIPLINA, TJ.NOMETURMA AS TURMAJUNCAO "
			sql = sql & " FROM	SCA_HORARIO_AULA HA"
			sql = sql & " INNER JOIN SCA_HORARIO H ON H.COD_EMPRESA=HA.COD_EMPRESA AND H.CODIGO=HA.COD_HORARIO"
			sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_EMPRESA=HA.COD_EMPRESA AND T.COD_TURMA=HA.COD_TURMA"
			sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.COD_EMPRESA=T.COD_EMPRESA AND G.COD_GRADECURRICULAR=T.COD_GRADECURRICULAR"
			sql = sql & " INNER JOIN SCA_PERIODO P ON P.COD_EMPRESA=T.COD_EMPRESA AND P.COD_PERIODO=G.COD_PERIODO"
			if strCompartilharDados = "S" then
			   sql = sql & " LEFT JOIN SRH_COLABORADOR C ON C.CODIGO=HA.COD_COLABORADOR"
			else   
			   sql = sql & " LEFT JOIN SRH_COLABORADOR C ON C.COD_EMPRESA = HA.COD_EMPRESA AND C.CODIGO=HA.COD_COLABORADOR"
			end if   
			sql = sql & " LEFT  JOIN SCA_DISCIPLINA D ON D.COD_EMPRESA=HA.COD_EMPRESA AND D.COD_DISCIPLINA=HA.COD_DISCIPLINA"
			sql = sql & " LEFT JOIN SCA_TURMA TJ ON TJ.COD_EMPRESA=HA.COD_EMPRESA AND TJ.COD_TURMA=HA.TURMA_JUNCAO"
			sql = sql & " WHERE	1=1"
			
			if strCompartilharDados = "S" then
				'sql = sql & "AND C.CODLOTACAO	= " & Session("CodEmpresa")
			else   
				sql = sql & " AND	HA.COD_EMPRESA	= " & Session("CodEmpresa")
			end if   
			
			sql = sql & " AND HA.ANOLETIVO	= " & strAnoLetivo
			sql = sql & " AND HA.SEMESTRE in (" & intSemestre & ")"
			sql = sql & " AND P.COD_CURSO = " & intCodCurso
			sql = sql & " AND T.COD_TURMA = " & intCodTurma
			sql = sql & " AND HA.COD_DISCIPLINA = " & intCodDisciplinaGrade   
			sql = sql & " Order by HA.ANOletivo, HA.semestre, P.DESCRICAO, T.NOMETURMA, HA.DIASEMANA, H.horario "
			
			rs.open sql, cnn
			if rs.eof = false then
			%>
                <table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                  <tr bgcolor="#E5E5E5">
                    <td height="21" colspan="8" class="celula"><div align="center"><strong>REGISTROS LISTADOS PARA E X C L U S &Atilde; O</strong></div></td>
                  </tr>
                  <tr bgcolor="#E5E5E5">
                    <td width="7%" class="celula"><strong>Per&iacute;odo  </strong></td>
                    <td width="5%" class="celula"><strong><strong>Turma</strong></strong></td>
                    <td width="10%" height="21" class="celula"><strong>Hor&aacute;rio<span class="TextoForm"></span></strong></td>
                    <td width="8%" class="celula"><strong>Sequencia</strong></td>
                    <td width="6%" class="celula"><strong>Tempo<span class="TextoForm"></span></strong></td>
                    <td width="10%" class="celula"><strong>Dia Semana <span class="TextoForm"></span></strong></td>
                    <td width="22%" class="celula"><strong>Disciplina</strong></td>
                    <td width="24%" class="celula"><strong>Professor(a)<span class="TextoForm"></span></strong></td>
                  </tr>
                  <%
				while not rs.eof
					cont = cont + 1	
					%>
                  <tr>
                    <td class="celula"><%=rs("periodo")%></td>
                    <td class="celula"><%=rs("nometurma")%></td>
                    <td height="20" class="celula"><%=trim(rs("horario"))%></td>
                    <td class="celula"><%=trim(rs("sequencia"))%>&ordf; Aula </td>
                    <td class="celula"><%=trim(rs("tempo"))%>&deg;</td>
                    <td class="celula"><%=WeekDayName(trim(rs("diasemana")))%></td>
                    <td class="celula"><%=trim(rs("DESC_DISCIPLINA"))%>&nbsp;</td>
                    <td class="celula"><%=trim(rs("PROFESSOR"))%>&nbsp;</td>
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
			  
			end if%>		</td>
    </tr>
    <tr> 
      <td colspan="2" class="texto1"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
    </tr>
  </table>
  		  </td>
		</tr>
  </table>
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>