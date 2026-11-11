<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 27/11/2007
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Notas
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../estilo/css.css" rel="stylesheet" type="text/css"></head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script src="../../js/js_funcoes_gerais.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file=../../includes/inc_aguarde.asp-->
<script>
	function controlaFoco(proximoEnter) {
		var codigoTecla = event.keyCode;
		if (codigoTecla==13) { //enter
			document.all(proximoEnter).focus();
			document.all(proximoEnter).select();
		}
			
	}
	function calculaNota(valor){ //->função que ignora deixa somente 1 número após a vírgula. Ex.: 6.86 para 6.8
	
		var qtde;
		var i;
		var VNota = "";
		var ponto = false;
		valor = "" + valor.toFixed(1); //->converte para string
		qtde = valor.length;
	
		for(i=0;i<qtde;i++){
			VNota = VNota + valor.substring(i,i+1);
			if (valor.substring(i,i+1) =="."){
				ponto = true;
				break;
			}
		}
		
		if (ponto){
			VNota = VNota + valor.substring(i+1,i+2)
		}	
		
		return VNota;
	}


	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}
	
	function validaNota(valor, posicao, linha){
		if (valor<0 || valor>10){
			alert("Atenção: nota inválida, deve estar entre 0 a 10!");
			document.all["txtNota_" + linha + "_" + posicao].select();
			document.all["txtNota_" + linha + "_" + posicao].style.backgroundColor = "#DAFA7A";
			document.all["txtNota_" + linha + "_" + posicao].focus();
			return false;
		}else{
			if (valor.substring(0,2) == "10" && valor.substring(2,3) == "," && valor.substring(3,4) != "0") {
				alert("Atenção: nota inválida, deve estar entre 0 a 10!");
				document.all["txtNota_" + linha + "_" + posicao].select();
				document.all["txtNota_" + linha + "_" + posicao].style.backgroundColor = "#DAFA7A";
				document.all["txtNota_" + linha + "_" + posicao].focus();
				return false;
			
			}
			document.all["txtNota_" + linha + "_" + posicao].style.backgroundColor = "#FFB7B7";
			return true;
		}
	}	
	
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		frm.action="NotasNovo_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}

