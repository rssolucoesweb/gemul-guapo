<!--
	::	Amanha dia 19 meu filho faz 8 meses
    ::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 18/03/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Promoção Automatica
-->
<html>
<title><%=session("Titulo")%></title>
<link type="text/css" rel="stylesheet" href="../../Estilo/css.css"><body>
<script src="../../js/js_funcoes_gerais.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurmaTodasSituacoes.asp"-->
<script>

	function marcaTodos(valor){
	
		var form = window.document.forms[0];
		var frm = document.getElementById("frm");
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
		var men = 'ATENCAO: \nDeseja realmente Promover os alunos selecionados?';
		
		if (confirm(men)) {
			
			if (frm.cmbTurma.value=="0"){
				alert("A Turma Atual deve ser informada, verifique!")		
				frm.cmbTurma.focus();
				return false
			}
			
			if (frm.txtNomeTurmaDestino.value==""){
				alert("A Turma Destino deve ser informada, verifique!")		
				frm.txtNomeTurmaDestino.focus();
				return false
			}
			
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
				alert("ATENCAO: Pelo menos um Aluno deve ser selecionado, Verifique!");
				return false;
			}
			
			frm.action="PromocaoAutomatica_cod.asp?acao=I";
			frm.submit();
			return true;
		
		} else {
			return false;
		}
		
 	}
</script>
<%
	strPaginaTitulo = "PromocaoAutomatica_cad.asp"
	strExecutarSubmitTurma	  = "S"
	strExecutarSubmitSemestreTodos = "S"
	
	
	if  Trim(Request.Form("txtAnoLetivo")) <> "" then
		strAnoLetivo = Trim(Request.Form("txtAnoLetivo"))
	else
		strAnoLetivo 			= session("strAnoLetivo")
	end if
	
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	strSemestre 			= Trim(Request.Form("cmbSemestre"))
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	bolExiteTurma			= false
	
	'regra ano / semestre destino
	if intSemestre = "1" then
		intAnoLetivoDestino = Session("strAnoLetivo")
		intSemestreDestino	 = 2
	elseif intSemestre = "2" then
		intAnoLetivoDestino = strAnoLetivo+1
		intSemestreDestino	 = 1
	elseif intSemestre = "3" then
		intAnoLetivoDestino = strAnoLetivo+1
		intSemestreDestino	 = 3
	end if
	
	strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
	strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
	strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir]
	
	if intCodTurma 		= "" then intCodTurma 		= "0"

	if trim(intCodTurma) <> "0"  then 
		
		sql = "SELECT P.COD_CURSO, P.COD_PERIODO, P.SEQUENCIA, T.Cod_SemestreCriacao, T.COD_TURNO, T.SALA, T.ANO, "
		sql = sql & " T.NOMETURMA, T.capacidade"
		sql = sql & " FROM	SCA_GRADECURRICULAR G"
		sql = sql & " INNER	JOIN SCA_TURMA T 	ON T.COD_GRADECURRICULAR = G.COD_GRADECURRICULAR AND T.COD_EMPRESA = G.COD_EMPRESA"
		sql = sql & " INNER	JOIN SCA_PERIODO P 	ON P.COD_PERIODO = G.COD_PERIODO AND P.COD_EMPRESA = G.COD_EMPRESA"
		sql = sql & " WHERE	T.COD_TURMA		= " & intCodTurma
		sql = sql & " AND	T.COD_EMPRESA	= " & Session("CodEmpresa")
		rs.open sql, cnn, 3, 3
		if not RS.EOF then	
			
			strCodCursoAtual 	= rs("COD_CURSO")
			strCodPeriodoAtual 	= rs("COD_PERIODO")
			strSequenciaAtual 	= rs("SEQUENCIA")
			strSequenciaDestino	= rs("SEQUENCIA")+1
			strCodTurnoDestino 	= rs("COD_TURNO")
			strSalaDestino 		= rs("SALA")
			strAnoDestino 		= rs("ANO")
			strSemestreCriacaoDestino = rs("Cod_SemestreCriacao")
			strNomeTurmaAtual	= rs("NOMETURMA")
			strCapacidadeDestino= rs("capacidade")
			
		end if
		rs.close	
		
		strNomeTurmaDestino = left(strNomeTurmaAtual,2) & strSequenciaDestino & right(strNomeTurmaAtual,6)
		
		'VERIFICA SE A TURMA JÁ FOI CADASTRADA
		sql = "select top 1 Cod_Turma, NomeTurma, Cod_Semestre, AnoLetivo"
		sql = sql & " FROM	SCA_TURMA "
		sql = sql & " WHERE	NOMETURMA	= '" & strNomeTurmaDestino & "'"
		sql = sql & " AND COD_EMPRESA	= " & Session("CodEmpresa")
		sql = sql & " order by cod_turma desc "
		rs.open sql, cnn, 3, 3
		if not RS.EOF then	
			bolExiteTurma = true
			intCodTurmaDestino 	= rs("Cod_Turma")
	
			strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir


		end if
		rs.close	

		if bolExiteTurma = false then
		
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir

			%>
			<script>
				alert("ATENCAO: Turma destino <%=strNomeTurmaDestino%>, ainda nao cadastrada.");
				window.navigate('PromocaoAutomatica_cad.asp');
			</script>
			<%
			response.end
		end if		
	
	end if

	

