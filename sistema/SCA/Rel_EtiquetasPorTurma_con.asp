<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/02/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Extrato de NOtas
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
		var caminho;
		if (frm.cmbModeloEtiqueta.value=='0'){
			alert('Modelo da etiqueta deve ser informada.');
			frm.cmbModeloEtiqueta.focus();
			return false
		}
		caminho = "Rel_EtiquetaPorTurma_rel.asp"
		frm.action = caminho;
		frm.submit();
		return true;	
	}	
</script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
<%
	strPaginaTitulo = "Rel_EtiquetasPorTurma_con.asp"
	
	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"
	strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"
	
	strOpcaoRelatorio		= Trim(Request.Form("optOpcao"))
	intCodModeloEtiqueta	= Trim(Request.Form("cmbModeloEtiqueta"))
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodDisciplinaTurma   = trim(request("cmbDisciplinaTurma"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	intCodGrade				= Trim(Request.Form("cmbGrade"))
	strSexo					= Trim(Request.Form("cmbSexo"))
	strMes					= Trim(Request.Form("cmbMes"))
	
	strCodParcelaInicial	= Trim(Request.Form("cmbParcelaInicial"))
	strCodParcelaFinal		= Trim(Request.Form("cmbParcelaFinal"))
	strAnoInicial			= Trim(Request.Form("cmbAnoInicial"))
	strAnoFinal				= Trim(Request.Form("cmbAnoFinal"))
	strStatusFinanceiro  	= Trim(Request.Form("cmbStatusFinanceiro"))
	intCodTipoParcela		= Trim(Request.Form("cmbTipoParcela"))
    
	
    if strCodParcelaInicial = "" or strCodParcelaInicial = "0" then strCodParcelaInicial = 1	
    if strCodParcelaFinal = "" or strCodParcelaFinal = "0" then strCodParcelaFinal = month(date)	
	if strAnoInicial = "" or strAnoInicial = "0" then strAnoInicial = year(date)	
  	if strAnoFinal = "" or strAnoFinal = "0" then strAnoFinal = year(date)	

	if strMes = "" or strMes = "0" then strMes = month(date)

	intCodTurno		 		= Trim(Request.Form("cmbTurno"))
	intCodPlanoPagamento	= Trim(Request.Form("cmbPlanoPagamento"))
	strSala		 			= Trim(Request.Form("txtSala"))
	intAno		 			= Trim(Request.Form("txtAno"))
	strSubTitulo 			= Trim(Request.Form("txtSubTitulo"))
	
	if Trim(Request.Form("txtAnoLetivo")) <> "" then
	   strAnoLetivo = Trim(Request.Form("txtAnoLetivo"))
	else
	   strAnoLetivo = session("strAnoLetivo")   
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

	strOpcaoRelatorio		= Trim(Request.Form("optOpcao"))
	strFiltroSerie = "0"
	strFiltroTurno = "0"

	if strSexo = "" then strSexo = "0"
	if intCodComp = "" then intCodComp = "0"
	if intCodSerie = "" then intCodSerie = "0"
	if intCodTurno = "" then intCodTurno = "0"
	if intCodTurma = "" then intCodTurma = "0"
	if intCodSemestre = "" then intCodSemestre = "0"
	if intCodTipoLancamento = "" then intCodTipoLancamento = "0"
	if intCodDisciplinaTurma = "" then intCodDisciplinaTurma = "0"
	if intCodNota = "" then intCodNota="0"

	'controla os botões
	strDesabilitaIncluir = "disabled"
	strDesabilitaExcluir = "disabled"
	strDesabilitaAlterar = ""
	strDesabilitaLimpar = ""
	
	strExecutarFuncaoParcInicial="S"
	strExecutarFuncaoAnoInicial="S"
	strExecutarFuncaoParcFinal="S"
	strExecutarFuncaoAnoFinal="S"
	strExecutarFuncao="S"

%> 
<form method="post" id="frm" action="#">
<input name="txtTipoRelatorio" type="hidden" value="<%=intTipoRelatorio%>">
<table width="966" border="0" cellpadding="0" cellspacing="0">
            <tr valign="top">
              <td width="100%" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
  </table>
<br>
	<table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
     <tr>
       <td height="38" colspan="3" class="texto1"><table width="40%" border="0" cellspacing="0" cellpadding="0">
         <tr>
           <td colspan="2" class="text"><div align="center"><strong>ATEN&Ccedil;&Atilde;O:<br>
           </strong>Antes de imprimir configurar as margens: </div></td>
         </tr>
         <tr>
           <td class="text"><div align="center">Esquerda: 7mm</div></td>
           <td class="text"><div align="center">Superior: 10mm</div></td>
         </tr>
         <tr>
           <td class="text"><div align="center">Direita:
             0mm</div></td>
           <td class="text"><div align="center">Inferior: 0</div></td>
         </tr>
       </table></td>
      </tr>
     <tr>
       <td height="19" class="texto1">&nbsp;</td>
       <td class="texto1">&nbsp;</td>
       <td class="texto1">&nbsp;</td>
     </tr>
    <tr>
      <td colspan="4"><hr size="1" color="#CCCCCC"></td>
    </tr>

     <tr>
       <td height="38" class="texto1"><strong>Op&ccedil;&atilde;o de Relat&oacute;rio: </strong></td>
       <td width="47%" class="texto1"><strong>
         <input <% if strOpcaoRelatorio = "0" then response.Write("checked")%> name="optOpcao" type="radio" value="0"  onClick="submit()">
Aniversariantes do Mês:&nbsp;&nbsp;
<!--#include file="../includes/inc_cmbMes.asp"-->&nbsp;apartir de 
<!--#include file="../includes/inc_cmbIdade.asp"-->&nbsp;anos

       </strong></td>
       <td width="37%" class="texto1"><p><strong>
         <input <% if strOpcaoRelatorio = "1" then response.Write("checked")%> name="optOpcao" type="radio" value="1" onClick="submit()">
         Documenta&ccedil;&otilde;es Pendentes &nbsp;&nbsp;
       </strong></p>       </td>
      </tr>
     <tr>
       <td class="texto1">&nbsp;</td>
       <td class="texto1"><strong>
         <input <% if strOpcaoRelatorio = "2" then response.Write("checked")%> name="optOpcao" type="radio" value="2" onClick="submit()">
         Financeiro
       </strong></td>
       <td class="texto1">&nbsp;</td>
     </tr>
		<tr> 
		<td colspan="2" class="texto1"><hr size="1" color="#CCCCCC"></td>
		</tr>
		
     <tr>
       <td colspan="3" class="texto1"><div align="center"></div></td>
      </tr>
     <tr>
       <td class="texto1">Ano Letivo:</td>
       <td colspan="2"><input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
     </tr> 
     
     <tr>
       <td class="texto1">Semestre:</td>
       <td colspan="2"><!--#include file="../includes/inc_cmdSemestre.asp"--></td>
     </tr>
     <tr>
      <td width="16%" class="texto1">Curso:</td>
      <td colspan="2"><span class="texto1"><!--#include file="../includes/inc_cmdCurso.asp"--></span></td>
    </tr>
    <tr>
      <td class="texto1">Per&iacute;odo:</td>
      <%
			 	if request.Form("txtHiddenStatus") <> "" then
				   strDesabilitaSerie = "disabled"
				end if
			 %>
      <td colspan="3"><!--#include file="../includes/inc_cmdPeriodo.asp"--></td>
    </tr>
    
    <tr>
      <td class="texto1">Turno:</td>
      <td colspan="3"><!--#include file="../includes/inc_cmdTurno.asp"--></td>
    </tr>
    
    <tr>
      <td class="texto1">Turma:</td>
      <td colspan="3"><!--#include file="../includes/inc_cmdTurma.asp"--></td>
    </tr>
    </tr>
	  <tr>
      <td class="texto1">Disciplina:</td>
       <td colspan="2"><!--#include file="../includes/inc_cmbDisciplinaTurma.asp"--></td>
    </tr>
    <tr>
      <td class="texto1">Sexo:</td>
      <td colspan="3"><span class="texto1">
        <!--#include file="../includes/inc_cmdSexo.asp" -->
      </span></td>
    </tr>
    <tr>
      <td class="texto1">Situa&ccedil;&atilde;o:</td>
      <td colspan="3"><!--#include file="../includes/inc_cmdSituacaoAluno.asp"--></td>
    </tr>
    <tr>
      <td class="texto1">Ordem:</td>
      <td colspan="3">
	  <select name="cmbOrdem" class="Combo" id="cmbOrdem"  style="width:100pt" >
      <option value="alfabetica" >Alfabetica</option>
	  <option value="matricula" >Matrícula</option>
	  <option value="datamatricula" >Data da Matricula</option>
	  <option value="dataafastamento" >Data de Afastamento</option>
	  <option value="idade" >Idade</option>
	  <option value="bairro" >Bairro</option>
	</select>	  </td>
    </tr>
    <tr>
      <td class="texto1">Modelo da Etiqueta:</td>
      <td colspan="3"><!--#include file="../includes/inc_cmbModeloEtiqueta.asp"--></td>
    </tr>
	<%for i=1 to 6%>
    <tr>
      <td class="texto1"><%=i%>&ordm; Campo</td>
      <td colspan="3">
          <select name="cmbCampo<%=i%>" class="Combo" id="cmbCampo<%=i%>"  style="width:100pt" >
			<option value="" >Selecione...</option>
            <option value="1" >Matrícula</option>
            <option value="12">Matrícula - Turma</option>
            <option value="2" >Nome do Aluno</option>
            <option value="4" >Data da Matrícula</option>
            <option value="5" >Período</option>
            <option value="6" >Curso</option>
            <option value="8" >Turma</option>
            <option value="9" >Endereço</option>
            <option value="13">Bairro - Cep</option>
            <option value="15">Cidade - UF</option>
            <option value="3" >Fone Residencial</option>
            <option value="16">Fone Comercial</option>
            <option value="17">Fone Celular</option>       
            <option value="18">Fones</option>       
          </select>      </td>
    </tr>
    <%next%>
			<tr>
			  	<td colspan="3"><hr size="1" color="#CCCCCC"></td>
			</tr>
	
	<% if strOpcaoRelatorio = "2" then %>
	       
			<tr>
			  <td colspan="2" class="texto1">&nbsp;</td>
	  		</tr>
			<tr>
				<td class="texto1">Parcela e Ano Inicial:</td>
        		<td class="texto1">
            	<!--#include file="../includes/inc_cmbParcelaInicial.asp" -->
            	/ 
            	<!--#include file="../includes/inc_cmbAnoInicial.asp" -->            </td>
          	</tr>
          	<tr> 
            	<td class="texto1">Parcela e Ano Final:</td>
            	<td class="texto1">
            	<!--#include file="../includes/inc_cmbParcelaFinal.asp" -->
            	/ 
            	<!--#include file="../includes/inc_cmbAnoFinal.asp" -->            </td>
          	</tr>
        	<tr>
            	<td class="texto1">Situa&ccedil;&atilde;o Financeira:</td>
            	<td class="texto1"> <!--#include file="../includes/inc_cmbStatusFinanceiro.asp" --></td>
          	</tr>
          	<tr> 
            	<td class="texto1">Tipo Parcela:</td>
            	<td class="texto1">	<!--#include file="../includes/inc_cmdTipoParcela.asp" --></td>
			<tr>
  		      <td colspan="3">&nbsp;</td>
             </tr>

		<% end if %>	 

	    <tr>
   		<td colspan="3"><!--#include file="../../includes/inc_botoes_geraRelatorio.asp"-->&nbsp;</td>
		</tr>
  </table>
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>
