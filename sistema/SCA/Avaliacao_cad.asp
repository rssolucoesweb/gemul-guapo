<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 27/11/2007
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Criterio de Avaliação
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
	function mostralinha(tipo){
		if (tipo == 'EF'){
			linhaREC.style.display="none";
			linhaEF.style.display="block";
		}
		if (tipo == 'REC'){
			linhaEF.style.display="none";
			linhaREC.style.display="block";
		}
	}
	function salvar(acao){
	
		if (frm.cmbCurso.value=="0"){
			alert("O curso deve ser informado!");
			frm.cmbCurso.focus();
			return false;
		}
		
		/*if (frm.txtFMedia.value==""){
			alert("A fórmula deve ser informada!");
			frm.txtFMedia.focus();
			return false;
		}*/					
		if (frm.txtMedia.value==""){
			alert("A média de aprovação deve ser informada!");
			frm.txtMedia.focus();
			return false;
		}else{
			if(parseFloat(frm.txtMedia.value) > 10){
				alert("O valor da média de aprovação deve ser menor ou igual a 10!");
				frm.txtMedia.focus();
				return false;
			}		
		}
	
		if (frm.formulaFinal[0].checked==true) {
			
			if (frm.txtMediaAprovacaoFinalEF.value==""){
				alert("A média de aprovação após exame final deve ser informada!");
				frm.txtMediaAprovacaoFinalEF.focus();
				return false;
			}else{
				if(parseFloat(frm.txtMediaAprovacaoFinalEF.value) > 10){
					alert("O valor da média de aprovação exame final deve ser menor ou igual a 10!");
					frm.txtMediaAprovacaoFinalEF.focus();
					return false;
				}		
			}
			if (frm.condicaoEF_notaInicial.value==""){
				alert("A condição para o exame final deve ser informada!");
				frm.condicaoEF_notaInicial.focus();
				return false;
			}
			if (frm.condicaoEF_notaFinal.value==""){
				alert("A condição para o exame final deve ser informada!");
				frm.condicaoEF_notaFinal.focus();
				return false;
			}						
			
		}
		
		if (frm.formulaFinal[1].checked==true) {
		
			if (frm.txtMediaAprovacaoFinalREC.value==""){
				alert("A média de aprovação após a recuperação deve ser informada!");
				frm.txtMediaAprovacaoFinalREC.focus();
				return false;
			}else{
				if(parseFloat(frm.txtMediaAprovacaoFinalREC.value) > 10){
					alert("O valor da média de aprovação da recupareação deve ser menor ou igual a 10!");
					frm.txtMediaAprovacaoFinalREC.focus();
					return false;
				}		
			}
			if (frm.txtNumDisciplinaRec.value==""){
				alert("A quantidade de disciplinas para a recuperação final deve ser informada!");
				frm.txtNumDisciplinaRec.focus();
				return false;
			}						
			
		}
		
		if (frm.txtFrequencia.value==""){
			alert("A freqüência deve ser informada!");
			frm.txtFrequencia.focus();
			return false;
		}else{
			if(parseFloat(frm.txtFrequencia.value) > 100){
				alert("O valor da freqüência mínima deve ser menor ou igual a 100%!");
				frm.txtFrequencia.focus();
				return false;
			}		
		}		
		
		if (frm.txtDuracao.value==""){
			alert("A duração do ano letivo deve ser informada!");
			frm.txtDuracao.focus();
			return false;
		}else{
			if(parseInt(frm.txtDuracao.value) > 365){
				alert("O valor da duração do ano letivo deve ser menor ou igual a 365!");
				frm.txtDuracao.focus();
				return false;
			}		
		}
		
		if (frm.txtQtdeAvaliacao.value==0){
			alert("As avaliações devem ser cadastradas no Tipo de Avaliação!");
			return false;
		}
		
		frm.action="Avaliacao_cod.asp?acao=" + acao;
		frm.submit();
		return true;	 
		
}