</script>
<%
	if trim(request("txtAnoLetivo")) = "" then 
		strAnoLetivo = session("strAnoLetivo")
	else
		strAnoLetivo = request("txtAnoLetivo")
	end if
	
    intPermitirAlteracaoNotaDocente = "0"
	sql = " SELECT top 1 Permitir_AlteracaoNotaDocente "
	sql = sql & " FROM SEG_ENCERRAMENTOATIVIDADES "
	sql = sql & " Where cod_empresa = " & Session("CodEmpresa")
	rs.Open SQL, cnn
	if rs.EOF = false then								
		intPermitirAlteracaoNotaDocente	 = trim(rs("Permitir_AlteracaoNotaDocente"))
		if isnull(intPermitirAlteracaoNotaDocente) then intPermitirAlteracaoNotaDocente = "0"
	end if
	rs.close

	'verifica se o usuario é professor ou admnistrativo
	sql = "select codigo "
	sql = sql & " from SRH_COLABORADOR"
	sql = sql & " where codigo_SEG_USUARIOS_SISTEMA = '" & trim(session("usuarioWeb")) & "'"
	sql = sql & " and codLotacao= " & Session("CodEmpresa")
	sql = sql & " and (CodCategoria = 1 or CodCategoria = 8)"'professor
	sql = sql & " and Situacao = 'A'"'ativo
	rs.open sql, cnn
	if rs.eof then
		strTipoAcessoCadastroNotas = "ADM"
		msnTipoLanc = ""		
	else
		strTipoAcessoCadastroNotas = "PROF"
		intCodColaboradorProfessor = rs("codigo")
		strExecutarSubmitDisciplinaDoProfessor = "S"
		msnTipoLanc = " - Professor"		
	end if
	rs.close
	
	if strTipoAcessoCadastroNotas = "ADM" then
		intCodTurma 			= Trim(Request("cmbTurma"))
		intCodTurmaProfessor	= intCodTurma
		intCodDisciplina  		= trim(request("cmbDisciplinaTurma"))
		intCodDisciplinaTurma	= intCodDisciplina
	elseif strTipoAcessoCadastroNotas = "PROF" then
		intCodTurma 			= Trim(Request("cmbTurmaProfessor"))
		intCodTurmaProfessor	= intCodTurma
		intCodDisciplina  		= trim(request("cmbDisciplinaDoProfessor"))
		intCodDisciplinaTurma	= intCodDisciplina
	end if

	intCodCurso	 			= Trim(Request("cmbCurso"))
	intCodPeriodo 			= Trim(Request("cmbPeriodo"))
	intSemestre 			= Trim(Request("cmbSemestre"))
	strAtivos               = trim(request("cmbativos"))
	
	intCodTurno		 		= Trim(Request("cmbTurno"))
	strAlunos      			= Trim(Request("chkAluno"))
	intCodTipoNota			= Trim(Request("chkTipoNota"))
	intCodTipoLancamento	= Trim(Request("cmbTipoLancamento")) '"0" '-->Nota e Falta | "1" '-->Somente Nota	| "2" '-->Somente Falta		
	bloqueiaAcumuladaFalta	= Trim(Request("cmbBloqueiaFaltas"))	
		
	buscaHistorico = "N"
	if trim(intSemestre) = "3" then
	   if trim(strAnoLetivo) <> trim(session("strAnoLetivo"))  then
	      buscaHistorico = "S"
		  msnHistorico  = "<font color='#0000FF'>(<strong>HIST&Oacute;RICO</strong>)</font>"
	   end if
	else
	   if trim(strAnoLetivo) <> trim(session("strAnoLetivo"))  or trim(intSemestre) <> trim(session("strSemestre")) then
		  buscaHistorico = "S"
		  msnHistorico  = "<font color='#0000FF'>(<strong>HIST&Oacute;RICO</strong>)</font>"
	   end if	   
    end if
	

	'carrega campos
	sql = "SELECT  posicao, descricao, formula, digitar, bimestre as tipo "
	sql = sql & " FROM SCA_TIPO_AVALIACAO "
	sql = sql & " WHERE	COD_EMPRESA = " & Session("CodEmpresa") 
	sql = sql & " AND 	COD_CURSO = " & intCodCurso
	sql = sql & " order by posicao"
	vetCampo = null
	rs.open sql, cnn
	if not rs.eof then
		vetCampo = rs.getRows
	end if
	rs.close
		
	strNomedisciplina = ""
	sql = "SELECT DESC_DISCIPLINA FROM SCA_DISCIPLINA"
	sql = sql & " WHERE	COD_EMPRESA = " & Session("CodEmpresa") 
	sql = sql & " AND	COD_DISCIPLINA = " & intCodDisciplina
	rs.open sql, cnn
	if not rs.eof then
		strNomedisciplina = rs("DESC_DISCIPLINA")
	end if
	rs.close
	
	strMostraNota = "style='display:block'"
	strMostraFalta = "style='display:block'"

	sql="select * from SCA_CRITERIO_AVALIACAO"
	sql=sql & " where	cod_empresa = "&Session("CodEmpresa") 
	sql=sql & " and		cod_curso	= "&intCodCurso
	rs.open sql, cnn
	if rs.eof then
		rs.close
		%>
		<script>
			alert("O critério de avaliação não foi criado para esse curso.");
			window.location="Avaliacao_cad.asp?intCodCurso=<%=intCodCurso%>";
		</script>
		<%
		response.end
	end if
	rs.close

	'busca a media
	sql = "SELECT media_aprovacao_final, media_aprovacao, condicaoEF_notaInicial, condicaoEF_notaFinal, tipoFormulaFinal, frequencia_minima_percentual "
	sql = sql & " FROM SCA_CRITERIO_AVALIACAO "
	sql = sql & " WHERE	COD_EMPRESA = " & Session("CodEmpresa") 
	sql = sql & " AND 	COD_CURSO = " & intCodCurso
	rs.open sql, cnn
	if not rs.eof then
		strMediaAprovacaoFinal 		= rs("media_aprovacao_final")
		strMediaAprovacaoExame 		= rs("media_aprovacao")'DO EXAME ESTA GRAVANDO INVERTIDO NO CRITERIO
		intCondicaoEF_notaInicial 	= rs("condicaoEF_notaInicial")
		intCondicaoEF_notaFinal 	= rs("condicaoEF_notaFinal")
		strTipoFormulaFinal 		= rs("tipoFormulaFinal")
		intFrequenciaMinimaPerc		= rs("frequencia_minima_percentual")
	end if
	rs.close

	strParametro = "NotasNovo_con.asp?cmbPeriodo="&intCodPeriodo
	strParametro = strParametro & "&cmbSemestre="&intSemestre
	strParametro = strParametro & "&cmbDisciplinaTurma="&intCodDisciplina
	strParametro = strParametro & "&chkTipoNota="&intCodTipoNota
	strParametro = strParametro & "&cmbTurma="&intCodTurma
	strParametro = strParametro & "&chkAluno="&strAlunos
	strParametro = strParametro & "&cmbTurno="&intCodTurno
	strParametro = strParametro & "&cmbTipoLancamento="&intCodTipoLancamento	
	strParametro = strParametro & "&cmbCurso="&intCodCurso	
	strParametro = strParametro & "&cmbativos="&strAtivos	
		%>

