<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 26/02/2008
	::	Desenvolvedores...: Sérgio Borges - sergiob76@gmail.com
	::	Objetivo Pagina...: Posição financeira
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../estilo/css.css" rel="stylesheet" type="text/css">
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
<style type="text/css">
<!--
.style1 {color: #009900}
-->
</style>
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../../images/botao_azul_over.gif','<%=session("strCaminhoRaiz")%>/images/botao_verde_over.gif')">
<script src="../../js/js_funcoes_gerais.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<script>
	function incluirNovo(){
		window.open("ProtocoloAvulso_cad.asp?codAluno="+frm.txtCodAluno.value,"cadTx", "top=0,left=0,height=420,width=635,menubar=no,toolbar=no,scrollbars=yes,status=yes");
		return true;
 	}
	function estornoBaixa(CodProtocolo, codAluno){
		window.open("ProtocoloBaixa_cod.asp?acao=E&CodProtocolo="+CodProtocolo+"&codAluno="+codAluno,"protocolo", "top=0,left=0,height=150,width=150,menubar=no,toolbar=no,scrollbars=no,status=no");
		return true;
 	}

	function excluirProtocolo(CodProtocolo, codAluno){
		window.open("ProtocoloBaixa_cod.asp?acao=EX&CodProtocolo="+CodProtocolo+"&codAluno="+codAluno,"protocolo", "top=0,left=0,height=150,width=150,menubar=no,toolbar=no,scrollbars=no,status=no");
		return true;
 	}

	function baixaProtocolo(CodProtocolo, CodAluno){
		window.open("ProtocoloBaixa_cad.asp?CodProtocolo="+CodProtocolo+"&CodAluno="+CodAluno,"protocolo", "top=0,left=0,height=400,width=635,menubar=no,toolbar=no,scrollbars=yes,status=yes");
		return true;
 	}
	
	function geraImpressao(codProtocolo) {
	
		var frm = document.getElementById("frm");
		var nomeRelBoleto = 'Protocolo_rel.asp';
		var caminho;
		caminho = nomeRelBoleto + '?codProtocolo=' + codProtocolo;
		frm.action = caminho;
		frm.submit();
	}
</script>
<%
	strMostraBotaoConsultaPrincipal = "S"
	strMostraBotaoConsultaRetornar 	= "N"
	strMostraBotaoIncluir			= "S"
	
	'strConsulta	 			= Trim(Request.Form("txtConsulta"))
	intCodEmpresa			= Session("CodEmpresa")	
	intCodigo	 			= Trim(Request.Form("txtCodigo"))
	strDescricao 			= Trim(Request.Form("txtDescricao"))
	intCodAluno				= Trim(Request.Form("txtCodAluno"))
	strMatricula			= Trim(Request.Form("txtMatricula"))
	strNomeAluno			= Trim(Request.Form("txtNomealuno"))
	
	if trim(strMatricula) <> "" then
	
		sql = "Select Codigo, NomeAluno, matricula from sca_aluno"
		sql = sql & " where cod_empresa = " & session("CodEmpresa")
		sql = sql & " and matricula = " & strMatricula
		rs.open sql, cnn
		if rs.eof = false then
			strCodAluno			= Trim(rs("codigo"))
			intcodAluno			= Trim(rs("codigo"))
			strMatricula 		= Trim(rs("Matricula"))
			strNomealuno 		= Trim(rs("Nomealuno"))
		else
			strCodAluno			= 0
			strNomealuno 		= ""
			strMatricula 		= ""
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
	end if

	'VERIFICAÇÃO DE BLOQUEIO
	%>
	<!--#include file="../includes/inc_VerificaBloqueio.asp"-->
	<%


%>
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td>
	<table width="100%"  height="325" border="0" cellspacing="0" cellpadding="0">
      <tr valign="top">
        <td colspan="2" align="center">
		<form id="frm" method="post">
		  <table width="99%" border="0" cellpadding="0" cellspacing="0">

            <tr valign="top">
              <td align="center" class="tituloSistema">Protocolo</td>
            </tr>
          </table>
		  <br>
		  <table width="99%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="99" height="25" class="texto1">Matr&iacute;cula</td>
            <td width="792"><input name="txtCodAluno" type="hidden" id="txtCodAluno" class="text" size="10" value="<%=strCodAluno%>" maxlength="10">
              <span class="texto1">
              <input name="txtMatricula" type="text" class="text" id="txtMatricula" size="20" maxlength="20" value="<%=strMatricula%>"  onKeyPress="return formataCampo(this, 2, 9)" onBlur="submit()">
              <a  href="#" onClick="return abreConsulta('Aluno_con.asp')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image7','','<%=session("strCaminhoRaiz")%>/images/botao_verde_over.gif',1)"><img alt="Clique para consultar o aluno" src="<%=session("strCaminhoRaiz")%>/images/botao_verde_normal.gif" name="Image7" width="26" height="26" border="0"  align="absmiddle" ></a></span>&nbsp;
              <input readonly name="txtNomealuno" type="text" class="textDesabilita" id="txtNomealuno" size="50" maxlength="50" value="<%=strNomealuno%>" ></td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2"><!--#include file="../../includes/inc_botoes_consulta.asp"--></td>
          </tr>
          <tr>
            <td colspan="2"></td>
          </tr>
        </table>
		<br>
		<%	if strMatricula <> "" then %>
		<table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela">
		  <tr bgcolor="#E5E5E5">
		    <td colspan="10" class="celula"><div align="center"><strong>Rela&ccedil;&atilde;o de Protocolos Gerados pelo Sistema  </strong></div></td>
		    </tr>
		  <tr bgcolor="#E5E5E5">
			<td align="center" class="celula"><strong>N&ordm; Protocolo</strong></td>
			<td align="center" class="celula"><strong>N&ordm; Recibo</strong></td>
			<td align="center" class="celula"><strong>Solicita&ccedil;&atilde;o</strong></td>
			<td align="center" class="celula"><div align="center"><strong>Tipo</strong></div></td>
			<td align="center" class="celula"><strong>Matr&iacute;cula</strong></td>
			<td align="center" class="celula"><strong>Aluno</strong></td>
			<td align="center" class="celula"><div align="center"><strong>Entrada</strong></div></td>
			<td align="center" class="celula"><strong>Entrega</strong></td>
			<td align="center" class="celula"><div align="center"><strong>Situação</strong></div></td>
		    <td align="center" class="celula"><strong> Execu&ccedil;&atilde;o </strong></td>
		  </tr>
			<%
			sql = "SELECT P.CODIGO, "
			sql = sql & " P.DATASOLICITACAO, P.COD_ALUNO, A.NOMEALUNO, A.MATRICULA, T.DESCRICAO AS TAXA, P.DATAVENCIMENTO, "
			sql = sql & " P.DATAENTREGA, P.SITUACAO, P.COD_DEBITOALUNO"
			sql = sql & " FROM SCF_PROTOCOLO P"
			sql = sql & " LEFT JOIN SCA_ALUNO A	ON P.COD_ALUNO = A.CODIGO AND P.COD_EMPRESA = A.COD_EMPRESA"
			sql = sql & " LEFT JOIN SCF_TAXA T	ON P.COD_TAXA = T.COD_TAXA AND P.COD_EMPRESA = T.COD_EMPRESA"
			sql = sql & " WHERE	A.COD_EMPRESA	= "&intCodEmpresa
			IF strMatricula <> "" THEN
				sql = sql & " AND A.MATRICULA = " & strMatricula
			END IF
			sql = sql & " ORDER BY P.DATASOLICITACAO"
			rs.open sql, cnn
			if rs.eof = false then
				intTotalOutrosDescontos = 0
				intTotalOutrosAcrescimo = 0
				intTotalValorParcela 	= 0
				intTotalValorPagamento 	= 0
				while not rs.eof
					cont = cont + 1	
					SIT = ""
					estiloImagemAberto = ""
					IF RS("SITUACAO") = "A" THEN 
						SIT = "Aberto"
						estiloImagemAberto = "style='cursor:default; Filter: Alpha(Opacity=100, FinishOpacity=0, Style=2, StartX=20, StartY=40, FinishX=0, FinishY=0)'"
					end if

					estiloImagemBaixado = ""
					IF RS("SITUACAO") = "B" THEN 
						SIT = "Finalizado"
						estiloImagemBaixado = "style='cursor:default; Filter: Alpha(Opacity=100, FinishOpacity=0, Style=2, StartX=20, StartY=40, FinishX=0, FinishY=0)'"
					end if
					%>
					  <tr  height="20">
						<td class="celula" align="center">&nbsp;<%=rs("codigo")%></td>
						<td class="celula" align="center"><%=rs("COD_DEBITOALUNO")%></td>
						<td class="celula" align="center"><%=formatadataAP(rs("DATASOLICITACAO"))%></td>
						<td class="celula"><%=rs("TAXA")%></td>
						<td class="celula" align="right"><%=rs("MATRICULA")%>&nbsp;</td>
						<td class="celula"><%=rs("NOMEALUNO")%>&nbsp;</td>
						<td class="celula" align="center">&nbsp;&nbsp;<%=formatadataAP(rs("DATASOLICITACAO"))%>&nbsp;&nbsp;</td>
						<td class="celula" align="right"><div align="center">&nbsp;&nbsp;<%=formatadataAP(rs("DATAENTREGA"))%>&nbsp;&nbsp;</div></td>
						<td class="celula" align="center"><%=SIT%></td>
					    <td class="celula" align="center">
						<a href="#" <% if RS("SITUACAO") = "A" then %> onClick="baixaProtocolo('<%=rs("codigo")%>','<%=rs("COD_ALUNO")%>')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('verdePGImage<%=rs("codigo")%>','','../../images/botao_baixa_over.gif',1)" <%end if%>><img align="absmiddle" src="../../images/botao_baixa_on.gif" alt="Clique para fazer a baixa do protocolo." name="verdePGImage<%=rs("codigo")%>" width="27" height="28" border="0" <%=estiloImagemBaixado%> ></a>
						<a href="#" <% if RS("SITUACAO") = "B" then %> onClick="estornoBaixa('<%=rs("codigo")%>','<%=rs("cod_aluno")%>')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('vermelhoImage<%=rs("codigo")%>','','../../images/botao_estorno_baixa_over.gif',1)"  <%end if%>><img align="absmiddle" src="../../images/botao_estorno_baixa_on.gif" alt="Clique para estornar a baixa desse protocolo." name="vermelhoImage<%=rs("codigo")%>" width="26" height="26" border="0"  <%=estiloImagemAberto%> ></a>
					    <a href="#" <% if RS("SITUACAO") = "A" then %> onClick="geraImpressao('<%=rs("codigo")%>')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('impressoraImage<%=rs("codigo")%>','','../../images/impressora_over.gif',1)" <%end if%>><img align="absmiddle" src="../../images/impressora_on.gif" alt="Clique para imprimir o Protocolo." name="impressoraImage<%=rs("codigo")%>" border="0" <%=estiloImagemBaixado%>></a>
						<a href="#" <% if RS("SITUACAO") = "A" then %> onClick="excluirProtocolo('<%=rs("codigo")%>','<%=rs("cod_aluno")%>')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('vermelhoEstImage<%=rs("codigo")%>','','../../images/botao_vermelho_over.gif',1)"  <%end if%>><img align="absmiddle" src="../../images/botao_vermelho_normal.gif" alt="Clique para excluir o protocolo." name="vermelhoEstImage<%=rs("codigo")%>" width="26" height="26" border="0"  <%=estiloImagemBaixado%> ></a>						</td>
						</tr>
						<%			
					rs.movenext
				wend %>
				  
		<%	else %>
				<tr>
					<td height="130" colspan="13" align="center" class="celula style1">Não foi encontrado débitos para esse aluno.</td>
				</tr>
		<%	end if 
			rs.close
		%>
		</table>
	<%	end if	%>		
	<input value="S" name="txtConsulta" type="hidden">
		</form>
		</td>
      </tr>
    </table>
	</td>
  </tr>
</table>
<br>
<!--#include file="../rodape.asp"-->
</body>
</html>