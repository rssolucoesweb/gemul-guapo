<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../estilo/css.css" rel="stylesheet" type="text/css"></head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script src="../../js/js_funcoes_gerais.js"></script>
<!--#include file="../../includes/inc_cnn.asp"-->
<script>

	function Fechar(){
		window.opener.frm1.submit();
		window.close();	
	}	
	
	function salvar(acao){
		
		var frm11 = document.getElementById("frm1");
		
		if (frm1.txtCodGrade.value == ""){
			alert("A Grade deve ser informada.");
			frm1.txtCodGrade.focus();
			return false;
		}
		
		if (frm1.txtCodCurricularDisciplina.value == "") {
			alert("A Disciplina deve ser informada !");
			frm1.txtCodCurricularDisciplina.focus();
			return false;
		}

		if (frm1.txtChSemanal.value == "") {
			alert("A Carga Horaria semanal deve ser informada !");
			frm1.txtChSemanal.focus();
			return false;
		}

		if (frm1.txtChMensal.value == "") {
			alert("A Carga Horaria Mensal deve ser informada !");
			frm1.txtChMensal.focus();
			return false;
		}

		if (frm1.txtChAnual.value == "") {
			alert("A Carga Horaria Anual em numero de Aulas, deve ser informada !");
			frm1.txtChAnual.focus();
			return false;
		}

		
		frm1.action="GradeCurricularDisciplina_cod.asp?acao=" + acao;
		frm1.submit();
		return true;
 	}
</script>
<%	  
    strExecutarDisciplinaGrade = "S"

	intCodEmpresa 				= Session("CodEmpresa")
	intCodGrade					= Trim(Request.QueryString("CodGrade"))
	if Trim(Request.form("cmbDisciplinaGrade")) = ""  then
		intCodCurricularDisciplina	= Trim(Request.QueryString("GradeCurricularDisciplina"))
		intDisciplinaPreRequisito   = Trim(Request.form("cmbDisciplinaPreRequisito"))
	else	
		intCodCurricularDisciplina	= Trim(Request.form("cmbDisciplinaGrade"))
	end if	
	
	if intCodGrade <> 0 then 
		
		sql = " SELECT SCA_GRADECURRICULARDISCIPLINA.COD_GRADECURRICULAR, SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina, "
		sql = sql & " SCA_DISCIPLINA.DESC_Disciplina, SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricularDisciplina, "
		sql = sql & " SCA_GRADECURRICULARDISCIPLINA.Ch_Semanal, SCA_GRADECURRICULARDISCIPLINA.Ch_Pratica, SCA_GRADECURRICULARDISCIPLINA.Ch_Teorica, "
		sql = sql & " SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricularDisciplina_Equivalente, "
		sql = sql & " SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricular_Equivalente,"
		sql = sql & " SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina_Equivalente, "
		sql = sql & " SCA_GRADECURRICULARDISCIPLINA.Ch_Mensal, SCA_GRADECURRICULARDISCIPLINA.Ch_Anual, "
		sql = sql & " ISNULL(SCA_GRADECURRICULARDISCIPLINA.Omitir_Criterio,'N') as Omitir_Criterio "
		sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA INNER JOIN SCA_DISCIPLINA "
		sql = sql & " ON SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = SCA_DISCIPLINA.COD_Disciplina "
		sql = sql & " WHERE SCA_GRADECURRICULARDISCIPLINA.COD_GRADECURRICULAR = " &  intCodGrade
		sql = sql & " And SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricularDisciplina = " &  intCodCurricularDisciplina
		rs.open sql, cnn		
	
		if rs.eof = false then
			strDESCDisciplina 	= trim(rs("DESC_Disciplina"))
			strCh_Semanal 		= trim(rs("Ch_Semanal"))
			strCh_Mensal 		= trim(rs("Ch_Mensal"))
			strCh_Anual 		= trim(rs("Ch_Anual"))
			strCh_Pratica 		= trim(rs("Ch_Pratica"))
			strCh_Teorica 		= trim(rs("Ch_Teorica"))
			strOmitirCriterio 	= trim(rs("Omitir_Criterio"))
			
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir

		end if
		rs.close
		
	else
		
		strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
		
	end if 
