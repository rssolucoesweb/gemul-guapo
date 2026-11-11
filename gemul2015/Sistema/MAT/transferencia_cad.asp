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
	function blocTexto(valor, id)
	{
		quant = 500;
		total = valor.length;
		if(total <= quant)
		{
			resto = quant - total;
			document.getElementById('cont').innerHTML = resto;
		}
		else
		{
			document.getElementById('descricaoAcompanhamentoSocial').value = valor.substr(0,quant);
		}
	}
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
		if (frm.cmbCurso.value == "0") {
			alert("Selecione o curso para onde o aluno será transferido!");
			frm.cmbCurso.focus();
			return false;
		}		
		if (frm.cmbPeriodo.value == "0") {
			alert("Selecione o período para onde o aluno será transferido!");
			frm.cmbPeriodo.focus();
			return false;
		}		
		if (frm.cmbTurno.value == "0") {
			alert("Selecione o turno para onde o aluno será transferido!");
			frm.cmbTurno.focus();
			return false;
		}		
		if (frm.cmbEmpresa1opcao.value == "0") {
			alert("Selecione a unidade de 1ª opção para onde o aluno será transferido!");
			frm.cmbEmpresa1opcao.focus();
			return false;
		}		
		if (frm.cmbEmpresa2opcao.value!="0"){
			if (frm.cmbEmpresa1opcao.value == frm.cmbEmpresa2opcao.value) {
				alert("A unidade de 2ª opção para onde o aluno será transferido não poder igual a de 1ª opção!");
				frm.cmbEmpresa2opcao.focus();
				return false;
			}	
		}
		
		if (frm.cmbEmpresa3opcao.value!="0"){
			if (frm.cmbEmpresa1opcao.value == frm.cmbEmpresa3opcao.value) {
				alert("A unidade de 3ª opção para onde o aluno será transferido não poder igual a de 1ª opção!");
				frm.cmbEmpresa3opcao.focus();
				return false;
			}		
		}
		
		if (frm.cmbEmpresa2opcao.value!="0" && frm.cmbEmpresa3opcao.value!="0"){
			if (frm.cmbEmpresa2opcao.value == frm.cmbEmpresa3opcao.value) {
				alert("A unidade de 3ª opção para onde o aluno será transferido não poder igual a de 2ª opção!");
				frm.cmbEmpresa3opcao.focus();
				return false;
			}	
		}		
		
		if (frm.cmbEmpresa1opcao.value == <%=Session("CodEmpresa")%>) {
			alert("A unidade de 1ª opção para onde o aluno será transferido não poder igual a sua unidade de origem!");
			frm.cmbEmpresa1opcao.focus();
			return false;
		}
		if (frm.cmbEmpresa2opcao.value == <%=Session("CodEmpresa")%>) {
			alert("A unidade de 2ª opção para onde o aluno será transferido não poder igual a sua unidade de origem!");
			frm.cmbEmpresa1opcao.focus();
			return false;
		}
		if (frm.cmbEmpresa3opcao.value == <%=Session("CodEmpresa")%>) {
			alert("A unidade de 3ª opção para onde o aluno será transferido não poder igual a sua unidade de origem!");
			frm.cmbEmpresa1opcao.focus();
			return false;
		}
		
		frm.action="transferencia_cod.asp?acao=" + acao;
		frm.submit();
		return true;
	}
	
	
	function verificaOpcaoIrmaoEscola(){
		if (document.getElementById("irmaoNaEscola").checked){
			if (document.getElementById("quantidadeIrmao").value =="0"){
				document.getElementById("quantidadeIrmao").value = "";
			}
			
			$("#linhaQtdeIrmaoEscola").show();	
			$("#linhaQtdeIrmaoEscola1").show();	
			$(".linhaDadosIrmaoEscola").show();	
		}else{
			$("#linhaQtdeIrmaoEscola").hide();	
			$("#linhaQtdeIrmaoEscola1").hide();	
			$(".linhaDadosIrmaoEscola").hide();	
		}
	}
	
	function verificaAcompanhamentoSocial(){
		if (document.getElementById("acompanhamentoSocial").checked){
			document.getElementById("descricaoAcompanhamentoSocial").value = "";
			$("#linhaAcompanhamentoSocial").show();	
		}else{
			$("#linhaAcompanhamentoSocial").hide();	
		}
	}
	
