<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 21/01/2020
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: transferencia
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

	function excluirTip(codigo, nome){
		var frm = document.getElementById("frm");
		if (!confirm("ATENÇÃO: a TIP de " + nome + " será EXCLUÍDA.\n\nO aluno sai da turma de destino e volta a ficar ativo na turma de origem.\nSó é possível se ainda não houver notas, faltas ou avaliações lançadas na turma de destino.\n\nDeseja continuar?"))
			return false;
		frm.txtCodTip.value = codigo;
		frm.action = "tip_cod.asp?acao=E";
		frm.submit();
		return true;
	}

	//Comprovante da TIP em janela de impressão
	function imprimirTip(codigo){
		var janela = window.open("tip_rel.asp?txtCodTip=" + codigo, "comprovanteTip", "width=950,height=750,scrollbars=yes,resizable=yes");
		if (janela) janela.focus();
		return false;
	}

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
<!--#include file="../../js/Calendario/Calendario.asp"-->
<script>
	
	function salvar(acao){
		
		var frm = document.getElementById("frm");

		if (frm.txtMatricula.value == "") {
			alert("A Matricula do Aluno deve ser informada !");
			frm.txtMatricula.focus();
			return false;
		}
		if (frm.txtNomealuno.value == "") {
			alert("Aluno deve ser informado!");
			frm.txtMatricula.focus();
			return false;
		}
		if (frm.cmbCursoTip.value == "0") {
			alert("Selecione o curso!");
			frm.cmbCursoTip.focus();
			return false;
		}		
		if (frm.cmbPeriodoTip.value == "0") {
			alert("Selecione o período!");
			frm.cmbPeriodoTip.focus();
			return false;
		}		
		if (frm.cmbTurnoTip.value == "0") {
			alert("Selecione o turno!");
			frm.cmbTurnoTip.focus();
			return false;
		}		
		if (frm.cmbEmpresaTip.value == "0") {
			alert("Selecione a unidade!");
			frm.cmbEmpresaTip.focus();
			return false;
		}		
		if (frm.cmbTurmaTip.value == "0") {
			alert("Selecione a turma!");
			frm.cmbTurmaTip.focus();
			return false;
		}		
		
		frm.action="tip_cod.asp?acao=" + acao;
		frm.submit();
		return true;
	}
	
