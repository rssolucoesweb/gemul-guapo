<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 04/08/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: desconto aluno
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link type="text/css" rel="stylesheet" href="../../Estilo/css.css">
<script type="text/JavaScript">
<!--
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
//-->
</script>
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%=session("strCaminhoRaiz")%>/images/botao_verde_over.gif')">
<script src="../../js/js_funcoes_gerais.js"></script>
<script type="text/javascript" src="../../js/js_dragdrop.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurmaTodasSituacoes.asp"-->
<script>

	function marcaTodos(valor){
		
		var form = window.document.forms[0];
		var i;
		for (var i = 0; i < form.elements.length; i++) {
			//verifica todos os checkbox
			if (form.elements[i].type == "checkbox"){
				//verifica se o checkbox está marcado
				form.elements[i].checked=valor;
			}
		}
	}
	
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.txtMatricula.value == "") {
			
			var intContMarcado =0;
			var intCodAluno = "0";
			
			for (var i = 0; i < frm.elements.length; i++) 
			{
				//verifica todos os checkbox
				if (frm.elements[i].name.substring(0,19) == "chkAluno"){				
					if (frm.elements[i].checked) {
						intContMarcado = intContMarcado + 1;
						intCodAluno = intCodAluno + "," + frm.elements[i].value;
					}
				}
			}
		
			if (intContMarcado==0){
				alert("ATENÇÃO: Pelo menos um Aluno deve ser selecionado, Verifique!");
				return false;
			}
			
		}
		
		if (frm.cmbCategoriaDesconto.value == "0") {
			alert("A categoria do desconto deve ser informada!");
			frm.cmbCategoriaDesconto.focus();
			return false;
		}		
		if (frm.txtValor.value == "") {
			alert("O Percentual do desconto deve ser informado!");
			frm.txtValor.focus();
			return false;
		}		

		if (parseFloat(frm.txtValor.value) < 0) {
			alert("O desconto deve esta entre 0 e 100!");
			frm.txtValor.focus();
			return false;
		}		

		if (parseFloat(frm.txtValor.value) > 100) {
			alert("O desconto deve esta entre 0 e 100!");
			frm.txtValor.focus();
			return false;
		}		

		frm.action="DescontoAluno_cod.asp?acao=" + acao;
		frm.submit();
		return true;
	}
