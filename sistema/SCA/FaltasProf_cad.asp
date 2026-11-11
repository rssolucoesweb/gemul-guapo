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
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script src="../../js/js_funcoes_gerais.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file=../../includes/inc_aguarde.asp-->
<script>

	function ExcluirFalta(CodFalta, CodAluno, AlunoDisc, Falta, CodHistoricoDisciplina){
		var men = 'ATENÇÃO: \nA falta do aluno será excluida, deseja continuar?';
		if (confirm(men)) {
			frm.action="Faltas_exc.asp?txtAluno=" + CodAluno + "&txtAlunoDisc=" + AlunoDisc + "&txtCodFalta=" + CodFalta + "&Falta=" + Falta + "&txtCodHistoricoDisciplina=" + CodHistoricoDisciplina;
			frm.submit();
			return true;
		}
	}

	function resultadoConsulta(intCodigo){
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}
	
	
	function salvar(acao){
		frm.action="Faltas_cod.asp?ret=FaltasProf_cad.asp&acao=" + acao;
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
	strData		 		= Trim(Request("txtData"))	
	
	'GRAVANDO SOMENTE NO ARQUIVO DE NOTAS
	strGravarOnde = "NOTA"
	msnHistorico  = ""
	
	intCodTurma 			= Trim(Request("cmbTurmaProfessor"))
	intCodCurso	 			= Trim(Request("cmbCurso"))
	intCodPeriodo 			= Trim(Request("cmbPeriodo"))
	intSemestre 			= Trim(Request("cmbSemestre"))
	
	intCodTurno		 		= Trim(Request("cmbTurno"))
	intCodDisciplina  		= trim(request("cmbDisciplinaDoProfessor"))
	strAlunos      			= Trim(Request("chkAluno"))
	intCodTipoNota			= Trim(Request("chkTipoNota"))
	intCodTipoLancamento	= Trim(Request("cmbTipoLancamento")) '"0" '-->Nota e Falta | "1" '-->Somente Nota	| "2" '-->Somente Falta		
	
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
		<form id="frm" method="post">
		<input type="hidden" name="txtPosicao" value="<%=strPosicao%>">
		<input type="HIDDEN" name="txtBimestreAtual" value="<%=strCodBimestre%>">
		<input type="HIDDEN" name="txtData" value="<%=strData%>">
		  <table width="100%" border="0" cellpadding="0" cellspacing="0">

            <tr valign="top">
              <td width="100%" align="center" class="tituloSistema">Cadastro de Faltas <%=msnHistorico%></td>
            </tr>
          </table>
		  <br>
		  <%
			sql = "SELECT TU.NOMETURMA, TU.ANO, TU.ANOLETIVO, T.DESC_TURNO "
			sql = sql & " FROM SCA_TURMA TU"
			sql = sql & " INNER JOIN SCA_TURNO T ON T.COD_TURNO = TU.COD_TURNO AND T.COD_EMPRESA = TU.COD_EMPRESA"
			sql = sql & " WHERE	TU.COD_EMPRESA = " & Session("CodEmpresa") 
			sql = sql & " AND	TU.COD_TURMA = " & intCodTurma
			rs.open sql, cnn
			if not rs.eof then
		  %>
		  <table width="703" border="0" cellspacing="0" cellpadding="0" class="tabela">
            <tr bgcolor="#E5E5E5">
              <td width="85" height="24" class="celula">&nbsp;<strong>Turma:</strong></td>
              <td width="262" class="celula">&nbsp;<%=RS("NOMETURMA")%></td>
              <td width="136" class="celula">&nbsp;<strong>Turno:</strong></td>
              <td width="219" class="celula">&nbsp;<%=RS("DESC_TURNO")%></td>
            </tr>
            <tr bgcolor="#E5E5E5">
              <td height="24" class="celula">&nbsp;<strong>Disciplina:</strong></td>
              <td colspan="3" class="celula">&nbsp;<%=strNomedisciplina%></td>
              </tr>
          </table>
		  <%
		  end if
		  rs.close
		  %>
		  <br>
			<%		 
			IF TRIM(strGravarOnde) = "NOTA" THEN
				
				'**** SELECIONA OS ALUNOS REGULARES E NOTAS E FALTAS
				sql = " SELECT SCA_ALUNO.CODIGO, "
				sql = sql & " 	SCA_ALUNO.MATRICULA, "
				sql = sql & " 	SCA_ALUNO.NOMEALUNO, "
				sql = sql & " 	SCA_ALUNO_TURMA.SEQUENCIA, "
				sql = sql & " 	SCA_ALUNO_TURMA.COD_TURMA, "
				sql = sql & " 	SCA_GRADECURRICULAR.Cod_Periodo, "
				sql = sql & " 	SCA_NOTAS_FALTAS.FALTA" & strPosicao & " as FALTA, "
	
				for i=0 to ubound(vetPosicaoNota1Bim)
					if trim(vetPosicaoNota1Bim(i)) <> "0" then
						strPos = ZeroLeft(vetPosicaoNota1Bim(i),2)
						sql = sql & " 	SCA_NOTAS_FALTAS.FALTA"&strPos&", "
					end if
				next
				for i=0 to ubound(vetPosicaoNota2Bim)
					if trim(vetPosicaoNota2Bim(i)) <> "0" then
						strPos = ZeroLeft(vetPosicaoNota2Bim(i),2)
						sql = sql & " 	SCA_NOTAS_FALTAS.FALTA"&strPos&", "
					end if
				next
				for i=0 to ubound(vetPosicaoNota3Bim)
					if trim(vetPosicaoNota3Bim(i)) <> "0" then
						strPos = ZeroLeft(vetPosicaoNota3Bim(i),2)
						sql = sql & " 	SCA_NOTAS_FALTAS.FALTA"&strPos&", "
					end if
				next
				for i=0 to ubound(vetPosicaoNota4Bim)
					if trim(vetPosicaoNota4Bim(i)) <> "0" then
						strPos = ZeroLeft(vetPosicaoNota4Bim(i),2)
						sql = sql & " 	SCA_NOTAS_FALTAS.FALTA"&strPos&", "
					end if
				next
				for i=0 to ubound(vetPosicaoNotaExameFinal)
					if trim(vetPosicaoNotaExameFinal(i)) <> "0" then
						strPos = ZeroLeft(vetPosicaoNotaExameFinal(i),2)
						sql = sql & " 	SCA_NOTAS_FALTAS.FALTA"&strPos&", "
					end if
				next
				for i=0 to ubound(vetPosicaoNotaCC)
					if trim(vetPosicaoNotaCC(i)) <> "0" then
						strPos = ZeroLeft(vetPosicaoNotaCC(i),2)
						sql = sql & " 	SCA_NOTAS_FALTAS.FALTA"&strPos&", "
					end if
				next
	
				sql = sql & " 	SCA_ALUNO_DISCIPLINA.CODIGO AS COD_ALUNO_DISCIPLINA, "
				sql = sql & " 	SCA_NOTAS_FALTAS.CODIGO AS COD_NOTA, "
				sql = sql & " 	SCA_NOTAS_FALTAS.SITUACAO"
				sql = sql & " FROM SCA_ALUNO_TURMA "
				sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO AND SCA_ALUNO_TURMA.COD_EMPRESA = SCA_ALUNO.COD_EMPRESA "
				sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma  AND SCA_ALUNO_TURMA.ANO_LETIVO = SCA_TURMA.AnoLetivo AND SCA_ALUNO_TURMA.SEMESTRE = SCA_TURMA.Cod_Semestre AND SCA_ALUNO_TURMA.cod_empresa = SCA_TURMA.cod_empresa "
				sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular AND SCA_TURMA.COD_EMPRESA = SCA_GRADECURRICULAR.COD_EMPRESA "
				sql = sql & " INNER JOIN SCA_ALUNO_DISCIPLINA ON SCA_ALUNO_DISCIPLINA.COD_ALUNO = SCA_ALUNO.CODIGO AND SCA_TURMA.Cod_Turma = SCA_ALUNO_DISCIPLINA.COD_TURMA AND SCA_TURMA.COD_EMPRESA = SCA_ALUNO_DISCIPLINA.COD_EMPRESA LEFT JOIN SCA_NOTAS_FALTAS ON SCA_NOTAS_FALTAS.COD_ALUNO = SCA_ALUNO.CODIGO AND SCA_NOTAS_FALTAS.COD_EMPRESA = SCA_ALUNO_DISCIPLINA.COD_EMPRESA AND SCA_NOTAS_FALTAS.COD_DISCIPLINA = SCA_ALUNO_DISCIPLINA.COD_DISCIPLINA AND SCA_NOTAS_FALTAS.COD_ALUNO_DISCIPLINA = SCA_ALUNO_DISCIPLINA.CODIGO "
				sql = sql & " where SCA_TURMA.cod_empresa = " & Session("CodEmpresa")
				sql = sql & " AND SCA_ALUNO_TURMA.COD_TURMA = " & intCodTurma
				sql = sql & " AND SCA_ALUNO_DISCIPLINA.COD_DISCIPLINA = " & intCodDisciplina
				sql = sql & " AND SCA_ALUNO.CODIGO in (" & strAlunos & ") "
				sql = sql & " and 	SCA_ALUNO_TURMA.situacao = 'A'"
				sql = sql & " and 	SCA_ALUNO_TURMA.Ano_Letivo = " & strAnoLetivo
				sql = sql & " and 	SCA_ALUNO_TURMA.Semestre = " & intSemestre
				sql = sql & " ORDER BY SCA_ALUNO.NOMEALUNO"
			
			ELSEIF TRIM(strGravarOnde) = "HISTORICO" THEN
			
				sql = " SELECT SCA_ALUNO.CODIGO, "
				sql = sql & " 	SCA_ALUNO.MATRICULA, "
				sql = sql & " 	SCA_ALUNO.NOMEALUNO, "
				sql = sql & " 	SCA_ALUNO_TURMA.SEQUENCIA, "
				sql = sql & " 	SCA_ALUNO_TURMA.COD_TURMA, "
				sql = sql & " 	SCA_GRADECURRICULAR.Cod_Periodo, "
				sql = sql & " 	SCA_HISTORICO_ESCOLAR_DISCIPLINA.FALTA" & strPosicao & " as FALTA, "
	
				for i=0 to ubound(vetPosicaoNota1Bim)
					if trim(vetPosicaoNota1Bim(i)) <> "0" then
						strPos = ZeroLeft(vetPosicaoNota1Bim(i),2)
						sql = sql & " 	SCA_HISTORICO_ESCOLAR_DISCIPLINA.FALTA"&strPos&", "
					end if
				next
				for i=0 to ubound(vetPosicaoNota2Bim)
					if trim(vetPosicaoNota2Bim(i)) <> "0" then
						strPos = ZeroLeft(vetPosicaoNota2Bim(i),2)
						sql = sql & " 	SCA_HISTORICO_ESCOLAR_DISCIPLINA.FALTA"&strPos&", "
					end if
				next
				for i=0 to ubound(vetPosicaoNota3Bim)
					if trim(vetPosicaoNota3Bim(i)) <> "0" then
						strPos = ZeroLeft(vetPosicaoNota3Bim(i),2)
						sql = sql & " 	SCA_HISTORICO_ESCOLAR_DISCIPLINA.FALTA"&strPos&", "
					end if
				next
				for i=0 to ubound(vetPosicaoNota4Bim)
					if trim(vetPosicaoNota4Bim(i)) <> "0" then
						strPos = ZeroLeft(vetPosicaoNota4Bim(i),2)
						sql = sql & " 	SCA_HISTORICO_ESCOLAR_DISCIPLINA.FALTA"&strPos&", "
					end if
				next
				for i=0 to ubound(vetPosicaoNotaExameFinal)
					if trim(vetPosicaoNotaExameFinal(i)) <> "0" then
						strPos = ZeroLeft(vetPosicaoNotaExameFinal(i),2)
						sql = sql & " 	SCA_HISTORICO_ESCOLAR_DISCIPLINA.FALTA"&strPos&", "
					end if
				next
				for i=0 to ubound(vetPosicaoNotaCC)
					if trim(vetPosicaoNotaCC(i)) <> "0" then
						strPos = ZeroLeft(vetPosicaoNotaCC(i),2)
						sql = sql & " 	SCA_HISTORICO_ESCOLAR_DISCIPLINA.FALTA"&strPos&", "
					end if
				next
	
				sql = sql & " 	SCA_ALUNO_DISCIPLINA.CODIGO AS COD_ALUNO_DISCIPLINA, "
				sql = sql & " 	SCA_HISTORICO_ESCOLAR_DISCIPLINA.CODIGO AS COD_NOTA, SCA_HISTORICO_ESCOLAR_DISCIPLINA.CODIGO AS CODHISTORICODISCIPLINA, "
				sql = sql & " 	SCA_HISTORICO_ESCOLAR_DISCIPLINA.SITUACAO"
				sql = sql & " FROM SCA_ALUNO_TURMA "
				sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO AND SCA_ALUNO_TURMA.COD_EMPRESA = SCA_ALUNO.COD_EMPRESA "
				sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma  AND SCA_ALUNO_TURMA.ANO_LETIVO = SCA_TURMA.AnoLetivo AND SCA_ALUNO_TURMA.SEMESTRE = SCA_TURMA.Cod_Semestre AND SCA_ALUNO_TURMA.cod_empresa = SCA_TURMA.cod_empresa "
				sql = sql & " INNER JOIN SCA_TURNO ON SCA_TURNO.COD_TURNO = SCA_TURMA.Cod_TURNO AND SCA_TURNO.COD_EMPRESA = SCA_TURMA.COD_EMPRESA "
				sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular AND SCA_TURMA.COD_EMPRESA = SCA_GRADECURRICULAR.COD_EMPRESA "
				sql = sql & " INNER JOIN SCA_ALUNO_DISCIPLINA ON SCA_ALUNO_DISCIPLINA.COD_ALUNO = SCA_ALUNO.CODIGO AND SCA_TURMA.Cod_Turma = SCA_ALUNO_DISCIPLINA.COD_TURMA AND SCA_TURMA.COD_EMPRESA = SCA_ALUNO_DISCIPLINA.COD_EMPRESA "
				sql = sql & " INNER JOIN SCA_DISCIPLINA ON SCA_DISCIPLINA.COD_EMPRESA = SCA_ALUNO_DISCIPLINA.COD_EMPRESA AND SCA_DISCIPLINA.COD_DISCIPLINA = SCA_ALUNO_DISCIPLINA.COD_DISCIPLINA "
				sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA ON SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricularDisciplina = SCA_ALUNO_DISCIPLINA.Cod_GradeCurricularDisciplina AND SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = SCA_ALUNO_DISCIPLINA.Cod_Disciplina "
				sql = sql & " INNER JOIN SCA_HISTORICO_ESCOLAR  ON SCA_HISTORICO_ESCOLAR.COD_ALUNO = SCA_ALUNO.CODIGO AND SCA_HISTORICO_ESCOLAR.COD_EMPRESA = SCA_ALUNO_DISCIPLINA.COD_EMPRESA "
				sql = sql & " INNER JOIN SCA_HISTORICO_ESCOLAR_DISCIPLINA ON SCA_HISTORICO_ESCOLAR_DISCIPLINA.COD_HISTORICO_ESCOLAR = SCA_HISTORICO_ESCOLAR.CODIGO AND SCA_HISTORICO_ESCOLAR_DISCIPLINA.COD_DISCIPLINA = SCA_ALUNO_DISCIPLINA.COD_DISCIPLINA AND SCA_HISTORICO_ESCOLAR_DISCIPLINA.COD_ALUNO_DISCIPLINA = SCA_ALUNO_DISCIPLINA.CODIGO "
				sql = sql & " where SCA_TURMA.cod_empresa = " & Session("CodEmpresa")
				sql = sql & " AND SCA_ALUNO_TURMA.COD_TURMA = " & intCodTurma
				sql = sql & " AND SCA_ALUNO_DISCIPLINA.COD_DISCIPLINA = " & intCodDisciplina
				sql = sql & " AND SCA_ALUNO.CODIGO in (" & strAlunos & ") "
				sql = sql & " and 	SCA_ALUNO_TURMA.situacao = 'A'"
				sql = sql & " and 	SCA_ALUNO_TURMA.Ano_Letivo = " & strAnoLetivo
				sql = sql & " and 	SCA_ALUNO_TURMA.Semestre = " & intSemestre
				sql = sql & " ORDER BY SCA_ALUNO.NOMEALUNO"	
			END IF
'response.Write(sql)
'response.End()
			rs.open sql, cnn
			%>		  
		  <table width="703" border="0" cellspacing="0" cellpadding="0" class="tabela">
          <tr bgcolor="#E5E5E5">
            <td height="24" colspan="3" align="center" class="celula"><strong>Data: <%=formatadataAP(strData)%></strong></td>
            <td align="center" class="celula" ><strong><%=ucase(strNomeTipoBimestre)%></strong></td>
            </tr>
          <tr bgcolor="#E5E5E5">
            <td height="24" class="celula">&nbsp;<strong>Seq.</strong></td>
            <td class="celula">&nbsp;<strong>Matrícula</strong></td>
            <td class="celula">&nbsp;<strong>Aluno</strong></td>
            <td class="celula" align="center"><strong>FALTA&nbsp;<%=strNomeNota%></strong></td>
            </tr>
		  <%
		  contLanc = 0
		  intCont1Bim = 0
		  intCont2Bim = 0
		  intCont3Bim = 0
		  intCont4Bim = 0
		  while not rs.eof
		  		contLanc = contLanc + 1
				strFalta = RS("FALTA")
				strCodAluno = RS("CODIGO")
				strCodHistoricoDisciplina = ""
				IF TRIM(strGravarOnde) = "HISTORICO" THEN
					strCodHistoricoDisciplina = RS("CODHISTORICODISCIPLINA")
				END IF

				IF TRIM(strGravarOnde) = "HISTORICO" THEN
					%>
					<input class="text" type="HIDDEN" name="txtCodHistoricoDisciplina_<%=contLanc%>" value="<%=strCodHistoricoDisciplina%>">
					<%
				END IF
				
				strFaltaInicial = ""
				strCorPodeFazerAvaliacao = ""
				strPodeFazerAvaliacao = ""
				strCodFalta = ""
				SQL = "SELECT CODIGO, FALTA FROM SCA_FALTAS_DIARIA "
				SQL = SQL & " WHERE cod_empresa="&Session("CodEmpresa")
				SQL = SQL & " AND cod_aluno="&strCodAluno
				SQL = SQL & " AND cod_aluno_disciplina="&rs("COD_ALUNO_DISCIPLINA")
				SQL = SQL & " AND cod_periodo="&intCodPeriodo
				SQL = SQL & " AND ano_letivo="&strAnoLetivo
				SQL = SQL & " AND semestre="&intSemestre
				SQL = SQL & " AND cod_disciplina="&intCodDisciplina
				SQL = SQL & " AND data='"&formatadataBD(strData) & "'"
				rsAux.open sql, cnn				
				if not rsAux.eof then
					strCorPodeFazerAvaliacao = " bgcolor='#FFCCFF' "
					strFaltaInicial = rsAux("falta")
					strPodeFazerAvaliacao = "disabled"
					strCodFalta = rsAux("CODIGO")
				end if
				rsAux.close
			  %>
			  <tr  <%=strCorPodeFazerAvaliacao%> onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)">
				<td class="celula" width="5%">&nbsp;<%=rs("SEQUENCIA")%><input type="hidden" name="txtCodAlunoNota_<%=contLanc%>" value="<%=rs("COD_NOTA")%>"></td>
				<td class="celula" width="10%">&nbsp;<%=rs("MATRICULA")%><input type="hidden" name="txtCodAluno_<%=contLanc%>" value="<%=rs("CODIGO")%>"></td>
				<td class="celula" width="49%">&nbsp;<%=rs("NOMEALUNO")%><br>
				<input type="hidden" name="txtAlunoDisciplina_<%=contLanc%>" value="<%=rs("COD_ALUNO_DISCIPLINA")%>"></td>
			    <td class="celula" width="13%" align="left">&nbsp;&nbsp;<input type="text" class="text" name="txtFalta_<%=contLanc%>" value="<%=strFaltaInicial%>" size="4" maxlength="4" onKeyPress="return formataCampo(this,2,2)" <%=strPodeFazerAvaliacao%>>
				<%if strPodeFazerAvaliacao <> "" then%>
			    <a href="#" onClick="ExcluirFalta('<%=strCodFalta%>','<%=strCodAluno%>','<%=rs("COD_ALUNO_DISCIPLINA")%>','<%=strFaltaInicial%>','<%=strCodHistoricoDisciplina%>')"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image1<%=rs("codigo")%>','','<%=session("strCaminhoRaiz")%>/images/botao_vermelho_over.gif',1)"><img alt="Clique para excluir a falta do aluno." align="absmiddle" src="<%=session("strCaminhoRaiz")%>/images/botao_vermelho_normal.gif" name="Image1<%=rs("codigo")%>" width="26" height="26" border="0"></a>
				<%end if%>
				</td>
			    </tr>
			  <%

				  intCont1Bim = 0
				  intCont2Bim = 0
				  intCont3Bim = 0
				  intCont4Bim = 0
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
		<input type="hidden" name="cmbDisciplinaTurma" value="<%=intCodDisciplina%>">
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
		
			strParametro = "FaltasProf_con.asp?cmbPeriodo="&intCodPeriodo
			strParametro = strParametro & "&cmbSemestre="&intSemestre
			strParametro = strParametro & "&cmbDisciplinaTurma="&intCodDisciplina
			strParametro = strParametro & "&chkTipoNota="&intCodTipoNota
			strParametro = strParametro & "&cmbTurma="&intCodTurma
			strParametro = strParametro & "&chkAluno="&strAlunos
			strParametro = strParametro & "&cmbTurno="&intCodTurno
			strParametro = strParametro & "&cmbTipoLancamento="&intCodTipoLancamento	
			strParametro = strParametro & "&cmbCurso="&intCodCurso	
			strParametro = strParametro & "&txtData="&strData
		
		%>
		<br>
		<div align="center"><input onClick="salvar('I')" name="btnSalvar" value=" Salvar Faltas" type="button" class="botao">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		  <input onClick="window.location='<%=strParametro%>'" name="btnVoltar" value="<< Voltar " type="button" class="botao"></div>
		  <input type="hidden" name="txtAnoLetivo" value="<%=strAnoLetivo%>">
		  <input type="hidden" name="txtSemestre" value="<%=intSemestre%>">
          <input type="hidden" name="txtPaginaRetorno" value="FALTASPROF">
		</form>
		<br>
		<table cellpadding="0" cellspacing="0" border="1" width="521">
		<tr>
		  <td bgcolor="#FFCCFF"  width="68">&nbsp;</td>
		<td width="441" class="texto"><strong>&nbsp;&nbsp;J&aacute; foram lan&ccedil;adas faltas para esse aluno neste dia </strong></td>
		</tr>
		</table>
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
</script>
</body>
</html>