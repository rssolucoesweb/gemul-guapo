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
<link href="../../estilo/css.css" rel="stylesheet" type="text/css">
</head>
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
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}
	
	function validaNota(valor, posicao){
		if (valor<0 || valor>10){
			alert("Atenção: nota inválida, deve estar entre 0 a 10!");
			document.all["txtNota_" + posicao].select();
			document.all["txtNota_" + posicao].style.backgroundColor = "#DAFA7A";
			document.all["txtNota_" + posicao].focus();
			return false;
		}else{
			if (valor.substring(0,2) == "10" && valor.substring(2,3) == "," && valor.substring(3,4) != "0") {
				alert("Atenção: nota inválida, deve estar entre 0 a 10!");
				document.all["txtNota_" + posicao].select();
				document.all["txtNota_" + posicao].style.backgroundColor = "#DAFA7A";
				document.all["txtNota_" + posicao].focus();
				return false;
			
			}
			document.all["txtNota_" + posicao].style.backgroundColor = "#FFB7B7";
			return true;
		}
	}	
	
	function salvar(acao){
		frm.action="Notas_cod.asp?acao=" + acao;
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
	
	intCodTurma 			= Trim(Request("cmbTurma"))
	intCodCurso	 			= Trim(Request("cmbCurso"))
	intCodPeriodo 			= Trim(Request("cmbPeriodo"))
	intSemestre 			= Trim(Request("cmbSemestre"))
	strAtivos               = trim(request("cmbativos"))
	
	intCodTurno		 		= Trim(Request("cmbTurno"))
	intCodDisciplina  		= trim(request("cmbDisciplinaTurma"))
	intCodDisciplinaTurma	= intCodDisciplina
	strAlunos      			= Trim(Request("chkAluno"))
	intCodTipoNota			= Trim(Request("chkTipoNota"))
	intCodTipoLancamento	= Trim(Request("cmbTipoLancamento")) '"0" '-->Nota e Falta | "1" '-->Somente Nota	| "2" '-->Somente Falta		
	bloqueiaAcumuladaFalta	= Trim(Request("cmbBloqueiaFaltas"))	
		
	buscaHistorico = "N"
	if trim(intSemestre) = "3" then
	   if trim(strAnoLetivo) <> trim(session("strAnoLetivo"))  then
	      buscaHistorico = "S"
		  msnHistorico  = "<font color='#0000FF'>(<strong>HISTÓRICO</strong>)</font>"
	   end if
	else
	   if trim(strAnoLetivo) <> trim(session("strAnoLetivo"))  or trim(intSemestre) <> trim(session("strSemestre")) then
		  buscaHistorico = "S"
		  msnHistorico  = "<font color='#0000FF'>(<strong>HISTÓRICO</strong>)</font>"
	   end if	   
    end if
	

	
	strNomedisciplina = ""
	sql = "SELECT DESC_DISCIPLINA FROM SCA_DISCIPLINA"
	sql = sql & " WHERE	COD_EMPRESA = " & Session("CodEmpresa") 
	sql = sql & " AND	COD_DISCIPLINA = " & intCodDisciplina
	rs.open sql, cnn
	if not rs.eof then
		strNomedisciplina = rs("DESC_DISCIPLINA")
	end if
	rs.close
	
	strNomeNota 		= ""
	strNomeTipoBimestre = ""
	strPosicao 			= ""
	strBimestreAtual 	= ""
	strBimestre1		= "1Bim"
	strBimestre2		= "2Bim"
	strBimestre3		= "3Bim"
	strBimestre4		= "4Bim"
	strExameFinal		= "5EF"
	strExameFinal		= "6CC"
	strCodBimestre		= ""
	strNotaDoTipoEF		= ""
	sql="SELECT CODIGO, DESCRICAO, POSICAO, BIMESTRE"
	sql=sql & " FROM  SCA_TIPO_AVALIACAO"
	sql=sql & " WHERE	COD_EMPRESA = " & Session("CodEmpresa") 
	sql=sql & " AND		CODIGO = " & intCodTipoNota
	rs.open sql, cnn
	if rs.eof = false then
		strNomeTipoBimestre 	= trim(rs("bimestre")) & "º Bimestre"
		strCodBimestre			= trim(rs("bimestre"))
		if trim(rs("bimestre")) = "5" then
			strNomeTipoBimestre = "Exame Final"		
			strNotaDoTipoEF		= "S"
		end if
		if trim(rs("bimestre")) = "6" then
			strNomeTipoBimestre = "Cons. Classe"		
		end if

		strNomeNota			 	= rs("DESCRICAO")
		strPosicao 				= ZeroLeft(rs("POSICAO"),2)
	end if
	rs.close
	
	strPosicaoNotas1Bim = "0"
	sql="Select TA.POSICAO "
	sql=sql & " from SCA_AVALIACAO A"
	sql=sql & " inner join SCA_CRITERIO_AVALIACAO CA ON CA.COD_EMPRESA = A.COD_EMPRESA"
	sql=sql & " and CA.CODIGO = A.CODCRITERIOAVALIACAO"
	sql=sql & " inner join SCA_TIPO_AVALIACAO TA ON TA.COD_EMPRESA = A.COD_EMPRESA"
	sql=sql & " and TA.CODIGO = A.CODTIPOAVALIACAO"
	sql=sql & " where A.cod_empresa = " & Session("CodEmpresa") 
	sql=sql & " and CA.cod_curso = " & intCodCurso
	sql=sql & " and TA.BIMESTRE = 1"
	rs.open sql, cnn
	if rs.eof = false then
		while not rs.eof
			strPosicaoNotas1Bim = strPosicaoNotas1Bim & "," & rs("posicao")
			rs.movenext
		wend
	end if
	rs.close	
	strPosicaoNotas2Bim = "0"
	sql="Select TA.POSICAO "
	sql=sql & " from SCA_AVALIACAO A"
	sql=sql & " inner join SCA_CRITERIO_AVALIACAO CA ON CA.COD_EMPRESA = A.COD_EMPRESA"
	sql=sql & " and CA.CODIGO = A.CODCRITERIOAVALIACAO"
	sql=sql & " inner join SCA_TIPO_AVALIACAO TA ON TA.COD_EMPRESA = A.COD_EMPRESA"
	sql=sql & " and TA.CODIGO = A.CODTIPOAVALIACAO"
	sql=sql & " where A.cod_empresa = " & Session("CodEmpresa") 
	sql=sql & " and CA.cod_curso = " & intCodCurso
	sql=sql & " and TA.BIMESTRE = 2"
	rs.open sql, cnn
	if rs.eof = false then
		while not rs.eof
			strPosicaoNotas2Bim = strPosicaoNotas2Bim & "," & rs("posicao")
			rs.movenext
		wend
	end if
	rs.close	
	strPosicaoNotas3Bim = "0"
	sql="Select TA.POSICAO "
	sql=sql & " from SCA_AVALIACAO A"
	sql=sql & " inner join SCA_CRITERIO_AVALIACAO CA ON CA.COD_EMPRESA = A.COD_EMPRESA"
	sql=sql & " and CA.CODIGO = A.CODCRITERIOAVALIACAO"
	sql=sql & " inner join SCA_TIPO_AVALIACAO TA ON TA.COD_EMPRESA = A.COD_EMPRESA"
	sql=sql & " and TA.CODIGO = A.CODTIPOAVALIACAO"
	sql=sql & " where A.cod_empresa = " & Session("CodEmpresa") 
	sql=sql & " and CA.cod_curso = " & intCodCurso
	sql=sql & " and TA.BIMESTRE = 3"
	rs.open sql, cnn
	if rs.eof = false then
		while not rs.eof
			strPosicaoNotas3Bim = strPosicaoNotas3Bim & "," & rs("posicao")
			rs.movenext
		wend
	end if
	rs.close	
	strPosicaoNotas4Bim = "0"
	sql="Select TA.POSICAO "
	sql=sql & " from SCA_AVALIACAO A"
	sql=sql & " inner join SCA_CRITERIO_AVALIACAO CA ON CA.COD_EMPRESA = A.COD_EMPRESA"
	sql=sql & " and CA.CODIGO = A.CODCRITERIOAVALIACAO"
	sql=sql & " inner join SCA_TIPO_AVALIACAO TA ON TA.COD_EMPRESA = A.COD_EMPRESA"
	sql=sql & " and TA.CODIGO = A.CODTIPOAVALIACAO"
	sql=sql & " where A.cod_empresa = " & Session("CodEmpresa") 
	sql=sql & " and CA.cod_curso = " & intCodCurso
	sql=sql & " and TA.BIMESTRE = 4"
	rs.open sql, cnn
	if rs.eof = false then
		while not rs.eof
			strPosicaoNotas4Bim = strPosicaoNotas4Bim & "," & rs("posicao")
			rs.movenext
		wend
	end if
	rs.close	
	strPosicaoNotasExameFinal = "0"
	sql="Select TA.POSICAO "
	sql=sql & " from SCA_AVALIACAO A"
	sql=sql & " inner join SCA_CRITERIO_AVALIACAO CA ON CA.COD_EMPRESA = A.COD_EMPRESA"
	sql=sql & " and CA.CODIGO = A.CODCRITERIOAVALIACAO"
	sql=sql & " inner join SCA_TIPO_AVALIACAO TA ON TA.COD_EMPRESA = A.COD_EMPRESA"
	sql=sql & " and TA.CODIGO = A.CODTIPOAVALIACAO"
	sql=sql & " where A.cod_empresa = " & Session("CodEmpresa") 
	sql=sql & " and CA.cod_curso = " & intCodCurso
	sql=sql & " and TA.BIMESTRE = 5"
	rs.open sql, cnn
	if rs.eof = false then
		while not rs.eof
			strPosicaoNotasExameFinal = strPosicaoNotasExameFinal & "," & rs("posicao")
			rs.movenext
		wend
	end if
	rs.close	
	strPosicaoNotasCC = "0"
	sql="Select TA.POSICAO "
	sql=sql & " from SCA_AVALIACAO A"
	sql=sql & " inner join SCA_CRITERIO_AVALIACAO CA ON CA.COD_EMPRESA = A.COD_EMPRESA"
	sql=sql & " and CA.CODIGO = A.CODCRITERIOAVALIACAO"
	sql=sql & " inner join SCA_TIPO_AVALIACAO TA ON TA.COD_EMPRESA = A.COD_EMPRESA"
	sql=sql & " and TA.CODIGO = A.CODTIPOAVALIACAO"
	sql=sql & " where A.cod_empresa = " & Session("CodEmpresa") 
	sql=sql & " and CA.cod_curso = " & intCodCurso
	sql=sql & " and TA.BIMESTRE = 6"
	rs.open sql, cnn
	if rs.eof = false then
		while not rs.eof
			strPosicaoNotasCC = strPosicaoNotasCC & "," & rs("posicao")
			rs.movenext
		wend
	end if
	rs.close	


	vetPosicaoNota1Bim 		= split(strPosicaoNotas1Bim,",")
	vetPosicaoNota2Bim 		= split(strPosicaoNotas2Bim,",")
	vetPosicaoNota3Bim 		= split(strPosicaoNotas3Bim,",")
	vetPosicaoNota4Bim 		= split(strPosicaoNotas4Bim,",")
	vetPosicaoNotaExameFinal= split(strPosicaoNotasExameFinal,",")
	vetPosicaoNotaCC		= split(strPosicaoNotasCC,",")
	
	strMostraNota = "style='display:block'"
	strMostraFalta = "style='display:block'"

	if intCodTipoLancamento = "0" then 
		strTipoLancamento = "NOTAS E FALTAS"
		strTipoLancamentoBotao = "Notas e Faltas"
	elseif intCodTipoLancamento = "1" then 
		strTipoLancamento = "NOTAS"
		strMostraNota = "style='display:block'"
		strMostraFalta = "style='display:none'"
		strTipoLancamentoBotao = "Notas"
	elseif intCodTipoLancamento = "2" then 
		strTipoLancamento = "FALTAS"
		strMostraNota = "style='display:none'"
		strMostraFalta = "style='display:block'"
		strTipoLancamentoBotao = "Faltas"
	end if
	
	if intCodDisciplina = "" then intCodDisciplina = "0"
	
	sql="select * from SCA_CRITERIO_AVALIACAO"
	sql=sql & " where	cod_empresa = "&Session("CodEmpresa") 
	sql=sql & " and		cod_curso	= "&intCodCurso
	rs.open sql, cnn
	if not rs.eof then
		strTipoFormulaFinal = rs("tipoFormulaFinal")
		strCondicaoEF_notaInicial = rs("condicaoEF_notaInicial")
		if isnull(strCondicaoEF_notaInicial) then strCondicaoEF_notaInicial = 0
		strCondicaoEF_notaFinal = rs("condicaoEF_notaFinal")
		if isnull(strCondicaoEF_notaFinal) then strCondicaoEF_notaFinal = 0
		
		if isnull(rs("peso_1bim")) = false then
			intPeso1Bim = rs("peso_1bim")
		else
			intPeso1Bim = 0
		end if
		
		if isnull(rs("peso_2bim")) = false then
			intPeso2Bim = rs("peso_2bim")
		else
			intPeso2Bim = 0			
		end if			
		
		if isnull(rs("peso_3bim")) = false then
			intPeso3Bim = rs("peso_3bim")
		else
			intPeso3Bim = 0			
		end if			
		
		if isnull(rs("peso_4bim")) = false then
			intPeso4Bim = rs("peso_4bim")
		else
			intPeso4Bim = 0			
		end if
		
		if isnull(rs("peso_EF")) = false then
			intPesoEF = rs("peso_EF")
		else
			intPesoEF = 0			
		end if
		
		'Armazena os pesos em uma string separada por ";" para ser utilizada na função calculaMedia
		strPesos = intPeso1Bim & ";" & intPeso2Bim & ";" & intPeso3Bim & ";"  & intPeso4Bim & ";" & intPesoEF
		
		if isnull(rs("formula")) = false then
			strFormula = rs("formula") 
		else
			strFormula = ""
		end if
		intMediaAprovacao     = rs("media_aprovacao")
		intMediaAprovacaoFinal = rs("media_aprovacao_final")
		intFreqMinima         = rs("frequencia_minima_percentual")
		
		if isnull(rs("num_disciplina_recuperacao")) = false then
			intNumDisciplinaRec   = rs("num_disciplina_recuperacao") 'Quantidade de disciplinas que o aluno pode ficar de recuperação
		else
			intNumDisciplinaRec = 0
		end if
		
		if isnull(rs("num_disciplina_prog_parcial")) = false then
			intNumDisciplinaProgParcial   = rs("num_disciplina_prog_parcial") 'Quantidade de disciplinas que o aluno pode ficar de prog. parcial
		else
			intNumDisciplinaProgParcial = 0
		end if	
		rs.close
	else
		rs.close
		%>
		<script>
			alert("O critério de avaliação não foi criado para esse curso.");
			window.location="Avaliacao_cad.asp?intCodCurso=<%=intCodCurso%>";
		</script>
		<%
		response.end
	end if
	
%>
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td>
	<table width="751"  height="325" border="0" cellspacing="0" cellpadding="0">
      <tr valign="top">
        <td colspan="2" align="center">
		<form id="frm" name="frm" method="post" action="notas_cad.asp">
		<input type="HIDDEN" name="txtPosicao" value="<%=strPosicao%>">
		<input type="HIDDEN" name="txtBimestreAtual" value="<%=strCodBimestre%>">
        <input type="HIDDEN" name="cmbativos" value="<%=strAtivos%>">
		  <table width="100%" border="0" cellpadding="0" cellspacing="0">

            <tr valign="top">
              <td width="100%" align="center" class="tituloSistema">Cadastro de Notas e Faltas <%=msnHistorico%></td>
            </tr>
          </table>
		  <br>
          <div align="center">
        <input onClick="salvar('I')" name="btnSalvar" value=" Salvar Notas e Faltas" type="button" class="botao">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
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
              <td colspan="3" class="celula">&nbsp;<!--#include file="../includes/inc_cmbDisciplinaTurma.asp"--></td>
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
			   sql = sql & " NF.nota" & strPosicao & " as NOTA, "
			   sql = sql & " NF.falta" & strPosicao & " as FALTA, "     
               sql = sql & " NF.codigo AS COD_NOTA, "
		       for i=0 to ubound(vetPosicaoNota1Bim)
			       if trim(vetPosicaoNota1Bim(i)) <> "0" then
					  strPos = ZeroLeft(vetPosicaoNota1Bim(i),2)
				  	  sql = sql & " 	NF.NOTA"&strPos&", "
			      	  sql = sql & " 	NF.FALTA"&strPos&", "
				   end if
				next
			    for i=0 to ubound(vetPosicaoNota2Bim)
			    	if trim(vetPosicaoNota2Bim(i)) <> "0" then
					   strPos = ZeroLeft(vetPosicaoNota2Bim(i),2)
					   sql = sql & " 	NF.NOTA"&strPos&", "
	     			   sql = sql & " 	NF.FALTA"&strPos&", "
					end if
				next
				for i=0 to ubound(vetPosicaoNota3Bim)
					if trim(vetPosicaoNota3Bim(i)) <> "0" then
						strPos = ZeroLeft(vetPosicaoNota3Bim(i),2)
						sql = sql & " 	NF.NOTA"&strPos&", "
						sql = sql & " 	NF.FALTA"&strPos&", "
					end if
				next
				for i=0 to ubound(vetPosicaoNota4Bim)
			      		if trim(vetPosicaoNota4Bim(i)) <> "0" then
						strPos = ZeroLeft(vetPosicaoNota4Bim(i),2)
						sql = sql & " 	NF.NOTA"&strPos&", "
						sql = sql & " 	NF.FALTA"&strPos&", "
				end if
				next
				for i=0 to ubound(vetPosicaoNotaExameFinal)
					if trim(vetPosicaoNotaExameFinal(i)) <> "0" then
			    	   strPos = ZeroLeft(vetPosicaoNotaExameFinal(i),2)
			           sql = sql & " 	NF.NOTA"&strPos&", "
					   sql = sql & " 	NF.FALTA"&strPos&", "
					end if
				next
				for i=0 to ubound(vetPosicaoNotaCC)
			    	if trim(vetPosicaoNotaCC(i)) <> "0" then
			    	   strPos = ZeroLeft(vetPosicaoNotaCC(i),2)
						sql = sql & " 	NF.NOTA"&strPos&", "
						sql = sql & " 	NF.FALTA"&strPos&", "
					end if
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
				sql = sql & " HED.nota" & strPosicao & " as NOTA, "
			    sql = sql & " HED.falta" & strPosicao & " as FALTA, "     
		       for i=0 to ubound(vetPosicaoNota1Bim)
			       if trim(vetPosicaoNota1Bim(i)) <> "0" then
					  strPos = ZeroLeft(vetPosicaoNota1Bim(i),2)
				  	  sql = sql & " 	HED.NOTA"&strPos&", "
			      	  sql = sql & " 	HED.FALTA"&strPos&", "
				   end if
				next
			    for i=0 to ubound(vetPosicaoNota2Bim)
			    	if trim(vetPosicaoNota2Bim(i)) <> "0" then
					   strPos = ZeroLeft(vetPosicaoNota2Bim(i),2)
					   sql = sql & " 	HED.NOTA"&strPos&", "
	     			   sql = sql & " 	HED.FALTA"&strPos&", "
					end if
				next
				for i=0 to ubound(vetPosicaoNota3Bim)
					if trim(vetPosicaoNota3Bim(i)) <> "0" then
						strPos = ZeroLeft(vetPosicaoNota3Bim(i),2)
						sql = sql & " 	HED.NOTA"&strPos&", "
						sql = sql & " 	HED.FALTA"&strPos&", "
					end if
				next
				for i=0 to ubound(vetPosicaoNota4Bim)
			      		if trim(vetPosicaoNota4Bim(i)) <> "0" then
						strPos = ZeroLeft(vetPosicaoNota4Bim(i),2)
						sql = sql & " 	HED.NOTA"&strPos&", "
						sql = sql & " 	HED.FALTA"&strPos&", "
				end if
				next
				for i=0 to ubound(vetPosicaoNotaExameFinal)
					if trim(vetPosicaoNotaExameFinal(i)) <> "0" then
			    	   strPos = ZeroLeft(vetPosicaoNotaExameFinal(i),2)
			           sql = sql & " 	HED.NOTA"&strPos&", "
					   sql = sql & " 	HED.FALTA"&strPos&", "
					end if
				next
				for i=0 to ubound(vetPosicaoNotaCC)
			    	if trim(vetPosicaoNotaCC(i)) <> "0" then
			    	   strPos = ZeroLeft(vetPosicaoNotaCC(i),2)
						sql = sql & " 	HED.NOTA"&strPos&", "
						sql = sql & " 	HED.FALTA"&strPos&", "
					end if
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
		  <table width="703" border="0" cellspacing="0" cellpadding="0" class="tabela">
          <tr bgcolor="#E5E5E5">
            <td height="24" class="celula">&nbsp;</td>
            <td class="celula">&nbsp;</td>
            <td class="celula">&nbsp;</td>
            <td colspan="3" align="center" class="celula" ><strong><%=ucase(strNomeTipoBimestre)%></strong></td>
            </tr>
          <tr bgcolor="#E5E5E5">
            <td height="24" class="celula">&nbsp;<strong>Seq.</strong></td>
            <td class="celula">&nbsp;<strong>Matrícula</strong></td>
            <td class="celula">&nbsp;<strong>Aluno</strong></td>
            <td class="celula" align="center" <%=strMostraNota%>><strong><%=strNomeNota%></strong></td>
            <td class="celula" align="center" <%=strMostraFalta%>><strong>FALTA</strong></td>
            <td align="center" class="celula" <%=strMostraFalta%>><strong>M&Eacute;DIA</strong></td>
            </tr>
		  <%
		  contLanc = 0
		  intQtdeRegistros = 0
		  if not rs.eof then
			  intQtdeRegistros = rs.recordCount
		  end if
		  while not rs.eof
		  		contLanc = contLanc + 1
				strNota = RS("NOTA")
				strFalta = RS("FALTA")
				strCodAluno = RS("CODIGO")
				strCodHistoricoDisciplina = ""
				IF buscaHistorico = "S" then
					strCodHistoricoDisciplina = RS("COD_NOTA")
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

				IF TRIM(RS("SITUACAO"))="RN" THEN
					strStyle = "style='color:#FF0000'"
					strSituacaoFinal = TRIM(RS("SITUACAO"))
				ELSEIF TRIM(RS("SITUACAO"))="AP" THEN
					strStyle = "style='color:#0000FF'"
					strSituacaoFinal = TRIM(RS("SITUACAO"))
				END IF
				strPodeFazerAvaliacao = ""
				strCorPodeFazerAvaliacao = ""
				if trim(strNotaDoTipoEF) = "S" then 
					if trim(strTipoFormulaFinal) = "EF" then
					if strMediaFinal<>"" then
							if cCur(strMediaFinal)>=cCur(strCondicaoEF_notaInicial) and cCur(strMediaFinal) < cCur(strCondicaoEF_notaFinal) then
								'poderá fazer a avaliação de Exame final
								strPodeFazerAvaliacao = ""
								strCorPodeFazerAvaliacao = ""
							else
								'não pode fazer avaliação de exame final
								if trim(strNota) = "" or isnull(strNota) then
									strPodeFazerAvaliacao = "readonly"
									strCorPodeFazerAvaliacao = "bgcolor='#F5CBCB'"
								end if
							end if
						end if
					end if
				end if
			  
				if buscaHistorico = "S" then
					%>
					<input class="text" type="HIDDEN" name="txtCodHistoricoDisciplina_<%=contLanc%>" value="<%=strCodHistoricoDisciplina%>">
					<%
				end if
				
				if CInt(intQtdeRegistros) = CInt(contLanc) then
					strProximoCampoNota = "txtFalta_" & contLanc
					strProximoCampoFalta = "btnSalvar"
				else
					strProximoCampoNota = "txtFalta_" & contLanc
					strProximoCampoFalta = "txtNota_" & contLanc+1
				end if
				
			  %>
			  <tr  <%=strCorPodeFazerAvaliacao%> onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)">
      		<td class="celula" width="5%">&nbsp;<input type="hidden" name="txtCodAlunoNota_<%=contLanc%>" value="<%=rs("COD_NOTA")%>"></td>
				<td class="celula" width="10%">&nbsp;<%=rs("MATRICULA")%><input type="hidden" name="txtCodAluno_<%=contLanc%>" value="<%=rs("CODIGO")%>"></td>
				<td class="celula" width="49%">&nbsp;<%=rs("NOMEALUNO")%><br>
				<input type="hidden" name="txtAlunoDisciplina_<%=contLanc%>" value="<%=rs("COD_ALUNO_DISCIPLINA")%>"></td>
				<td class="celula" width="12%" align="center"  <%=strMostraNota%>><input  onKeyUp="return controlaFoco('<%=strProximoCampoNota%>')" onBlur="return validaNota(this.value, '<%=contLanc%>')" type="text" class="text" name="txtNota_<%=contLanc%>" id="txtNota_<%=contLanc%>" value="<%=strNota%>" size="4" maxlength="4" onKeyPress="return formataCampo(this,6,4)" <%=strPodeFazerAvaliacao%>></td>
			    <td class="celula" width="13%" align="center"  <%=strMostraFalta%>><input onKeyUp="return controlaFoco('<%=strProximoCampoFalta%>')" <%=bloqueiaAcumuladaFalta%> type="text" class="text" id="txtFalta_<%=contLanc%>" name="txtFalta_<%=contLanc%>" value="<%=strFalta%>" size="4" maxlength="4" onKeyPress="return formataCampo(this,2,2)" <%=strPodeFazerAvaliacao%>></td>
			    <td class="celula" width="11%" align="center"  <%=strMostraFalta%>><input readonly type="text" class="textDesabilita" name="txtMediaFinal_<%=contLanc%>" value="<%if strMediaFinal <> "" then response.Write formatNumber(strMediaFinal,1) %>" size="4" <%=strStyle%> ><input readonly type="hidden" class="textDesabilita" name="txtSituacaoFinal_<%=contLanc%>" value="<%=strSituacaoFinal%>" size="4" <%=strStyle%> ></td>
			    </tr>
			  <%

				  intCont1Bim = 0
				  intCont2Bim = 0
				  intCont3Bim = 0
				  intCont4Bim = 0
				  intContExameFinal	= 0
				  intContCC	= 0
				  strNotaAcumulada1Bim = 0
				  strNotaAcumulada2Bim = 0
				  strNotaAcumulada3Bim = 0
				  strNotaAcumulada4Bim = 0
				  strNotaAcumuladaExameFinal = 0
				  strNotaAcumuladaCC = 0
			  
		  		rs.movenext
		  wend
		  rs.close
		  cnn.close
		  %>
        </table>
		<input type="hidden" name="strQuantNotasBimAtual" value="<%=strQuantNotas%>">
		<input type="hidden" name="qtdeAluno" value="<%=contLanc%>">
		<input type="hidden" name="cmbPeriodo" value="<%=intCodPeriodo%>">
		<input type="hidden" name="cmbSemestre" value="<%=intSemestre%>">
<!--		<input type="hidden" name="cmbDisciplinaTurma" value="<%'=intCodDisciplina%>">-->
		<input type="hidden" name="chkTipoNota" value="<%=intCodTipoNota%>">
		<input type="hidden" name="cmbTurma" value="<%=intCodTurma%>">
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
		<%
		
			strParametro = "Notas_con.asp?cmbPeriodo="&intCodPeriodo
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
	document.all.txtNota_1.focus();
	document.all.txtNota_1.select();
</script>
</body>
</html>