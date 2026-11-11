<html>
<head>
<title><%=session("Titulo")%></title>
<link type="text/css" rel="stylesheet" href="../../Estilo/css.css">
<script>
	function carregaPeriodo(intCurso, posicao){
		
		if( intCurso != "0" ) {
			$('#cmbPeriodo'+posicao).html('<option value="0">Carregando...</option>');

			$.getJSON('../json/carregar.asp?tipoAcao=CARREGA_PERIODO',{intCodCurso: intCurso, ajax: 'true'}, function(j){
				var options = '<option value="0">Selecione...</option>';		
				for (var i = 0; i < j.length; i++) {
					options += '<option value="' + j[i].codigo + '">' + j[i].nome + '</option>';
				}	
				$('#cmbPeriodo'+posicao).html(options);
			});
			
		} else {
			$('#cmbPeriodo'+posicao).html('<option value="0">Selecione...</option>');
		}
	}
	function carregaTurma(posicao){
		
		var intPeriodo = $('#cmbPeriodo'+posicao).val();
		var intTurno = $('#cmbTurno'+posicao).val();
		
		var AnoLetivo = $('#txtAnoLetivoRenovacao').val();
		
		if( intPeriodo != "0" || intTurno != "0") {
			$('#cmbTurma'+posicao).html('<option value="0">Carregando...</option>');

			$.getJSON('../json/carregar.asp?tipoAcao=CARREGA_TURMA',{intCodPeriodo: intPeriodo, intCodTurno: intTurno, AnoLetivoAtual: AnoLetivo, ajax: 'true'}, function(j){
				var options = '<option value="0">Selecione...</option>';		
				for (var i = 0; i < j.length; i++) {
					options += '<option value="' + j[i].codigo + '">' + j[i].nome + '</option>';
				}	
				$('#cmbTurma'+posicao).html(options);
			});
			
		} else {
			$('#cmbTurma'+posicao).html('<option value="0">Selecione...</option>');
		}
	}
	
	function mostraVagas(codTurma, posicao){
		
		if( codTurma != "0" ) {
			$('#txtVagas'+posicao).val("");

			$.getJSON('../json/carregar.asp?tipoAcao=MOSTRA_VAGAS',{intCodTurma: codTurma, ajax: 'true'}, function(j){
				$('#txtVagas'+posicao).val(j[0].nome);
			});
			
		} else {
			$('#txtVagas'+posicao).val("");
		}
	}
	
	function emitirComprovante(codigo, AnoLetivo, semestre){
	
		if (AnoLetivo==""){
			alert("Ano letivo deve ser informado!");
			return false
		}
		window.open("renovacaoAluno_rel.asp?chkAluno=" + codigo + "&txtAnoLetivo=" + AnoLetivo + "&cmbSemestre=" + semestre,"Comprovantes","top=0,left=0,height=543,width=793,menubar=no,toolbar=no,scrollbars=yes,status=yes");
 	}
	function cancelarComprovante(codigo,codTurmaRenovacao){
		if (confirm("Você realmente deseja cancelar a renovação da matrícula desse aluno?")) { 
			frm.action="renovacaoAluno_cod.asp?acao=C&codAluno="+codigo+"&codTurmaRenovacao="+codTurmaRenovacao;
			frm.submit();
			return true;
		}
 	}
	function marcaTodos(valor){
		
		var frm = document.getElementById("frm");
		var form = window.document.forms[0];
		var i;
		for (var i = 0; i < form.elements.length; i++) {
			//verifica todos os checkbox
			if (form.elements[i].type == "checkbox"){
				//verifica se o checkbox está marcado
				if (form.elements[i].disabled == false){
				form.elements[i].checked=valor;
				}

			}
		}
	}
	
	function salvar(acao){
		var selecionado = "N"
		var escolheu_turma = "N"
		var cod_aluno = "0";
		var frm = document.getElementById("frm");
		
		var acesso_liberado = document.getElementById("acesso_liberado").value;
		
		var form = window.document.forms[0];
		var i;
		for (var i = 0; i < form.elements.length; i++) {
			//verifica todos os checkbox
			if (form.elements[i].type == "checkbox"){
				//verifica se o checkbox está marcado
				if (form.elements[i].disabled == false){
					if (form.elements[i].checked==true){
						if (form.elements[i].name != "chkTodos"){
							selecionado = "S"
							cod_aluno = form.elements[i].value
							if (document.getElementById("cmbTurma" + cod_aluno).value == "0") {
								alert("A turma do aluno deve ser selecionada!");
								document.getElementById("cmbTurma" + cod_aluno).focus();
								return false
							}
							if (acesso_liberado=='N'){
								if (document.getElementById("txtVagas" + cod_aluno).value == "0" || document.getElementById("txtVagas" + cod_aluno).value <= 0) {
									alert("A turma que foi selecionada, não existe mais vagas, selecione outra turma!");
									document.getElementById("cmbTurma" + cod_aluno).value="0";
									document.getElementById("cmbTurma" + cod_aluno).focus();
									return false
								}
							}
						}
					}
				}

			}
		}
		
		
		
		if (selecionado == "N"){
			alert("Selecione o(s) aluno(s) para confirmação!")		
			return false
		}
		
		frm.action="renovacaoAluno_cod.asp";
		frm.submit();
		return true;
 	}

