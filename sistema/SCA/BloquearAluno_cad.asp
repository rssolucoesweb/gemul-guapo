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

<script>

	function resultadoConsulta(intCodigo){
	
		var frm = document.getElementById("frm");
		
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}


	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.txtMatricula.value == "") {
			alert("A matrícula deve ser informada !");
			frm.txtMatricula.focus();
			return false;
		}
		
		if (frm.cmbSituacao.value == "D" && acao == "I" ) {
			alert("ATENÇÃO! Não é necessário inserir um DESBLOQUEIO");
			frm.cmbSituacao.focus();
			return false;
		}
		
		if (frm.txtMotivo.value == "") {
			alert("Atenção! Descreva o Motivo do BLOQUEIO");
			frm.txtMotivo.focus();
			return false;
		}
		
		frm.action="BloquearAluno_cod.asp?acao=" + acao;
		frm.submit();
		return true;
	}
</script>
<%
	strPaginaTitulo 	= "BloquearAluno_cad.asp"
    strAnoLetivo 		= session("strAnoLetivo")
	strSemestre 		= session("strSemestre")
	
	intcodigo			= Trim(Request("txtCodigo"))
	strCodAluno			= Trim(Request("txtCodAluno"))
    intCodAluno 	    = Trim(Request("txtCodAluno"))
	strMatricula 		= Trim(Request("txtMatricula"))
	strMotivo 		    = Trim(Request("txtMotivo"))
	strsituacao 		= Trim(Request("cmbSituacao"))
	
	strDesabilitaIncluir	= "" 'Habilita o botão Incluir
	strDesabilitaAlterar 	= "disabled" 
	strDesabilitaExcluir	= "disabled" 

	
	if strMatricula <> "" then
		sql = "Select a.Codigo, a.NomeAluno, a.matricula, sa.desc_situacaoaluno from sca_aluno a"
  	    sql = sql & " inner join sca_situacaoaluno sa on sa.cod_situacaoAluno = a.cod_situacaoAluno and sa.cod_empresa =     a.cod_empresa "
		sql = sql & " where a.cod_empresa = " & session("CodEmpresa")
		sql = sql & " and a.matricula = " & strMatricula
		rs.open sql, cnn
		if rs.eof = false then
		    intCodAluno			= Trim(rs("codigo"))
			strCodAluno			= Trim(rs("codigo"))
			strMatricula 		= Trim(rs("Matricula"))
			strNomealuno 		= Trim(rs("Nomealuno"))
		else 
		    %>
	        <script>
		       alert("Matrícula não Cadastrada ou o aluno não pertence a nenhuma situação. Verifique!");
		       window.history.back();
	        </script>
            <%
	    end if
		rs.close
	end if

	if intcodigo <> "" then
	   sql = "Select * from SCA_BLOQUEIO_ALUNO"
	   sql = sql & " where codigo = " & intcodigo
	   rs.open sql, cnn
	   if rs.eof = false then
  	  	  strMotivo 		    = Trim(rs("descricao"))
		  strsituacao 		    = Trim(rs("situacao"))
		  intCod_Departamento   = Trim(rs("Cod_Departamento"))
		  if strsituacao = "B" then
		     statusatual = "CADASTRO - BLOQUEADO"
	      else	
 		     statusatual = "CADASTRO - DESBLOQUEADO"
		  end if	 
		  strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
		  strDesabilitaAlterar 	= ""
		  strDesabilitaExcluir	= "disabled"
	      if  trim(Session("CodDeptoUsuario")) <> intCod_Departamento then
		  	  strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
		      strDesabilitaAlterar 	= "disabled"
		      strDesabilitaExcluir	= "disabled"
			  %>
		      <script>
			     alert("ATENÇÃO: Esse Bloqueio não pertence ao seu Departamento. Verifique!");
		      </script>
		      <%
	      end if
	   end if
	   rs.close	
	end if    
	