function editorFormula(tipoFormula,conteudoFormula){
	window.open ("AvaliacaoPeso_cad.asp?codigo=" + frm.txtCodigo.value + "&tipoFormula=" + tipoFormula + "&intCodCurso=" + frm.cmbCurso.value + "&conteudoFormula=" + conteudoFormula,"Editor","height=300,width=460,statusbar=yes");
}
function editorFormulaEF(tipoFormula,conteudoFormula){
	window.open ("AvaliacaoPesoEF_cad.asp?codigo=" + frm.txtCodigo.value + "&tipoFormula=" + tipoFormula + "&intCodCurso=" + frm.cmbCurso.value + "&conteudoFormula=" + conteudoFormula,"Editor","height=300,width=460,statusbar=yes");
}
function editorFormularREC(tipoFormula,conteudoFormula){
	window.open ("AvaliacaoPesoREC_cad.asp?codigo=" + frm.txtCodigo.value + "&tipoFormula=" + tipoFormula + "&intCodCurso=" + frm.cmbCurso.value + "&conteudoFormula=" + conteudoFormula,"Editor","height=300,width=460,statusbar=yes");
}

</script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_validaPermissaoPagina.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%
strPaginaTitulo = "Avaliacao_cad.asp"
strExecutarSubmitCurso = "S"
strDesabilitaEditar = "disabled"
intCodSemestre 			= request.Form("cmbSemestre")

strcondicaoEF_notaInicial	= request.Form("condicaoEF_notaInicial")
strcondicaoEF_notaFinal		= request.Form("condicaoEF_notaFinal")

if intCodSemestre 		= "" then intCodSemestre = "0"
strTipoFormulaFinal		= request.Form("formulaFinal")
if strTipoFormulaFinal = "" then strTipoFormulaFinal = "EF"

if strTipoFormulaFinal = "EF" then
	strMostraLinhaREC = " style='display:none' "
	strMostraLinhaEF = " style='display:block' "
elseif strTipoFormulaFinal = "REC" then
	strMostraLinhaEF = " style='display:none' "
	strMostraLinhaREC = " style='display:block' "
end if

intCodCurso 				= Trim(Request.QueryString("intCodCurso"))
if intCodCurso = "" then
	intCodCurso = Trim(Request("cmbCurso"))
end if

if intCodCurso = "" then intCodCurso="0"

'seleciona os dados da composição escolhida
if intCodCurso<>"0" then
	sql	=	"select * from SCA_CRITERIO_AVALIACAO"
	sql	=	sql & " where cod_curso=" & intCodCurso
	sql	=	sql & " and cod_empresa=" & Session("CodEmpresa") 
	rs.open sql, cnn
	if rs.eof = false then
		strDesabilitaEditar= ""
		intCodigo		   = trim(rs("codigo"))
		strMedia           = trim(rs("media_aprovacao"))
		strMediaAprovacaoFinal      = trim(rs("media_aprovacao_final"))
		strTipoFormulaFinal = trim(rs("tipoFormulaFinal"))
		intFrequencia      = trim(rs("frequencia_minima_percentual"))
		intDuracao         = trim(rs("qtd_aula"))
		strCC        		 = trim(rs("CC"))

		if isnull(rs("peso_1bim")) = false then
			intPeso1Bim = rs("peso_1bim")
		else
			intPeso1Bim = 0
		end if
		
		if isnull(rs("peso_2bim")) = false then
			intPeso2Bim = rs("peso_2bim")
		else
			intPeso2Bim = 0			
		end if			
		
		if isnull(rs("peso_3bim")) = false then
			intPeso3Bim = rs("peso_3bim")
		else
			intPeso3Bim = 0			
		end if			
		
		if isnull(rs("peso_4bim")) = false then
			intPeso4Bim = rs("peso_4bim")
		else
			intPeso4Bim = 0			
		end if
		
		if isnull(rs("peso_EF")) = false then
			intPesoEF = rs("peso_EF")
		else
			intPesoEF = 0			
		end if

		if isnull(rs("condicaoEF_notaInicial")) = false then
			strcondicaoEF_notaInicial = rs("condicaoEF_notaInicial")
		else
			strcondicaoEF_notaInicial = ""
		end if
		if isnull(rs("condicaoEF_notaFinal")) = false then
			strcondicaoEF_notaFinal = rs("condicaoEF_notaFinal")
		else
			strcondicaoEF_notaFinal = ""	
		end if				
				
		'*****Formula da média anual
		strFMedia			= trim(rs("formula"))
		if trim(strTipoFormulaFinal) = "EF" then		
			strFMediaEF			= trim(rs("formulaEF"))
			strMostraLinhaREC = " style='display:none' "
			strMostraLinhaEF = " style='display:block' "
		end if
		if trim(strTipoFormulaFinal) = "REC" then		
			strFMediaREC		= trim(rs("formulaEF"))
			strMostraLinhaEF = " style='display:none' "
			strMostraLinhaREC = " style='display:block' "
		end if

		intNumDisciplinaRec         = rs("num_disciplina_recuperacao")
		intNumDisciplinaPorgParcial = rs("num_disciplina_prog_parcial")
		
		strDesabilitaIncluir = "disabled" 'Desabilita o botão Incluir
		strDesabilitaAlterar = "" 'Habilita o botão Alterar
		strDesabilitaExcluir = "" 'Habilita o botão Excluir
	else
		strDesabilitaIncluir = "" 'Habilita o botão Incluir
		strDesabilitaAlterar = "disabled" 'Desabilita o botão Alterar
		strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir		
	end if
	rs.close
	