</script>
<%
	strDesabilitaIncluir = "disabled" 'Desabilita o botão Incluir'
	strDesabilitaAlterar = "disabled" 'Habilita o botão Alterar
	strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir
	strDesabilitaLimpar  = "" 'Habilita o Botão Limpar'
	strExecutarSubmitTurma = "S"
	
	strPaginaTitulo 		= "DescontoAluno_cad.asp"
	
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	strCodAluno				= Trim(Request("txtCodAluno"))
	strMatricula 			= Trim(Request("txtMatricula"))
	strNomealuno 			= Trim(Request("txtNomealuno"))
	intCodCategoriaDesconto = Trim(Request("cmbCategoriaDesconto"))
	

	if Request("txtValor") <> "" then
		strValor				= formatNumber(Trim(Request("txtValor")),4)
	end if
	if Request("txtValor2") <> "" then
		strValor				= formatNumber(Trim(Request("txtValor2")),4)
	end if
	if Request("txtValor3") <> "" then
		strValor				= formatNumber(Trim(Request("txtValor3")),4)
	end if
	if Request("txtValor4") <> "" then
		strValor				= formatNumber(Trim(Request("txtValor4")),4)
	end if
	
	ValorApagar1             = Trim(Request("txtValorApagar1"))
	ValorApagar2             = Trim(Request("txtValorApagar2"))
	ValorApagar3             = Trim(Request("txtValorApagar3"))
	ValorApagar4             = Trim(Request("txtValorApagar4"))
	
	if trim(strMatricula) <> "" then
	
		sql = "Select Codigo, NomeAluno, matricula, cod_categoria_desconto, perc_desconto, perc_desconto2, perc_desconto3, perc_desconto4 from sca_aluno"
		sql = sql & " where cod_empresa = " & session("CodEmpresa")
		sql = sql & " and matricula = " & strMatricula
		rs.open sql, cnn
		
		if rs.eof = false then
		
			strCodAluno			= Trim(rs("codigo"))
			strMatricula 		= Trim(rs("Matricula"))
			strNomealuno 		= Trim(rs("Nomealuno"))
			
			intCodCategoriaDesconto = "0"
			
			if not isnull(rs("cod_categoria_desconto")) then
			
				intCodCategoriaDesconto = rs("cod_categoria_desconto")
				intCodCategoriaDescontoAnterior = rs("cod_categoria_desconto")
				strValor 			= formatNumber(rs("perc_desconto"),4)
				strValorAnterior	= formatNumber(rs("perc_desconto"),4)
				
				'
				if not isnull(rs("perc_desconto2")) then 
				   strValor2 			= formatNumber(rs("perc_desconto2"),4)
				   strValorAnterior2	= formatNumber(rs("perc_desconto2"),4)
				end if  
				'
				if not isnull(rs("perc_desconto3")) then 
				   strValor3 			= formatNumber(rs("perc_desconto3"),4)
				   strValorAnterior3	= formatNumber(rs("perc_desconto3"),4)
				end if
				'
				if not isnull(rs("perc_desconto4")) then 
				   strValor4 			= formatNumber(rs("perc_desconto4"),4)
				   strValorAnterior4	= formatNumber(rs("perc_desconto4"),4)
				end if   
				'
				strDesabilitaIncluir = "disabled" 'Desabilita o botão Incluir'
				strDesabilitaAlterar = "" 'Habilita o botão Alterar
				strDesabilitaExcluir = "" 'Desabilita o botão Excluir
				strDesabilitaLimpar  = "" 'Habilita o Botão Limpar'				
			
			else
				strDesabilitaIncluir = "" 'Desabilita o botão Incluir'
				strDesabilitaAlterar = "disabled" 'Habilita o botão Alterar
				strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir
				strDesabilitaLimpar  = "" 'Habilita o Botão Limpar'				
			end if
			
		else
		
			strCodAluno			= 0
			strNomealuno 		= ""
			intCodCategoriaDesconto = "0"
			strValorAnterior	= ""
			strValor			= ""
			strDesabilitaIncluir = "disabled" 'Desabilita o botão Incluir'
			strDesabilitaAlterar = "disabled" 'Habilita o botão Alterar
			strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir
			strDesabilitaLimpar  = "" 'Habilita o Botão Limpar'
			%>
			<script>
				alert("Aluno não foi encontrado.");
			</script>
			<%
		end if
		rs.close	
	
	else
		strCodAluno			= ""
		strMatricula 		= ""
		strNomealuno 		= ""
		strDesabilitaIncluir = "" 'Desabilita o botão Incluir'
		strDesabilitaAlterar = "disabled" 'Habilita o botão Alterar
		strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir
		strDesabilitaLimpar  = "" 'Habilita o Botão Limpar'
	end if
	
	if intCodTurma = "" then intCodTurma = 0