</script>
<%
	strDesabilitaIncluir = "disabled" 'Desabilita o botão Incluir'
	strDesabilitaAlterar = "disabled" 'Habilita o botão Alterar
	strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir
	strDesabilitaLimpar  = "" 'Habilita o Botão Limpar'
	strEmpresa_submit = "S"
	strExecutarSubmitCurso = "S"
	strExecutarSubmitPeriodo = "S"
	strExecutarSubmitTurno = "S"

	pagina	= "tip_cad.asp"
	strPaginaTitulo	= "tip_cad.asp"	
	strAnoLetivoDestino = session("strAnoLetivo") + 1

	strCod_empresa 		= Session("CodEmpresa")
	strCodAluno			= Trim(Request("txtCodAluno"))
	strMatricula 		= Trim(Request("txtMatricula"))
	strNomealuno 		= Trim(Request("txtNomealuno"))
	intCodCursoTip 	= request.form("cmbCursoTip")
	intCodPeriodoTip 	= request.form("cmbPeriodoTip")
	intCodTurnoTip 	= request.form("cmbTurnoTip")
	intCodEmpresaTip = request.Form("cmbEmpresaTip")
	if intCodEmpresaTip = "" then intCodEmpresaTip = "0"
	intCodTurmaTip = request.Form("cmbTurmaTip")
	if intCodTurmaTip = "" then intCodTurmaTip = "0"
	tip_existe = "N"
	dados = "Dados Atuais do Aluno"
	if strMatricula <> "" then
	
		sql = "select t.codigo, e.RAZAOSOCIAL, tu.NomeTurma, t.cod_aluno, a.matricula, a.nomealuno, tu.TurmaAluno, pe.Descricao as periodo, cu.Descricao as curso, tur.Desc_Turno as turno"
		sql = sql & " from SCA_TRANSFERENCIA_INTERESSE_PROPRIO t"
		sql = sql & " inner join SCA_ALUNO a on a.codigo = t.COD_ALUNO"
		sql = sql & " inner join SEG_EMPRESA e on e.codigo = t.COD_EMPRESA_DESTINO"
		sql = sql & " inner join SCA_TURMA tu on tu.cod_turma = t.COD_TURMA_DESTINO"
		sql = sql & " inner join SCA_PERIODO pe on pe.Cod_Periodo = tu.Cod_periodo"
		sql = sql & " inner join SCA_curso cu on cu.Cod_curso = pe.Cod_Curso"
		sql = sql & " inner join SCA_turno tur on tur.Cod_Turno = t.COD_TURNO_DESTINO"
		sql = sql & " where a.Matricula = '" & strMatricula & "'"
		
		rs.open sql, cnn
		if rs.eof = false then
			%>
			<script>
				alert("Já existe uma TIP para esse aluno.");
			</script>
			<%
			tip_existe = "S"
			
			intCodTip			= Trim(rs("codigo"))
			strCodAluno			= Trim(rs("cod_aluno"))
			strMatricula 		= Trim(rs("Matricula"))
			strNomealuno 		= Trim(rs("nomealuno"))
			
			escola_tip 		= Trim(rs("RAZAOSOCIAL"))
			turma_tip 		= Trim(rs("periodo")) & " " & Trim(rs("TurmaAluno")) & " - " & Trim(rs("NomeTurma"))
			
			curso_atual			= rs("curso")
			serie_atual			= rs("periodo")
			turno_atual			= rs("turno")
			dados = "Dados da TIP do Aluno para " & strAnoLetivoDestino
		end if
		rs.close
	end if
	
	if (strCodAluno <> "" or strMatricula <>"") and tip_existe = "N" then
		sql = "select a.bairroaluno, tu.desc_turno as turno, p.Descricao as periodo, c.Descricao as curso, a.codigo as cod_aluno, a.matricula, a.nomealuno"
		sql = sql & " from sca_aluno a"
		sql = sql & " inner join sca_aluno_turma at on a.codigo = at.cod_aluno and at.situacao = 'A'"
		sql = sql & " inner join sca_turma t on t.cod_turma = at.cod_turma"
		sql = sql & " inner join sca_turno tu on tu.Cod_Turno = t.Cod_Turno"
		sql = sql & " inner join SCA_GRADECURRICULAR g on g.cod_gradecurricular = t.cod_gradecurricular"
		sql = sql & " inner join sca_periodo p on p.cod_periodo = g.cod_periodo"
		sql = sql & " inner join sca_curso c on c.cod_curso = p.cod_curso"
		if strCodAluno<>"" then
			sql = sql & " where a.codigo = " & strCodAluno	
		elseif strMatricula<>"" then
			sql = sql & " where a.matricula = '" & strMatricula & "'"
		end if
		'response.write sql
		rsAux.open sql, cnn
		if not rsAux.eof then
			strCodAluno			= Trim(rsAux("cod_aluno"))
			strMatricula 		= Trim(rsAux("Matricula"))
			strNomealuno 		= Trim(rsAux("nomealuno"))
			
			curso_atual			= rsAux("curso")
			serie_atual			= rsAux("periodo")
			turno_atual			= rsAux("turno")
			
			strDesabilitaIncluir = "" 'Desabilita o botão Incluir'
			strDesabilitaAlterar = "disabled" 'Habilita o botão Alterar
			strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir
			strDesabilitaLimpar  = "" 'Habilita o Botão Limpar'
		end if
		rsAux.close
		
		'verifica se o aluno esta ativo
		sql = "SELECT "
		sql = sql & "     SA.DESC_SITUACAOALUNO"
		sql = sql & " FROM SCA_ALUNO A"
		sql = sql & " OUTER APPLY ("
		sql = sql & "     SELECT TOP 1"
		sql = sql & "         C.COD_EMPRESA,"
		sql = sql & "         C.COD_SITUACAOALUNO,"
		sql = sql & "         E.RAZAOSOCIAL AS UNIDADE, C.ANO_LETIVO"
		sql = sql & "     FROM SCA_CONTROLE_SITUACAO_ALUNO C"
		sql = sql & "     INNER JOIN SEG_EMPRESA E ON E.CODIGO = C.COD_EMPRESA"
		sql = sql & "     WHERE "
		sql = sql & "         C.COD_ALUNO = A.CODIGO"
		sql = sql & "         AND C.ANO_LETIVO <= " & trim(session("strAnoLetivo"))
		sql = sql & "         AND C.COD_EMPRESA = " & trim(Session("CodEmpresa"))
		sql = sql & "     ORDER BY C.CODIGO DESC"
		sql = sql & " ) CC"
		sql = sql & " left JOIN SCA_SITUACAOALUNO SA "
		sql = sql & "     ON SA.Cod_SituacaoAluno = CC.COD_SITUACAOALUNO"
		sql = sql & " where 1=1"
		sql = sql & "         AND CC.COD_EMPRESA = " & trim(Session("CodEmpresa"))
		sql = sql & " and A.MATRICULA = '" & strMatricula & "'"
		rsAux.open sql, cnn
		if not rsAux.eof then
			DESC_SITUACAOALUNO			= Trim(rsAux("DESC_SITUACAOALUNO"))
		end if
		rsAux.close
		
		if DESC_SITUACAOALUNO<>"ATIVO" then
			%>
			<script>
				alert("Para fazer a TIP o aluno deve estar com situação ATIVO!");
			</script>
			<%
			'retira_tela = "S"
			'
			'strDesabilitaIncluir = "disabled" 'Desabilita o botão Incluir'
			'strDesabilitaAlterar = "disabled" 'Habilita o botão Alterar
			'strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir
			'strDesabilitaLimpar  = "" 'Habilita o Botão Limpar'
		end if
		
		if trim(request.form("cmbCursoTip"))		<>"0" then intCodCursoTip 	= request.form("cmbCursoTip")
		if trim(request.form("cmbPeriodoTip"))		<>"0" then intCodPeriodoTip 	= request.form("cmbPeriodoTip")
		if trim(request.form("cmbTurnoTip"))		<>"0" then intCodTurnoTip 	= request.form("cmbTurnoTip")
	end if
	
	