else
	strDesabilitaIncluir = "" 'Habilita o botão Incluir
	strDesabilitaAlterar = "disabled" 'Desabilita o botão Alterar
	strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir		
end if
	
	'seleciona o nome da composicao
	sql="select descricao from sca_curso"
	sql=sql & " where cod_curso = " & intCodCurso
	sql=sql & " And cod_empresa = " & Session("CodEmpresa")			
	rs.open sql, cnn
	if rs.eof = false then
		strNomeComp = rs("descricao")
	end if
	rs.close

%>
<form method="post" id="frm">
<table width="708" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
            <tr valign="top">
              <td width="700" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
  </table>  <table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario" bgcolor="#FFFFFF">
    <tr> 
      <td width="22%">&nbsp;</td>
      <td colspan="4">&nbsp;</td>
    </tr>
    <tr> 
      <td class="texto1">Curso:</td>
      <td colspan="4"> 
			<!--#include file="../includes/inc_cmdCurso.asp"--> 
			<input type="hidden" name="txtCodigo" value="<%=intCodigo%>">
			<input type="hidden" name="txtHiddenPossuiSemestre" value="<%=strDesabilitaSemestre%>">      
			<input type="hidden" value="<%=intPeso1Bim%>" name="txtHiddenPeso1Bim">
			<input type="hidden" value="<%=intPeso2Bim%>" name="txtHiddenPeso2Bim">
			<input type="hidden" value="<%=intPeso3Bim%>" name="txtHiddenPeso3Bim">
			<input type="hidden" value="<%=intPeso4Bim%>" name="txtHiddenPeso4Bim">
			<input type="hidden" value="<%=intPeso5Bim%>" name="txtHiddenPeso5Bim"><!--Exame final-->			</td>
    </tr>
    <tr>
      <td colspan="5"><hr size="1" color="#CCCCCC"></td>
    </tr>
    <tr>
      <td><span class="texto1">F&oacute;rmulas:</span></td>
      <td colspan="4"><span class="texto1">
      <input <%if strTipoFormulaFinal = "EF" then response.Write("checked")%>  name="formulaFinal" type="radio" value="EF" onClick="mostralinha('EF')">Exame Final 
      <input <%if strTipoFormulaFinal = "REC" then response.Write("checked")%> name="formulaFinal" type="radio" value="REC" onClick="mostralinha('REC')">Recupera&ccedil;&atilde;o </span></td>
    </tr>
    <tr id="linhaEF" <%=strMostraLinhaEF%>>
      <td><span class="texto1">Condi&ccedil;&atilde;o do Exame Final:</span></td>
      <td colspan="4" class="texto1">(  M&eacute;dia Final &gt;= 
        <input name="condicaoEF_notaInicial" type="text" class="text" id="condicaoEF_notaInicial" value="<%=strcondicaoEF_notaInicial%>" size="3" maxlength="3" onKeyPress="return formataCampo(this,6,3)"> 
        e M&eacute;dia Final &lt; <input name="condicaoEF_notaFinal" type="text" class="text" id="condicaoEF_notaFinal" value="<%=strcondicaoEF_notaFinal%>" size="3" maxlength="3" onKeyPress="return formataCampo(this,6,3)"> 
      )&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;M&eacute;dia para Aprova&ccedil;&atilde;o sem o Exame:
      <input name="txtMediaAprovacaoFinalEF" type="text" class="text" id="txtMediaAprovacaoFinalEF" value="<%=strMediaAprovacaoFinal%>" size="3" maxlength="3" onKeyPress="return formataCampo(this,6,3)"></td>
    </tr>
    
    <tr id="linhaREC" <%=strMostraLinhaREC%>>
      <td class="texto1">M&eacute;dia de Aprova&ccedil;&atilde;o Recupera&ccedil;&atilde;o:</td>
      <td class="texto1"><input name="txtMediaAprovacaoFinalREC" type="text" class="text" id="txtMediaAprovacaoFinalREC" value="<%=strMediaAprovacaoFinal%>" size="3" maxlength="3" onKeyPress="return formataCampo(this,6,3)"></td>
      <td class="texto1">Qtde. de disciplinas p/recupera&ccedil;&atilde;o:</td>
      <td class="texto1"><input name="txtNumDisciplinaRec" type="text" class="text" id="txtNumDisciplinaRec" onKeyPress="return formataCampo(this,2,3)" value="<%=intNumDisciplinaRec%>" size="3" maxlength="2"></td>
      <td class="texto1">&nbsp;</td>
    </tr>
