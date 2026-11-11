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
	
	function emitirComprovante(codigo, AnoLetivo, semestre){
	
		if (AnoLetivo==""){
			alert("Ano letivo deve ser informado!");
			return false
		}
		window.open("renovacaoAluno_rel.asp?chkAluno=" + codigo + "&txtAnoLetivo=" + AnoLetivo + "&cmbSemestre=" + semestre,"Comprovantes","top=0,left=0,height=543,width=793,menubar=no,toolbar=no,scrollbars=yes,status=yes");
 	}
	function cancelarComprovante(codigo){
		if (confirm("Você realmente deseja cancelar a renovação da matrícula desse aluno?")) { 
			frm.action="renovacaoAluno_cod.asp?acao=C&codAluno="+codigo;
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
		
		var frm = document.getElementById("frm");
		var form = window.document.forms[0];
		var i;
		for (var i = 0; i < form.elements.length; i++) {
			//verifica todos os checkbox
			if (form.elements[i].type == "checkbox"){
				//verifica se o checkbox está marcado
				if (form.elements[i].disabled == false){
					if (form.elements[i].checked==true){
						selecionado = "S"
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
	if trim(request("txtAnoLetivo")) = "" then 
		strAnoLetivo = session("strAnoLetivo")
	else
		strAnoLetivo = request("txtAnoLetivo")
	end if

	strCodAluno			= Trim(Request.form("txtCodAluno"))
	strMatricula 		= Trim(Request("txtMatricula"))
	strNomealuno 		= Trim(Request("txtNomealuno"))

	intCodTurma 			= Trim(Request("txtCodTurmaRenovacao"))
	
	if intCodCursoRenovacao = "" then intCodCursoRenovacao = "0"
	if intCodPeriodoRenovacao = "" then intCodPeriodoRenovacao = "0"
	if intCodTurnoRenovacao = "" then intCodTurnoRenovacao = "0"
	
	strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
	strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
	strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	strbotaoAtualizar		= "S"

%>
<form method="post" id="frm" action="renovacaoAluno_cad.asp">
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
			if strCodAluno <> "" then%> 
			
			<table class="tabela" width="98%" align="center" border="1" cellpadding="0" cellspacing="0">
          <tr class="CabecalhoConsulta" > 
            <td width="2%" align="center" class="celula" >
				<input type="checkbox" name="chkTodos" onClick="return marcaTodos(this.checked)">
			</td>
            <td width="40" class="celula"><strong>Ord.</strong></td>
            <td width="127" class="celula"><strong>Matr&iacute;cula</strong></td>
            <td width="391" class="celula"><strong>Nome</strong></td>
            <td width="125" class="celula"><strong>Turma</strong></td>
            <td width="120" class="celula" align="center" ><strong>Confirmado</strong></td>
			<td width="120" class="celula" align="center" ><strong>Curso</strong></td>
			<td width="120" class="celula" align="center" ><strong>Período</strong></td>
			<td width="120" class="celula" align="center" ><strong>Turno</strong></td>
			<td width="131" class="celula" align="center" ><strong>Ficha</strong></td>
			<td width="120" class="celula" align="center" ><strong>Cancelamento</strong></td>
          </tr>
          <%	
		  	cont = 0				
			'seleciona os alunos da turma'					
			sql = "SELECT SCA_ALUNO_TURMA.CODIGO AS CODALUNOTURMA, SCA_ALUNO.CODIGO, SCA_ALUNO.DATANASCIMENTO, SCA_ALUNO.MATRICULA, SCA_ALUNO.NOMEALUNO, SCA_ALUNO_TURMA.SEQUENCIA, SCA_ALUNO_TURMA.COD_TURMA, SCA_GRADECURRICULAR.Cod_Periodo, SCA_TURMA.NomeTurma,SCA_TURMA.TURMAALUNO, SCA_SITUACAOALUNO.Desc_SituacaoAluno, SCA_ALUNO.PERC_DESCONTO, SCA_ALUNO.PERC_DESCONTO2, SCA_ALUNO.PERC_DESCONTO3, SCA_ALUNO.PERC_DESCONTO4, SCA_TURMA.Cod_FichaDescritiva "
			sql = sql & " FROM SCA_ALUNO_TURMA "
			sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO AND SCA_ALUNO_TURMA.COD_EMPRESA = SCA_ALUNO.COD_EMPRESA "
			sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma and SCA_TURMA.cod_empresa = sca_aluno.cod_empresa "
			sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
			sql = sql & " LEFT JOIN SCA_SITUACAOALUNO ON SCA_SITUACAOALUNO.Cod_SituacaoAluno = SCA_ALUNO.COD_SITUACAOALUNO" 
			sql = sql & " where SCA_ALUNO_TURMA.cod_empresa = " & Session("CodEmpresa")
			sql = sql & " and SCA_ALUNO_TURMA.situacao = 'A'"
			sql = sql & " and SCA_ALUNO_TURMA.COD_ALUNO = " & strCodAluno
			sql = sql & " order by SCA_ALUNO.NOMEALUNO"
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
					
					curso 	= ""
					periodo = ""
					turno 	= ""
					
					sql = "select r.codigo, c.descricao as curso, p.descricao as periodo, t.desc_turno as turno, r.usuario_incl, r.data_hora_incl "
					sql = sql & " from SCA_ALUNO_RENOVACAO r "
					sql = sql & " inner join sca_curso c on c.cod_curso = r.cod_curso"
					sql = sql & " inner join sca_periodo p on p.cod_periodo = r.cod_periodo"
					sql = sql & " inner join sca_turno t on t.cod_turno = r.cod_turno"
					sql = sql & " where ano_letivo = " & strAnoLetivo & " and cod_aluno = " & strCodigoAluno
					
					rsAux1.open sql, cnn
					if not rsAux1.eof then
						strRenovado		  = "<strong><font color='Green'>Sim</font></strong>"
						cor_fundo		  = " bgcolor='#E0FFFF' "
						quem = rsAux1("usuario_incl") & "<br>" & rsAux1("data_hora_incl")
						curso 	= rsAux1("curso")
						periodo = rsAux1("periodo")
						turno 	= rsAux1("turno")
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
							<td class="celula"><%=rsAux("NOMEALUNO")%>&nbsp;</td>
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
							<td class="celula" align="center">
								<%IF strRenovado = "Não" THEN%>
									&nbsp;
								<%ELSE%>
									<a href="#" onClick="emitirComprovante('<%=rsAux("codigo")%>','<%=strAnoLetivo%>','<%=strSemestre%>')" ><img src="../../../images/impressora_on.gif" alt="Emitir comprovante de renovação"></a>
								<%END IF%>
							</td>
							<td class="celula" align="center">
								<%IF strRenovado = "Não" THEN%>
									&nbsp;
								<%ELSE%>
									<a href="#" onClick="cancelarComprovante('<%=rsAux("codigo")%>')" ><img src="../../../images/botao_vermelho_normal.gif" alt="Cancelar renovação"></a>
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
						<td colspan="12" align="center" class="celula"><%=session("strMensagemRelatorioNaoEncontrado")%></td>
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