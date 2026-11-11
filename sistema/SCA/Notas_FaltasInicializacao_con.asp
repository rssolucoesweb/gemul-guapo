<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>

<!--include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->

<html>
<head>
<title><%=session("Titulo")%></title>
<link type="text/css" rel="stylesheet" href="../../Estilo/css.css">
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script src="../../js/js_funcoes_gerais.js"></script>
<script type="text/javascript" src="../../js/js_dragdrop.js"></script>
<!--include file="../../includes/inc_validaPermissaoPagina.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file=../../includes/inc_aguarde.asp-->
<script>

	function AlunoFoto(codAluno){
		window.open("AlunoFoto_con.asp?codAluno="+codAluno,"consulta", "top=0,left=0,height=400,width=578,menubar=no,toolbar=no,scrollbars=yes,status=yes");
	}
	
	function cadastrarNotas(){
		var form = window.document.forms[0];
		var intContMarcado=0;
		var strAlunos='';
		var strEja='';
		
		if (frm.cmbSemestre.value == 0){
			alert("O Semestre deve ser informado!");
			frm.cmbSemestre.focus();
			return false;
		}
		if (frm.cmbTurma.value == 0){
			alert("A turma deve ser informada!");
			frm.cmbTurma.focus();
			return false;
		}		
		if (frm.cmbDisciplinaTurma.value == 0){
			alert("A disciplina deve ser informada!");
			frm.cmbDisciplinaTurma.focus();
			return false;
		}		
	
		//*****verifica se um aluno foi selecionado
		intContMarcado=0;
		for (var i = 0; i < form.elements.length; i++) {
			//verifica todos os checkbox
			if (form.elements[i].type == "checkbox"){
				if (form.elements[i].name == "chkAluno"){
					//verifica se o checkbox está marcado
					if (form.elements[i].checked){
						intContMarcado = intContMarcado + 1;
					}
				}
			}
		}	
		if (intContMarcado==0){
			alert("O(s) aluno(s) deve(m) ser informado(s)!");
			return false;
		}
		
		frm.action = "Notas_FaltasInicializacao_cod.asp";
		frm.submit();
		
		return true;	
	}
</script>
<%
strPaginaTitulo = "Notas_FaltasInicializacao_con.asp"

strExecutarSubmitCurso	  			= "S"
strExecutarSubmitPeriodo  			= "S"
strExecutarSubmitSemestre 			= "S"
strExecutarSubmitTurno	 			= "S"
strExecutarSubmitTurma	  			= "S"
strExecutarSubmitSitDisciplina      = "S"

intSemestre = session("strSemestre")
if trim(request("txtAnoLetivo")) = "" then 
	strAnoLetivo = session("strAnoLetivo")
else
	strAnoLetivo = request.Form("txtAnoLetivo")
end if
intSemestre 			= Trim(Request("cmbSemestre"))
if Trim(Request("cmbSemestre")) = "" then intSemestre = Trim(Request.form("cmbSemestre"))
if intSemestre = "" then intSemestre = session("strSemestre")

if Trim(Request("txtAnoLetivo")) = "" then strAnoLetivo	= Trim(Request.form("txtAnoLetivo"))
if strAnoLetivo = "" then strAnoLetivo = session("strAnoLetivo")

intCodCurso	 			= Trim(Request("cmbCurso"))
intCodPeriodo 			= Trim(Request("cmbPeriodo"))
intCodTurno		 		= Trim(Request("cmbTurno"))
intCodPlanoPagamento	= Trim(Request("cmbPlanoPagamento"))
strSala		 			= Trim(Request("txtSala"))
intCodTipoLancamento    = trim(request("cmbTipoLancamento"))
intCodTurma 			= Trim(Request("cmbTurma"))
intCodDisciplinaTurma	= trim(request("cmbDisciplinaTurma"))
intCodDisciplina	   	= trim(request("cmbDisciplinaTurma"))
intCodTurmaProfessor	= intCodTurma
strSituacaoDisciplina 	= Trim(Request("cmbSituacaoDisciplina"))
strAtivos               = trim(request("cmbativos"))
strVerificaHistorico    = Trim(Request("optVerificaHistorico"))