<tr>
      <td colspan="5"><hr size="1" color="#CCCCCC"></td>
    </tr>
    <tr> 
      <td class="texto1">Qtde. de disciplinas p/depend&ecirc;ncia:</td>
      <td class="texto1"><input name="txtNumDisciplinaPorgParcial" type="text" class="text" id="txtNumDisciplinaPorgParcial" onKeyPress="return formataCampo(this,2,3)" value="<%=intNumDisciplinaPorgParcial%>" size="3" maxlength="2"></td>
      <td class="texto1">M&eacute;dia de Aprova&ccedil;&atilde;o Final:</td>
      <td class="texto1"><input name="txtMedia" type="text" class="text" id="txtMedia" value="<%=strMedia%>" size="3" maxlength="3" onKeyPress="return formataCampo(this,6,3)"></td>
      <td class="texto1">&nbsp;</td>
    </tr>
    <tr>
      <td class="texto1">Percentual de Faltas para Reprova&ccedil;&atilde;o acima de:</td>
      <td width="9%" class="texto1"><input name="txtFrequencia" type="text" class="text" id="txtFrequencia" value="<%=intFrequencia%>" size="3" maxlength="3" onKeyPress="return formataCampo(this,2,3)">
%</td>
      <td width="25%" class="texto1">Dias Letivos:&nbsp;</td>
      <td width="19%" class="texto1"><input name="txtDuracao" type="text" class="text" id="txtDuracao" value="<%=intDuracao%>" size="5" maxlength="3">
dias </td>
      <td width="25%" class="texto1">&nbsp;</td>
    </tr>
    
    <tr>
      <td>&nbsp;</td>
      <td colspan="4">&nbsp;</td>
    </tr>
    <tr>
      <td colspan="5"><div align="center"><strong>Avalia&ccedil;&otilde;es</strong></div></td>
    </tr>
    <tr>
      <td colspan="5">