</script>

<style>
.textVagas {
    /* background: #E8E8E8; */
    /* border-top: #999; */
    /* border-right: #999; */
    /* border-left: #999; */
    /* border-bottom: #999; */
    border: 1px
	solid #fff;
    font-family: Verdana;
    font-size: 11px;
    color: #000000;
</style>

</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >
<script src="../../js/js_funcoes_gerais.js"></script>
<script type="text/javascript" src="../json/jquery-2.0.3.min.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->

<%
	strPaginaTitulo = "renovacaoAluno_cad.asp"

	strExecutarSubmitSemestre 		= "S"
	strExecutarSubmitCurso	  		= "S"
	strExecutarSubmitPeriodo  		= "S"
	strExecutarSubmitTurno	 		= "S"
	strExecutarSubmitTurma	 		= "S"	

	intSemestre 			= Trim(Request("cmbSemestre"))
	strSemestre 			= Trim(Request("cmbSemestre"))
	
	ano_matricula = year(date)+1
	
	acesso_liberado="N"
	sql = "SELECT id"
	sql = sql & " FROM SEG_USUARIOS_INCLUI_CADASTRO "
	sql = sql & " where CODIGO_SEG_USUARIOS_SISTEMA='" & session("usuarioWeb") & "'"
	rs.open sql, cnn
	if rs.eof = false then
		acesso_liberado = "S"
	end if 
	rs.close
	
	if trim(request("txtAnoLetivo")) = "" then 
		strAnoLetivo = ano_matricula-1
	else
		strAnoLetivo = request("txtAnoLetivo")
	end if
	strAnoLetivoRenovacao = request("txtAnoLetivoRenovacao")
	if strAnoLetivoRenovacao = "" then strAnoLetivoRenovacao = ano_matricula

	intCodTurma 			= Trim(Request("cmbTurma"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intCodTurno		 		= Trim(Request.Form("cmbTurno"))
	intCodSituacaoAluno		 		= Trim(Request.Form("cmbSituacaoAluno"))
	
	strFiltroSerie 			= "0"
	strFiltroTurno 			= "0"

	if intCodCurso 		= "" then intCodCurso 		= "0"
	if intCodSerie 		= "" then intCodSerie 		= "0"
	if intCodTurno 		= "" then intCodTurno 		= "0"
	if intCodTurma 		= "" then intCodTurma 		= "0"
	if intCodSituacaoAluno 		= "" then intCodSituacaoAluno 		= "0"

	strMostraAlunos = ""
	if 	intCodCurso <> "0" then strMostraAlunos = "S"
	if 	intCodSerie <> "0" then strMostraAlunos = "S"
	if 	intCodTurno <> "0" then strMostraAlunos = "S"
	if 	intCodTurma <> "0" then strMostraAlunos = "S"
	
	if intCodCursoRenovacao = "" then intCodCursoRenovacao = "0"
	if intCodPeriodoRenovacao = "" then intCodPeriodoRenovacao = "0"
	if intCodTurnoRenovacao = "" then intCodTurnoRenovacao = "0"
	
	strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
	strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
	strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	strbotaoAtualizar		= "S"

%>
<form method="post" id="frm" action="renovacaoAluno_cad.asp">
<input name="acesso_liberado" 			type="hidden" id="acesso_liberado" 			value="<%=acesso_liberado%>">
<table width="100% border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
            <tr valign="top">
              <td  align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
		<tr valign="top">
		  <td>
  <table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
    <tr>
      <td class="texto1">&nbsp;</td>
      <td colspan="2">&nbsp;</td>
    </tr>
    <tr>
      <td class="texto1">Ano:</td>
      <td class="texto1" colspan="2"><input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
    </tr>
    <tr>
      <td class="texto1">Semestre:</td>
      <td colspan="2"><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
    </tr>
    <tr> 
      <td width="14%" class="texto1">Turma:</td>
      <td width="86%" colspan="2"><!--#include file="../includes/inc_cmdTurma.asp"--></td>
    </tr>
	<tr>
      <td class="texto1">Ano Renovação:</td>
      <td class="texto1" colspan="2"><input  name="txtAnoLetivoRenovacao" type="text" class="text" id="txtAnoLetivoRenovacao" onBlur="submit()"  value="<%=strAnoLetivoRenovacao%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
    </tr>
	<tr>
      <td class="texto1">Situação:</td>
      <td class="texto1" colspan="2"><%strExecutarSubmit="S"%><!--#include file="../includes/inc_cmdSituacaoAluno.asp"--></td>
    </tr>
    <tr> 
      <td class="texto1">&nbsp;</td>
      <td colspan="2">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="3"><hr size="1" color="#CCCCCC"></td>
    </tr>
    <tr> 
      <td colspan="3"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
    </tr>
    <tr> 
      <td colspan="3" class="texto1"> <br> 
	  <%
			if strMostraAlunos = "S" OR strMatricula <> "" then%> 
			
			<table class="tabela" width="98%" align="center" border="1" cellpadding="0" cellspacing="0">
			<tr  bgcolor="#EEEEEE">
				<td colspan="5" class="celula" align="center"><strong>Dados Atuais <%=strAnoLetivo%></strong></td>
				<td colspan="8" class="celula" align="center"><strong>Dados da Confirmação para <%=strAnoLetivoRenovacao%></strong></td>
			</tr>
          <tr class="CabecalhoConsulta" > 
            <td width="2%" align="center" class="celula" >
				<input type="checkbox" name="chkTodos" onClick="return marcaTodos(this.checked)">
			</td>
            <td width="40" class="celula"><strong>Ord.</strong></td>
            <td width="127" class="celula"><strong>Matr&iacute;cula</strong></td>
            <td width="500" class="celula"><strong>Nome</strong></td>
            <td width="125" class="celula"><strong>Turma </strong></td>
            <td width="120" class="celula" align="center" ><strong>Confirmado</strong></td>
			<td width="120" class="celula" align="center" ><strong>Curso</strong></td>
			<td width="40" class="celula" align="center" ><strong>Período</strong></td>
			<td width="60" class="celula" align="center" ><strong>Turno</strong></td>
			<td width="120" class="celula" align="center" ><strong>Turma <%=strAnoLetivoRenovacao%></strong></td>
			<td width="20" class="celula" align="center" ><strong>Vagas</strong></td>
			<td width="131" class="celula" align="center" ><strong>Ficha</strong></td>
          </tr>
          <%	
		  	cont = 0	
			intCodPeriodo = ""
			'seleciona os alunos da turma'					
			sql = "SELECT 'R' as tipo, SCA_ALUNO_TURMA.CODIGO AS CODALUNOTURMA,SCA_TURMA.cod_turno, SCA_TURMA.COD_PERIODO, SCA_PERIODO.COD_CURSO, SCA_ALUNO.CODIGO, SCA_ALUNO.DATANASCIMENTO, SCA_ALUNO.MATRICULA, SCA_ALUNO.NOMEALUNO, SCA_ALUNO_TURMA.SEQUENCIA, SCA_ALUNO_TURMA.COD_TURMA, SCA_GRADECURRICULAR.Cod_Periodo, SCA_TURMA.NomeTurma,SCA_TURMA.TURMAALUNO, SCA_SITUACAOALUNO.Desc_SituacaoAluno, SCA_ALUNO.PERC_DESCONTO, SCA_ALUNO.PERC_DESCONTO2, SCA_ALUNO.PERC_DESCONTO3, SCA_ALUNO.PERC_DESCONTO4, SCA_TURMA.Cod_FichaDescritiva, SCA_PERIODO.sequencia "
			sql = sql & " FROM SCA_ALUNO_TURMA "
			sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO  "
			sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma "
			sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.COD_PERIODO = SCA_TURMA.Cod_PERIODO "
			sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
			sql = sql & " LEFT JOIN SCA_SITUACAOALUNO ON SCA_SITUACAOALUNO.Cod_SituacaoAluno = SCA_ALUNO.COD_SITUACAOALUNO "
			sql = sql & " WHERE SCA_ALUNO_TURMA.cod_empresa = " & Session("CodEmpresa") 
			sql = sql & "     AND SCA_ALUNO_TURMA.COD_TURMA = " & intCodTurma  
			sql = sql & "     AND SCA_ALUNO_TURMA.situacao = 'A'"
			if intCodSituacaoAluno<>"0" then
				sql = sql & " and SCA_SITUACAOALUNO.cod_SituacaoAluno = " & intCodSituacaoAluno
			end if						
			sql = sql & "     AND NOT EXISTS ("
			sql = sql & "         SELECT 1"
			sql = sql & "         FROM SCA_ALUNO_RENOVACAO AS renovacao"
			sql = sql & "         INNER JOIN SCA_TURMA AS turma_renovacao"
			sql = sql & "             ON turma_renovacao.Cod_Turma = renovacao.COD_TURMA_RENOVACAO"
			sql = sql & "         WHERE renovacao.COD_ALUNO = SCA_ALUNO_TURMA.COD_ALUNO"
			sql = sql & "             AND renovacao.cod_empresa = SCA_ALUNO_TURMA.cod_empresa"
			sql = sql & "             AND renovacao.COD_TURMA = SCA_ALUNO_TURMA.COD_TURMA"
			sql = sql & "             AND renovacao.EFETIVADO = 'S'"
			sql = sql & "     )"
			
			sql = sql & " union"
			
			sql = sql & " SELECT 'E' as tipo, SCA_ALUNO_RENOVACAO.CODIGO AS CODALUNOTURMA,SCA_TURMA.cod_turno, SCA_TURMA.COD_PERIODO, SCA_PERIODO.COD_CURSO, SCA_ALUNO.CODIGO, SCA_ALUNO.DATANASCIMENTO, SCA_ALUNO.MATRICULA, SCA_ALUNO.NOMEALUNO, '0' as SEQUENCIA, SCA_ALUNO_RENOVACAO.COD_TURMA, SCA_GRADECURRICULAR.Cod_Periodo, SCA_TURMA.NomeTurma,SCA_TURMA.TURMAALUNO, SCA_SITUACAOALUNO.Desc_SituacaoAluno, SCA_ALUNO.PERC_DESCONTO, SCA_ALUNO.PERC_DESCONTO2, SCA_ALUNO.PERC_DESCONTO3, SCA_ALUNO.PERC_DESCONTO4, SCA_TURMA.Cod_FichaDescritiva, SCA_PERIODO.sequencia "
			sql = sql & " from SCA_ALUNO_RENOVACAO"
			sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_RENOVACAO.COD_ALUNO = SCA_ALUNO.CODIGO "
			sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_RENOVACAO.COD_TURMA = SCA_TURMA.Cod_Turma "
			sql = sql & " INNER JOIN SCA_TURMA SCA_TURMA_RENOVACAO  ON SCA_ALUNO_RENOVACAO.COD_TURMA_RENOVACAO = SCA_TURMA_RENOVACAO.Cod_Turma "
			sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.COD_PERIODO = SCA_TURMA.Cod_PERIODO "
			sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
			sql = sql & " LEFT JOIN SCA_SITUACAOALUNO ON SCA_SITUACAOALUNO.Cod_SituacaoAluno = SCA_ALUNO.COD_SITUACAOALUNO "
			sql = sql & " where SCA_ALUNO_RENOVACAO.cod_empresa = " & Session("CodEmpresa") 
			sql = sql & " and SCA_ALUNO_RENOVACAO.COD_TURMA = " & intCodTurma  
			sql = sql & " and SCA_ALUNO_RENOVACAO.EFETIVADO = 'S' "
			if intCodSituacaoAluno<>"0" then
				sql = sql & " and SCA_SITUACAOALUNO.cod_SituacaoAluno = " & intCodSituacaoAluno
			end if
			sql = sql & " order by SCA_ALUNO.NOMEALUNO"
			if session("usuarioweb") = "ROBERTO" then
				response.write sql
			end if
			rsAux.open sql, cnn
			if rsAux.eof = false then
				selecionado = "checked"
				while not rsAux.eof

					cont = cont + 1
					strCodigoAluno        = rsAux("codigo")
					strMatricula		  = rsAux("MATRICULA")
					strRenovado		      = "Não"
					strBloqAltrExcl 	  = ""
					corLinha 			  = " "
					cor_fundo			  = ""
					quem=""
					intCodCursoRenovacao = RSAux("cod_curso")
					
					if intCodPeriodo = "" then
					
						sql = "select cod_periodo "
						sql = sql & " from sca_periodo p "
						sql = sql & " where cod_curso = " & intCodCursoRenovacao
						sql = sql & " and sequencia = " & rsAux("sequencia") + 1
						sql = sql & " order by cod_periodo"
						rsAux1.open sql, cnn
						if not rsAux1.eof then
							intCodPeriodo 		 = RSAux1("cod_periodo")
						end if
						rsAux1.close
						
					end if
					if rsAux("Desc_SituacaoAluno")="ATIVO" then
						sitAluno = "<br><font size='1px' color='blue'>" & rsAux("Desc_SituacaoAluno") & "</font>"
					else
						sitAluno = "<br><font size='1px' color='red'>" & rsAux("Desc_SituacaoAluno") & "</font>"
					end if
					intCodTurnoRenovacao = RSAux("cod_turno")
					vagas	= ""
					curso 	= ""
					periodo = ""
					turno 	= ""
					turma	= ""
					cod_turma_renovacao = 0
					efetivado = ""
					sql = "select r.codigo, r.efetivado, c.descricao as curso, p.descricao as periodo, t.desc_turno as turno, r.COD_TURMA_RENOVACAO, NomeTurma + ' - ' + TurmaAluno as turma, r.usuario_incl, r.data_hora_incl, isnull(tu.capacidade,0) - isnull(tu.VagasMatriculasUtilizadas,0) - isnull(tu.VagasReservadas,0) as vagas "
					sql = sql & " from SCA_ALUNO_RENOVACAO r "
					sql = sql & " inner join sca_curso c on c.cod_curso = r.cod_curso"
					sql = sql & " inner join sca_periodo p on p.cod_periodo = r.cod_periodo"
					sql = sql & " inner join sca_turno t on t.cod_turno = r.cod_turno"
					sql = sql & " inner join sca_turma tu on tu.cod_turma = r.COD_TURMA_RENOVACAO"
					sql = sql & " where r.ano_letivo = " & strAnoLetivo & " and r.cod_aluno = " & strCodigoAluno
					'IF strCodigoAluno = 28286 and session("usuarioweb") = "SERGIO" THEN
					'	RESPONSE.WRITE SQL & "<hr>"
					'END IF
					rsAux1.open sql, cnn
					if not rsAux1.eof then
						strRenovado		  = "<strong><font color='Green'>Sim</font></strong>"
						cor_fundo		  = " bgcolor='#E0FFFF' "
						quem = rsAux1("usuario_incl") & "<br>" & rsAux1("data_hora_incl")
						curso 	= rsAux1("curso")
						periodo = rsAux1("periodo")
						turno 	= rsAux1("turno")
						turma 	= rsAux1("turma")
						cod_turma_renovacao = rsAux1("COD_TURMA_RENOVACAO")
						if rsAux1("efetivado") = "S" then efetivado = "<br><font color='green'><strong>efetivado</strong></font>"
						vagas = rsAux1("vagas")
					end if
					rsAux1.close
					%>
						  <tr <%=cor_fundo%> onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" <%=corLinha%>> 
							<td class="celula" align="center" height="26" >
								<%IF strRenovado = "Não" THEN%>
								<input type="checkbox" id="chkAluno"  <%=strBloqAltrExcl%>  name="chkAluno" value="<%=rsAux("codigo")%>">
								<%ELSE%>
								&nbsp;
								<%END IF%>
							</td>
							
							<td class="celula"><div align="center"><%=cont%></div></td>
							<td class="celula">&nbsp;<%=strMatricula%></td>
							<td class="celula"><strong><%=rsAux("NOMEALUNO")%></strong>&nbsp;<%=sitAluno%></td>
							<td class="celula"><%=rsAux("TURMAALUNO")%>&nbsp;<%=rsAux("NOMETURMA")%></td>
							<td class="celula" align="center"><%=strRenovado%>&nbsp;</td>
							<td class="celula" align="center" height="26" >
								<%if curso = "" then%>
									<!--#include file="../includes/inc_cmbCursoRenovacao.asp"-->
								<%else%>
									<%=curso%>
								<%end if%>
							</td>
							<td class="celula" align="center" height="26" >
								<%if periodo = "" then%>
									<!--#include file="../includes/inc_cmbPeriodoRenovacao.asp"-->
								<%else%>
									<%=periodo%>
								<%end if%>
							</td>
							<td class="celula" align="center" height="26" >
								<%if turno = "" then%>
									<!--#include file="../includes/inc_cmbTurnoRenovacao.asp"-->
								<%else%>
									<%=turno%>
								<%end if%>
							</td>
							<td class="celula" align="center" height="26" >
								<%if turma = "" then%>
									<!--#include file="../includes/inc_cmbTurmaRenovacao.asp"-->
								<%else%>
									<%=turma%><%=efetivado%>
								<%end if%>
							</td>
							<td class="celula" align="left">
								<%if cor_fundo = "" then%>
								<input name="txtVagas<%=rsAux("codigo")%>" type="text" class="textVagas" id="txtVagas<%=rsAux("codigo")%>" size="5" readonly>
								<%else%>
								<%=vagas%>&nbsp;
								<%end if%>
							</td>
							<td class="celula" align="center">
								<%IF strRenovado = "Não" THEN%>
									&nbsp;
								<%ELSE%>
									<a href="#" onClick="emitirComprovante('<%=rsAux("codigo")%>','<%=strAnoLetivo%>','<%=strSemestre%>')" ><img src="../../../images/impressora_on.gif" alt="Emitir comprovante de renovação"></a>
								<%END IF%>
							</td>
							
						  </tr>
						<%			
						selecionado = ""
						rsAux.movenext
					wend
				else
					%>
					  <tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"> 
						<td colspan="13" align="center" class="celula"><%=session("strMensagemRelatorioNaoEncontrado")%></td>
					  </tr>
					  <%
					end if
					rsAux.close
			end if
					%>
        </table>
			<br>
			<br>
			<br>
			</td>
    </tr>
  </table>
  		  </td>
		</tr>
  </table>
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>