if intCodComp = "" then intCodComp = "0"
if intCodSerie = "" then intCodSerie = "0"
if intCodTurno = "" then intCodTurno = "0"
if intCodTurma = "" then intCodTurma = "0"
if intCodSemestre = "" then intCodSemestre = "0"
if intCodTipoLancamento = "" then intCodTipoLancamento = "0"
if intCodDisciplinaTurma = "" then intCodDisciplinaTurma = "0"
if strVerificaHistorico = "" then strVerificaHistorico = "N"

sql = " SELECT SCA_TURMA.cod_turma, SCA_TURMA.cod_Semestre , SCA_PERIODO.Cod_Curso, SCA_PERIODO.Cod_Periodo, SCA_TURMA.cod_turno, SCA_TURMA.Sala, SCA_TURMA.NomeTurma"
sql = sql & " FROM SCA_TURMA "
sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
sql = sql & " INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo"
SQL = SQL & " WHERE SCA_TURMA.cod_empresa=" & Session("CodEmpresa")
sql = sql & " AND SCA_TURMA.Cod_Turma= " & intCodTurma
RS.OPEN SQL, CNN
IF not RS.EOF THEN
	intCodCurso 	= rs("cod_curso")
	intCodPeriodo = rs("cod_periodo")
	intCodTurno = rs("cod_turno")
	intSemestre = rs("cod_Semestre")
END IF
rs.close

strSituacaoTurmaCad = ""
sql = "SELECT SCA_TURMA.SITUACAO"
sql = sql & " FROM SCA_TURMA "
sql = sql & " WHERE SCA_TURMA.cod_empresa=" & Session("CodEmpresa")
sql = sql & " AND SCA_TURMA.Cod_Turma= " & intCodTurma
RS.OPEN sql, CNN
IF not RS.EOF THEN
	strSituacaoTurmaCad = rs("Situacao")
END IF
rs.close

strSituacaoTurmaFechada = "N"
sql = "SELECT Cod_Turma "
sql = sql & " FROM SCA_CONTROLE_FECHAMENTO "
sql = sql & " WHERE Cod_Turma= " & intCodTurma
RS.OPEN sql, CNN
IF not RS.EOF THEN
	strSituacaoTurmaFechada = "S"
END IF
rs.close


'controla os botões
strDesabilitaIncluir = "disabled"
strDesabilitaExcluir = "disabled"
strDesabilitaAlterar = ""
strDesabilitaLimpar = ""

%>
<form method="post" id="frm" action="Notas_FaltasInicializacao_con.asp">
<input  name="cmbCurso1" type="hidden" id="cmbCurso" value="<%=intCodCurso%>">
<input  name="cmbPeriodo1" type="hidden" id="cmbPeriodo" value="<%=intCodPeriodo%>">

<table width="100%" border="0" cellpadding="0" bgcolor="#FFFFFF" cellspacing="0">
<tr valign="top">
<td  align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
</tr>
</table>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="2" bgcolor="#FFFFFF">
<tr>
<td width="15%" class="texto1">Ano Letivo:</td>
<td width="85%" colspan="2"><input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
</tr>
<tr>
<td class="texto1">Semestre:</td>
<td colspan="2"><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
</tr>
  <tr>
  <td width="15%" class="texto1">Curso:</td>
  <td><span class="texto1">
    <!--#include file="../includes/inc_cmdCurso.asp"-->
    - Opcional</span></td>
</tr>
    <tr>
      <td class="texto1">Per&iacute;odo/Módulo:</td>
      <td colspan="3" class="texto1"><!--#include file="../includes/inc_cmdPeriodo.asp"-->
        <span class="texto1">- Opcional</span></td>
    </tr>
<tr> 
    <td class="texto1">Turma: </td>
    <td colspan="2"><!--#include file="../includes/inc_cmdTurma.asp"--></td>