%>
<form method="post" id="frm" action="DescontoAluno_cad.asp">
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
            <tr valign="top">
              <td width="100%" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
		<tr valign="top">
		  <td align="center" valign="top">
  <table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
    <tr>
      <td class="texto1">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td class="texto1">Turma:</td>
      <td><!--#include file="../includes/inc_cmdTurma.asp"--></td>
    </tr>
    <%
	if intCodTurma <> "0" then
	    
		sql = " Select cod_planopagamento from sca_turma "
		sql = sql & " where cod_turma = " & intCodTurma
		rs.open sql, cnn
		if rs.eof = false then
		   intcodplanopagamento = Trim(rs("cod_planopagamento"))
		end if   
		rs.close

        if intcodplanopagamento <> "" and not isnull(intcodplanopagamento) then
			sql = " select top 1 valor1, valor2, valor3, valor4 from scf_planoparcela "
			sql = sql & " where cod_plano = " & intcodplanopagamento
			sql = sql & " order by Ano, parcela desc "
			rs.open sql, cnn
			if rs.eof = false then
			  
			  if Trim(Request("txtValorApagar1")) = "" then ValorApagar1 = Trim(rs("valor1"))
			  if ValorApagar1 = "" or isnull(ValorApagar1) then ValorApagar1 = "0"
			 
			  if Trim(Request("txtValorApagar2")) = "" then ValorApagar2 = Trim(rs("valor2"))
			  if ValorApagar2 = "" or isnull(ValorApagar2) then ValorApagar2 = "0"

			  if Trim(Request("txtValorApagar3")) = "" then ValorApagar3 = Trim(rs("valor3"))
			  if ValorApagar3 = "" or isnull(ValorApagar3) then ValorApagar3 = "0"

			  if Trim(Request("txtValorApagar4")) = "" then ValorApagar4 = Trim(rs("valor4"))
			  if ValorApagar4 = "" or isnull(ValorApagar4) then ValorApagar4 = "0"
			  
			  ValorDividir1 = Trim(rs("valor1"))
			  ValorDividir2 = Trim(rs("valor2"))
			  ValorDividir3 = Trim(rs("valor3"))
			  ValorDividir4 = Trim(rs("valor4"))

			  if ValorDividir1 = "" or isnull(ValorDividir1) then ValorDividir1 = "1"
			  if ValorDividir2 = "" or isnull(ValorDividir2) then ValorDividir2 = "1"
			  if ValorDividir3 = "" or isnull(ValorDividir3) then ValorDividir3 = "1"
			  if ValorDividir4 = "" or isnull(ValorDividir4) then ValorDividir4 = "1"

			  if ValorApagar1 <> "0" then
			     strValor  = round((( ValorApagar1 * 100 )/ ValorDividir1 ) - 100,4)* -1
			  end if
			  if ValorApagar2 <> "0" then
			     strValor2 = round((( ValorApagar2 * 100 )/ ValorDividir2 ) - 100,4)* -1
			  end if
			  if ValorApagar3 <> "0" then
			     strValor3 = round((( ValorApagar3 * 100 )/ ValorDividir3 ) - 100,4)* -1
			  end if
			  if ValorApagar4 <> "0" then
			     strValor4 = round((( ValorApagar4 * 100 )/ ValorDividir4 ) - 100,4)* -1
			  end if
			  
			   if ValorApagar1 > ValorDividir1 then strValor = "0"
			   if ValorApagar2 > ValorDividir2 then strValor2 = "0"
			   if ValorApagar3 > ValorDividir3 then strValor3 = "0"
			   if ValorApagar4 > ValorDividir4 then strValor4 = "0"
			  
			end if   
			rs.close
		
		end if
		
	end if
	
	
	
	%>
    
    <tr>
      <td width="15%" class="texto1">Matr&iacute;cula : </td>
      <td width="85%"><input name="txtCodAluno" type="hidden" id="txtCodAluno" class="text" size="10" value="<%=strCodAluno%>" maxlength="10"><span class="texto1">
        <input name="txtMatricula" type="text" class="text" id="txtMatricula" size="20" maxlength="10" value="<%=strMatricula%>"  onKeyPress="return formataCampo(this, 2, 10)" onBlur="submit()">
        <a  href="#" onClick="return abreConsulta('../sca/Aluno_con.asp')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image7','','<%=session("strCaminhoRaiz")%>/images/botao_verde_over.gif',1)"><img alt="Clique para consultar o aluno" src="<%=session("strCaminhoRaiz")%>/images/botao_verde_normal.gif" name="Image7" width="26" height="26" border="0"  align="absmiddle" ></a></span>&nbsp;<input readonly name="txtNomealuno" type="text" class="textDesabilita" id="txtNomealuno" size="50" maxlength="50" value="<%=strNomealuno%>" ></td>
    </tr>
    <tr>
      <td height="18" colspan="2" class="texto1"><hr size="1" color="#CCCCCC"></td>
      </tr>
    <tr>
      <td height="18" colspan="2" class="texto1"><strong>Informe abaixo o valor a pagar para calcular o desconto: (Opcional )</strong></td>
      </tr>
      <%  if ValorApagar1 <> "0"  then %>
            <tr>
              <td height="18" class="texto1">Valor n. 01 a pagar:</td>
              <td><span class="texto1">
                <input name="txtValorApagar1" type="text" class="text" id="txtValorApagar1"  onKeyPress="return currencyFormat(this,event)" size="11" maxlength="11" value="<%=ValorApagar1%>" onBlur="submit()">
              </span></td>
            </tr>
     <% end if %>
     <%  if ValorApagar2 <> "0"  then %>
        <tr>
          <td height="18" class="texto1">Valor n. 02 a pagar:</td>
          <td><span class="texto1">
            <input name="txtValorApagar2" type="text" class="text" id="txtValorApagar2"  onKeyPress="return currencyFormat(this,event)" size="11" maxlength="11" value="<%=ValorApagar2%>" onBlur="submit()">
          </span></td>
        </tr>
     <% end if %>
     <%  if ValorApagar3 <> "0"  then %>
        <tr>
          <td height="18" class="texto1">Valor n. 03 a pagar:</td>
          <td><span class="texto1">
            <input name="txtValorApagar3" type="text" class="text" id="txtValorApagar3"  onKeyPress="return currencyFormat(this,event)" size="11" maxlength="11" value="<%=ValorApagar3%>" onBlur="submit()">
          </span></td>
        </tr>
     <% end if %>
     <%  if ValorApagar4 <> "0"  then %>
        <tr>
          <td height="18" class="texto1">Valor n. 04 a pagar:</td>
          <td><span class="texto1">
            <input name="txtValorApagar4" type="text" class="text" id="txtValorApagar4"  onKeyPress="return currencyFormat(this,event)" size="11" maxlength="11" value="<%=ValorApagar4%>" onBlur="submit()">
          </span></td>
        </tr>
	<% end if %>
    <tr>
      <td height="18" class="texto1">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td height="18" colspan="2" class="texto1"><hr size="1" color="#CCCCCC"></td>
      </tr>
    <tr>
      <td height="18" class="texto1">Categoria:</td>
      <td><!--#include file="../includes/inc_cmdCategoriaDesconto.asp"--></td>
    </tr>
    <tr>
      <td height="18" class="texto1">Desconto: Valor n. 01 </td>
      <td><span class="TextoForm">
        <input name="txtValor" type="text" class="text" id="txtValor" onKeyPress="return currencyFormat4casas(this, '.', ',', event)" size="11" maxlength="10" value="<%=strValor%>">
        %
        <input name="txtValorAnterior" type="hidden" id="txtValorAnterior" value="<%=strValorAnterior%>">
		<input name="cmbCategoriaDescontoAnterior" type="hidden" id="cmbCategoriaDescontoAnterior" value="<%=intCodCategoriaDescontoAnterior%>">
      </span></td>
    </tr>
    <tr>
      <td height="18" class="texto1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Valor n. 02</td>
      <td><span class="TextoForm">
        <input name="txtValor2" type="text" class="text" id="txtValor2" onKeyPress="return currencyFormat4casas(this, '.', ',', event)" size="11" maxlength="10" value="<%=strValor2%>">
      %
      
      
      </span></td>
    </tr>
    <tr>
      <td height="18" class="texto1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Valor n. 03</td>
      <td><span class="TextoForm">
        <input name="txtValor3" type="text" class="text" id="txtValor3" onKeyPress="return currencyFormat4casas(this, '.', ',', event)" size="11" maxlength="10" value="<%=strValor3%>">
      %
      
      
      </span></td>
    </tr>
    <tr> 
      <td height="18" class="texto1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Valor n. 04</td>
      <td><span class="TextoForm">
        <input name="txtValor4" type="text" class="text" id="txtValor4" onKeyPress="return currencyFormat4casas(this, '.', ',', event)" size="11" maxlength="10" value="<%=strValor4%>">
      %
      
      
      </span></td>
    </tr>
    <tr>
      <td height="18" class="texto1" colspan="2">&nbsp;</td>
    </tr>
    <tr>
      <td height="18" class="texto1" colspan="2"><br>
        <%
			if intCodTurma <> "0" OR strMatricula <> "" then%>
            
        <table class="tabela" width="98%" align="center" border="1" cellpadding="0" cellspacing="0">
          <tr class="CabecalhoConsulta">
            <td width="38" align="center" class="celula"><input type="checkbox" name="chkTodos" onClick="return marcaTodos(this.checked)"></td>
            <td width="104" class="celula"><strong>Matr&iacute;cula</strong></td>
            <td width="764" class="celula"><strong>Nome</strong></td>
            <td width="149" class="celula"><strong>Turma</strong></td>
            <td width="149" class="celula"><strong>Situa&ccedil;&atilde;o</strong></td>
          </tr>
          <%					
			'seleciona os alunos da turma'					
			sql = sqlAlunoTurma(intCodTurma, "")
			rs.open sql, cnn
			if rs.eof = false then
				selecionado = "checked"
				while not rs.eof
					strCodigoAluno        = rs("codigo")
					strMatricula		  = rs("MATRICULA")
					%>
          <tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)">
            <td class="celula" align="center"><input type="checkbox" id="chkAluno" name="chkAluno" value="<%=rs("codigo")%>"></td>
            <td class="celula">&nbsp;<%=strMatricula%></td>
            <td class="celula"><%=rs("NOMEALUNO")%>&nbsp;</td>
            <td class="celula"><%=rs("NOMETURMA")%>&nbsp;</td>
            <td class="celula"><%=rs("Desc_SituacaoAluno")%>&nbsp;</td>
          </tr>
          <%			selecionado = ""
						rs.movenext
					wend
				else
					%>
          <tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)">
            <td colspan="5" align="center" class="celula"><%=session("strMensagemRelatorioNaoEncontrado")%></td>
          </tr>
          <%
					end if
					rs.close
			end if
					%>
        </table>
        <br></td>
    </tr>
    <tr>
      <td height="18" class="texto1" colspan="2">&nbsp;</td>
    </tr>
    <tr> 
      <td height="18" class="texto1" colspan="2"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
    </tr>
    <tr>
      <td height="18" class="texto1" colspan="2">&nbsp;</td>
    </tr>
    <tr>
      <td height="18" class="texto1" colspan="2">&nbsp;</td>
    </tr>    
  </table>
  		  </td>
		</tr>
  </table>
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>