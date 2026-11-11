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

	'verifica se o usuario é professor ou admnistrativo
	sql = "select codigo "
	sql = sql & " from SRH_COLABORADOR"
	sql = sql & " where codigo_SEG_USUARIOS_SISTEMA = '" & trim(session("usuarioWeb")) & "'"
	sql = sql & " and codLotacao= " & Session("CodEmpresa")
	sql = sql & " and CodCategoria = 1"'professor
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

	strNomedisciplina = ""
	sql = "SELECT DESC_DISCIPLINA FROM SCA_DISCIPLINA"
	sql = sql & " WHERE	COD_EMPRESA = " & Session("CodEmpresa") 
	sql = sql & " AND	COD_DISCIPLINA in (" & intCodDisciplina & ")"
	rs.open sql, cnn
	if not rs.eof then
		strNomedisciplina = rs("DESC_DISCIPLINA")
	end if
	rs.close
	
	if intCodDisciplinaTurma = "0" then
		SQL = "SELECT     SCA_DISCIPLINA.Cod_Disciplina, SCA_DISCIPLINA.Desc_Disciplina, SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricularDisciplina"
		SQL = SQL & " FROM         SCA_TURMA INNER JOIN"
		SQL = SQL & "                       SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular INNER JOIN"
		SQL = SQL & "                       SCA_GRADECURRICULARDISCIPLINA ON "
		SQL = SQL & "                       SCA_GRADECURRICULAR.Cod_GradeCurricular = SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricular INNER JOIN"
		SQL = SQL & "                       SCA_DISCIPLINA ON SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = SCA_DISCIPLINA.Cod_Disciplina"
		SQL = SQL & " WHERE 1=1"
		SQL = SQL & " AND (SCA_TURMA.Cod_Turma = " & intCodTurma & ")"
		RS.OPEN SQL, CNN
		IF RS.EOF = FALSE THEN
			while not rs.eof
				if intCodDisciplina = "0" then intCodDisciplina = ""
				if intCodDisciplina = "" then
					intCodDisciplina = rs("Cod_Disciplina")
					strNomedisciplina = rs("Desc_Disciplina")
				else
					intCodDisciplina = intCodDisciplina & "," & rs("Cod_Disciplina")
					strNomedisciplina = strNomedisciplina & "<br>" & rs("Desc_Disciplina")
				end if
				rs.movenext
			wend
		END IF
		rs.close
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

	strParametro = "NotasRecalculo_con.asp?cmbPeriodo="&intCodPeriodo
	strParametro = strParametro & "&cmbSemestre="&intSemestre
	strParametro = strParametro & "&cmbDisciplinaTurma="&intCodDisciplina
	strParametro = strParametro & "&chkTipoNota="&intCodTipoNota
	strParametro = strParametro & "&cmbTurma="&intCodTurma
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
        <input type="hidden" name="txtRecalculo" id="txtRecalculo" value="S">
		<input type="HIDDEN" name="txtPosicao" value="<%=strPosicao%>">
        <input type="HIDDEN" name="cmbDisciplinaTurma" value="<%=intCodDisciplina%>">
		<input type="HIDDEN" name="txtBimestreAtual" value="<%=strCodBimestre%>">
        <input type="HIDDEN" name="cmbativos" value="<%=strAtivos%>">
		  <table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr valign="top">
              <td width="100%" align="center" class="tituloSistema"><br>
                Recalculo de Notas <%=msnTipoLanc%><%=msnHistorico%></td>
            </tr>
          </table>

		  <%
			sql = "SELECT TU.NOMETURMA, TU.ANO, TU.ANOLETIVO, T.DESC_TURNO "
			sql = sql & " FROM SCA_TURMA TU"
			sql = sql & " INNER JOIN SCA_TURNO T ON T.COD_TURNO = TU.COD_TURNO AND T.COD_EMPRESA = TU.COD_EMPRESA"
			sql = sql & " WHERE	TU.COD_EMPRESA = " & Session("CodEmpresa") 
			sql = sql & " AND	TU.COD_TURMA = " & intCodTurma
			rsAux.open sql, cnn
			if not rsAux.eof then
		  %>
		  <br>