<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td>
	<table width="100%"  height="325" border="0" cellspacing="0" cellpadding="0">
      <tr valign="top">
        <td colspan="2" align="center">
		<form id="frm" name="frm" method="post" action="notasNovo_cad.asp">
		<input type="HIDDEN" name="txtPosicao" value="<%=strPosicao%>">
		<input type="HIDDEN" name="txtBimestreAtual" value="<%=strCodBimestre%>">
        <input type="HIDDEN" name="cmbativos" value="<%=strAtivos%>">
		  <table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr valign="top">
              <td width="100%" align="center" class="tituloSistema">Lan&ccedil;amentos de Notas <%=msnTipoLanc%><%=msnHistorico%></td>
            </tr>
          </table>
		  <br>
          <div align="center">
         <% if session("UsuarioWeb") <> "USUARIO.TESTE" then %> 
        	<input onClick="salvar('I')" name="btnSalvar" value=" Salvar Notas e Faltas" type="button" class="botao">
         <% end if %>   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		  <input onClick="window.location='<%=strParametro%>'" name="btnVoltar" value="<< Voltar " type="button" class="botao">
          </div>
          <br>
		  <%
			sql = "SELECT TU.NOMETURMA, TU.ANO, TU.ANOLETIVO, T.DESC_TURNO "
			sql = sql & " FROM SCA_TURMA TU"
			sql = sql & " INNER JOIN SCA_TURNO T ON T.COD_TURNO = TU.COD_TURNO AND T.COD_EMPRESA = TU.COD_EMPRESA"
			sql = sql & " WHERE	TU.COD_EMPRESA = " & Session("CodEmpresa") 
			sql = sql & " AND	TU.COD_TURMA = " & intCodTurma
			rsAux.open sql, cnn
			if not rsAux.eof then
		  %>
		  <table width="703" border="0" cellspacing="0" cellpadding="0" class="tabela">
            <tr bgcolor="#E5E5E5">
              <td width="85" height="24" class="celula">&nbsp;<strong>Turma:</strong></td>
              <td width="262" class="celula">&nbsp;<%=rsAux("NOMETURMA")%></td>
              <td width="136" class="celula">&nbsp;<strong>Turno:</strong></td>
              <td width="219" class="celula">&nbsp;<%=rsAux("DESC_TURNO")%></td>
            </tr>
            <tr bgcolor="#E5E5E5">
              <td height="24" class="celula">&nbsp;<strong>Disciplina:</strong></td>
              <td colspan="3" class="celula">&nbsp;
			  	<%IF strTipoAcessoCadastroNotas = "ADM" THEN%>
				<!--#include file="../includes/inc_cmbDisciplinaTurma.asp"-->
                <%ELSEIF strTipoAcessoCadastroNotas = "PROF" THEN%>
				<!--#include file="../includes/inc_cmdDisciplinaDoProfessor.asp"-->
                <%END IF%>
				</td>
              </tr>
          </table>
		  <%
		  end if
		  rsAux.close
		  %>
		  <br>
			<%		 
			IF buscaHistorico = "N" then
			   'SELECIONA OS ALUNOS REGULARES CONFORME DISCIPLINA CADASTRADA
	           sql = " SELECT "
			   sql = sql & " AD.CODIGO AS COD_ALUNO_DISCIPLINA, "
			   sql = sql & " AD.COD_ALUNO AS CODIGO,"
			   sql = sql & " AD.COD_TURMA_REMANEJAMENTO AS COD_TURMA, "
			   sql = sql & " AD.COD_DISCIPLINA, "
			   sql = sql & " A.NOMEALUNO, "
			   sql = sql & " A.MATRICULA, "
			   sql = sql & " '' AS SEQUENCIA, " 
			   sql = sql & " SA.DESC_SITUACAOALUNO, "
			   sql = sql & " GC.COD_PERIODO, "
			   sql = sql & " NF.media, "    
               sql = sql & " NF.codigo AS COD_NOTA, "
				for n=1 to 15
					strComplemento = "0"	
					if cInt(n)>9 then strComplemento = ""
					sql = sql & " NF.nota" & strComplemento & n & ", "
				next
		        sql = sql & " NF.situacao "
				sql = sql & "FROM SCA_ALUNO_DISCIPLINA AD INNER JOIN "
 				sql = sql & "SCA_ALUNO A ON A.CODIGO = AD.COD_ALUNO  INNER JOIN "
 				sql = sql & "SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = A.COD_SITUACAOALUNO AND SA.Cod_Empresa = A.COD_EMPRESA INNER JOIN "
 				sql = sql & "SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurriculardisciplina = AD.COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO INNER JOIN "
 				sql = sql & "SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = GCD.Cod_GradeCurricular INNER JOIN "
 				sql = sql & "SCA_NOTAS_FALTAS NF ON NF.cod_aluno_disciplina = AD.CODIGO "
 				sql = sql & "WHERE AD.COD_EMPRESA = " & Session("CodEmpresa")
				sql = sql & "AND GCD.COD_DISCIPLINA = " & intCodDisciplina
				sql = sql & "AND AD.COD_TURMA_REMANEJAMENTO =  " & intCodTurma
				'sql = sql & "AND (SA.Desc_SituacaoAluno = 'ATIVO' OR SA.Desc_SituacaoAluno = 'PRÉ-MATRÍCULA') " 
				sql = sql & "AND A.CODIGO in (" & strAlunos & ") "
 				sql = sql & "ORDER BY A.NOMEALUNO "
		     else
		   		'HISTORICO ESCOLAR
				sql = " select DISTINCT A.CODIGO, "
				sql = sql & " ' ' AS COD_ALUNO_DISCIPLINA, "
				sql = sql & " A.MATRICULA, "
				sql = sql & " A.NOMEALUNO, "
				sql = sql & " AT.COD_TURMA, "
			    sql = sql & " '' AS SEQUENCIA, " 
				sql = sql & " AT.COD_TURMA, "
				sql = sql & " T.NOMETURMA, "
				sql = sql & " G.Cod_Periodo, "
				sql = sql & " HED.MEDIA, "
				for n=1 to 15
					strComplemento = "0"	
					if cInt(n)>9 then strComplemento = ""
					sql = sql & " HED.nota" & strComplemento & n & ", "
				next
				sql = sql & " D.DESC_DISCIPLINA, "
				sql = sql & " TU.DESC_TURNO, "
				sql = sql & " HED.CODIGO AS COD_NOTA, "
				sql = sql & " HED.SITUACAO "
				sql = sql & " from SCA_HISTORICO_ESCOLAR_DISCIPLINA HED "
				sql = sql & " INNER JOIN SCA_HISTORICO_ESCOLAR HE ON HE.CODIGO = HED.COD_HISTORICO_ESCOLAR "
				sql = sql & " INNER JOIN SCA_ALUNO A ON A.CODIGO = HE.COD_ALUNO AND A.COD_EMPRESA = HE.COD_EMPRESA "
				sql = sql & " INNER JOIN SCA_SITUACAOALUNO SA ON SA.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO AND SA.COD_EMPRESA = A.COD_EMPRESA "
				sql = sql & " INNER JOIN SCA_ALUNO_TURMA AT ON AT.COD_ALUNO=A.CODIGO AND AT.COD_EMPRESA = A.COD_EMPRESA "
				sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = AT.COD_TURMA AND T.ANOLETIVO = AT.Ano_Letivo AND T.COD_SEMESTRE = AT.SEMESTRE AND T.cod_empresa = AT.cod_empresa "
				sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.Cod_GradeCurricular = T.Cod_GradeCurricular AND G.COD_EMPRESA = T.COD_EMPRESA"
				sql = sql & " INNER JOIN SCA_DISCIPLINA D ON D.COD_EMPRESA = HE.COD_EMPRESA AND D.COD_DISCIPLINA = HED.COD_DISCIPLINA "
				sql = sql & " INNER JOIN SCA_TURNO TU ON TU.COD_TURNO = T.Cod_TURNO AND TU.COD_EMPRESA = T.COD_EMPRESA "
				sql = sql & " WHERE A.COD_EMPRESA = " & Session("CodEmpresa")
				sql = sql & " AND AT.COD_TURMA = " & intCodTurma
		        sql = sql & " AND HED.COD_DISCIPLINA= " & intCodDisciplina
				sql = sql & " AND HED.ANO_LETIVO = " & strAnoLetivo
				sql = sql & " AND HED.SEMESTRE = " & intSemestre
				sql = sql & "AND A.CODIGO in (" & strAlunos & ") "
				sql = sql & " ORDER BY NOMEALUNO "
			end if
			rs.open sql, cnn,3,1
			%>		  
		  <table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela">
          <tr bgcolor="#E5E5E5">
            <td height="24" class="celula" width="3%">&nbsp;<strong>Seq.</strong></td>
            <td class="celula" width="6%">&nbsp;<strong>Matricula</strong></td>
            <td class="celula" width="30%" >&nbsp;<strong>Aluno</strong></td>
            <%
				for i=0 to ubound(vetCampo,2)
				%>
            		<td class="celula" align="center" width="10%"><strong><%=ucase(vetCampo(1,i))%></strong></td>
				<%
                next
			%>
            <td width="10%" align="center" class="celula"><strong>RESULTADO</strong></td>
          </tr>
		  <%
		  contLanc = 0
		  intQtdeRegistros = 0
		  if not rs.eof then
			  intQtdeRegistros = rs.recordCount
		  end if
		  while not rs.eof
		  		contLanc = contLanc + 1
				strCodAluno = RS("CODIGO")
				strCodAlunoZeros = ZeroLeft(RS("CODIGO"),10)  
				strCodHistoricoDisciplina = ""
				IF buscaHistorico = "S" then
					strCodHistoricoDisciplina = RS("COD_NOTA")
				end if

				IF TRIM(RS("SITUACAO"))="RN" THEN
					strStyle = "style='color:#FF0000'"
					strSituacaoFinal = TRIM(RS("SITUACAO"))
				ELSEIF TRIM(RS("SITUACAO"))="AP" THEN
					strStyle = "style='color:#0000FF'"
					strSituacaoFinal = TRIM(RS("SITUACAO"))
				END IF

				if buscaHistorico = "S" then
					%>
					<input class="text" type="HIDDEN" name="txtCodHistoricoDisciplina_<%=contLanc%>" value="<%=strCodHistoricoDisciplina%>">
					<%
				end if

				if buscaHistorico = "N" then
			
					' Início da Regra de reprovação por Falta
						SQL = "SELECT "
						SQL = SQL &   "Isnull(NF.falta01,'0') + Isnull(NF.falta02,'0') + Isnull(NF.falta03,'0') + Isnull(NF.falta04,'0') + Isnull(NF.falta05,'0') + Isnull(NF.falta06,'0') + Isnull(NF.falta07,'0') + Isnull(NF.falta08,'0') + Isnull(NF.falta09,'0') + Isnull(NF.falta10,'0') + Isnull(NF.falta11,'0') + Isnull(NF.falta12,'0') + Isnull(NF.falta13,'0') + Isnull(NF.falta14,'0') + Isnull(NF.falta15,'0') as totalfalta, "
						SQL = SQL & "AD.CODIGO AS COD_ALUNO_DISCIPLINA, "
						SQL = SQL & "AD.COD_ALUNO AS CODIGO, "
						SQL = SQL & "AD.COD_TURMA_REMANEJAMENTO AS COD_TURMA, "
						SQL = SQL & "AD.COD_DISCIPLINA, "
						SQL = SQL & "GCD.Ch_Anual "
						SQL = SQL & "FROM SCA_ALUNO_DISCIPLINA AD " 
						SQL = SQL & "INNER JOIN SCA_ALUNO A ON A.CODIGO = AD.COD_ALUNO " 
						SQL = SQL & "INNER JOIN SCA_NOTAS_FALTAS NF ON NF.cod_aluno_disciplina = AD.CODIGO " 
						SQL = SQL & "INNER JOIN SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurriculardisciplina = AD.COD_GRADECURRICULARDISCIPLINA "
						SQL = SQL & "WHERE AD.COD_EMPRESA = " & Session("CodEmpresa") 
						SQL = SQL & "AND AD.COD_TURMA_REMANEJAMENTO = " & intCodTurma 
						SQL = SQL & "AND A.CODIGO = " & strCodAluno 
						SQL = SQL & "AND AD.COD_DISCIPLINA = " & intCodDisciplina
						rs1.open sql, cnn
						if not rs1.eof then
						   if rs1("CH_ANUAL") = "" or rs1("CH_ANUAL") = "0" then
							  strCHDisciplina = 0
						   else  
							  strCHDisciplina = rs1("CH_ANUAL")
							  IF rs1("TOTALFALTA") = "" or rs1("TOTALFALTA") = "0" then
								 strTotalFaltas  = 0
							  else	 
								 strTotalFaltas  = rs1("TOTALFALTA")
							  end if	 
						   end if  
						   if strCHDisciplina = "0" or strCHDisciplina = "" then
							  strPercFaltas = 0 
						   else	
							  strPercFaltas = (strTotalFaltas * 100)/strCHDisciplina
						   end if	   
						else 
						   strPercFaltas = 0
						end if  
						rs1.close
						if strPercFaltas > intFrequenciaMinimaPerc then	
						   strSituacaoFinalFaltas = "RN"
						else
						   strSituacaoFinalFaltas = ""
						end if   
					' Fim da regra de reprovação por faltas	
				end if

			  	%>
			  <tr  <%=strCorPodeFazerAvaliacao%> onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)">
      		<td class="celula" width="5%">&nbsp;<input type="hidden" name="txtCodAlunoNota_<%=contLanc%>" value="<%=rs("COD_NOTA")%>"><%=contLanc%></td>
				<td class="celula" width="10%">&nbsp;<%=rs("MATRICULA")%><input type="hidden" name="txtCodAluno_<%=contLanc%>" value="<%=rs("CODIGO")%>"></td>
				<td class="celula" width="49%">&nbsp;<%=rs("NOMEALUNO")%><br>
				<input type="hidden" name="txtAlunoDisciplina_<%=contLanc%>" value="<%=rs("COD_ALUNO_DISCIPLINA")%>"></td>
            	<%
				for i=0 to ubound(vetCampo,2)
					strComplementoNota = "0"	
					if cInt(vetCampo(0,i))>9 then strComplementoNota = ""
					strNota = RS("NOTA" &strComplementoNota& vetCampo(0,i))
					strCampoEdicao = ""
					strStyleCampo = "text"
			  		strStyleFundoCelulaTabela = "" 
					if isnull(strNota) or strNota="" then
						strPodeFazerAlteracao = ""
					else
						'Encerramento das atividade esta como liberado, desconsidera a regra de bloqueio
						if intPermitirAlteracaoNotaDocente <> 9 then ' Liberado
							if strTipoAcessoCadastroNotas = "PROF" then 
							   strStyleCampo = "textDesabilitaSemCaixa"
							   strPodeFazerAlteracao = "readonly"
							   if trim(vetCampo(4,i)) = trim(intPermitirAlteracaoNotaDocente) then 
									strPodeFazerAlteracao = ""
								end if
							else
								strPodeFazerAlteracao = ""   
							end if   
						else
							strPodeFazerAlteracao = ""  
						end if
					end if
					
					if vetCampo(3,i) = "N" then 
						strCampoEdicao = "readonly"
						strStyleFundoCelulaTabela = "bgcolor='#D4D4D4'" 
					end if

					strComplemento = "0"
					if cInt(i)>9 then strComplemento = ""
					if CInt(intQtdeRegistros) = CInt(contLanc) then
						strProximoCampo = "btnSalvar"
					else
						strProximoCampo = "txtNota_" & contLanc+1 & "_" &strComplemento & i
					end if
					
					strMediaFinal = rs("MEDIA")
					IF ISNULL(strMediaFinal) THEN strMediaFinal = ""
	
					strStyle = ""
					if strMediaFinal <> "" then 
						if cCur(strMediaFinal)<cCur(intMediaAprovacao) then
							strStyle = "style='color:#FF0000'"
							strSituacaoFinal = "RN"
						else
							strStyle = "style='color:#0000FF'"
							strSituacaoFinal = "AP"
						end if
					end if

					
					%>
				  <td class="celula" align="center" <%=strStyleFundoCelulaTabela%>  >
                    <%
                    if vetCampo(3,i) = "N" then 
					%>
                    <%=strNota%>&nbsp;
                    <%
					else
					%>
                    <input <%=strPodeFazerAlteracao%> <%=strCampoEdicao%> onKeyUp="return controlaFoco('<%=strProximoCampo%>')" onBlur="return validaNota(this.value,'<%=strComplemento%><%=i%>','<%=contLanc%>')" type="text" class="<%=strStyleCampo%>" name="txtNota_<%=contLanc%>_<%=strComplemento%><%=i%>" id="txtNota_<%=contLanc%>_<%=strComplemento%><%=i%>" value="<%=strNota%>" size="4" maxlength="4" onKeyPress="return formataCampo(this,6,4)"  <%if vetCampo(4,i)="8" then response.Write strStyle%>>
                    <%
					end if
					%>                  </td>
				  <%
                next
				if strSituacaoFinalFaltas = "" then
					%>
					 <td class="celula" align="center" width="10%"><%=RS("SITUACAO")%>&nbsp;</td>
					</tr>
				  	<%
				else 
					%>
					 <td class="celula" align="center" width="10%"><font color='#FF0000'>RF (<%=round(strPercFaltas,2)%>%)</font></td>
					</tr>
				  	<%
				end if	
		  		rs.movenext
		  wend
		  rs.close
		  cnn.close
		  %>
        </table>
        <%if strTipoAcessoCadastroNotas = "PROF" then%>
