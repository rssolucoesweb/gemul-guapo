<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 28/01/2009
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Vincula a Rota ao Aluno
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../estilo/css.css" rel="stylesheet" type="text/css">
<script type="text/JavaScript">
<!--
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
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
</script></head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%=session("strCaminhoRaiz")%>/images/botao_verde_over.gif')">
<script src="../../js/js_funcoes_gerais.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurmaTodasSituacoes.asp"-->
<script>

	function marcaTodos(valor){
		
		var frm = document.getElementById("frm");
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
			
		}else{
			
			if (frm.txtMatricula.value == "") {
				alert("A Matricula deve ser informada!");
				frm.txtMatricula.focus();
				return false;
			}		
			
		}
		
		frm.action="InicializaSenhaAluno_cod.asp?acao=" + acao;
		frm.submit();
		return true;
   	   
 	}
</script>
<%
	strPaginaTitulo 				= "InicializaSenhaAluno_con.asp"
	strExecutarSubmitSemestre 		= "S"
	strExecutarSubmitTurma 			= "S"
	
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	strCodAluno				= Trim(Request("txtCodAluno"))
	strMatricula 			= Trim(Request("txtMatricula"))
	strNomealuno 			= Trim(Request("txtNomealuno"))
	strUsuario          	= Trim(Request("txtMatricula"))
	intSemestre 			= Trim(Request("cmbSemestre"))

	if trim(request("txtAnoLetivo")) = "" then 
		strAnoLetivo = session("strAnoLetivo")
	else
		strAnoLetivo = request("txtAnoLetivo")
	end if
	
	strDesabilitaIncluir 	= "disabled" 'Desabilita o botão Incluir'
	strDesabilitaAlterar 	= "disabled" 'Habilita o botão Alterar
	strDesabilitaExcluir 	= "disabled" 'Desabilita o botão Excluir
	strDesabilitaLimpar  	= "" 'Habilita o Botão Limpar'

	if trim(strMatricula) <> "" then
	
		sql = "Select Codigo, NomeAluno, matricula, cod_situacaoaluno from sca_aluno"
		sql = sql & " where cod_empresa = " & session("CodEmpresa")
		sql = sql & " and matricula = " & strMatricula
		rs.open sql, cnn
		if rs.eof = false then
			strCodAluno			= Trim(rs("codigo"))
			strMatricula 		= Trim(rs("Matricula"))
			strUsuario  		= Trim(rs("Matricula"))
			strNomealuno 		= Trim(rs("Nomealuno"))
			
			if isnull(rs("cod_situacaoaluno")) then
			   %>
			   <script>
				  alert("Aluno não Vinculado a uma Situação Cadastral.");
			   </script>
			   <%
			end if   
		else
			%>
			<script>
				alert("Aluno não foi encontrado.");
			</script>
			<%
		end if
		rs.close

		strDesabilitaIncluir = "disabled" 'Desabilita o botão Incluir'
	    strDesabilitaAlterar = "" 'Habilita o botão Alterar
	    strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir
	    strDesabilitaLimpar  = "" 'Habilita o Botão Limpar'
		
	end if
	
	strDesabilitaIncluir = "disabled" 'Desabilita o botão Incluir'
	strDesabilitaAlterar = "" 'Habilita o botão Alterar
	strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir
	strDesabilitaLimpar  = "" 'Habilita o Botão Limpar'

	if intCodTurma = "" then intCodTurma = 0
	%>
    <table width="100%" height="355" border="0" bgcolor="#FFFFFF"  cellpadding="0" cellspacing="0">
    <tr>
    <td>
	<table width="100%"  height="325" border="0" cellspacing="0" cellpadding="0">
      <tr valign="top">
        <td colspan="2" align="center">
		<form id="frm" method="post">
		  <table width="98%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td height="18" colspan="3" align="center" class="texto1"><span class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></span></td>
            </tr>
          <tr>
            <td height="18" colspan="3" class="texto1">&nbsp;</td>
            </tr>
          <tr>
            <td height="28" class="texto1">Ano:</td>
            <td colspan="2"><input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
          </tr>
          <tr>
            <td height="28" class="texto1">Semestre:</td>
            <td colspan="2"><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
          </tr>
          <tr>
            <td width="11%" height="28" class="texto1">Turma:</td>
            <td colspan="2"><!--#include file="../includes/inc_cmdTurma.asp"--></td>
          </tr>
          <tr>
            <td height="28" class="texto1">Matr&iacute;cula : </td>
            <td colspan="2">
            <input name="txtCodAluno" type="hidden" id="txtCodAluno" class="text" size="10" value="<%=strCodAluno%>" maxlength="10">
             <input name="txtMatricula" type="text" class="text" id="txtMatricula" size="20" maxlength="20" value="<%=strMatricula%>"  onKeyPress="return formataCampo(this, 2, 10)" onBlur="submit()">
              <a  href="#" onClick="return abreConsulta('Aluno_con.asp')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image7','','<%=session("strCaminhoRaiz")%>/images/botao_verde_over.gif',1)"><img alt="Clique para consultar o aluno" src="<%=session("strCaminhoRaiz")%>/images/botao_verde_normal.gif" name="Image7" width="26" height="26" border="0"  align="absmiddle" ></a></span>&nbsp;
              <input readonly name="txtNomealuno" type="text" class="textDesabilita" id="txtNomealuno" size="50" maxlength="50" value="<%=strNomealuno%>" >           </td>
          </tr>
          <tr>
            <td height="28" class="texto1">Usu&aacute;rio/Login:</td>
             <td colspan="2"><input readonly="txtUsuario" name="txtUsuario" type="text" class="text" id="txtUsuario" size="20" maxlength="20" value="<%=strUsuario%>"  onKeyPress="return formataCampo(this, 2, 9)" onBlur="submit()">             </td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2"><%
			if intCodTurma <> "0" OR strMatricula <> "" then%>
              <table class="tabela" width="98%" align="center" border="1" cellpadding="0" cellspacing="0">
                <tr class="CabecalhoConsulta">
                  <td align="center" class="celula"><input type="checkbox" name="chkTodos" onClick="return marcaTodos(this.checked)"></td>
                  <td class="celula"><strong>Matr&iacute;cula</strong></td>
                  <td class="celula"><strong>Nome</strong></td>
                  <td class="celula"><strong>Turma</strong></td>
                  <td class="celula"><strong>Situa&ccedil;&atilde;o</strong></td>
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
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2"><br></td>
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