<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 23/05/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Historico Escolar
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
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../../images/botao_vermelho_over.gif')">
<script src="../../js/js_funcoes_gerais.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<script>
	function validaMedia(mediaAprovacao){
		var valor = frm.txtMedia.value;
		if (valor != "") {
			if (valor<0 || valor>10){
				alert("Atenção: Média inválida, deve estar entre 0 a 10!");
				frm.txtMedia.select();
				frm.txtMedia.style.backgroundColor = "#DAFA7A";
				frm.txtMedia.focus();
				return false;
			}else{
				if (frm.cmbSituacaoPromocao.value.substring(0,2) == "AP") {
					if (parseFloat(valor) < parseFloat(mediaAprovacao)) {
						alert("Atenção: Média informada esta maoir que a média de aprovação, a situação não porderá ser aprovado.");
						frm.txtMedia.select();
						frm.txtMedia.style.backgroundColor = "#DAFA7A";
						frm.txtMedia.focus();
					}else{
						frm.txtMedia.style.backgroundColor = "#FFB7B7";
					}
				}else{
					frm.txtMedia.style.backgroundColor = "#FFB7B7";			
				}
			}
		}
	}		
	function dadosHistorico(){
		if (mostraDadosHistorico.style.display=="none"){
			mostraDadosHistorico.style.display="block"
			frm.imgDadosHistorico.src="<%=session("strCaminhoRaiz")%>/images/down.jpg"
			frm.txtExpandirHistorico.value="S"
		}
		else{
			mostraDadosHistorico.style.display="none"
			frm.imgDadosHistorico.src="<%=session("strCaminhoRaiz")%>/images/up.jpg"
			frm.txtExpandirHistorico.value="N"
		}
	}
	function resultadoConsulta(intCodigo){
		frm.action="HistoricoEscolar_cad.asp?codhistoricoEscolar=" + intCodigo;
		frm.submit();
	}

	function resultadoConsultaDisciplina(intCodHistorico, intCodHistoricoDisciplina){
		frm.action="HistoricoEscolar_cad.asp?codhistoricoEscolar=" + intCodHistorico + "&codhistoricoEscolarDisciplina=" + intCodHistoricoDisciplina;
		frm.submit();
	}


	function salvar(acao){
		
		frm.action="HistoricoEscolar_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}

	function excluirHistorico(codigo){
			var men = 'ATENÇÃO: Deseja realmente Excluir TODO o Histórico Escolar?\n'
			if (confirm(men)) {
				frm.action="HistoricoEscolar_cod.asp?acao=EH&codHistoricoEscolar="+codigo;
				frm.submit();
			} 
			else {
				return false;
			}
 	}

	function excluirDisciplina(codigo){
			var men = 'ATENÇÃO: Deseja realmente Excluir essa disciplina do Histórico Escolar?\n'
			if (confirm(men)) {
				frm.action="HistoricoEscolar_cod.asp?acao=ED&codHistoricoEscolarDisciplina="+codigo;
				frm.submit();
			} 
			else {
				return false;
			}
 	}
</script>
<%
	strPaginaTitulo 					= "HistoricoEscolar_cad.asp"

	intCodEmpresa 						= Session("CodEmpresa")
	intSemestreHistorico 				= session("strSemestre")
	strAnoHistorico 					= session("strAnoLetivo")

	intCodAluno							= Trim(Request("txtCodAluno"))
	strMatricula						= Trim(Request("txtMatricula"))
	codHistoricoEscolar					= Trim(Request("codHistoricoEscolar"))
	codHistoricoEscolarDisciplina		= Trim(Request("codHistoricoEscolarDisciplina"))
	strExpandirHistorico				= Trim(Request("txtExpandirHistorico"))
	
	intCodPeriodo 						= Trim(Request("cmbPeriodo"))
	intCodCurso	            			= Trim(Request("cmbCurso"))
	intCodDisciplinaGradeHistorico 		= Trim(Request("cmbDisciplinaGradeHistorico"))
	strCH 								= Trim(Request("txtCH"))
	strMedia 							= Trim(Request("txtMedia"))
	strSituacaoPromocao 				= Trim(Request("cmbSituacaoPromocao"))
	strObservacao		   	 			= Trim(Request.Form("txtObservacao"))
	strSimouNao         				= Trim(Request("cmbSimouNao"))
	
	'bloqueia historico disciplina
	strPeriodo_Disabled = " disabled " 
	strDisciplina_Disabled = " disabled "  
	strAno_Disabled = " disabled " 
	strSemestre_Disabled = " disabled " 
	strCH_Disabled = " disabled " 
	strSituacaoPromocao_Disabled = " disabled " 
	strMedia_Disabled = " disabled " 
	
	strExecutarSubmitPeriodo = "S"
	strFuncaoSitPromocao = "S"
	
	if codHistoricoEscolar <> "" then
		sql = "SELECT * FROM SCA_HISTORICO_ESCOLAR "
		sql = sql & " WHERE	CODIGO = " & codHistoricoEscolar
		sql = sql & " and cod_empresa = " & intCodEmpresa
		rs.open sql, cnn
		if not rs.eof then
			'DADOS DO HISTORICO 
			strEscola			= Trim(Rs("escola"))
			strCidade			= Trim(Rs("cidade"))
			strUfResidencia		= Trim(Rs("uf"))
			strAnoHistorico		= Trim(Rs("ano_letivo"))
			intSemestreHistorico= Trim(Rs("semestre"))
			strCurso			= Trim(Rs("curso"))
			strSerie			= Trim(Rs("serie"))
			intCodAluno      	= Trim(rs("cod_aluno"))

			'libera historico disciplina
			strPeriodo_Disabled = ""
			strDisciplina_Disabled = "" 
			strAno_Disabled = ""
			strSemestre_Disabled = ""
			strCH_Disabled = ""
			strSituacaoPromocao_Disabled = ""
			strMedia_Disabled = ""
		
		end if
		rs.close
	end if
%>
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td>
	<table width="790"  height="325" border="0" cellspacing="0" cellpadding="0">
      <tr valign="top">
        <td colspan="2" align="center">
		<form id="frm" method="post" action="historicoEscolar_cad.asp">
		  <table width="98%" border="0" cellpadding="0" cellspacing="0" align="center">

            <tr valign="top">
              <td align="center" class="tituloSistema">HISTÓRICO ESCOLAR</td>
            </tr>
          </table>
		  <br>
		  <table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
		  <%
			strMatricula = ""
			strDataNascimento = ""
			strNomeCompleto = ""
			if intSemestreHistorico = "" then intSemestreHistorico = "0"
			sql = "SELECT TOP 1 SCA_CURSO.Cod_Curso, SCA_ALUNO.CODIGO, SCA_ALUNO.MATRICULA, SCA_ALUNO.NOMEALUNO, SCA_GRADECURRICULAR.Cod_GradeCurricular, "
			sql = sql & " SCA_ALUNO.DATANASCIMENTO, SCA_ALUNO.DATACOLACAO,SCA_ALUNO.ANOCONCLUSAO,SCA_ALUNO.MAE , SCA_PERIODO.DESCRICAO AS PERIODO, SCA_CURSO.DESCRICAO AS CURSO, SCA_CURSO.cod_curso,"
			sql = sql & " SCA_TURMA.COD_SEMESTRE, SCA_TURMA.COD_TURMA, SCA_TURMA.COD_TURNO,SCA_TURMA.NomeTurma "
			sql = sql & " FROM SCA_ALUNO_TURMA "
			sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO "
			sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma  AND SCA_ALUNO_TURMA.ANO_LETIVO = SCA_TURMA.AnoLetivo AND SCA_ALUNO_TURMA.SEMESTRE = SCA_TURMA.Cod_Semestre AND SCA_ALUNO_TURMA.cod_empresa = SCA_TURMA.cod_empresa "
			sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_Periodo = SCA_GRADECURRICULAR.Cod_Periodo "
			sql = sql & " and SCA_PERIODO.cod_empresa = SCA_GRADECURRICULAR.cod_empresa "
			sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_Curso = SCA_PERIODO.Cod_Curso and SCA_CURSO.cod_empresa = SCA_PERIODO.cod_empresa "
			sql = sql & " where SCA_TURMA.cod_empresa = " & intCodEmpresa
			sql = sql & " and 	SCA_ALUNO.CODIGO = " & intCodAluno
			sql = sql & " order by SCA_ALUNO_TURMA.CODIGO DESC "
			rs.open sql, cnn
			if not rs.eof then
				strMatricula = rs("MATRICULA")
				strDataNascimento = formatadataap(rs("DATANASCIMENTO"))
				strNomeCompleto = rs("NOMEALUNO") 
				intCodGrade = rs("Cod_GradeCurricular") 
				intCodCurso = rs("cod_curso") 
				intCodTurma = rs("COD_TURMA")
				intSemestreHistorico = rs("COD_SEMESTRE")
				intCodTurno = rs("COD_TURNO")
				strAnoConclusao = rs("ANOCONCLUSAO")
				strDataColacao = rs("DATACOLACAO")
				strDescCurso = rs("CURSO")
				strDescPeriodo = rs("PERIODO")
				strTurma = rs("NOMETURMA")
				
				%>
				<tr bgcolor="#EEEEEE">
              <td width="93" height="24" class="celula">&nbsp;<strong>Matr&iacute;cula:</strong></td>
              <td width="288" class="celula">&nbsp;<font color="#0000CC"><strong><%=strMatricula%></strong></font></td>
              <td width="96" class="celula">&nbsp;<strong>Data Nasc.:</strong></td>
              <td width="296" class="celula">&nbsp;<font color="#0000CC"><strong><%=strDataNascimento%></strong></font></td>
            </tr>
            <tr bgcolor="#EEEEEE">
              <td height="24" class="celula">&nbsp;<strong>Aluno:</strong></td>
              <td colspan="3" class="celula">&nbsp;<font color="#0000CC"><strong><%=strNomeCompleto%></strong></font></td>
              </tr>
            <tr bgcolor="#EEEEEE">
                  <td height="24" class="celula">&nbsp;<strong>Curso:</strong></td>
              <td colspan="3" class="celula">&nbsp;<font color="#0000CC"><strong><%=strDescCurso%></strong></font></td>
              </tr>
            <tr bgcolor="#EEEEEE">
              <td height="24" class="celula">&nbsp;<strong>Per&iacute;odo:</strong></td>
              <td class="celula">&nbsp;<font color="#0000CC"><strong><%=strDescPeriodo%></strong></font></td>
                  <td class="celula">&nbsp;<strong>Turma Atual:</strong></td>
              <td class="celula">&nbsp;<font color="#0000CC"><strong><%=strTurma%></strong></font></td>
            </tr>				
				
				<%
			else
			   %>
			  	<script>
				   alert("ATENÇÃO: O Aluno ainda não foi alocado em uma turma, verifique!");
				</script>
			   <%
			end if
			rs.close
		  %>
		  </table>
		  <%		
			strMediaAprovacao = 0	  
			sql	=	"select media_aprovacao as resultado_aprovacao_final from SCA_CRITERIO_AVALIACAO"
			sql	=	sql & " where cod_curso=" & intCodCurso
			sql	=	sql & " and cod_empresa=" & Session("CodEmpresa") 
		    rs.open sql, cnn
			if rs.eof = false then
				strMediaAprovacao           = trim(rs("resultado_aprovacao_final"))
			end if
			rs.close
			sql = "SELECT * FROM SCA_HISTORICO_ESCOLAR "
			sql = sql & " WHERE	COD_EMPRESA = " & Session("CodEmpresa") 
			sql = sql & " AND	COD_ALUNO = " & intCodAluno
			sql = sql & " order by ano_letivo, semestre, serie "
			rs.open sql, cnn
			if not rs.eof then	%>
			<br>
			  <table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
                <tr bgcolor="#EEEEEE"> 
                  <td height="20" colspan="6" class="celula"><div align="center"><strong>Estudos 
                      Realizados </strong></div></td>
                </tr>
                <tr bgcolor="#EEEEEE"> 
                  <td width="3%" class="celula">&nbsp;</td>
                  <td width="7%" class="celula"><strong>&nbsp;Ano</strong></td>
                  <td width="11%" class="celula"><strong>&nbsp;Semestre</strong></td>
                  <td width="34%" class="celula"><strong>&nbsp;Escola</strong></td>
                  <td width="30%" class="celula">&nbsp;<strong>Curso</strong></td>
                  <td width="15%" height="20" class="celula">&nbsp;<strong>Per&iacute;odo/S&eacute;rie&nbsp;</strong></td>
                </tr>
                <%
				while not rs.eof 
				%>
                <tr bgcolor="#FFFFFF"  style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"  > 
                  <td class="celula"><a href="#" onClick="excluirHistorico('<%=rs("codigo")%>')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image3','','../../images/botao_vermelho_over.gif',1)"><img src="../../images/botao_vermelho_normal.gif" alt="Clique para excluir por completo o histórico" name="Image3" width="26" height="26" border="0"></a></td>
                  <td class="celula" onClick="return resultadoConsulta('<%=rs("CODIGO")%>')">&nbsp;<%=rs("ano_letivo")%></td>
                  <td class="celula" onClick="return resultadoConsulta('<%=rs("CODIGO")%>')">&nbsp;<%=rs("semestre")%></td>
                  <td class="celula" onClick="return resultadoConsulta('<%=rs("CODIGO")%>')">&nbsp;<%=rs("escola")%></td>
                  <td class="celula" onClick="return resultadoConsulta('<%=rs("CODIGO")%>')">&nbsp;<%=rs("curso")%></td>
                  <td height="20" class="celula" onClick="return resultadoConsulta('<%=rs("CODIGO")%>')">&nbsp;<%=rs("serie")%></td>
                </tr>
                <%
					rs.movenext
				wend
				%>
              </table>
				<%
			end if
			rs.close
			%>
			<br>
		      <table width="98%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td height="20" bgcolor="#EEEEEE" class="texto1" align="left"  style="cursor:hand" onClick="return dadosHistorico()">&nbsp;<img id="imgDadosHistorico" src="<%=session("strCaminhoRaiz")%>/images/down.jpg" width="12" height="12"></td>
                  <td height="20" colspan="5" align="center" bgcolor="#EEEEEE" class="texto1"><strong>CADASTRO 
                    DO HISTORICO</strong> <input name="txtExpandirHistorico" value="<%=strExpandirHistorico%>" type="hidden"></td>
                </tr>
                <tr> 
                  <td colspan="6" height="20" class="texto1" align="center" id="mostraDadosHistorico">&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="6" height="20" class="texto1" align="center" id="mostraDadosHistorico"> 
                    <!-- linnha historico -->
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td colspan="8"><hr size="1" color="#999999"></td>
                      </tr>
                      <tr> 
                        <td colspan="8" height="20" bgcolor="#EEEEEE" class="texto1" >&nbsp;&nbsp;<strong>Dados 
                          do Hist&oacute;rico </strong></td>
                      </tr>
                      <tr> 
                        <td class="texto1">&nbsp;Ano: </td>
                        <td colspan="3" class="texto1"><input name="txtAnoHistorico" type="text" class="text" id="txtAnoHistorico" size="5" maxlength="4" value="<%=strAnoHistorico%>" onKeyPress="return formataCampo(this, 2, 4)"></td>
                        <td class="texto1">Semestre:</td>
                        <td colspan="3" class="texto1"> 
                          <!--#include file="../includes/inc_cmdSemestreHistorico.asp" -->
                        </td>
                      </tr>
                      <tr> 
                        <td class="texto1"> &nbsp;Curso:</td>
                        <td colspan="3" class="texto1"><input name="txtCurso" type="text" class="text" id="txtCurso" size="50" maxlength="100" value="<%=strCurso%>" ></td>
                        <td class="texto1">Per&iacute;odo/S&eacute;rie:</td>
                        <td colspan="3" class="texto1"><input name="txtSerie" type="text" class="text" id="txtSerie" size="15" maxlength="100" value="<%=strSerie%>" ></td>
                      </tr>
                      <tr> 
                        <td width="9%" class="texto1">&nbsp;Escola: </td>
                        <td colspan="3" class="texto1"><input name="txtEscola" type="text" class="text" id="txtEscola" size="50" maxlength="100" value="<%=strEscola%>"  onKeyPress="return formataCampo(this, 1, 100)"></td>
                        <td width="14%" class="texto1">&nbsp;</td>
                        <td colspan="3" class="texto1">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td class="texto1">&nbsp;Cidade:</td>
                        <td colspan="3" class="texto1"><input name="txtCidade" type="text" class="text" id="txtCidade" size="50" maxlength="50" value="<%=strCidade%>" onKeyPress="return formataCampo(this, 1, 100)"></td>
                        <td class="texto1">UF:</td>
                        <td width="13%" class="texto1"> 
                          <!--#include file="../includes/inc_cmdUFResidencia.asp"-->
                        </td>
                        <td width="12%" class="texto1">Observa&ccedil;&otilde;es</td>
                        <td width="13%" class="texto1"> 
                          <!--#include file="../includes/inc_cmbSimouNao.asp"-->
                          &nbsp;</td>
                      </tr>
                    </table>
                    <hr size="1" color="#999999"> 
                    <!-- fim linha -->
                  </td>
                </tr>
				<%
				if strSimouNao="S" then
				   %>
                   <tr>
                   <td colspan="6" bgcolor="#EEEEEE" class="texto1" ><div align="center">&nbsp;<strong>Observa&ccedil;&otilde;es 
                      na S&eacute;rie/Per&iacute;odo ( M&aacute;ximo 200 caracteres 
                      )</strong></div></td>
                   </tr>
                   <tr> 
                   <td colspan="6"><div align="center">
                   <textarea name="txtObservacao" cols="80" rows="3" class="text" id="txtObservacao"> <%=strObservacao%> </textarea>
                   </div></td>
                   </tr>
                   <%
				end if
		  IF codHistoricoEscolarDisciplina <> "" then
			sql = "SELECT * FROM SCA_HISTORICO_ESCOLAR_DISCIPLINA "
			sql = sql & " WHERE	CODIGO = " & codHistoricoEscolarDisciplina
			sql = sql & " AND	cod_historico_escolar = " & codHistoricoEscolar
			rs.open sql, cnn
			if not rs.eof then	
				intCodPeriodo 		= Trim(Rs("cod_periodo"))
				intCodDisciplinaGradeHistorico = Trim(Rs("cod_disciplina"))
				strSituacaoPromocao = Trim(Rs("situacao"))
				intSemestreHistorico= Trim(Rs("semestre"))
				strCH 				= Trim(Rs("carga_horaria"))
				strAnoHistorico		= Trim(Rs("ano_letivo"))
				strMedia			= ""
				if not isnull(Rs("media")) then
					strMedia			= formatNumber(Rs("media"),1)
				end if
			end if
			rs.close	  
		  
		  END IF
		  %>
                <tr> 
                  <td colspan="6" height="20" bgcolor="#EEEEEE" class="texto1" >&nbsp;&nbsp;<strong>Disciplinas 
                    do Hist&oacute;rico </strong></td>
                </tr>
                <tr> 
                  <td class="texto1">&nbsp;Per&iacute;odo:</td>
                  <td colspan="5" class="texto1"> 
                    <!--#include file="../includes/inc_cmdPeriodo.asp" -->
                  </td>
                </tr>
                <tr> 
                  <td class="texto1">&nbsp;Disciplina:</td>
                  <td colspan="5" class="texto1"> 
                    <!--#include file="../includes/inc_cmdDisciplinaGradeHistorico.asp" -->
                  </td>
                </tr>
                <tr> 
                  <td height="26" class="texto1">&nbsp;Ano:</td>
                  <td class="texto1"><input  disabled="disabled" name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" size="5" maxlength="4" value="<%=strAnoHistorico%>" onKeyPress="return formataCampo(this, 2, 4)"  <%=strAno_Disabled%>></td>
                  <td class="texto1">Semestre:</td>
                  <td class="texto1"><input  disabled="disabled" name="txtAnoLetivo2" type="text" class="text" id="txtAnoLetivo2" size="5" maxlength="4" value="<%=intSemestreHistorico%>" onKeyPress="return formataCampo(this, 2, 4)"  <%=strSemestre_Disabled%>></td>
                  <td class="texto1">&nbsp;</td>
                  <td class="texto1">&nbsp;</td>
                </tr>
                <tr> 
                  <td class="texto1">&nbsp;C.H.: </td>
                  <td class="texto1"><input name="txtCH" type="text" class="text" id="txtCH" size="5" maxlength="4" value="<%=strCH%>" onKeyPress="return formataCampo(this, 2, 5)" <%=strCH_Disabled%>></td>
                  <td class="texto1">Situa&ccedil;&atilde;o:</td>
                  <td class="texto1"> 
                    <!--#include file="../includes/inc_cmdSituacaoPromocao.asp" -->
                  </td>
                  <td class="texto1">M&eacute;dia:</td>
                  <td class="texto1"><input id="txtMedia" type="text" class="text" name="txtMedia" value="<%=strMedia%>" size="6" <%=strMedia_Disabled%> onBlur="validaMedia('<%=round(strMediaAprovacao,1)%>')"  onKeyPress="return formataCampo(this,6,4)"></td>
                </tr>
                <tr> 
                  <td colspan="6"><hr size="1" color="#999999"></td>
                </tr>
              </table>
		<input type="hidden" name="txtCodAluno"  value="<%=intCodAluno%>">
		<input type="hidden" name="txtMatricula"  value="<%=strMatricula%>">
		<input type="hidden" name="codHistoricoEscolar"  value="<%=codHistoricoEscolar%>">
		<input type="hidden" name="codHistoricoEscolarDisciplina"  value="<%=codHistoricoEscolarDisciplina%>"><div align="left">&nbsp;&nbsp;&nbsp;<input onClick="salvar('I')" name="btnSalvar" value=" Salvar Histórico" type="button" class="botao">&nbsp;&nbsp;&nbsp;&nbsp;
		<input onClick="window.location='HistoricoEscolar_con.asp?txtMatricula=<%=strMatricula%>'" name="btnVoltar" value="<< Voltar " type="button" class="botao"></div>
		</form>
		<br>
		<%IF codHistoricoEscolar <> "" THEN  
			'historico disciplinas
			sql = "SELECT H.*, D.DESC_DISCIPLINA, P.DESCRICAO AS PERIODO, H.situacao AS SITPROMOCAO"
			sql = sql & " FROM SCA_HISTORICO_ESCOLAR E"
			sql = sql & " inner JOIN SCA_HISTORICO_ESCOLAR_DISCIPLINA H ON H.cod_historico_escolar = E.CODIGO"
			sql = sql & " inner JOIN SCA_PERIODO P ON P.COD_PERIODO = H.COD_PERIODO AND P.COD_EMPRESA = E.COD_EMPRESA"
			sql = sql & " inner JOIN SCA_DISCIPLINA D ON D.COD_DISCIPLINA = H.COD_DISCIPLINA AND D.COD_EMPRESA = E.COD_EMPRESA"
			sql = sql & " WHERE H.cod_historico_escolar  = " & codHistoricoEscolar
			sql = sql & " AND 	E.COD_EMPRESA  = " & Session("CodEmpresa") 
			sql = sql & " order by H.ano_letivo, H.semestre, P.DESCRICAO "
			rs.open sql, cnn
			if not rs.eof then	%>
			 <table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela" align="center">
			<tr bgcolor="#EEEEEE">
			  <td height="20" colspan="7" class="celula"><div align="center"><strong>Disciplinas do Historico </strong></div></td>
			  </tr>
			<tr bgcolor="#EEEEEE">
			  <td width="4%" class="celula">&nbsp;</td>
			  <td width="20%" class="celula">&nbsp;<strong>Disciplina</strong></td>
			  <td width="12%" class="celula">&nbsp;<strong>Per&iacute;odo</strong></td>
              <td width="12%" height="20" class="celula">&nbsp;<strong>Ano/Sem.</strong></td>
              <td width="7%" class="celula">&nbsp;<strong>C.H.</strong></td>
              <td width="13%" class="celula">&nbsp;<strong>M&eacute;dia</strong></td>
              <td width="32%" class="celula"><strong>&nbsp;Situa&ccedil;&atilde;o</strong></td>
            </tr>
			<%
				while not rs.eof 
				%>	  
				  <tr bgcolor="#FFFFFF"  style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"  >
				  <td class="celula"><a href="#" onClick="excluirDisciplina('<%=rs("CODIGO")%>')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image<%=rs("CODIGO")%>','','../../images/botao_vermelho_over.gif',1)"><img src="../../images/botao_vermelho_normal.gif" alt="Clique para excluir a disciplina do historico" name="Image1<%=rs("CODIGO")%>" width="26" height="26" border="0"></a></td>
				  <td class="celula" onClick="return resultadoConsultaDisciplina('<%=rs("cod_historico_escolar")%>','<%=rs("CODIGO")%>')">&nbsp;<%=rs("DESC_DISCIPLINA")%></td>
				  <td class="celula" onClick="return resultadoConsultaDisciplina('<%=rs("cod_historico_escolar")%>','<%=rs("CODIGO")%>')">&nbsp;<%=rs("PERIODO")%></td>
				  <%
				  if trim(rs("SEMESTRE")) = 3  then
				     %>
			  	     <td height="20" class="celula" onClick="return resultadoConsultaDisciplina('<%=rs("cod_historico_escolar")%>','<%=rs("CODIGO")%>')">&nbsp;&nbsp;&nbsp;&nbsp;<%=rs("ANO_LETIVO")%></td>
					 <%
				  else	 
				     %>
				     <td height="20" class="celula" onClick="return resultadoConsultaDisciplina('<%=rs("cod_historico_escolar")%>','<%=rs("CODIGO")%>')">&nbsp;<%=rs("ANO_LETIVO")%>/<%=rs("SEMESTRE")%></td>
				     <%
				  end if
				  %>	  
			  	  <td class="celula" onClick="return resultadoConsultaDisciplina('<%=rs("cod_historico_escolar")%>','<%=rs("CODIGO")%>')">&nbsp;<%=rs("CARGA_HORARIA")%></td>
				  <% 
				  if not isnull(rs("MEDIA")) then
				     %>	
			         <td class="celula" onClick="return resultadoConsultaDisciplina('<%=rs("cod_historico_escolar")%>','<%=rs("CODIGO")%>')">&nbsp;<%=round(rs("MEDIA"),1)%></td>
				     <%	 
		   	      else
				     %>	
			         <td class="celula" onClick="return resultadoConsultaDisciplina('<%=rs("cod_historico_escolar")%>','<%=rs("CODIGO")%>')">&nbsp;----</td>
				     <%	 
				  end if	
				  %>  
			      <td class="celula" onClick="return resultadoConsultaDisciplina('<%=rs("cod_historico_escolar")%>','<%=rs("CODIGO")%>')">&nbsp;<%=rs("SITPROMOCAO")%></td>
			  	  </tr>				
				  <%
				  rs.movenext
				wend
				%>
			  </table>
				<br>
                <br>
               <%
			end if
			rs.close
		END IF
			%>
		</td>
      </tr>
    </table>
	</td>
  </tr>
</table>
	<%	if trim(strExpandirHistorico) = "S" or trim(strExpandirHistorico) = "" then %>
		<script>
			mostraDadosHistorico.style.display="block";
		</script>
	<%	else	%>		
		<script>
			mostraDadosHistorico.style.display="none";
		</script>
	<%	end if	%>		
<!--#include file="../rodape.asp"-->
</body>
</html>