</tr>
<tr>
  <td class="texto1">Disciplina Turma: </td>
  <td colspan="2"><!--#include file="../includes/inc_cmbDisciplinaTurma.asp"--></td>
</tr>
    <tr>
      <td class="texto1">Situa&ccedil;&atilde;o Disciplinar:</td>
      <td colspan="2"><!--#include file="../includes/inc_cmdSituacaoDisciplina.asp"--></td>
    </tr>
    <tr>
  <td class="texto1">Situa&ccedil;&otilde;es:</td>
  <td colspan="2"><!--#include file="../includes/inc_cmbAtivos.asp"--></td>
</tr>
    <tr>
      <td class="texto1">Inicializar NOTAS?</td>
      <td colspan="2"><span class="texto1">
        <input type="checkbox" name="InicializaNotas" value="S">
      </span></td>
    </tr>
    <tr>
      <td class="texto1">Inicializar FALTAS?</td>
      <td colspan="2"><span class="texto1">
        <input type="checkbox" name="InicializaFaltas" value="S">
      </span></td>
    </tr>
    <% if strSituacaoTurmaFechada = "S" then %>
        <tr>
          <td class="texto1">Buscar Hist&oacute;rico:</td>
          <td colspan="2" class="texto1">
          <input  <% if strVerificaHistorico = "S" then response.Write("checked")%> name="optVerificaHistorico" type="radio" value="S"  onClick="submit()"> Sim <br> 
          <input <% if strVerificaHistorico = "N" then response.Write("checked")%> name="optVerificaHistorico" type="radio" value="N" onClick="submit()"> Não </td>
        </tr>
    <% end if %>
    <tr>
      <td class="texto1">&nbsp;</td>
      <td colspan="2">&nbsp;</td>
    </tr>
<tr> 
  <td colspan="3" class="texto1">Obs: Para acessar dados de notas e faltas no hist&oacute;rico, &eacute; necess&aacute;rio apenas informar o ANO ou SEMESTRE anterior ao atual. </td>
</tr>
<tr align="center"> 
  <td colspan="3" class="texto1"></td>