%>
<form method="post" id="frm" action="#">
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
            <tr valign="top">
              <td width="700" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
		<tr valign="top">
		  <td align="center">
  <table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
    <tr>
      <td width="9%" class="texto1">Matr&iacute;cula:</td>
      <td colspan="2">
	  <input name="txtCodAluno" type="hidden" id="txtCodAluno" class="text" size="10" value="<%=strCodAluno%>" maxlength="10">
	  <input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intcodigo%>" maxlength="10">
      <input name="txtMatricula" type="text" class="text" id="txtMatricula" size="20" maxlength="20" value="<%=strMatricula%>"  onKeyPress="return formataCampo(this, 2, 10)" onBlur="submit()">
        <a  href="#" onClick="return abreConsulta('Aluno_con.asp')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image7','','<%=session("strCaminhoRaiz")%>/images/botao_verde_over.gif',1)"><img alt="Clique para consultar o aluno" src="<%=session("strCaminhoRaiz")%>/images/botao_verde_normal.gif" name="Image7" width="26" height="26" border="0"  align="absmiddle" ></a></span><input readonly name="txtNomealuno" type="text" class="textDesabilita" id="txtNomealuno" size="50" maxlength="50" value="<%=strNomealuno%>" ></td>
    </tr>
    <tr>
      <td class="texto1">&nbsp;</td>
      <td colspan="2">&nbsp;</td>
    </tr>	
    <tr class="texto1" bgcolor="#D3D3D3">
	  <td height="19" colspan="7" class="texto1"><!--#include file="../includes/inc_sqlDadosEscolaresAluno.asp" --></td>
	</tr>
    <tr>
      <td class="texto1">&nbsp;</td>
      <td colspan="2">&nbsp;</td>
    </tr>
    <tr>
      <td class="texto1">Motivo:</td>
      <td colspan="2"><label>
        <textarea name="txtMotivo" cols="80" rows="3" class="text" id="txtObservacao" ><%=strMotivo%></textarea>
      </label></td>
    </tr>
    <tr>
      <td class="texto1">A&ccedil;&atilde;o:</td>
      <td colspan="2"><select name="cmbSituacao" class="Combo">
        <option value="B">Bloquear</option>
        <option value="D">Desbloquear</option>
      </select></td>
    </tr>
    <tr>
	  <%if statusatual <> "" then%>
            <td colspan="3" class="texto1"><div align="center"><strong><%=statusatual%></strong></div></td>
      <%else %>
            <%end if %>
    </tr>
    <tr>
      <td class="texto1">&nbsp;</td>
      <td colspan="2"><label></label></td>
    </tr>
    <tr> 
      <td colspan="3"><hr size="1" color="#CCCCCC"></td>
    </tr>
    <tr> 
      <td colspan="3"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
    </tr>
    <tr>
      <td colspan="3">
	  <%
			cont =0
			
			sql = "select ab.codigo, ab.ano_letivo, ab.semestre_letivo, a.matricula, a.nomealuno, ab.databloqueio, ab.datadesbloqueio, ab.descricao as bloqueio, d.descricao as depto, ab.situacao, ab.usuario"
			sql = sql & " from SCA_BLOQUEIO_ALUNO ab"
			sql = sql & " inner join sca_aluno a on a.codigo=ab.cod_aluno and a.cod_empresa=ab.cod_empresa"
			sql = sql & " left join seg_departamento d on d.codigo=ab.cod_departamento and d.cod_empresa=ab.cod_empresa"
			sql = sql & " where ab.cod_empresa = " & Session("CodEmpresa")
			sql = sql & " and matricula = '" & strMatricula & "'"
			sql = sql & " order by ab.databloqueio desc"
			rs.open sql, cnn
							
			if rs.eof = false then

			%><br>
<br>

              <table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                <tr bgcolor="#E5E5E5">
                  <td height="21" colspan="7" align="center" class="celula"><strong>Lista de Bloqueios/Desbloqueios </strong></td>
                </tr>
                <tr bgcolor="#E5E5E5">
                  <td width="12%" class="celula"><strong>Per&iacute;odo Letivo</strong></td>
                  <td width="14%" class="celula"><strong>D. do Bloqueio</strong></td>
                  <td width="14%" class="celula"><strong>D. do Desbloqueio</strong></td>
                  <td width="22%" class="celula"><strong>Motivo</strong></td>
                  <td width="15%" class="celula"><strong><strong>Depto Respons&aacute;vel </strong></strong></td>
                  <td width="14%" class="celula"><strong>Usu&aacute;rio</strong></td>
                  <td width="9%" height="21" class="celula"><strong>Situa&ccedil;&atilde;o<span class="TextoForm"> </span></strong></td>
                </tr>
                <%
				while not rs.eof
					cont = cont + 1	
					if rs("situacao") = "B" then sit = "BLOQUEADO"
					if rs("situacao") = "D" then sit = "DESBLOQUEADO"
					%>
                    <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("codigo")%>')">
					<%if  trim(rs("semestre_letivo")) <> "3" then %>
                      <td class="celula"><div align="center">&nbsp;<%=trim(rs("ano_letivo"))%>/<%=trim(rs("semestre_letivo"))%></div></td>
	                <%else%>
	                   <td class="celula"><div align="center">&nbsp;<%=trim(rs("ano_letivo"))%></div></td>	
					<%end if%>   				
                    <td class="celula"><div align="center">&nbsp;<%=trim(rs("databloqueio"))%></div></td>
                    <td class="celula">&nbsp;<%=trim(rs("datadesbloqueio"))%></td>
                    <td class="celula">&nbsp;<%=trim(rs("bloqueio"))%></td>
                    <td class="celula">&nbsp;<%=trim(rs("depto"))%></td>
                    <td class="celula">&nbsp;<%=trim(rs("usuario"))%></td>
                    <td height="20" class="celula">&nbsp;<%=trim(sit)%></td>
                    </tr>
                    <%				
					rs.movenext
					wend
				  %>
                <tr>
                  <td height="21" colspan="7" class="celula">Total Registros : <%=cont%></td>
                </table>
              <%
			  end if
			  rs.close
			  %>	  </td>
    </tr>
  </table>
  		  </td>
		</tr>
  </table>
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>