</script>
<%
	strSituacao 		 = "A"
	strDesabilitaIncluir = "disabled" 'Desabilita o botão Incluir'
	strDesabilitaAlterar = "disabled" 'Habilita o botão Alterar
	strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir
	strDesabilitaLimpar  = "" 'Habilita o Botão Limpar'
	
	strExecutarSubmitCurso = "S"
	strExecutarSubmitPeriodo = "S"
	strExecutarSubmitTurno = "S"

	pagina	= "transferencia_cad.asp"
	strPaginaTitulo	= "transferencia_cad.asp"
	
	strCod_empresa 		= Session("CodEmpresa")
	intInscricao		= Trim(Request("txtInscricao"))
	cod_transferencia	= Trim(Request("cod_transferencia"))
	strCodAluno			= Trim(Request("txtCodAluno"))
	strMatricula 		= Trim(Request("txtMatricula"))
	strNomealuno 		= Trim(Request("txtNomealuno"))
	
	acompanhamentoSocial = Trim(Request.Form("acompanhamentoSocial"))
	descricaoAcompanhamentoSocial = Trim(Request.Form("descricaoAcompanhamentoSocial"))

	quantidadeIrmao = request.Form("quantidadeIrmao")
	if quantidadeIrmao = "" then quantidadeIrmao = "0"
	
	irmaoNaEscola = request.Form("irmaoNaEscola")
	
	intCodEmpresa1opcao = request.Form("cmbEmpresa1opcao")
	if intCodEmpresa1opcao = "" then intCodEmpresa1opcao = "0"
	intCodEmpresa2opcao = request.Form("cmbEmpresa2opcao")
	if intCodEmpresa2opcao = "" then intCodEmpresa2opcao = "0"
	intCodEmpresa3opcao = request.Form("cmbEmpresa3opcao")
	if intCodEmpresa3opcao = "" then intCodEmpresa3opcao = "0"
	
	strVerificaRegiao = "N"
	strMostraIntegral 	= "N"

	sql = "select parecer_integral, travar_regiao from MAT_configura_transferencia"
	rsAux.open sql, cnn
	if not rsAux.eof then
		strVerificaRegiao = rsAux("travar_regiao")
		strMostraIntegral = rsAux("parecer_integral")
	end if
	rsAux.close	
	strLinhaIrmao = ""
	if cod_transferencia <> "" then
	
		sql = "Select codigo" 
		sql = sql & " ,situacao"
		sql = sql & " ,matricula"
		sql = sql & " ,cod_aluno"
		sql = sql & " ,nome"
		sql = sql & " ,bairro"
		sql = sql & " ,curso"
		sql = sql & " ,periodo"
		sql = sql & " ,turno"
		sql = sql & " ,acompanhamento_social"
		sql = sql & " ,descricao_acompanhamento_social"
		sql = sql & " ,irmao_escola"
		sql = sql & " ,qtde_irmao_escola"
		sql = sql & " ,Cod_empresa_1opcao"
		sql = sql & " ,Cod_empresa_2opcao"
		sql = sql & " ,Cod_empresa_3opcao"
		sql = sql & " from mat_transferencia"
		sql = sql & " where cod_empresa = " & session("CodEmpresa")
		sql = sql & " and codigo = " & cod_transferencia
		rs.open sql, cnn
		if rs.eof = false then
			strSituacao 		= rs("situacao")
			strCodAluno			= Trim(rs("cod_aluno"))
			strMatricula 		= Trim(rs("Matricula"))
			strNomealuno 		= Trim(rs("nome"))

			strBairroAluno		  	= rs("bairro")
			
			strCursoAluno			= rs("curso")
			strPeriodoAluno			= rs("periodo")
			strTurnoAluno			= rs("turno")
			
			sql = "select a.bairroaluno, tu.desc_turno as turno, p.Descricao as periodo, c.Descricao as curso"
			sql = sql & " from sca_aluno a"
			sql = sql & " inner join sca_aluno_turma at on a.codigo = at.cod_aluno and at.situacao = 'A'"
			sql = sql & " inner join sca_turma t on t.cod_turma = at.cod_turma"
			sql = sql & " inner join sca_turno tu on tu.Cod_Turno = t.Cod_Turno"
			sql = sql & " inner join SCA_GRADECURRICULAR g on g.cod_gradecurricular = t.cod_gradecurricular"
			sql = sql & " inner join sca_periodo p on p.cod_periodo = g.cod_periodo"
			sql = sql & " inner join sca_curso c on c.cod_curso = p.cod_curso"
			sql = sql & " where a.codigo = " & strCodAluno	
			rsAux.open sql, cnn
			if not rsAux.eof then
				curso_atual			= rsAux("curso")
				serie_atual			= rsAux("periodo")
				turno_atual			= rsAux("turno")
			end if
			rsAux.close
			
			acompanhamentoSocial	= rs("acompanhamento_social")
			descricaoAcompanhamentoSocial= rs("descricao_acompanhamento_social")
			irmaoNaEscola			= rs("irmao_escola")
			quantidadeIrmao			= rs("qtde_irmao_escola")
			intCodEmpresa1opcao		= rs("Cod_empresa_1opcao")
			intCodEmpresa2opcao		= rs("Cod_empresa_2opcao")
			intCodEmpresa3opcao		= rs("Cod_empresa_3opcao")
			
			strDesabilitaIncluir = "disabled" 'Desabilita o botão Incluir'
			strDesabilitaAlterar = "" 'Habilita o botão Alterar
			strDesabilitaExcluir = "" 'Desabilita o botão Excluir
			strDesabilitaLimpar  = "" 'Habilita o Botão Limpar'
			
			strLinhaIrmao =  "style='display:none'"
			
			if trim(request.form("cmbCurso"))		<>"0" and trim(request.form("cmbCurso"))		<>"" then strCursoAluno 	= request.form("cmbCurso")
			if trim(request.form("cmbPeriodo"))		<>"0" and trim(request.form("cmbPeriodo"))		<>"" then strPeriodoAluno 	= request.form("cmbPeriodo")
			if trim(request.form("cmbTurno"))		<>"0" and trim(request.form("cmbTurno"))		<>"" then strTurnoAluno 	= request.form("cmbTurno")

			rs.close
		else
			rs.close
			%>
			<script>
				alert("transferencia não foi encontrada.");
				window.location='Transferencia_Acompanhamento_con.asp'
			</script>
			<%
			response.end
		end if
	end if
	'response.write "strCodAluno:"& strCodAluno
	if (strCodAluno <> "" or strMatricula <>"") and cod_transferencia = "" then
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
			strBairroAluno		  	= rsAux("bairroaluno")
			'strCursoAluno			= rsAux("curso")
			'strPeriodoAluno			= rsAux("periodo")
			'strTurnoAluno			= rsAux("turno")
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
		
		if trim(request.form("cmbCurso"))		<>"0" then strCursoAluno 	= request.form("cmbCurso")
		if trim(request.form("cmbPeriodo"))		<>"0" then strPeriodoAluno 	= request.form("cmbPeriodo")
		if trim(request.form("cmbTurno"))		<>"0" then strTurnoAluno 	= request.form("cmbTurno")
	end if
	
	marcaIrmaoEscola = ""
	mostraLinhaQtdeIrmao = "display:none"
	if trim(irmaoNaEscola) = "S" then 
		marcaIrmaoEscola = "checked"
		mostraLinhaQtdeIrmao = "display:table-row"
	end if
	
	mostraLinhaAcompanhamentoSocial = "display:none"
	if trim(acompanhamentoSocial) = "S" then 
		marcaAcompanhamentoSocial = "checked"
		mostraLinhaAcompanhamentoSocial = "display:table-row"
	end if
	
	
