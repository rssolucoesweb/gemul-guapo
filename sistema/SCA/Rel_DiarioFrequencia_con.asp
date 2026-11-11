<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/02/2008
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@hotmail.com
	::	Objetivo Pagina...: Diário de Frequência 
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link type="text/css" rel="stylesheet" href="../../Estilo/css.css">
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script src="../../js/js_funcoes_gerais.js"></script>
<script type="text/javascript" src="../../js/js_dragdrop.js"></script>
<script>
	function gerar(){
		
		var frm = document.getElementById("frm");
		
		if (frm.optOpcao[0].checked==false && frm.optOpcao[1].checked==false) {
			alert("Opção de relatório deve ser informada !");
			frm.optOpcao[0].focus();
			return false;
		}	
		if (frm.cmbCurso.value == "0") {
			alert("O Curso deve ser informado !");
			frm.cmbCurso.focus();
			return false;
		}	
		
		if (frm.cmbSemestre.value == "0") {
			alert("O Semestre deve ser informado !");
			frm.cmbSemestre.focus();
			return false;
		}
		
		frm.action = "Rel_DiarioFrequencia_rel.asp";
		frm.submit();
		
		return true;	
	}	
</script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_validaPermissaoPagina.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
<%
	strPaginaTitulo = "Rel_DiarioFrequencia_con.asp"

	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"
	strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"
	strExecutarSubmitBimestre = "S"

	strOpcaoRelatorio 		= Trim(Request.Form("optOpcao"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	
	intCodTurno		 		= Trim(Request.Form("cmbTurno"))
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodDisciplinaTurma	= Trim(Request.Form("cmbDisciplinaTurma"))
	intCodDisciplinaCurso	= Trim(Request.Form("cmbDisciplinaCurso"))
	intCodEstagio     		= Trim(Request.Form("cmbEstagio"))
	
	strclasse=Trim(Request.Form("cmbTamanhoFonteArial"))
	
	if Trim(Request.Form("txtAnoLetivo")) <> "" then
	   strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	else
	   strAnoLetivo = session("strAnoLetivo")   
	end if   
	'intSemestre 			= session("strSemestre")
	intCodBimestre			= Trim(Request.Form("cmbBimestre"))
	
	strMes 					= Trim(Request.Form("cmbMes"))
	if strMes = "" then strMes = month(date)
	
	strFiltroSerie = "0"
	strFiltroTurno = "0"

	if intCodComp = "" then intCodComp = "0"
	if intCodSerie = "" then intCodSerie = "0"
	if intCodTurno = "" then intCodTurno = "0"
	if intCodTurma = "" then intCodTurma = "0"
	if intSemestre = "" then intSemestre = "0"
	if intCodTipoLancamento = "" then intCodTipoLancamento = "0"
	if intCodDisciplinaTurma = "" then intCodDisciplinaTurma = "0"
	if intCodNota = "" then intCodNota="0"
	if intCodEstagio = "" then intCodEstagio="0"
	
	' Consulta a Categoria	
	sql = "select codigo "
	sql = sql & " from SRH_COLABORADOR"
	sql = sql & " where codigo_SEG_USUARIOS_SISTEMA = '" & trim(session("usuarioWeb")) & "'"
	sql = sql & " and codLotacao = " & Session("CodEmpresa")
	sql = sql & " and CodCategoria = 1 "'professor
	sql = sql & " and Situacao = 'A'" 'Ativo
	rs.open sql, cnn
	if rs.EOF = false then	
		strVerificaCategoria 		= "Professor"
		intCodColaboradorProfessor 	= trim(rs("codigo"))
	else
		strVerificaCategoria = ""
	end if
	rs.close

    if strVerificaCategoria <> "Professor" then
	   intCodDisciplina			= Trim(Request("cmbDisciplinaTurma"))
	   intCodDisciplinaTurma	= Trim(Request.Form("cmbDisciplinaTurma"))
	else
	   intCodDisciplina		    = Trim(Request("cmbDisciplinaDoProfessor"))
	   intCodDisciplinaTurma	= Trim(Request("cmbDisciplinaDoProfessor"))
	end if   

    if strVerificaCategoria <> "Professor" then
		intCodTurma 			= Trim(Request("cmbTurma"))
		intCodTurmaProfessor	= Trim(Request("cmbTurma"))
	else   
		intCodTurma				= Trim(Request("cmbTurmaProfessor"))
		intCodTurmaProfessor	= Trim(Request("cmbTurmaProfessor"))
	end if   

	if trim(intCodTurma) <> "" then
		sql = "SELECT SCA_TURMA.cod_turma, SCA_TURMA.cod_Semestre , SCA_PERIODO.Cod_Curso, SCA_PERIODO.Cod_Periodo, SCA_TURMA.cod_turno, SCA_TURMA.Sala, SCA_TURMA.NomeTurma"
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
			intSemestre = rs("cod_Semestre")
		END IF
		rs.close
	end if


	'controla os botões
	strDesabilitaIncluir 	= "disabled"
	strDesabilitaExcluir 	= "disabled"
	strDesabilitaAlterar 	= ""
	strDesabilitaLimpar 	= ""
	
	if intCodBimestre <> "0" then
		strColunas = 60
		strMes = "0"
	else
		strColunas = 30
	end if

%>
<form method="post" id="frm" action="#">
<input name="txtTipoRelatorio" type="hidden" value="<%=intTipoRelatorio%>">
<table width="100%" border="0"  bgcolor="#FFFFFF"cellpadding="0" cellspacing="0">
            <tr valign="top">
              <td align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
  </table>
	<table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" bgcolor="#FFFFFF">
     <tr>
       <td class="texto1"><strong>Op&ccedil;&atilde;o de Relat&oacute;rio: </strong></td>
       <td class="texto1"><strong>
        <input <% if strOpcaoRelatorio = "T" then response.Write("checked")%> name="optOpcao" type="radio" value="T">
        Por Turma &nbsp;&nbsp;&nbsp;&nbsp;
        <br>
        <input <% if strOpcaoRelatorio = "A" then response.Write("checked")%> name="optOpcao" type="radio" value="A">
Por Grade de Disciplinas</strong></td>
     </tr>
     <tr>
       <td class="texto1">&nbsp;</td>
       <td>&nbsp;</td>
     </tr>
     <tr>
       <td class="texto1">Ano Letivo:</td>
       <td><input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
     </tr>
     <tr>
       <td class="texto1">Semestre:</td>
       <td><!--#include file="../includes/inc_cmdSemestre.asp"--></td>
     </tr>
     <tr>
      <td width="21%" class="texto1">Curso:</td>
      <td width="79%"><span class="texto1"><!--#include file="../includes/inc_cmdCurso.asp"--></span></td>
    </tr>
    <tr>
      <td class="texto1">Per&iacute;odo:</td>
      <%
			 	if request.Form("txtHiddenStatus") <> "" then
				   strDesabilitaSerie = "disabled"
				end if
			 %>
      <td colspan="2"><!--#include file="../includes/inc_cmdPeriodo.asp"--></td>
    </tr>
    
    <tr>
      <td class="texto1">Turno:</td>
      <td colspan="2"><!--#include file="../includes/inc_cmdTurno.asp"--></td>
    </tr>
    
    <tr>
      <td class="texto1">Turma:</td>
        <td>
          <% if strVerificaCategoria <> "Professor" then %>
             <!--#include file="../includes/inc_cmdTurma.asp"-->
          <% else %>	 
             <!--#include file="../includes/inc_cmdTurmaProfessor.asp"-->
          <% end if %>      </td>
    </tr>
    <tr>
      <td class="texto1">Bimestre:</td>
      <td colspan="2"><!--#include file="../includes/inc_cmdBimestre.asp"--></td>
    </tr>
    <tr>
      <td class="texto1">M&ecirc;s Refer&ecirc;ncia:</td>
      <td colspan="2"><!--#include file="../includes/inc_cmbMes.asp"--></td>
    </tr>
<%if intCodTurma <>"0" then%>
    <tr>
      <td class="texto1">Disciplina:</td>
        <td>
          <% if strVerificaCategoria <> "Professor" then %>
                <!--#include file="../includes/inc_cmbDisciplinaTurma.asp"-->
          <% else %>
                <!--#include file="../includes/inc_cmdDisciplinaDoProfessor.asp"-->			  
          <% end if %>         </td>
    </tr>
<%else%>
    <tr>
      <td class="texto1">Disciplina:</td>
      <td colspan="2"><!--#include file="../includes/inc_cmbDisciplinaCurso.asp"--></td>
    </tr>
<%end if%>
    <tr>
      <td class="texto1">Tipo de Disciplinas:</td>
      <td class="texto1"><select name="cmbTipoDisciplina" class="Combo" id="cmbTipoDisciplina" style="width:100pt" >
          <option value="CR" >Curricular</option>
          <option value="DE" >Depend&ecirc;cia</option>
          <option value="CD" >Curricular e Depend&ecirc;cia</option>
      </select></td>
      <td class="texto1">&nbsp;</td>
    </tr>
    <tr>
      <td class="texto1">Est&aacute;gio: </td>
      <td class="texto1"><!--#include file="../includes/inc_cmdEstagio.asp"--></td>
      <td class="texto1">&nbsp;</td>
    </tr>
    <tr>
      <td class="texto1">Mostrar Conte&uacute;do Program&aacute;tico: </td>
      <td class="texto1"><input type="checkbox" name="mostraConteudo" value="S"></td>
      <td width="0%" class="texto1">&nbsp;</td>
    </tr>
    <tr>
      <td class="texto1">Omitir Dados do Relat&oacute;rio: </td>
      <td class="texto1"><input type="checkbox" name="omiteDadosdoDiario" value="S"></td>
      <td class="texto1">&nbsp;</td>
    </tr>
    <tr>
      <td class="texto1">Omitir Data Impress&atilde;o:</td>
      <td class="texto1"><input type="checkbox" name="omiteDataImpressao" value="S"></td>
      <td class="texto1">&nbsp;</td>
    </tr>
    <tr>
      <td class="texto1">Omitir ACM. FAL.:</td>
      <td class="texto1"><input type="checkbox" name="omiteAcumuladoFalta" value="S"></td>
      <td class="texto1">&nbsp;</td>
    </tr>
    <tr>
      <td class="texto1">Colunas:</td>
      <td class="texto1">

      <select name="cmbColunas" class="combo" id="cmbColunas"  style="width:80pt" >
      <option value="15" <%if strColunas = "15" then response.Write("selected") %>>15</option>
      <option value="16" <%if strColunas = "16" then response.Write("selected") %>>16</option>
      <option value="17" <%if strColunas = "17" then response.Write("selected") %>>17</option>
      <option value="18" <%if strColunas = "18" then response.Write("selected") %>>18</option>
      <option value="19" <%if strColunas = "19" then response.Write("selected") %>>19</option>
      <option value="20" <%if strColunas = "20" then response.Write("selected") %>>20</option>
      <option value="21" <%if strColunas = "21" then response.Write("selected") %>>21</option>
      <option value="22" <%if strColunas = "22" then response.Write("selected") %>>22</option>
      <option value="23" <%if strColunas = "23" then response.Write("selected") %>>23</option>
      <option value="24" <%if strColunas = "24" then response.Write("selected") %>>24</option>
      <option value="25" <%if strColunas = "25" then response.Write("selected") %>>25</option>
      <option value="26" <%if strColunas = "26" then response.Write("selected") %>>26</option>
      <option value="27" <%if strColunas = "27" then response.Write("selected") %>>27</option>
      <option value="28" <%if strColunas = "28" then response.Write("selected") %>>28</option>
      <option value="29" <%if strColunas = "29" then response.Write("selected") %>>29</option>
      <option value="30" <%if strColunas = "30" then response.Write("selected") %>>30</option>
      <%if intCodBimestre <> "0" then %>
        <option value="31" <%if strColunas = "31" then response.Write("selected") %>>31</option>
        <option value="32" <%if strColunas = "32" then response.Write("selected") %>>32</option>
        <option value="33" <%if strColunas = "33" then response.Write("selected") %>>33</option>
        <option value="34" <%if strColunas = "34" then response.Write("selected") %>>34</option>
        <option value="35" <%if strColunas = "35" then response.Write("selected") %>>35</option>
        <option value="36" <%if strColunas = "36" then response.Write("selected") %>>36</option>
        <option value="37" <%if strColunas = "37" then response.Write("selected") %>>37</option>
        <option value="38" <%if strColunas = "38" then response.Write("selected") %>>38</option>
        <option value="39" <%if strColunas = "39" then response.Write("selected") %>>39</option>
        <option value="40" <%if strColunas = "40" then response.Write("selected") %>>40</option>
        <option value="41" <%if strColunas = "41" then response.Write("selected") %>>41</option>
        <option value="42" <%if strColunas = "42" then response.Write("selected") %>>42</option>
        <option value="43" <%if strColunas = "43" then response.Write("selected") %>>43</option>
        <option value="44" <%if strColunas = "44" then response.Write("selected") %>>44</option>
        <option value="45" <%if strColunas = "45" then response.Write("selected") %>>45</option>
        <option value="46" <%if strColunas = "46" then response.Write("selected") %>>46</option>
        <option value="47" <%if strColunas = "47" then response.Write("selected") %>>47</option>
        <option value="48" <%if strColunas = "48" then response.Write("selected") %>>48</option>
        <option value="49" <%if strColunas = "49" then response.Write("selected") %>>49</option>
        <option value="50" <%if strColunas = "50" then response.Write("selected") %>>50</option>
        <option value="51" <%if strColunas = "51" then response.Write("selected") %>>51</option>
        <option value="52" <%if strColunas = "52" then response.Write("selected") %>>52</option>
        <option value="53" <%if strColunas = "53" then response.Write("selected") %>>53</option>
        <option value="54" <%if strColunas = "54" then response.Write("selected") %>>54</option>
        <option value="55" <%if strColunas = "55" then response.Write("selected") %>>55</option>
        <option value="56" <%if strColunas = "56" then response.Write("selected") %>>56</option>
        <option value="57" <%if strColunas = "57" then response.Write("selected") %>>57</option>
        <option value="58" <%if strColunas = "58" then response.Write("selected") %>>58</option>
        <option value="59" <%if strColunas = "59" then response.Write("selected") %>>59</option>
        <option value="60" <%if strColunas = "60" then response.Write("selected") %>>60</option>
      <% end if %> 
    </select>      </td>
      <td class="texto1">&nbsp;</td>
    </tr>
    <tr>
      <td class="texto1">Tamanho da Fonte:</td>
      <td class="texto1"><!--#include file="../includes/inc_cmbTamanhoFonteArial.asp"--></td>
      <td class="texto1">&nbsp;</td>
    </tr>
    <tr>
      <td class="texto1">Linhas por P&aacute;gina: </td>
      <td class="texto1"><!--#include file="../includes/inc_cmbLinhaPorPagina.asp"--></td>
      <td class="texto1">&nbsp;</td>
    </tr>
    <tr>
      <td class="texto1">Op&ccedil;&atilde;o de Visualiza&ccedil;&atilde;o:</td>
      <td class="texto1"><!--#include file="../includes/inc_cmbOpcaoVisualizacao.asp"--></td>
      <td class="texto1">&nbsp;</td>
    </tr>
<!--
    <tr>
      <td class="texto1">Op&ccedil;&atilde;o de Visualiza&ccedil;&atilde;o</td>
      <td class="texto1"><select name="cmbVisualizacao" id="cmbVisualizacao"  style="width:70pt" class="combo" >
  <option  value="R">Retrato</option>
  <option  value="P">Paisagem</option>
</select></td>
      <td class="texto1">&nbsp;</td>
    </tr>
  -->
    <tr>
      <td colspan="3" class="texto1"><em><strong><br>
      * Melhor visualiza&ccedil;&atilde;o e impress&atilde;o modo paisagem</strong></em></td>
      </tr>
    <tr>
      <td colspan="3" class="texto1">&nbsp;</td>
      </tr>
    <tr>
      <td colspan="3"><hr size="1" color="#CCCCCC"></td>
    </tr>
    <tr>
      <td colspan="3"><!--#include file="../../includes/inc_botoes_geraRelatorio.asp"-->&nbsp;</td>
    </tr>
  </table>
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>
