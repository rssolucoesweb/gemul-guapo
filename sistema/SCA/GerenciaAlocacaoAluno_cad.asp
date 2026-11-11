<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 02/03/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Grade Disciplina
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
</script></head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%=session("strCaminhoRaiz")%>/images/botao_verde_over.gif','<%=session("strCaminhoRaiz")%>/images/botao_vermelho_over.gif')">
<iframe name="iframeAlunoDisciplina" height="0" width="0"></iframe>	
<script src="../../js/js_funcoes_gerais.js"></script>
<script type="text/javascript" src="../../js/js_dragdrop.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
<script>
	
	function resultadoConsulta(intCodigo){
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}

	function salvar(acao){
		
		if (frm.txtAnoLetivoAlocacao.value == "") {
			alert("O Ano da Alocação deve ser informado !");
			frm.txtAnoLetivoAlocacao.focus();
			return false;
		}
		
		frm.action="GerenciaAlocacaoAluno_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
	
	function ExcluirDisciplina(Codigo, CodAluno){
		var men = 'ATENCAO: \nA Alocação do aluno sera exluída, deseja continuar?';
		if (confirm(men)) {
			var acao ="ED";
			window.open("GerenciaAlocacaoAluno_cod.asp?acao=" + acao + "&Codigo=" + Codigo + "&CodAluno=" + CodAluno,"disciplina", "top=0,left=0,height=10,width=10,menubar=no,toolbar=no,scrollbars=yes,status=yes");
		}
	}

</script>
<%
	strPaginaTitulo 			= "GerenciaAlocacaoAluno_cad.asp"
	strPagina					= "GerenciaAlocacaoAluno_cad.asp"
	
	intCodigo							= Trim(Request.Form("txtCodigo"))
	strSemestre 						= session("strSemestre")
	intSemestre 						= session("strSemestre")
	strAnoLetivo 						= session("strAnoLetivo")
	
	strCodAluno							= Trim(Request("txtCodAluno"))
	strMatricula 						= Trim(Request("txtMatricula"))
	strNomealuno 						= Trim(Request("txtNomealuno"))
	strDesabilitaIncluir				= "disabled" 'Desabilita o botão Incluir
	strDesabilitaAlterar 				= "disabled" 'Desabilita o botão Excluir
	strDesabilitaExcluir				= "disabled" 'Desabilita o botão Excluir

	strAnoLetivoAlocacao 				= Trim(Request("txtAnoLetivoAlocacao"))
	strSemestreAlocacao 				= Trim(Request("cmbSemestreAlocacao"))
	strSituacaoAlocacao 				= Trim(Request("cmbSituacaoAlocacao"))

	if intCodigo <> "" then
		sql = " select " 
		sql = sql & " SCA_ALUNO_TURMA.CODIGO, "
		sql = sql & " SCA_ALUNO_TURMA.ANO_LETIVO, "
		sql = sql & " SCA_ALUNO_TURMA.SEMESTRE, "
		sql = sql & " SCA_ALUNO_TURMA.SITUACAO, "
		sql = sql & " SCA_ALUNO.MATRICULA, "
		sql = sql & " SCA_ALUNO.NOMEALUNO, "
		sql = sql & " SCA_ALUNO.CODIGO as CODIGO_ALUNO "
		sql = sql & " from SCA_ALUNO_TURMA "
		sql = sql & " inner join SCA_ALUNO ON SCA_ALUNO.CODIGO = SCA_ALUNO_TURMA.COD_ALUNO "
		sql = sql & " WHERE SCA_ALUNO_TURMA.CODIGO = " & intCodigo
		rs.open sql, cnn
		
		if rs.eof = false then
			intCodigo				= Trim(rs("CODIGO"))
			strAnoLetivoAlocacao	= Trim(rs("ANO_LETIVO"))
			strSemestreAlocacao		= Trim(rs("SEMESTRE"))
			strSituacaoAlocacao		= Trim(rs("SITUACAO"))
			
			strCodAluno				= Trim(rs("CODIGO_ALUNO"))
			strMatricula 			= Trim(rs("MATRICULA"))
			strNomealuno 			= Trim(rs("NOMEALUNO"))

			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			
		end if
		rs.close	
		
	end if
	
	if strMatricula <> "" then
	
		sql = " SELECT TOP 1"
		sql = sql & " A.CODIGO,"	
		sql = sql & " A.MATRICULA,"	
		sql = sql & " A.NOMEALUNO,"
		sql = sql & " C.Cod_curso,"
		sql = sql & " C.DESCRICAO AS CURSO,"
		sql = sql & " C.SIGLA,"
		sql = sql & " P.DESCRICAO AS PERIODO,"
		sql = sql & " AT.COD_TURMA AS TURMA_ATUAL,  T.cod_gradecurricular, P.Cod_Periodo,"
		sql = sql & " T.cod_planopagamento AS PlanoPagamento, isnull(GC.COD_AGRUPAMENTO,'') as COD_AGRUPAMENTO"
		sql = sql & " FROM SCA_ALUNO A"
		sql = sql & " LEFT JOIN SCA_SITUACAOALUNO SA ON SA.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO AND A.COD_EMPRESA = SA.COD_EMPRESA"
		sql = sql & " LEFT JOIN SCA_ALUNO_TURMA AT ON AT.COD_ALUNO = A.CODIGO AND A.COD_EMPRESA = AT.COD_EMPRESA"
		sql = sql & " LEFT JOIN SCA_TURMA T ON T.COD_TURMA = AT.COD_TURMA AND T.COD_EMPRESA = AT.COD_EMPRESA"
		sql = sql & " LEFT JOIN SCA_GRADECURRICULAR GC ON GC.COD_GRADECURRICULAR = T.COD_GRADECURRICULAR AND T.COD_EMPRESA = GC.COD_EMPRESA"
		sql = sql & " LEFT JOIN SCA_PERIODO P ON GC.COD_PERIODO = P.COD_PERIODO AND P.COD_EMPRESA = GC.COD_EMPRESA"
		sql = sql & " LEFT JOIN SCA_CURSO C ON C.COD_CURSO = P.COD_CURSO AND C.COD_EMPRESA = P.COD_EMPRESA"
		sql = sql & " LEFT JOIN SCA_GRAU G ON G.COD_GRAU = C.COD_GRAU AND G.COD_EMPRESA = C.COD_EMPRESA"
		sql = sql & " LEFT JOIN SCF_PLANO PL ON PL.CODIGO = T.Cod_PlanoPagamento AND PL.COD_EMPRESA = T.COD_EMPRESA "
		sql = sql & " LEFT JOIN SCF_UF UF ON UF.CODIGO = A.UFRESIDENCIA"
		sql = sql & " LEFT JOIN SCF_UF UFI ON UFI.CODIGO = A.IDENTIDADEUF"
		sql = sql & " WHERE A.MATRICULA = " & strMatricula
		sql = sql & " AND A.cod_empresa = " & Session("CodEmpresa")	
		sql = sql & " Order BY AT.CODIGO DESC "
		rs.open sql, cnn
		
		if rs.eof = false then
			strCodAluno				= Trim(rs("CODIGO"))
			strMatricula 			= Trim(rs("Matricula"))
			strNomealuno 			= Trim(rs("Nomealuno"))
		end if
		rs.close	
		
	end if


	if session("NivelPermissao") <> "A" then
		%>
		<script>
			alert("Atenção! Procedimento não autorizado para esse perfil.");
			window.navigate('GerenciaAlocacaoAluno_cad.asp');
		</script>
		<%
		response.end
    end if
	%>
	<form method="post" id="frm" action="#">
  	<table width="100%" border="0" align="center" cellpadding="0" cellspacing="2" bgcolor="#FFFFFF">
    <tr>
      <td height="17" colspan="3" align="center" class="texto1"><span class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></span></td>
    </tr>
    <tr>
      <td height="17" colspan="3" bgcolor="#CCCCCC" class="texto1"><strong>Dados Aluno</strong></td>
    </tr>
    <tr>
      <td colspan="3" class="texto1"><input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">&nbsp;</td>
    </tr>
    <tr>
      <td width="133" class="texto1">Ano Letivo:</td>
      <td colspan="2"><span class="texto1">
        <input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
      </span></td>
    </tr>
    <tr>
      <td class="texto1">Semestre:</td>
      <td colspan="2"><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
    </tr>
    <tr>
      <td class="texto1">Matr&iacute;cula:</td>
      <td colspan="2"><input name="txtCodAluno" type="hidden" id="txtCodAluno" class="text" size="10" value="<%=strCodAluno%>" maxlength="10"><span class="texto1">
        <input name="txtMatricula" type="text" class="text" id="txtMatricula" size="20" maxlength="20" value="<%=strMatricula%>"  onKeyPress="return formataCampo(this, 2, 11)" onBlur="submit()">
        <a  href="#" onClick="return abreConsulta('Aluno_con.asp')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image7','','<%=session("strCaminhoRaiz")%>/images/botao_verde_over.gif',1)"><img alt="Clique para consultar o aluno" src="<%=session("strCaminhoRaiz")%>/images/botao_verde_normal.gif" name="Image7" width="26" height="26" border="0"  align="absmiddle" ></a></span><input readonly name="txtNomealuno" type="text" class="textDesabilita" id="txtNomealuno" size="50" maxlength="50" value="<%=strNomealuno%>" ></td>
    </tr>
    
    <tr>
      <td class="texto1">&nbsp;</td>
      <td colspan="2">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="3"><hr size="1" color="#CCCCCC"></td>
    </tr>
    <tr>
      <td class="texto1"><strong>Ano Letivo</strong>:</td>
      <td width="841"><span class="texto1">
        <input  name="txtAnoLetivoAlocacao" type="text" class="text" id="txtAnoLetivoAlocacao" onBlur="submit()"  value="<%=strAnoLetivoAlocacao%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
      </span></td>
      <td width="338">&nbsp;</td>
    </tr>
    <tr>
      <td class="texto1"><strong>Semestre</strong>:</td>
      <td><select name="cmbSemestreAlocacao" class="combo" id="cmbSemestreAlocacao"  style="width:90pt" onchange='' >
        <option value="1" <%if strSemestreAlocacao = "1" then response.Write("selected") %>>1. Semestre</option>
        <option value="2" <%if strSemestreAlocacao = "2" then response.Write("selected") %>>2. Semestre</option>
        <option value="3" <%if strSemestreAlocacao = "3" then response.Write("selected") %>>Anual</option>
      </select></td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td class="texto1"><strong>Situa&ccedil;&atilde;o</strong>:</td>
      <td><select name="cmbSituacaoAlocacao" class="combo" id="cmbSituacaoAlocacao"  style="width:100pt" onchange='' >
        <option value="A" <%if strSituacaoAlocacao = "A" then response.Write("selected") %>>Aloca&ccedil;&atilde;o Ativa</option>
        <option value="R" <%if strSituacaoAlocacao = "R" then response.Write("selected") %>>Remanejado</option>
      </select></td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="3"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
    </tr>
    <tr>
      <td colspan="3" class="texto1">&nbsp;    
    <tr>
      <td colspan="3" class="texto1"><%
			if strCodAluno <> "" then%>
				<%              
				sql = " select AT.CODIGO, AT.COD_ALUNO, AT.COD_TURMA, AT.ANO_LETIVO, AT.SEMESTRE, AT.SITUACAO, AT.DATA_SITUACAO, T.NomeTurma " 
				sql = sql & " from SCA_ALUNO_TURMA AT "
				sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = AT.COD_TURMA "
				sql = sql & " where	AT.COD_ALUNO = " & strCodAluno
				sql = sql & " order by AT.CODIGO DESC"
				rs.open sql, cnn		
				if not rs.eof then
					%>
        			<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" class="tabela" >
                		<tr bgcolor="#D3D3D3">
                		<td height="19" colspan="6" align="center" class="celula"><strong>Hist&oacute;rico de Aloca&ccedil;&atilde;o</strong></td>
          			</tr>
          			<tr bgcolor="#D3D3D3">
               		  <td width="2%" class="celula">&nbsp;</td>
                		<td width="8%" align="center" class="celula"><strong>Turma</strong></td>
              			<td width="9%" class="celula"><div align="center"><strong>Ano Letivo</strong></div></td>
                		<td width="11%" class="celula"><div align="center"><strong>Semestre</strong></div></td>
                		<td width="11%" class="celula"><div align="center"><strong>Situa&ccedil;&atilde;o</strong></div></td>
                		<td width="16%" class="celula"><strong>Data Aloca&ccedil;&atilde;o</strong></td>
               		  </tr>
          			<%
					id = 0
					while not rs.eof 
					    strSituacao = ""
						if trim(rs("SITUACAO")) = "A" then 
							strSituacao = "ATIVA"
						end if
						
						if trim(rs("SITUACAO")) = "R" then 
							strSituacao = "REMANEJADO"
						end if

						%>
                        
                      	<tr bgcolor="#F3F3F3">
                            <td class="celula" align="center"><a href="#" onClick="ExcluirDisciplina('<%=rs("codigo")%>','<%=strMatricula%>')"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image<%=rs("codigo")%>','','<%=session("strCaminhoRaiz")%>/images/botao_vermelho_over.gif',1)"><img alt="Clique para excluir aloca&ccedil;&atilde;o do aluno." align="absmiddle" src="<%=session("strCaminhoRaiz")%>/images/botao_vermelho_normal.gif" name="Image<%=rs("codigo")%>" width="26" height="26" border="0"></a></td>
                            <td style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("codigo")%>')" class="celula"><div align="center"><strong><%=rs("nometurma")%>&nbsp;</strong></div></td>
                            <td class="celula"><div align="center"><strong><strong>&nbsp;<%=rs("Ano_Letivo")%></strong></strong></div></td>
                            <td class="celula"><div align="center"><strong>&nbsp;<%=rs("SEMESTRE")%></strong></div></td>
                          <td class="celula"><div align="center">&nbsp;<%=strSituacao%></div></td>
                            <td class="celula"><div align="center"><strong>&nbsp;</strong>&nbsp;<%=rs("DATA_SITUACAO")%></div></td>
                        </tr>
          				<%
					id = id + 1
					rs.movenext
				wend 
			end if			
			rs.close
			%>
            
              
               <tr>
                <td colspan="6" align="center" class="celula">&nbsp;</td>
                </tr>
      </table>
        <%end if%>
   	  <tr> 
      	<td colspan="3" class="texto1">&nbsp;<tr>
        <td colspan="3" class="texto1">      
    </table>
	</td>
    </tr>
  </table>
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>