%>
<form method="post" id="frm" action="transferencia_cad.asp">
<input name="cod_transferencia" type="hidden" id="cod_transferencia" value="<%=cod_transferencia%>">
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
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
				  <td width="14%" height="26" class="texto1"><strong>Matr&iacute;cula: * </strong></td>
				  <td width="86%"><input name="txtCodAluno" type="hidden" id="txtCodAluno" class="text" size="10" value="<%=strCodAluno%>" maxlength="10">
					<input <%if cod_transferencia<>"" then response.write "readonly"%> name="txtMatricula" type="text" class="text" id="txtMatricula" size="20" maxlength="20" value="<%=strMatricula%>"  onKeyPress="return formataCampo(this, 2, 9)" onBlur="submit()">
					<%if cod_transferencia="" then%>
					<a  href="#" onClick="return abreConsulta('Aluno_con.asp')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image7','','<%=session("strCaminhoRaiz")%>/images/botao_verde_over.gif',1)"><img alt="Clique para consultar o aluno" src="<%=session("strCaminhoRaiz")%>/images/botao_verde_normal.gif" name="Image7" width="26" height="26" border="0"  align="absmiddle" ></a>&nbsp;
					<%end if%>
					<input readonly name="txtNomealuno" type="text" class="textDesabilita" id="txtNomealuno" size="50" maxlength="50" value="<%=strNomealuno%>" >
					</td>
				</tr>
				<tr>
				  <td height="26" class="texto1">Bairro do Aluno</td>
				  <td class="texto1"><strong><%=strBairroAluno%></strong>&nbsp;<input name="txtBairro" type="hidden" id="txtBairro" value="<%=strBairroAluno%>"></td>
			    </tr>
				<tr>
				  <td height="26" colspan="2" class="texto1"><strong>Dados Atuais do Aluno </strong></td>
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
				<tr>
				  <td height="26" colspan="2" class="texto1"><strong>Dados da Transfer&ecirc;ncia </strong></td>
			    </tr>
				<tr>
				  <td height="26" class="texto1">Curso: *</td>
				  <td><!--#include file="../includes/inc_cmdCursoTransferencia.asp"--></td>
			    </tr>
				<tr>
				  <td height="26" class="texto1">S&eacute;rie: *</td>
				  <td><!--#include file="../includes/inc_cmdPeriodoTransferencia.asp"--></td>
			    </tr>
				<tr>
				  <td height="26" class="texto1">Turno: *</td>
				  <td><!--#include file="../includes/inc_cmdTurnoTransferencia.asp"--></td>
			    </tr>
				<tr>
				  <td height="26" class="texto1">Acompanhamento social:</td>
				  <td class="texto1"><input type="checkbox" name="acompanhamentoSocial" id="acompanhamentoSocial" <%=marcaAcompanhamentoSocial%>  value="S" onClick="verificaAcompanhamentoSocial();"></td>
			    </tr>
				<tr id="linhaAcompanhamentoSocial" style="<%=mostraLinhaAcompanhamentoSocial%>">
				  <td height="26" class="texto1">Descreva *: </td>
				  <td class="texto1">
				  <textarea  onkeyup="blocTexto(this.value,'<%=cont%>')"  name="descricaoAcompanhamentoSocial" cols="55" rows="3" class="text" id="descricaoAcompanhamentoSocial"><%=descricaoAcompanhamentoSocial%></textarea>
				  <font color="#FF0000">(caracteres restantes: <span id="cont">500</span>)</font>
				  </td>
			    </tr>
				<tr <%=strLinhaIrmao%>>
				  <td height="26" class="texto1">Irm&atilde;o na mesma escola: </td>
				  <td class="texto1"><input type="checkbox" name="irmaoNaEscola" id="irmaoNaEscola" value="S" <%=marcaIrmaoEscola%> onClick="verificaOpcaoIrmaoEscola();"></td>
			    </tr>
				<tr id="linhaQtdeIrmaoEscola" style="<%=mostraLinhaQtdeIrmao%>" <%=strLinhaIrmao%>>
				  <td height="26" class="texto1">Quantidade de irmão *: </td>
				  <td class="texto1"><input type="text" name="quantidadeIrmao" id="quantidadeIrmao" class="text" value="<%=quantidadeIrmao%>" onBlur="submit()" size="2"></td>
			    </tr>
				<%if quantidadeIrmao > 0 then%>
				<tr id="linhaQtdeIrmaoEscola1">
				  <td height="26" colspan="2" class="texto1"><strong>Informe o dados dos irmãos </strong></td>
			    </tr>
				<%end if%>
				<%
				
				if cod_transferencia = "" then
					for i=1 to quantidadeIrmao
						intCodAlunoIrmao 		= request("txtCodAlunoIrmao"&i)				
						strMatriculaAlunoIrmao= request("txtMatriculaAlunoIrmao"&i)				
						strNomeAlunoIrmao 	= request("txtNomeAlunoIrmao"&i)				
						if intCodAlunoIrmao <> "" and cod_transferencia = "" then
							sql = "select a.bairroaluno, tu.desc_turno as turno, p.Descricao as periodo, c.Descricao as curso"
							sql = sql & " from sca_aluno a"
							sql = sql & " inner join sca_aluno_turma at on a.codigo = at.cod_aluno and at.situacao = 'A'"
							sql = sql & " inner join sca_turma t on t.cod_turma = at.cod_turma"
							sql = sql & " inner join sca_turno tu on tu.Cod_Turno = t.Cod_Turno"
							sql = sql & " inner join SCA_GRADECURRICULAR g on g.cod_gradecurricular = t.cod_gradecurricular"
							sql = sql & " inner join sca_periodo p on p.cod_periodo = g.cod_periodo"
							sql = sql & " inner join sca_curso c on c.cod_curso = p.cod_curso"
							sql = sql & " where a.codigo = " & intCodAlunoIrmao	
							rsAux.open sql, cnn
							if not rsAux.eof then
								strCursoAlunoIrmao			= rsAux("curso")
								strPeriodoAlunoIrmao		= rsAux("periodo")
								strTurnoAlunoIrmao			= rsAux("turno")
							end if
							rsAux.close

							if trim(request.form("txtCodAlunoIrmao"&i))			<>"" then intCodAlunoIrmao 		= request("txtCodAlunoIrmao"&i)
							if trim(request.form("txtMatriculaAlunoIrmao"&i))	<>"" then strMatriculaAlunoIrmao= request("txtMatriculaAlunoIrmao"&i)
							if trim(request.form("txtNomeAlunoIrmao"&i))		<>"" then strNomeAlunoIrmao 	= request("txtNomeAlunoIrmao"&i)
							
							if trim(request.form("cmbCursoIrmao"&i))		<>"0" then strCursoAlunoIrmao 	= request.form("cmbCursoIrmao"&i)
							if trim(request.form("cmbPeriodoIrmao"&i))		<>"0" then strPeriodoAlunoIrmao = request.form("cmbPeriodoIrmao"&i)
							if trim(request.form("cmbTurnoIrmao"&i))		<>"0" then strTurnoAlunoIrmao 	= request.form("cmbTurnoIrmao"&i)
							
						
						else
							strCursoAlunoIrmao			= "0"
							strPeriodoAlunoIrmao		= "0"
							strTurnoAlunoIrmao			= "0"
						end if
						%>
						<tr class="linhaDadosIrmaoEscola">
						  <td width="14%" height="26" class="texto1"><%=i%>º irmão matr&iacute;cula: *</td>
						  <td width="86%">
							<a href="#" onClick="return abreConsulta('AlunoIrmao_con.asp?posicao=<%=i%>')"><img alt="Clique para consultar o aluno" src="<%=session("strCaminhoRaiz")%>/images/botao_verde_normal.gif" name="Image7" width="26" height="26" border="0"  align="absmiddle" ></a>
							<input name="txtCodAlunoIrmao<%=i%>" type="hidden" id="txtCodAlunoIrmao<%=i%>" class="text" size="10" maxlength="10" value="<%=intCodAlunoIrmao%>">
							<input name="txtMatriculaAlunoIrmao<%=i%>" type="text" readonly class="textDesabilitaSemCaixa" id="txtMatriculaAlunoIrmao<%=i%>" size="15"  value="<%=strMatriculaAlunoIrmao%>">
							<input readonly name="txtNomeAlunoIrmao<%=i%>" type="text" class="textDesabilitaSemCaixa" id="txtNomeAlunoIrmao<%=i%>" size="50" maxlength="50" value="<%=strNomeAlunoIrmao%>"></td>
						</tr>
						<tr class="linhaDadosIrmaoEscola">
						  <td height="26" class="texto1">Curso <%=i%>º irmão: *</td>
						  <td><!--#include file="../includes/inc_cmdCursoTransferenciaIrmao.asp"--></td>
						</tr>
						<tr class="linhaDadosIrmaoEscola">
						  <td height="26" class="texto1">S&eacute;rie <%=i%>º irmão: *</td>
						  <td><!--#include file="../includes/inc_cmdPeriodoTransferenciaIrmao.asp"--></td>
						</tr>
						<tr class="linhaDadosIrmaoEscola">
						  <td height="26" class="texto1">Turno <%=i%>º irmão: *</td>
						  <td><!--#include file="../includes/inc_cmdTurnoTransferenciaIrmao.asp"--></td>
						</tr>
						<%
					next
				
				else
						i=1
						sql = "select cod_aluno, matricula, nome, curso, periodo, turno"
						sql = sql & " from mat_transferencia_irmao_escola"
						sql = sql & " where cod_transferencia = " & cod_transferencia
						rsAux.open sql, cnn
						if not rsAux.eof then
							while not rsAux.eof
								intCodAlunoIrmao 			= rsAux("cod_aluno")
								strMatriculaAlunoIrmao		= rsAux("matricula")
								strNomeAlunoIrmao 			= rsAux("nome")
								
								strCursoAlunoIrmao			= rsAux("curso")
								strPeriodoAlunoIrmao		= rsAux("periodo")
								strTurnoAlunoIrmao			= rsAux("turno")
								
								if trim(request.form("txtCodAlunoIrmao"&i))			<>"" then intCodAlunoIrmao 		= request("txtCodAlunoIrmao"&i)
								if trim(request.form("txtMatriculaAlunoIrmao"&i))	<>"" then strMatriculaAlunoIrmao= request("txtMatriculaAlunoIrmao"&i)
								if trim(request.form("txtNomeAlunoIrmao"&i))		<>"" then strNomeAlunoIrmao 	= request("txtNomeAlunoIrmao"&i)
								
								if trim(request.form("cmbCursoIrmao"&i))		<>"0" and trim(request.form("cmbCursoIrmao"&i))		<>"" then strCursoAlunoIrmao 	= request.form("cmbCursoIrmao"&i)
								if trim(request.form("cmbPeriodoIrmao"&i))		<>"0" and trim(request.form("cmbPeriodoIrmao"&i))	<>"" then strPeriodoAlunoIrmao = request.form("cmbPeriodoIrmao"&i)
								if trim(request.form("cmbTurnoIrmao"&i))		<>"0" and trim(request.form("cmbTurnoIrmao"&i))		<>"" then strTurnoAlunoIrmao 	= request.form("cmbTurnoIrmao"&i)
				
								%>
								<tr class="linhaDadosIrmaoEscola">
								  <td width="14%" height="26" class="texto1"><%=i%>º irmão matr&iacute;cula: *</td>
								  <td width="86%">
									<a href="#" onClick="return abreConsulta('AlunoIrmao_con.asp?posicao=<%=i%>')"><img alt="Clique para consultar o aluno" src="<%=session("strCaminhoRaiz")%>/images/botao_verde_normal.gif" name="Image7" width="26" height="26" border="0"  align="absmiddle" ></a>
									<input name="txtCodAlunoIrmao<%=i%>" type="hidden" id="txtCodAlunoIrmao<%=i%>" class="text" size="10" maxlength="10" value="<%=intCodAlunoIrmao%>">
									<input name="txtMatriculaAlunoIrmao<%=i%>" type="text" readonly class="textDesabilitaSemCaixa" id="txtMatriculaAlunoIrmao<%=i%>" size="15"  value="<%=strMatriculaAlunoIrmao%>">
									<input readonly name="txtNomeAlunoIrmao<%=i%>" type="text" class="textDesabilitaSemCaixa" id="txtNomeAlunoIrmao<%=i%>" size="50" maxlength="50" value="<%=strNomeAlunoIrmao%>"></td>
								</tr>
								<tr class="linhaDadosIrmaoEscola">
								  <td height="26" class="texto1">Curso <%=i%>º irmão: *</td>
								  <td><!--#include file="../includes/inc_cmdCursoTransferenciaIrmao.asp"--></td>
								</tr>
								<tr class="linhaDadosIrmaoEscola">
								  <td height="26" class="texto1">S&eacute;rie <%=i%>º irmão: *</td>
								  <td><!--#include file="../includes/inc_cmdPeriodoTransferenciaIrmao.asp"--></td>
								</tr>
								<tr class="linhaDadosIrmaoEscola">
								  <td height="26" class="texto1">Turno <%=i%>º irmão: *</td>
								  <td><!--#include file="../includes/inc_cmdTurnoTransferenciaIrmao.asp"--></td>
								</tr>
								<%
								i=i+1
								rsAux.movenext
							wend
						end if
						rsAux.close
					end if	
				
				%>
				<tr>
				  <td height="26" colspan="2" class="texto1"><strong>Informe as opções de unidade para transferência</strong></td>
			    </tr>
				<tr>
				  <td height="26" class="texto1">Unidade 1&ordf; op&ccedil;&atilde;o: *</td>
				  <td><!--#include file="../includes/inc_cmbEmpresa1opcao.asp"--></td>
			    </tr>
				<tr>
				  <td height="26" class="texto1">Unidade 2&ordf; op&ccedil;&atilde;o:</td>
				  <td><!--#include file="../includes/inc_cmbEmpresa2opcao.asp"--></td>
			    </tr>
				<tr>
				  <td height="26" class="texto1">Unidade 3&ordf; op&ccedil;&atilde;o:</td>
				  <td><!--#include file="../includes/inc_cmbEmpresa3opcao.asp"--></td>
			    </tr>
				<tr>
				  <td height="26" class="texto1" colspan="2"><strong>* Obrigatório o preenchimento</strong>&nbsp;</td>
			    </tr>
				<%
				if strSituacao = "A" then
				%>
				<tr>
				  <td height="26" colspan="2" class="texto1"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
			    </tr>   
				<%
				end if
				 
				if strSituacao = "F" then
				
					sql = "select t.matricula, t.nome, t.matricula_transferencia, e.razaosocial as unidade, t.turno_transferencia, t.periodo_transferencia, t.data_situacao, '' as irmao"
					sql = sql & " from mat_transferencia t"
					sql = sql & " inner join seg_empresa e on e.codigo = t.cod_empresa_transferencia"
					sql = sql & " where t.codigo = " & cod_transferencia
					sql = sql & " union"
					sql = sql & " select i.matricula, i.nome, i.matricula_transferencia, e.razaosocial as unidade, i.turno_transferencia, i.periodo_transferencia, t.data_situacao, 'S' as irmao "
					sql = sql & " from mat_transferencia_irmao_escola i"
					sql = sql & " inner join mat_transferencia t on t.codigo = i.cod_transferencia"
					sql = sql & " inner join seg_empresa e on e.codigo = i.cod_empresa_transferencia"
					sql = sql & " where i.cod_transferencia = " & cod_transferencia
					sql = sql & " order by irmao"
					rs.open sql, cnn
					if not rs.eof then
						%>
						<tr  bgcolor="#A9F5D0">
						  <td height="26" colspan="2" class="texto1"><strong>Dados da TRANSFERÊNCIA CONCLUIDA</strong></td>
						</tr>
						<%
						while not rs.eof
							irmao = "Aluno"
							if rs("irmao") = "S" then
								irmao = "Irmão"
							end if
							
							%>
							<tr>
							  <td height="26" class="texto1"><%=irmao%>:</td>
							  <td class="texto1"><font color="#088A29"><strong><%=rs("matricula_transferencia")%> - <%=rs("nome")%><%=irmao%></strong></font></td>
							</tr>
							<tr>
							  <td height="26" class="texto1">Unidade transferido:</td>
							  <td class="texto1"><font color="#088A29"><strong><%=rs("unidade")%></strong></font></td>
							</tr>
							<tr>
							  <td height="26" class="texto1">Período transferido:</td>
							  <td class="texto1"><font color="#088A29"><strong><%=rs("periodo_transferencia")%></strong></font></td>
							</tr>
							<tr>
							  <td height="26" class="texto1">Turno transferido:</td>
							  <td class="texto1"><font color="#088A29"><strong><%=rs("turno_transferencia")%></strong></font></td>
							</tr>
							<tr>
							  <td height="26" class="texto1" colspan="2"><hr></td>
							</tr>
							<%
							rs.movenext
						wend
					end if
					rs.close
				end if
				%>
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