%>
<form method="post" id="frm" action="PromocaoAutomatica_cad.asp">
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
            <tr valign="top">
              <td  align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
		<tr valign="top">
		  <td align="center">
  <table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
    <tr>
      <td class="texto1">Ano Letivo Anterior:</td>
      <td colspan="2"><input onBlur="submit()"  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo"  value="<%=strAnoLetivo%>" size="5" maxlength="4" onKeyPress="return formataCampo(this,2,4)"></td>
    </tr>
    <tr>
      <td height="28" class="texto1">Semestre Letivo:</td>
      <td colspan="2"><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
    </tr>
    <tr> 
      <td width="11%" height="28" class="texto1">Turma Atual:</td>
      <td width="89%" colspan="2"><!--#include file="../includes/inc_cmdTurma.asp"--></td>
    </tr>
    
    <tr>
      <td class="texto1">Turma Destino:</td>
      <td colspan="2"><input name="txtCodTurmaDestino" type="hidden" class="text" id="txtCodTurmaDestino"  value="<%=intCodTurmaDestino%>" size="12" maxlength="10" > <input readonly name="txtNomeTurmaDestino" type="text" class="text" id="txtNomeTurmaDestino"  value="<%=strNomeTurmaDestino%>" size="12" maxlength="10" ></td>
    </tr>
    <tr>
      <td class="texto1">Ano e Semestre:</td>
      <td colspan="2" class="texto1">
 <input readonly="true" name="txtAnoLetivoDestino" type="hidden" class="text" id="txtAnoLetivoDestino"  value="<%=intAnoLetivoDestino%>" size="12" maxlength="10" >
	<%
    if intSemestreDestino = "3" then 
        strMostraSemestre = "/Anual" 
    else
        strMostraSemestre = "/" & intSemestreDestino
    end if 
	%>
    <%=intAnoLetivoDestino%><%=strMostraSemestre%>
        <input name="txtSemestreDestino" type="hidden" class="text" id="txtSemestreDestino"  value="<%=intSemestreDestino%>" size="12" maxlength="10" ></td>
    </tr>
    <tr>
      <td class="texto1">&nbsp;</td>
      <td colspan="2">&nbsp;</td>
    </tr>
    <tr> 
      <td class="texto1">&nbsp;</td>
      <td class="texto1" colspan="2">ATEN&Ccedil;&Atilde;O! A promo&ccedil;&atilde;o autom&aacute;tica do aluno s&oacute; ser&aacute; bem sucedida se a turma informada estiver FECHADA.</td>
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
			if intCodTurma <> "0" then%> 
			
			<table class="tabela" width="98%" align="center" border="1" cellpadding="0" cellspacing="0">
          <tr bgcolor="#CCCCCC" class="CabecalhoConsulta"> 
            <td width="31" rowspan="2" align="center" class="celula">&nbsp;&nbsp;<input type="checkbox" name="chkTodos" onClick="return marcaTodos(this.checked)"></td>
            <td width="44" rowspan="2" class="celula"><strong>Ord.</strong></td>
            <td width="177" rowspan="2" class="celula"><strong>Matr&iacute;cula</strong></td>
            <td width="382" rowspan="2" class="celula"><strong>Nome</strong></td>
            <td width="88" rowspan="2" class="celula"><strong>Turma</strong></td>
            <td colspan="2" class="celula"><div align="center"><strong>Situa&ccedil;&atilde;o</strong></div></td>
            </tr>
          <tr bgcolor="#CCCCCC" class="CabecalhoConsulta">
            <td width="76" class="celula">Aloca&ccedil;&atilde;o</td>
            <td width="87" class="celula"> Acad&ecirc;mica</td>
          </tr>
          <%	
		    Cont = 0				
			sql = " select Distinct "
			sql = sql & " he.cod_aluno AS codigo, "
			sql = sql & " a.MATRICULA, "
			sql = sql & " a.NOMEALUNO, "
			sql = sql & " t.NomeTurma, SA.DESC_SITUACAOALUNO, "
			sql = sql & " ( SELECT TOP 1 T.NOMETURMA FROM SCA_ALUNO_TURMA AT "
			sql = sql & "   INNER JOIN SCA_TURMA T ON T.COD_TURMA = AT.Cod_Turma "
			sql = sql & " 	where AT.cod_empresa = " & Session("CodEmpresa") 	 
			sql = sql & " 	and AT.COD_TURMA = " & intCodTurmaDestino 
			sql = sql & " 	and AT.situacao = 'A' "
			sql = sql & " 	AND AT.COD_ALUNO in (he.cod_aluno) " 
			sql = sql & " 	ORDER BY AT.CODIGO DESC ) AS TURMADESTINO "
			sql = sql & " from SCA_HISTORICO_ESCOLAR_DISCIPLINA hed "
			sql = sql & " inner join SCA_HISTORICO_ESCOLAR he on he.codigo = hed.cod_historico_escolar "
			sql = sql & " inner join SCA_ALUNO a on a.CODIGO = he.cod_aluno "
			sql = sql & " INNER JOIN SCA_SITUACAOALUNO SA ON SA.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO " 
			sql = sql & " inner join SCA_TURMA t on t.Cod_Turma = hed.cod_turma "
			sql = sql & " where he.cod_empresa = " & Session("CodEmpresa")			
			sql = sql & " and hed.cod_turma = " & intCodTurma	
			sql = sql & " and hed.ano_letivo = " & strAnoLetivo	
			sql = sql & " and hed.semestre = " & intSemestre	
			sql = sql & " order by a.NOMEALUNO "
			rs.open sql, cnn
			if rs.eof = false then
				selecionado = "checked"
				while not rs.eof

					strCodigoAluno        = rs("codigo")
					strMatricula		  = rs("MATRICULA")
					strDesc_SituacaoAluno = rs("Desc_SituacaoAluno")
					
					MarcaReprovacao = ""
					sql = " select DISTINCT "
					sql = sql & " SITUACAO "
					sql = sql & " from SCA_HISTORICO_ESCOLAR_DISCIPLINA hed "
					sql = sql & " inner join SCA_HISTORICO_ESCOLAR he on he.codigo = hed.cod_historico_escolar "
					sql = sql & " where cod_aluno = " & rs("codigo")
					sql = sql & " and hed.ano_letivo = " & strAnoLetivo	
					sql = sql & " and hed.semestre = " & intSemestre	
					'sql = sql & " and hed.situacao = 'RN' "
					sql = sql & " and (hed.situacao = 'RN' or isnull(hed.situacao,'0') = '')"
					rsaux.open sql, cnn
					if rsaux.eof = false then
						MarcaReprovacao = "ok"
					end if
					rsaux.close	

					if MarcaReprovacao <> "OK" then	
					   	if trim(rs("TURMADESTINO")) = trim(strNomeTurmaDestino) then
					    	strHabilitaMarcacao = " disabled "
							msgHabilitaMarcacao = " J&aacute; alocado "
					 	else
						   	strHabilitaMarcacao = ""	
							msgHabilitaMarcacao = ""
							cont = cont + 1
						end if   

						%>
						<tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"> 
						<td class="celula" align="center"><input <%=strHabilitaMarcacao%> type="checkbox" id="chkAluno" name="chkAluno" value="<%=rs("codigo")%>"></td>
						<td class="celula"align="center"><%=cont%></td>
						<td class="celula">&nbsp;<%=strMatricula%></td>
						<td class="celula"><%=rs("NOMEALUNO")%>&nbsp;</td>
						<td class="celula"><%=rs("NOMETURMA")%>&nbsp;</td>
						<td class="celula"><%=msgHabilitaMarcacao%>&nbsp;</td>
						<td class="celula"><%=strDesc_SituacaoAluno%></td>
						</tr>
						<%			
						selecionado = ""
						
                    end if
					rs.movenext
					wend
				else
					%>
					  <tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"> 
						<td colspan="7" align="center" class="celula"><%=session("strMensagemRelatorioNaoEncontrado")%></td>
					  </tr>
					  <%
					end if
					rs.close
			end if
					%>
        </table>
			<br></td>
    </tr>
  </table>
  		  </td>
		</tr>
  </table>
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>