</tr>
     <tr> 
     <td colspan="3"><hr size="1" color="#CCCCCC"></td>
     </tr>
     <tr> 
     <td colspan="3"><input type="button" name="cmdCadastrar" value="Inicializar<%=strMsnBotaoHistorico%>" class="botao" onClick="return cadastrarNotas()"> 
     <input type="button" name="cmdLimpar"  value="Limpar"  class="botao" <%=strDesabilitaLimpar%>  onClick="window.location='Notas_FaltasInicializacao_con.asp'"> 
     <input class="botao" type="button" value="Principal" name="BtnFechar" onClick="window.navigate('default.asp')">      </td>
     </tr>
     <tr> 
     <td colspan="3" class="texto1"> <br> <%
	 if intCodTurma    = "" then intCodTurma="0"
	 if intCodSemestre = "" then intCodSemestre="0"
	 if intCodTurma<>"0" and intCodDisciplinaTurma<>"0" then%> 
		<table class="tabela" width="98%" align="center" border="1" cellpadding="0" cellspacing="0">
        <tr class="CabecalhoConsulta"> 
        <td width="32" align="center" class="celula"><div align="center"><input type="checkbox" name="chkTodos" onClick="return MarcaTodos(this.checked)">
          </div></td><td width="47" class="celula"><strong>Ordem</strong></td>
        <td width="66" class="celula"><strong>Matr&iacute;cula</strong></td>
        <td width="46" class="celula"><strong>Tipo</strong></td>
        <td width="874" class="celula"><strong>Nome</strong></td>
        <td width="80" align="center" class="celula"><strong>Situa&ccedil;&atilde;o</strong></td>
        <td width="113" align="center" class="celula"><strong>Visualizar Foto</strong></td>
        </tr>

        <%	
		'seleciona os alunos da turma através de sua disciplina
		Cont=0

		buscaHistorico = "N"
		if trim(intSemestre) = "3" then
		   if trim(strAnoLetivo) < trim(session("strAnoLetivo"))  then
			  buscaHistorico = "S"
		   end if
		else
		   if trim(strAnoLetivo) <> trim(session("strAnoLetivo"))  or trim(intSemestre) <> trim(session("strSemestre")) then
			  buscaHistorico = "S"
		   end if	   
		end if
		
		if strSituacaoTurmaCad = "S" then buscaHistorico = "N"  'Turmas sem fechamento
		if strVerificaHistorico = "S" then buscaHistorico = "S" 'Turmas já fechada com opcao de busca pelo histórico
		if strVerificaHistorico = "N" then buscaHistorico = "N" 'Turmas já fechada com opcao de busca pelo histórico

	    if buscaHistorico = "N" then

		   sql = " SELECT AD.CODIGO AS COD_ALUNO_DISCIPLINA, "
		   sql = sql & " AD.COD_ALUNO AS CODIGO, " 
		   sql = sql & " AD.COD_TURMA_REMANEJAMENTO AS COD_TURMA, "
		   sql = sql & " GCD.COD_DISCIPLINA, "
		   sql = sql & " A.NOMEALUNO, "
		   sql = sql & " A.MATRICULA, "
		   sql = sql & " '' AS SEQUENCIA, "
		   sql = sql & " AD.SITUACAO AS SITUACAO_DISCIPLINA, "
		   sql = sql & " SA.DESC_SITUACAOALUNO "
		   sql = sql & " FROM SCA_ALUNO_DISCIPLINA AD INNER JOIN " 
		   sql = sql & " SCA_ALUNO A ON A.CODIGO = AD.COD_ALUNO  INNER JOIN "
		   sql = sql & " SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = A.COD_SITUACAOALUNO AND SA.Cod_Empresa = A.COD_EMPRESA INNER JOIN "
		   sql = sql & " SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricularDisciplina = AD.COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO"
		   sql = sql & " WHERE AD.COD_EMPRESA = " & Session("CodEmpresa") 
		   sql = sql & " AND GCD.COD_DISCIPLINA= " & intCodDisciplinaTurma
		   sql = sql & " AND AD.COD_TURMA_REMANEJAMENTO= " & intCodTurma
		   if strAtivos = "A" then	
  		      sql = sql & "AND (SA.Desc_SituacaoAluno = 'ATIVO' OR SA.Desc_SituacaoAluno = 'PRÉ-MATRÍCULA') " 
		   end if	  
            
		   if strTipoAcessoCadastroNotas = "PROF" then	
			   ' faz filtro do acompanhamento - Variavel será alimentada somente pela include inc_cmdVerificaAcompanhamento.asp.
			   if strAcompanhamento <> "0" and strAcompanhamento <> "" then  
			   		sql = sql & " and AD.SITUACAO = '" & strAcompanhamento & "'"
			   end if	
				'
		   else	
			   ' faz filtro do acompanhamento - Variavel será alimentada somente pela include inc_cmdSituacaoDisciplina.asp.
				if strSituacaoDisciplina <> "0" then 
					sql = sql & " and AD.SITUACAO = '" & strSituacaoDisciplina & "'"
				end if	
				'
			end if	

		   sql = sql & " ORDER BY A.NOMEALUNO "
		else 

		   'seleciona os alunos pelo ano e semestres do histórico 			
		   sql = " select DISTINCT A.CODIGO, HED.COD_TURMA, HED.COD_DISCIPLINA, A.NOMEALUNO, A.MATRICULA,  '' AS SEQUENCIA, SA.DESC_SITUACAOALUNO, situacao_disciplinar AS SITUACAO_DISCIPLINA "
		   sql = sql & " from SCA_HISTORICO_ESCOLAR_DISCIPLINA HED "
		   sql = sql & " INNER JOIN SCA_HISTORICO_ESCOLAR HE ON HE.CODIGO = HED.COD_HISTORICO_ESCOLAR "
		   sql = sql & " INNER JOIN SCA_ALUNO A ON A.CODIGO = HE.COD_ALUNO AND A.COD_EMPRESA = HE.COD_EMPRESA "
		   sql = sql & " INNER JOIN SCA_SITUACAOALUNO SA ON SA.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO " 
		   'sql = sql & " INNER JOIN SCA_ALUNO_TURMA AT ON  AT.COD_ALUNO=A.CODIGO AND AT.COD_EMPRESA = A.COD_EMPRESA " Seu Uso era para os casos sem turmas 
		   sql = sql & " WHERE A.COD_EMPRESA = " & Session("CodEmpresa")
		   sql = sql & " AND HE.ANO_LETIVO = " & strAnoLetivo
		   sql = sql & " AND HE.SEMESTRE = " & intSemestre 
		   sql = sql & " AND HED.COD_TURMA = " & intCodTurma	
		   sql = sql & " AND HED.COD_DISCIPLINA= " & intCodDisciplinaTurma
		   ' faz filtro do acompanhamento - Variavel será alimentada somente pela include inc_cmdSituacaoDisciplina.asp.
			if strSituacaoDisciplina <> "0" then 
				sql = sql & " and HED.situacao_disciplinar = '" & strSituacaoDisciplina & "'"
			end if	
			'
		   sql = sql & " ORDER BY NOMEALUNO "
        end if
       	rs.open sql, cnn
		if rs.eof = false then
   		   while not rs.eof
		      
			  strCodAluno             = rs("CODIGO")
			  intCodEmp               = Session("CodEmpresa") 
			  strDesabilitaAluno 	  	= ""
			  strSituacaoAluno 		= ""
			  
		      if buscaHistorico = "N" then
				  strCodAlunoDisciplina  	= rs("COD_ALUNO_DISCIPLINA")
				  if strCodAlunoDisciplina <> "0" then
					 'VERIFICA SE EXISTE REGISTRO DE NOTAS PARA O ALUNO 
					 sql = "SELECT COD_ALUNO_DISCIPLINA "
					 sql = sql & " FROM SCA_NOTAS_FALTAS "
					 sql = sql & " WHERE	COD_ALUNO_DISCIPLINA = " & strCodAlunoDisciplina
					 rsAux.open sql, cnn
					 if rsAux.eof then
						strDesabilitaAluno 	= " disabled "
						strSituacaoAluno	= " <strong>(Não não existe registro de notas)</strong>"
					end if
					rsAux.close
				 end if
			 end if	 
			 strMatricula		          = rs("MATRICULA")
			 strDesc_SituacaoAluno		  = rs("Desc_SituacaoAluno")
			 'Função que verifica a siuação do aluno
			 strSituacaoPromocao = "" 'Não é necessário mostrar a situação promoção nesta tela
			 cont = cont + 1
			 %>
             <tr> 
             <td class="celula" align="center"><input type="hidden" value="<%=strCodAlunoDisciplina%>" name="txtCodAlunoDisciplina"><input type="checkbox" id="chkAluno" name="chkAluno" <%=strDesabilitaAluno%> value="<%=rs("codigo")%>"></td>
             <td class="celula"><div align="center"><%=zeroleft(cont,2)%>&nbsp;</div></td>
             <td class="celula"><%=strMatricula%></td>
             <td class="celula"><div align="center"><%=rs("SITUACAO_DISCIPLINA")%>&nbsp;</div></td>
             <td class="celula"><%=rs("NOMEALUNO") & " " & strSituacaoAluno%></td>
             <td align="center" class="celula"><%=strDesc_SituacaoAluno%></td>
			 <td align="center" class="celula" onClick="AlunoFoto('<%=strCodAluno%>')"><a href="#"><img src="../../images/logo_camera.gif" width="22" height="18"></a></td>
             </tr>
             <%
			 rs.movenext
		  wend
	  else
 	     %>
         <tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"> 
         <td colspan="7" align="center" class="celula"><%=session("strMensagemNaoEncontrado")%></td>
         </tr>
         <%
	  end if
 	  rs.close
   end if
   %>
   </table></td>
   </tr>
   </table>
</form>
<!--#include file="../rodape.asp"-->
<script>
	aguarde.style.display="none";
</script>
</body>
</html>