<br>
        <table width="380" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><input type="text" class="textDesabilitaSemCaixa" name="legenda" size="4" maxlength="4"></td>
            <td class="TextoForm">Nota lan&ccedil;ada pelo professor n&atilde;o poder&aacute; ser alterada.</td>
          </tr>
        </table>
        <%end if%>

		<input type="hidden" name="strQuantNotasBimAtual" value="<%=strQuantNotas%>">
		<input type="hidden" name="qtdeAluno" value="<%=contLanc%>">
		<input type="hidden" name="cmbPeriodo" value="<%=intCodPeriodo%>">
		<input type="hidden" name="cmbSemestre" value="<%=intSemestre%>">
		<input type="hidden" name="chkTipoNota" value="<%=intCodTipoNota%>">
		<input type="hidden" name="cmbTurma" value="<%=intCodTurma%>">
        <input type="hidden" name="cmbTurmaProfessor" value="<%=intCodTurma%>">
		<input type="hidden" name="cmbTurno" value="<%=intCodTurno%>">
		<input type="hidden" name="chkAluno" value="<%=strAlunos%>">
		<input type="hidden" name="cmbTipoLancamento" value="<%=intCodTipoLancamento%>">
		<input type="hidden" name="cmbCurso" value="<%=intCodCurso%>">

		 <!--Armazena a média que o aluno deve alcançar para ser aprovado na disciplina-->
        <input type="Hidden" name="txtHiddenMediaAprovacao" value="<%=intMediaAprovacao%>"> 
		 <!--Armazena a média que o aluno deve alcançar para ser aprovado na disciplina-->
        <input type="Hidden" name="txtHiddenMediaAprovacaoFinal" value="<%=intMediaAprovacaoFinal%>"> 
        <!--Armazena a média que o aluno deve alcançar para ser aprovado na disciplina-->
        <input type="Hidden" name="txtHiddenTipoFormulaFinal" value="<%=strTipoFormulaFinal%>"> 
        <!--Armazena a média que o aluno deve alcançar para ser aprovado na disciplina-->
        <input type="Hidden" name="txtHiddenFreqMinima" value="<%=intFreqMinima%>"> 
        <!--Verifica se possui recuperação-->
        <input type="Hidden" name="txtHiddenRecuperacao" value="<%=strRecuperacao%>">	
        <!--Verifica se possui recuperação-->
        <input type="Hidden" name="txtHiddenConselho" value="<%=strConselho%>"> 
        <!--Verifica quantas disciplinas o aluno pode ficar de recuperação-->
        <input type="hidden" name="txtHiddenNumDisciplinaRec" value="<%=intNumDisciplinaRec%>"> 
        <!--Verifica quantas disciplinas o aluno pode ficar de prog. parcial-->
        <input type="hidden" name="txtHiddenNumDisciplinaProgParcial" value="<%=intNumDisciplinaProgParcial%>"> 
        <!--Verifica se haverá reprovação por falta para a prog. parcial-->
        <input type="hidden" name="txtHiddenReprovacaoFaltaProgParcial" value="<%=strReprovacaoFaltaProgParcial%>"> 
		<!--Verifica se haverá reprovação por falta para a prog. parcial-->
        <input type="hidden" name="txtHiddenNotaDoTipoEF" value="<%=strNotaDoTipoEF%>"> 	
		<br>
		  <input type="hidden" name="txtAnoLetivo" value="<%=strAnoLetivo%>">
		  <input type="hidden" name="txtSemestre" value="<%=intSemestre%>">
          <input type="hidden" name="txtPaginaRetorno" value="NOTA">
		</form>
		<br>
		</td>
      </tr>
    </table>
	</td>
  </tr>
</table>
<!--#include file="../rodape.asp"-->
<script>
	aguarde.style.display="none";
	document.all.txtNota_1_01.focus();
	document.all.txtNota_1_01.select();
</script>
</body>
</html>