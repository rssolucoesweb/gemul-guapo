<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br" 
	::	Data de Criação...: 13/02/2008
	::	Desenvolvedores...: Sergio Borges - Sergiob76@gmail.com
	::	Objetivo Pagina...: Cadastro de Turma 
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../estilo/css.css" rel="stylesheet" type="text/css">
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script src="../../js/js_funcoes_gerais.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<script>
	function resultadoConsulta(intCodigo){
		frm.txtCodigo.value=intCodigo;
		frm.action = "Turma_cad.asp?Consulta=Turma";
		frm.submit();
	}

	function salvar(acao){
			
		if (frm.cmbSemestre.value == "0") {
			alert("O Semestre deve ser informada !");
			frm.cmbSemestre.focus();
			return false;
		}
		if (frm.cmbGrade.value == "0") {
			alert("A Grade Curricular deve ser informada !");
			frm.cmbGrade.focus();
			return false;
		}
	
		if (frm.cmbTurno.value == "0") {
			alert("O Turno deve ser informado !");
			frm.cmbTurno.focus();
			return false;
		}
		
		if (frm.txtNomeTurma.value == "") {
			alert("O Nome da Turma deve ser informada !");
			frm.txtNomeTurma.focus();
			return false;
		}
		
		if (frm.txtSala.value == "") {
			alert("A Sala deve ser informada !");
			frm.txtSala.focus();
			return false;
		}
		
		if (frm.txtAno.value == "") {
			alert("O Ano deve ser informado !");
			frm.txtAno.focus();
			return false;
		}
		if (frm.txtCapacidade.value == "") {
			alert("O Capacidade deve ser informada !");
			frm.txtCapacidade.focus();
			return false;
		}
				
		if (frm.txtAnoLetivo.value == "") {
			alert("O Ano Letivo deve ser informado !");
			frm.txtAnoLetivo.focus();
			return false;
		}
		
		frm.action="Turma_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}

</script>
<%
	strPaginaTitulo = "Turma_cad.asp"
	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"
	strExecutarSubmitTurno	  = "S"
	
	strAnoLetivo 			= session("strAnoLetivo")
	intCodTurma 			= Trim(Request.Form("txtCodigo"))
	strNomeTurma 			= Trim(Request.Form("txtNomeTurma"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	intCodGrade				= Trim(Request.Form("cmbGrade"))

	intCodTurno		 		= Trim(Request.Form("cmbTurno"))
	strSala		 			= Trim(Request.Form("txtSala"))
	if strSala <> "" then strSala = ZeroLeft(Trim(strSala),2)
	intAno		 			= Trim(Request.Form("txtAno"))
	intAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	intCapacidade 			= Trim(Request.Form("txtCapacidade"))
		
	if trim(intCodTurma) <> "" then
	
		sql = "SELECT SCA_TURMA.capacidade, SCA_TURMA.nomeTurma, SCA_SEMESTRE.sigla, SCA_TURMA.Cod_Turma, SCA_TURMA.Cod_GradeCurricular, SCA_TURMA.Cod_Semestre, SCA_TURMA.Cod_Turno, SCA_TURMA.Sala, SCA_TURMA.Ano, SCA_TURMA.AnoLetivo, SCA_TURMA.TurmaAluno, SCA_GRADECURRICULAR.Cod_Periodo, SCA_PERIODO.Cod_Curso"
		sql = sql & " FROM SCA_TURMA "
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = dbo.SCA_GRADECURRICULAR.Cod_GradeCurricular "
		sql = sql & " INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo"
		sql = sql & " INNER JOIN SCA_SEMESTRE ON SCA_SEMESTRE.Codigo = SCA_TURMA.Cod_Semestre"
		sql = sql & " WHERE     (SCA_TURMA.Cod_Turma = " & intCodTurma & ") "
		sql = sql & " AND 		(SCA_TURMA.Cod_Empresa = " & Session("CodEmpresa") & ") "
		rs.open sql, cnn
		if rs.eof = false then
			
			intCodTurma 			= rs("Cod_Turma")
			strNomeTurma 			= rs("NomeTurma")
			intCodCurso	 			= rs("Cod_Curso")
			intCodPeriodo 			= rs("Cod_Periodo")
			intSemestre 			= rs("Cod_Semestre")
			strSiglaSemestre		= rs("sigla")
			intCodGrade				= rs("Cod_GradeCurricular")
			intCodTurno		 		= rs("Cod_Turno")
			strSala		 			= ZeroLeft(rs("Sala"),2)
			intAno		 			= rs("Ano")
			intAnoLetivo 			= rs("AnoLetivo")
			strTurmaAluno			= rs("TurmaAluno")
			intCapacidade			= rs("Capacidade")

			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir

		end if 
		rs.close
		IF Trim(Request.Form("txtNomeTurma"))<>"" THEN
			strNomeTurma 			= Trim(Request.Form("txtNomeTurma"))
		END IF
		IF Trim(Request.Form("cmbCurso")) <>"0" THEN
			intCodCurso	 			= Trim(Request.Form("cmbCurso"))
		END IF
		IF Trim(Request.Form("cmbPeriodo"))<>"0" THEN
			intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
		END IF
		IF Trim(Request.Form("cmbSemestre"))<>"0" THEN
			intSemestre 			= Trim(Request.Form("cmbSemestre"))
		END IF
		IF  Trim(Request.Form("cmbGrade"))<>"0" THEN
			intCodGrade				= Trim(Request.Form("cmbGrade"))
		END IF
		IF Trim(Request.Form("cmbTurno"))<>"0" THEN
			intCodTurno		 		= Trim(Request.Form("cmbTurno"))
		END IF
		IF Trim(Request.Form("txtSala"))<>"" THEN
			strSala		 			= Trim(Request.Form("txtSala"))
		END IF
		if strSala <> "" then strSala = ZeroLeft(Trim(strSala),2)
		IF Trim(Request.Form("txtAno"))<>"" THEN
			intAno		 			= Trim(Request.Form("txtAno"))
		END IF
		IF Trim(Request.Form("txtAnoLetivo"))<>"" THEN
			intAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
		END IF		
	else
		IF LEN(trim(strNomeTurma)) = 9 THEN
			strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		ELSE
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
		END IF
		strDesabilitaAlterar 		= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir		= "disabled" 'Desabilita o botão Excluir
		
		IF Trim(Request.Form("txtNomeTurma"))<>"" THEN
			strNomeTurma 			= Trim(Request.Form("txtNomeTurma"))
		END IF
		IF Trim(Request.Form("cmbCurso")) <>"" THEN
			intCodCurso	 			= Trim(Request.Form("cmbCurso"))
		END IF
		IF Trim(Request.Form("cmbPeriodo"))<>"" THEN
			intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
		END IF
		IF Trim(Request.Form("cmbSemestre"))<>"" THEN
			intSemestre 			= Trim(Request.Form("cmbSemestre"))
		END IF
		IF  Trim(Request.Form("cmbGrade"))<>"" THEN
			intCodGrade				= Trim(Request.Form("cmbGrade"))
		END IF
		IF Trim(Request.Form("cmbTurno"))<>"" THEN
			intCodTurno		 		= Trim(Request.Form("cmbTurno"))
		END IF
		IF Trim(Request.Form("txtSala"))<>"" THEN
			strSala		 			= Trim(Request.Form("txtSala"))
		END IF
		if strSala <> "" then strSala = ZeroLeft(Trim(strSala),2)
		IF Trim(Request.Form("txtAno"))<>"" THEN
			intAno		 			= Trim(Request.Form("txtAno"))
		END IF
		IF Trim(Request.Form("txtAnoLetivo"))<>"" THEN
			intAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
		END IF
		strSiglaSemestre = intSemestre
		if intSemestre = "3" then strSiglaSemestre		= "A"
	end if 
	
	if intCodCurso = "" then intCodCurso = "0"
	
	if intCodCurso <> "0" then
		strSigla = ""
		sql = "SELECT Sigla"
		sql = sql & " FROM SCA_CURSO"
		SQL = SQL & " WHERE cod_empresa=" & Session("CodEmpresa")
		SQL = SQL & " and cod_curso = " & intCodCurso
		RS.OPEN SQL, CNN		
		IF NOT RS.EOF THEN
			strSigla = RS("sigla")
		END IF
		RS.CLOSE
	end if
	if intCodPeriodo = "" then intCodPeriodo = "0"
	
	if intCodPeriodo <> "0" then
		strSequencia = ""
		sql = "SELECT Sequencia"
		sql = sql & " FROM SCA_PERIODO"
		SQL = SQL & " WHERE cod_empresa=" & Session("CodEmpresa")
		SQL = SQL & " and cod_periodo = " & intCodPeriodo
		RS.OPEN SQL, CNN		
		IF NOT RS.EOF THEN
			strSequencia = RS("Sequencia")
		END IF
		RS.CLOSE
		
	end if

	
%>
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td>
	<table width="751"  height="325" border="0" cellspacing="0" cellpadding="0">
      <tr valign="top">
        <td colspan="2" align="center">
		<form id="frm" method="post" action="Turma_cad.asp">
		  <table width="708" border="0" cellpadding="0" cellspacing="0">

            <tr valign="top">
              <td width="700" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
          </table>
		  <br>
		  <table width="703" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="146" class="texto1">&nbsp;</td>
            <td width="557"><input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodTurma%>" maxlength="10"></td>
          </tr>
          <tr>
            <td class="texto1">Curso:</td>
            <td><!--#include file="../includes/inc_cmdCurso.asp" --></td>
          </tr>
          <tr>
            <td height="28" class="texto1">Per&iacute;odo:</td>
            <td><!--#include file="../includes/inc_cmdPeriodo.asp" --></td>
          </tr>
          <tr>
            <td class="texto1">Sala:</td>
            <td><input onBlur="submit()" name="txtSala" type="text" class="text" id="txtSala"  value="<%=strSala%>" size="3" maxlength="2" onKeyPress="return formataCampo(this,2,2)"></td>
          </tr>
          <tr>
            <td height="28" class="texto1">Turno:</td>
            <td><!--#include file="../includes/inc_cmdTurno.asp" --></td>
          </tr>
          <tr>
            <td height="28" class="texto1">Semestre:</td>
            <td><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
          </tr>
          <tr>
            <td class="texto1">Grade:</td>
            <td><!--#include file="../includes/inc_cmdGradeCurricular.asp" --></td>
          </tr>
          <tr>
            <td height="27" class="texto1">Ano Cria&ccedil;&atilde;o:</td>
            <td><input  name="txtAno" type="text" class="text" id="txtAno"  value="<%=intAno%>" size="5" maxlength="4" onKeyPress="return formataCampo(this,2,4)"></td>
          </tr>
          <tr>
            <td height="27" class="texto1">Ano Letivo:</td>
            <td><input onBlur="submit()" name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo"  value="<%=intAnoLetivo%>" size="5" maxlength="4" onKeyPress="return formataCampo(this,2,4)"></td>
          </tr>
		<%
		strNomeTurma = strSigla 
		strNomeTurma = strNomeTurma & strSequencia 
		strNomeTurma = strNomeTurma & strSala 
		strNomeTurma = strNomeTurma & strSiglaTurno 
		if intSemestre <> "0" then strNomeTurma = strNomeTurma & strSiglaSemestre
		if intAnoLetivo <> "" then
			strNomeTurma = strNomeTurma & right(intAnoLetivo,2)
		end if
		if trim(intCodTurma) = "" then
			IF LEN(trim(strNomeTurma)) = 9 THEN
				strDesabilitaIncluir= "" 'Desabilita o botão Incluir
			ELSE
				strDesabilitaIncluir= "disabled" 'Desabilita o botão Incluir
			END IF
			strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir		
		end if
		%>
          <tr>
            <td height="27" class="texto1">Nome da Turma:</td>
            <td><input readonly="true" name="txtNomeTurma" type="text" class="text" id="txtNomeTurma"  value="<%=strNomeTurma%>" size="12" maxlength="10" ></td>
          </tr>
          <tr>
            <td height="27" class="texto1">Capacidade:</td>
            <td><input name="txtCapacidade" type="text" class="text" id="txtCapacidade"  value="<%=intCapacidade%>" size="3" maxlength="2" onKeyPress="return formataCampo(this,2,2)"></td>
          </tr>
          <tr>
            <td class="texto1">&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td class="texto1">&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
          <td colspan="2">
			<%
			cont =0
			
			sql = "SELECT Cod_Turma, Cod_GradeCurricular, Cod_Semestre, Cod_Turno, "
			sql = sql & " nomeTurma, Sala, Ano, AnoLetivo, TurmaAluno"
			sql = sql & " FROM SCA_TURMA"
			sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
			sql = sql & " and 	AnoLetivo = " & strAnoLetivo		
			sql = sql & " Order by Cod_Turma"
			rs.open sql, cnn
							
			if rs.eof = false then
			%>
              <table width = "75%" border="1" align="left" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                <tr bgcolor="#E5E5E5">
                  <td width="23%" class="celula"><strong>Nome da Turma </strong></td>
                  <td width="18%" class="celula"><strong>Sala</strong></td>
                  <td width="31%" height="21" class="celula"><strong>Ano Letivo <span class="TextoForm"></span></strong></td>
                </tr>
                <%
				while not rs.eof
					cont = cont + 1	
					%>
                <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("Cod_Turma")%>')">
                  <td class="celula"><%=trim(rs("NomeTurma"))%></td>
                  <td class="celula"><%=trim(rs("Sala"))%></td>
                  <td height="20" class="celula"><%=trim(rs("AnoLetivo"))%></td>
                </tr>
                <%				
					rs.movenext
					wend
				  %>
                <tr>
                  <td height="21" colspan="3" class="celula">Total Registros : <%=cont%></td>
                </table>
              <%
			  end if
			  rs.close%></td>
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