<br>
<table width="703" border="0" cellspacing="0" cellpadding="0" class="tabela">
            <tr bgcolor="#E5E5E5">
              <td width="85" height="24" class="celula">&nbsp;<strong>Turma:</strong></td>
              <td width="262" class="celula">&nbsp;<%=rsAux("NOMETURMA")%></td>
              <td width="136" class="celula">&nbsp;<strong>Turno:</strong></td>
              <td width="219" class="celula">&nbsp;<%=rsAux("DESC_TURNO")%></td>
            </tr>
            <tr bgcolor="#E5E5E5">
              <td height="24" class="celula">&nbsp;<strong>Disciplinas:</strong></td>
              <td colspan="3" class="celula"><%=strNomedisciplina%></td>
              </tr>
          </table>
		  <%
		  end if
		  rsAux.close
		  %>
		 		  <br>
          <div align="center">
        <input onClick="salvar('I')" name="btnSalvar" value=" Iniciar Recalculo de M&eacute;dias" type="button" class="botao">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		  <input onClick="window.location='<%=strParametro%>'" name="btnVoltar" value="<< Voltar " type="button" class="botao">
          </div>
          <br>
			<%		 
			IF buscaHistorico = "N" then
			
			
			   sqlFiltroAluno = " SELECT DISTINCT AD.COD_ALUNO AS CODIGO	"
			   sqlFiltroAluno = sqlFiltroAluno & " FROM SCA_ALUNO_DISCIPLINA AD INNER JOIN " 
			   sqlFiltroAluno = sqlFiltroAluno & " SCA_ALUNO A ON A.CODIGO = AD.COD_ALUNO  INNER JOIN "
			   sqlFiltroAluno = sqlFiltroAluno & " SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = A.COD_SITUACAOALUNO AND SA.Cod_Empresa = A.COD_EMPRESA INNER JOIN "
			   sqlFiltroAluno = sqlFiltroAluno & " SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricularDisciplina = AD.COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO"
			   sqlFiltroAluno = sqlFiltroAluno & " WHERE AD.COD_EMPRESA = " & Session("CodEmpresa") 
			   sqlFiltroAluno = sqlFiltroAluno & " AND GCD.COD_DISCIPLINA in (" & intCodDisciplina & ")"
			   sqlFiltroAluno = sqlFiltroAluno & " AND AD.COD_TURMA_REMANEJAMENTO= " & intCodTurma
			   if strAtivos = "A" then	
				  sqlFiltroAluno = sqlFiltroAluno & " AND (SA.Desc_SituacaoAluno = 'ATIVO' OR SA.Desc_SituacaoAluno = 'PRÉ-MATRÍCULA') " 
			   end if	  
			
			   'SELECIONA OS ALUNOS REGULARES CONFORME DISCIPLINA CADASTRADA
	           sql = " SELECT "
			   sql = sql & " AD.COD_ALUNO AS CODIGO,"
				for n=1 to 15
					strComplemento = "0"	
					if cInt(n)>9 then strComplemento = ""
					sql = sql & " NF.nota" & strComplemento & n & ", "
				next
               sql = sql & " NF.codigo AS COD_NOTA "
				
				sql = sql & "FROM SCA_ALUNO_DISCIPLINA AD INNER JOIN "
 				sql = sql & "SCA_ALUNO A ON A.CODIGO = AD.COD_ALUNO  INNER JOIN "
 				sql = sql & "SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = A.COD_SITUACAOALUNO AND SA.Cod_Empresa = A.COD_EMPRESA INNER JOIN "
 				sql = sql & "SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurriculardisciplina = AD.COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO INNER JOIN "
 				sql = sql & "SCA_GRADECURRICULAR GC ON GC.Cod_GradeCurricular = GCD.Cod_GradeCurricular INNER JOIN "
 				sql = sql & "SCA_NOTAS_FALTAS NF ON NF.cod_aluno_disciplina = AD.CODIGO "
 				sql = sql & " WHERE AD.COD_EMPRESA = " & Session("CodEmpresa")
				sql = sql & " AND GCD.COD_DISCIPLINA in (" & intCodDisciplina & ")"
				sql = sql & " AND AD.COD_TURMA_REMANEJAMENTO =  " & intCodTurma
				sql = sql & " AND A.CODIGO in (" & sqlFiltroAluno & ") "
 				sql = sql & " ORDER BY AD.COD_ALUNO "
		     else

			   'seleciona os alunos pelo ano e semestres do histórico 			
			   sqlFiltroAluno = " select DISTINCT A.CODIGO"
			   sqlFiltroAluno = sqlFiltroAluno & " from SCA_HISTORICO_ESCOLAR_DISCIPLINA HED "
			   sqlFiltroAluno = sqlFiltroAluno & " INNER JOIN SCA_HISTORICO_ESCOLAR HE ON HE.CODIGO = HED.COD_HISTORICO_ESCOLAR "
			   sqlFiltroAluno = sqlFiltroAluno & " INNER JOIN SCA_ALUNO A ON A.CODIGO = HE.COD_ALUNO AND A.COD_EMPRESA = HE.COD_EMPRESA "
			   sqlFiltroAluno = sqlFiltroAluno & " INNER JOIN SCA_SITUACAOALUNO SA ON SA.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO AND SA.COD_EMPRESA = A.COD_EMPRESA " 
			   sqlFiltroAluno = sqlFiltroAluno & " INNER JOIN SCA_ALUNO_TURMA AT ON  AT.COD_ALUNO=A.CODIGO AND AT.COD_EMPRESA = A.COD_EMPRESA "
			   sqlFiltroAluno = sqlFiltroAluno & " WHERE A.COD_EMPRESA = " & Session("CodEmpresa")
			   sqlFiltroAluno = sqlFiltroAluno & " AND AT.COD_TURMA = " & intCodTurma	
			   sqlFiltroAluno = sqlFiltroAluno & " AND HE.ANO_LETIVO = " & strAnoLetivo
			   sqlFiltroAluno = sqlFiltroAluno & " AND HE.SEMESTRE = " & intSemestre 
			   sqlFiltroAluno = sqlFiltroAluno & " AND HED.COD_DISCIPLINA in (" & intCodDisciplina & ")"

		   		'HISTORICO ESCOLAR
				sql = " select DISTINCT A.CODIGO, "
				for n=1 to 15
					strComplemento = "0"	
					if cInt(n)>9 then strComplemento = ""
					sql = sql & " HED.nota" & strComplemento & n & ", "
				next
				sql = sql & " HED.CODIGO AS COD_NOTA "
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
		        sql = sql & " AND HED.COD_DISCIPLINA in (" & intCodDisciplina & ")"
				sql = sql & " AND HED.ANO_LETIVO = " & strAnoLetivo
				sql = sql & " AND HED.SEMESTRE = " & intSemestre
				sql = sql & " AND A.CODIGO in (" & sqlFiltroAluno & ") "
				sql = sql & " ORDER BY A.CODIGO "
			end if
			rs.open sql, cnn,3,1
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
				if buscaHistorico = "S" then
					%>
					<input class="text" type="HIDDEN" name="txtCodHistoricoDisciplina_<%=contLanc%>" value="<%=strCodHistoricoDisciplina%>">
					<%
				end if
			  	%>
			  	<input type="hidden" name="txtCodAlunoNota_<%=contLanc%>" value="<%=rs("COD_NOTA")%>">
				<input type="hidden" name="txtCodAluno_<%=contLanc%>" value="<%=rs("CODIGO")%>">
            	<%
				for i=0 to ubound(vetCampo,2)
					strComplementoNota = "0"	
					if cInt(vetCampo(0,i))>9 then strComplementoNota = ""
					strNota = RS("NOTA" &strComplementoNota& vetCampo(0,i))
					strComplemento = "0"
					if cInt(i)>9 then strComplemento = ""
                    if vetCampo(3,i) <> "N" then 
					%>
                    <input type="hidden" name="txtNota_<%=contLanc%>_<%=strComplemento%><%=i%>" id="txtNota_<%=contLanc%>_<%=strComplemento%><%=i%>" value="<%=strNota%>" >
                    <%
					end if
					%>
				  <%
                next
		  		rs.movenext
		  wend
		  rs.close
		  cnn.close
		  %>
        
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