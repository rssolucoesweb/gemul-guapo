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
//-->
</script>
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%=session("strCaminhoRaiz")%>/images/botao_verde_over.gif')">
<script src="../../js/js_funcoes_gerais.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--include file="../../includes/inc_validaPermissaoPagina.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../js/Calendario/Calendario.asp"-->
<script>
	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}

	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		
		if (frm.txtMatricula.value == "") {
			alert("A Matricula do Aluno deve ser informada !");
			frm.txtMatricula.focus();
			return false;
		}
		
		if (frm.txtDataOcorrencia.value == "") {
			alert("A Data da Ocorrência deve ser informada !");
			frm.txtDataOcorrencia.focus();
			return false;
		}
		
		if (frm.txtOcorrencia.value == "") {
			alert("A Ocorrência deve ser informada !");
			frm.txtOcorrencia.focus();
			return false;
		}
		
		frm.action="FaltasHorarioOcorrencia_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}

</script>
<%
	strPaginaTitulo			= "Ocorrencia_cad.asp"
	intCodOcorrencia 		= Trim(Request.Form("txtCodigo"))
	strCodAluno 			= Trim(Request("txtCodAluno"))
	strDataOcorrencia 		= Trim(Request.Form("txtDataOcorrencia"))
	IF strDataOcorrencia = "" THEN strDataOcorrencia = formatadataAP(date)
	strOcorrencia 			= Trim(Request.Form("txtOcorrencia"))
	
	if trim(strCodAluno) <> "" then
	   sql = "SELECT codigo,matricula,nomealuno from sca_aluno "
	   sql = sql & " Where cod_empresa = " & Session("CodEmpresa")			
	   sql = sql & " And codigo = " & strCodAluno
	   rs.open sql, cnn
  	   if rs.eof = false then
	      strCodAluno				= rs("codigo")
		  strMatricula				= rs("matricula")
		  strNomeAluno				= rs("nomealuno")
	   end if
	   rs.close	  
	end if   
	
	
	if trim(intCodOcorrencia) <> "" then
	
		sql = "SELECT O.COD_OCORRENCIA_FALTAS, O.COD_ALUNO, A.MATRICULA, A.NOMEALUNO, O.DATAOCORRENCIA, O.OCORRENCIA"
		sql = sql & " FROM SCA_OCORRENCIA_FALTAS O"
		sql = sql & " LEFT JOIN SCA_ALUNO A ON A.CODIGO = O.COD_ALUNO"
		sql = sql & " Where O.COD_OCORRENCIA_FALTAS = " & intCodOcorrencia
		sql = sql & " And O.cod_empresa = " & Session("CodEmpresa")			
		
		rs.open sql, cnn
		
		if rs.eof = false then
			strCodAluno				= rs("COD_ALUNO")
			intCodOcorrencia 		= rs("COD_OCORRENCIA_FALTAS")
			strMatricula 			= rs("MATRICULA")
			strNomeAluno 			= rs("NOMEALUNO")
			strDataOcorrencia 		= FORMATADATAAP(rs("DATAOCORRENCIA"))
			strOcorrencia 			= rs("OCORRENCIA")

			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir

		end if 
		rs.close
	else
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	end if 
%>
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td>
	<table width="100%"  height="325" border="0" cellspacing="0" cellpadding="0">
      <tr valign="top">
        <td colspan="2" align="center">
		<form id="frm" method="post">
              <input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodOcorrencia%>" maxlength="10">
              <input name="txtCodAluno" type="hidden" class="text" id="txtCodAluno" size="15" maxlength="20" value="<%=strCodAluno%>">
        
		  <table width="100%" border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td height="45" colspan="4" class="texto1"><div align="center"><span class="tituloSistema">Cadastro de Ocorr&ecirc;ncias de Faltas</span></div></td>
            </tr>
          <tr>
            <td height="26" class="texto1">Aluno: 
              </td>
            <td colspan="3"><span class="texto1">
              <input name="txtMatricula" readonly type="text" class="textDesabilita" id="txtMatricula" size="15" maxlength="20" value="<%=strMatricula%>"  onKeyPress="return formataCampo(this, 2, 10)" onChange="submit()">
              
              </span>- <span class="texto1">
                <input name="txtNomealuno" readonly type="text" class="textDesabilita" id="txtNomealuno" size="50" maxlength="50" value="<%=strNomealuno%>"  onKeyPress="return formataCampo(this, 1, 50)">
                </span></td>
          </tr>
          <tr>
            <td height="24" class="texto1">Data Ocorr&ecirc;ncia: </td>
            <td colspan="3"><span class="texto1">
              <input <%if strDesabilitaAlterar="" then response.Write("disabled")%>  name="txtDataOcorrencia" type="text" class="text" id="txtDataOcorrencia" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" style="cursor:hand" title="Click aqui para visualizar o calend&aacute;rio" maxlength="10" value="<%=strDataOcorrencia%>">
              </span></td>
          </tr>
          <tr>
            <td class="texto1">Ocorr&ecirc;ncia: </td>
            <td colspan="3"><textarea name="txtOcorrencia" cols="60" rows="5" class="text" id="txtOcorrencia"><%=strOcorrencia%></textarea></td>
          </tr>
          <tr>
            <td class="texto1">&nbsp;</td>
            <td colspan="3">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="4">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="4"><!--#include file="../../includes/inc_botoes_cadastroPopap.asp"--></td>
          </tr>
          <tr>
            <td colspan="4">&nbsp;</td>
          </tr>
          </table>
		  <%
		  if trim(strCodAluno) <> "" then
		  	 sql = "SELECT O.COD_OCORRENCIA_FALTAS, O.COD_ALUNO, A.MATRICULA, A.NOMEALUNO, O.DATAOCORRENCIA ,O.OCORRENCIA, O.USUARIO_INCL, O.DATA_HORA_INCL"
		  	 sql = sql & " FROM SCA_OCORRENCIA_FALTAS O"
		     sql = sql & " LEFT JOIN SCA_ALUNO A ON A.CODIGO = O.COD_ALUNO"
		     sql = sql & " where O.cod_empresa = " & Session("CodEmpresa")			
  	         sql = sql & " and O.COD_ALUNO = " & strCodAluno
			 sql = sql & " and O.ANO_LETIVO = " & SESSION("strAnoLetivo")
			 sql = sql & " and O.SEMESTRE = " & session("strSemestre")
 		     sql = sql & " order by O.DATAOCORRENCIA DESC"
		     rs.open sql, cnn
		     if rs.eof = false then
		        %>
				
			  <table width = "100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
	            <tr bgcolor="#E5E5E5" class="celula">
		        <td class="celula">Data</td>
		        <td height="26" class="celula">Ocorr&ecirc;ncia</td>
		        <td class="celula">Usu&aacute;rio</td>
		        <td class="celula">Atualização</td>
		        </tr>
			    <%
			    while not rs.eof
				   cont = cont + 1	
				   if trim(ucase(rs("USUARIO_INCL"))) = trim(ucase(Session("UsuarioWeb"))) then
						strMostraFuncao = "bgcolor='#FFFFFF' class='celula'  style='cursor:hand' onMouseOver='return linhaMouseOver(this)' onMouseOut='return linhaMouseOut(this)'  onClick='return resultadoConsulta(" & rs("COD_OCORRENCIA_FALTAS") & ")'"
				   else
				   		strMostraFuncao = "bgcolor='#C0C0C0'"
				   end if
				   %>
				   <tr <%=strMostraFuncao%>>
				   <td width="8%" class="celula">&nbsp;<%=trim(rs("DATAOCORRENCIA"))%></td>
				   <td width="40%" height="26" class="celula">&nbsp;<%=trim(rs("OCORRENCIA"))%></td>
				   <td width="15%" height="26" class="celula">&nbsp;<%=trim(rs("USUARIO_INCL"))%></td>
				   <td width="20%" height="26" class="celula">&nbsp;<%=trim(rs("DATA_HORA_INCL"))%></td>
				   </tr>
				   <%				
				   rs.movenext
			    wend
			    %>
			    <tr> 
			    <td height="21" colspan="5" class="celula"><span class="texto">Total Registros :</span> <%=cont%></td>
			    <%
			else
			    %>
				</table>
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
	            <tr bgcolor="#E5E5E5" class="celula">
				<td  height="19" class="texto1"><div align="center">Não Existe Lançamento de Ocorrência para essa Matrícula</div></td>
		        </tr>
				<%				
		    end if
		    rs.close
		 end if	
		 %>
        </table>
		</form>
		</td>
      </tr>
    </table>
	</td>
  </tr>
</table>
</body>
</html>