<%
		cont =0
		intQtdeAvaliacao = 0

		if intCodigo = "" then intCodigo = 0
		if intCodCurso = "" then intCodCurso = "0"
		if intCodCurso <> "0" then
			sql = "SELECT SCA_TIPO_AVALIACAO_AGRUPAMENTO.DESCRICAO AS AGRUPAMENTO, SCA_TIPO_AVALIACAO.codigo, SCA_TIPO_AVALIACAO.Descricao, SCA_TIPO_AVALIACAO.Sigla, SCA_TIPO_AVALIACAO.bimestre, SCA_TIPO_AVALIACAO.posicao, SCA_TIPO_AVALIACAO.formula, SCA_TIPO_AVALIACAO.digitar, SCA_CURSO.sigla AS CURSO"
			sql = sql & " FROM SCA_TIPO_AVALIACAO"
			sql = sql & " LEFT JOIN SCA_TIPO_AVALIACAO_AGRUPAMENTO ON SCA_TIPO_AVALIACAO_AGRUPAMENTO.CODIGO = SCA_TIPO_AVALIACAO.BIMESTRE"
			sql = sql & " LEFT JOIN SCA_CURSO ON SCA_CURSO.COD_CURSO = SCA_TIPO_AVALIACAO.COD_CURSO"
			sql = sql & " where SCA_TIPO_AVALIACAO.cod_empresa = " & Session("CodEmpresa")			
			sql = sql & " and 	SCA_CURSO.COD_CURSO = "& intCodCurso
			sql = sql & " Order by posicao"
			rs.open sql, cnn
			if rs.eof = false then
			%>
                <table width = "85%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                  <tr bgcolor="#E5E5E5">
                    <td width="7%" align="center" class="celula"><strong>Ativada</strong></td>
                    <td width="7%" class="celula" align="center"><strong>Campo</strong></td>
                    <td width="19%" height="21" class="celula"><strong><span class="TextoForm">Descri&ccedil;&atilde;o</span></strong></td>
                    <td width="33%" class="celula"><strong>Tipo</strong></td>
                    <td width="41%" class="celula"><strong>F&oacute;rmula</strong></td>
                  </tr>
                  <%
				while not rs.eof
					intQtdeAvaliacao = intQtdeAvaliacao + 1
					selecionado = ""
					if intCodigo <> "" then
						sql = "select codigo"
						sql = sql & " from sca_avaliacao"
						sql = sql & " where cod_empresa = " & Session("CodEmpresa")
						sql = sql & " and codcriterioavaliacao = " & intCodigo
						sql = sql & " and codTipoAvaliacao = " & rs("codigo")
						rsAux.open sql, cnn
						if rsAux.eof = false then
							if not isnull(rsAux("codigo")) then
								selecionado = "<img src='../../images/v.gif' width='15' height='15' />"
							end if
						end if
						rsAux.close
					end if
					if trim(rs("bimestre")) = "1" or trim(rs("bimestre")) = "2" or trim(rs("bimestre")) = "3" or trim(rs("bimestre")) = "4" then
						bimestre = trim(rs("bimestre")) & "º Bimestre"
					else
						bimestre = trim(rs("AGRUPAMENTO"))
					end if			
					%>
                  <tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)">
                    <td class="celula" align="center"><%=selecionado%></td>
                    <td class="celula">&nbsp;
                      <input type="hidden" name="chkTipoAvaliacao" value="<%=rs("codigo")%>" class="texto">                      C<%=rs("posicao")%></td>
                    <td height="20" class="celula"><%=trim(rs("descricao"))%></td>
                    <td class="celula"><%=bimestre%></td>
                    <td class="celula"><%=trim(rs("formula"))%>&nbsp;</td>
                  </tr>
                  <%				
					rs.movenext
				wend
				%>
                  </table>
      <%
			  end if
			  rs.close
		end if%>	  
           <input type="hidden" name="txtQtdeAvaliacao" value="<%=intQtdeAvaliacao%>" class="texto">      </td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
      <td colspan="4">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="5"><hr size="1" color="#CCCCCC"></td>
    </tr>
    <tr> 
      <td colspan="5"> <!--#include file="../../includes/inc_botoes_cadastro.asp"--> </td>
    </tr>
    <tr> 
      <td colspan="5">&nbsp;</td>
    </tr>
  </table>	
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>