%>
<table width="100%" height="195" cellpadding="0" cellspacing="0" class="CorFundo" bgcolor="#FFFFFF">
  <tr  valign="top">
    <td width="500" height="162" align="center"  class="celula">
	<form id="frm1" method="post">
	  <table width="100%" border="0" cellpadding="0" cellspacing="0" >
        <tr valign="top">
          <td align="center" class="tituloPrincipal"><span class="tituloPrincipal style2">Disciplina</span></td>
        </tr>
        <tr valign="top">
          <td align="left" >
		 </td>
        </tr>
        <tr valign="top">
          <td align="center" class="tituloPrincipal style2">&nbsp;</td>
        </tr>
        <tr valign="top">
          <td height="18" bgcolor="#CCCCCC" class="texto">Dados Disciplina</td>
        </tr>
      </table>
      
      <table border="0" cellpadding="3" cellspacing="0" width="534">

                  <tr>
                    <td class="texto">Selecionar Disciplina:</td>
                    <td><!--#include file="../includes/inc_cmdDisciplinaGradeAlteracao.asp"--></td>
                  </tr>
                  <tr>
                    <td width="144" class="texto">C&oacute;digo Grade:</td>
                    <td width="378"><input name="txtCodGrade" type="text" id="txtCodGrade" class="text" size="10" readonly=false value="<%=intCodGrade%>" maxlength="10"></td>
                  </tr>
                  <tr>
                    <td class="texto">Disciplina:</td>
                    <td><input name="txtCodCurricularDisciplina" type="text" id="txtCodCurricularDisciplina" class="text" size="10" readonly=false value="<%=intCodCurricularDisciplina%>" maxlength="10"> <span class="texto1">
                      <input name="txtDescDisciplina" type="text" class="text" id="txtDescDisciplina"  readonly=false size="50" maxlength="50" value="<%=strDESCDisciplina%>"  onKeyPress="return formataCampo(this, 1, 50)">
                    </span></td>
                  </tr>
                  

                  <tr>
                    <td colspan="2" class="texto">&nbsp;</td>
                  </tr>
                  <tr>
                    <td colspan="2" bgcolor="#CCCCCC" class="texto">Dados Carga Horaria</td>
                  </tr>
                  <tr>
                    <td colspan="2" class="texto">                    </td>
                  </tr>
                  <tr>
                    <td colspan="2" class="texto"><table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" class="tabela" >
                      
                      <tr bgcolor="#D3D3D3">
                        <td colspan="3" align="center" class="celula"><strong>Aulas</strong></td>
                        <td colspan="2" align="center" class="celula"><strong>Horas</strong></td>
                        <td colspan="2" align="center" class="celula"><strong>Horas - (Opcional)</strong></td>
                        <td width="13%" colspan="2" rowspan="2" align="center" class="celula"><strong>Omitir Crit&eacute;rio de Avalia&ccedil;&atilde;o</strong></td>
                      </tr>
                      <tr bgcolor="#D3D3D3">
                        <td width="13%" align="center" class="celula"><strong>C.H. Semanal </strong></td>
                        <td width="11%" align="center" class="celula"><strong>C.H. Mensal </strong></td>
                        <td width="10%" align="center" class="celula"><strong>C.H. Total</strong></td>
                        <td width="13%" align="center" class="celula"><strong>Hora Rel&oacute;gio</strong></td>
                        <td width="13%" align="center" class="celula"><strong>C.H. Total</strong></td>
                        <td width="13%" align="center" class="celula"><strong>C.H. Pr&aacute;tica</strong></td>
                        <td width="13%" align="center" class="celula"><strong>C.H. Te&oacute;rica</strong></td>
                      </tr>
                          <tr bgcolor="#F3F3F3">
                        <td class="celula" align="center"><input name="txtChSemanal" type="text" class="text" id="txtChSemanal" onKeyPress="return formataCampo(this,2,5)"  value="<%=strCh_Semanal%>" size="5" maxlength="8"></td>
                        <td class="celula" align="center"><input name="txtChMensal" type="text" class="text" id="txtChMensal" onKeyPress="return formataCampo(this,2,5)"  value="<%=strCh_Mensal%>" size="5" maxlength="8"></td>
                        <td align="center" class="celula"><input name="txtChAnual" type="text" class="text" id="txtChAnual" onKeyPress="return formataCampo(this,2,5)"  value="<%=strCh_Anual%>" size="5" maxlength="8"></td>
                        <td align="center" class="celula"><input name="txtChHorasRelogio" type="text" class="text" id="txtChHorasRelogio" onKeyPress="return formataCampo(this,2,5)"  value="<%=strCh_HoraRelogio%>" size="5" maxlength="8"></td>
                        <td align="center" class="celula"><input name="txtChHoras" type="text" class="text" id="txtChHoras" onKeyPress="return formataCampo(this,2,5)"  value="<%=strCh_Horas%>" size="5" maxlength="8"></td>
                        <td align="center" class="celula"><input name="txtChPratica" type="text" class="text" id="txtChPratica" onKeyPress="return formataCampo(this,2,5)"  value="<%=strCh_Pratica%>" size="5" maxlength="8"></td>
                        <td align="center" class="celula"><input name="txtChTeorica" type="text" class="text" id="txtChTeorica" onKeyPress="return formataCampo(this,2,5)"  value="<%=strCh_Teorica%>" size="5" maxlength="8"></td>
                        <td align="center" class="celula"><select name="cmbOmitirCriterio" class="combo" id="cmbOmitirCriterio"  style="width:50pt" onchange='' >
              <option value="N" <%if strOmitirCriterio = "N" then response.Write("selected") %>>NAO</option>
              <option value="S" <%if strOmitirCriterio = "S" then response.Write("selected") %>>SIM</option>
            </select></td>
                      </tr>
                  </table>                  </tr>
                  <tr>
                    <td colspan="2" class="texto">&nbsp;</td>
                  </tr>
                  <tr>
                    <td colspan="2" class="texto"><!--#include file="../../includes/inc_botoes_cadastroPopapD.asp"--></td>
                  </tr>
              </table>
	  </form>
	  </td>
  </tr>
  <tr >
  <td height="31" align="center"  class="celula">&nbsp;</td>
  </tr>
</table>

</body>
</html>