%>
<form method="post" id="frm" action="tip_cad.asp">
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
<input name="txtAnoLetivoDestino" type="hidden" id="txtAnoLetivoDestino" value="<%=strAnoLetivoDestino%>">
<input name="txtCodTip" type="hidden" id="txtCodTip" value="<%=intCodTip%>">


        <tr valign="top">
           <td width="100%" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
        </tr>
		<tr valign="top">
		  <td align="center" valign="top">
		  
			  <table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
				<tr>
				  <td height="26" class="texto1">&nbsp;</td>
				  <td>&nbsp;</td>
			    </tr>
				<tr>
				  <td width="20%" height="26" class="texto1"><strong>Matr&iacute;cula: * </strong></td>
				  <td width="80%"><input name="txtCodAluno" type="hidden" id="txtCodAluno" class="text" size="10" value="<%=strCodAluno%>" maxlength="10">
					<input <%if cod_transferencia<>"" then response.write "readonly"%> name="txtMatricula" type="text" class="text" id="txtMatricula" size="20" maxlength="20" value="<%=strMatricula%>"  onKeyPress="return formataCampo(this, 2, 9)" onBlur="submit()">
					<%if cod_transferencia="" then%>
					<a  href="#" onClick="return abreConsulta('Aluno_con.asp')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image7','','<%=session("strCaminhoRaiz")%>/images/botao_verde_over.gif',1)"><img alt="Clique para consultar o aluno" src="<%=session("strCaminhoRaiz")%>/images/botao_verde_normal.gif" name="Image7" width="26" height="26" border="0"  align="absmiddle" ></a>&nbsp;
					<%end if%>
					<input readonly name="txtNomealuno" type="text" class="textDesabilita" id="txtNomealuno" size="50" maxlength="50" value="<%=strNomealuno%>" >
					</td>
				</tr>
				<%if retira_tela = "" then%>
				<tr>
				  <td height="26" colspan="2" class="texto1"><strong><%=dados%> </strong></td>
			    </tr>
				<tr>
				  <td height="26" class="texto1">Curso: </td>
				  <td class="texto1"><%=curso_atual%></td>
			    </tr>
				<tr>
				  <td height="26" class="texto1">S&eacute;rie:</td>
				  <td class="texto1"><%=serie_atual%></td>
			    </tr>
				<tr>
				  <td height="26" class="texto1">Turno: </td>
				  <td class="texto1"><%=turno_atual%></td>
			    </tr>
				<%if tip_existe = "S" then%>
				<tr>
				  <td height="26" class="texto1">Escola: </td>
				  <td class="texto1"><%=escola_tip%></td>
			    </tr>
				<tr>
				  <td height="26" class="texto1">Curso: </td>
				  <td class="texto1"><%=curso_atual%></td>
			    </tr>
				<tr>
				  <td height="26" class="texto1">Turma: </td>
				  <td class="texto1"><%=turma_tip%></td>
			    </tr>
				<%end if%>
				<%if tip_existe = "N" then%>
				<tr>
				  <td height="26" colspan="2" class="texto1"><strong>Dados da TIP para <%=strAnoLetivoDestino%> </strong></td>
			    </tr>
				<tr>
				  <td height="26" class="texto1">Curso: *</td>
				  <td><!--#include file="../includes/inc_cmdCursoTip.asp"--></td>
			    </tr>
				<tr>
				  <td height="26" class="texto1">S&eacute;rie: *</td>
				  <td><!--#include file="../includes/inc_cmdPeriodoTip.asp"--></td>
			    </tr>
				<tr>
				  <td height="26" class="texto1">Turno: *</td>
				  <td><!--#include file="../includes/inc_cmdTurnoTip.asp"--></td>
			    </tr>
				<tr>
				  <td height="26" class="texto1">Unidade Escolar: *</td>
				  <td><!--#include file="../includes/inc_cmdEmpresaTip.asp"--></td>
			    </tr>
				<tr>
				  <td height="26" class="texto1">Turma com vaga disponível para 2027 *:</td>
				  <td><!--#include file="../includes/inc_cmdTurmaTip.asp"--></td>
			    </tr>
				<tr>
				  <td height="26" class="texto1" colspan="2"><strong>* Obrigatório o preenchimento</strong>&nbsp;</td>
			    </tr>
				<%end if%>
				<%if tip_existe = "S" then%>
				<tr>
					<td height="26" class="texto1" colspan="2">
					<input type="button" name="cmdCancelar" style="cursor:hand"   value="Imprimir Comprovante" class="botao" onClick="imprimirTip('<%=intCodTip%>')"> 
					<input type="button" name="cmdCancelar" style="cursor:hand"   value="Cancelar TIP (defazer)" class="botao" <%=strDesabilitaCancelar%> onClick="excluirTip('<%=intCodTip%>', '<%=replace(replace(strNomeAluno & "", "\", ""), "'", "\'")%>')"> 
					</td>
			    </tr>
				<%end if%>
				<%end if%>
				<tr>
				  <td height="26" colspan="2" class="texto1"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
			    </tr>   
			  </table>
			<br>
			<br>
  		  </td>
		</tr>
  </table>
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>