<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>

<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 27/11/2007
	::	Data de Atualização...: 02/05/2011
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Notas
-->

<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->

<%

'verifica se o usuario é professor ou admnistrativo
intSemestre = session("strSemestre")
if trim(request("txtAnoLetivo")) = "" then 
	strAnoLetivo = session("strAnoLetivo")
else
	strAnoLetivo = request.Form("txtAnoLetivo")
end if

sql = "select codigo "
sql = sql & " from SRH_COLABORADOR"
sql = sql & " where codigo_SEG_USUARIOS_SISTEMA = '" & trim(session("usuarioWeb")) & "'"
sql = sql & " and codLotacao= " & Session("CodEmpresa")
sql = sql & " and (CodCategoria = 1 or CodCategoria = 8)"'professor
sql = sql & " and Situacao = 'A'"'ativo
rs.open sql, cnn
if rs.eof then
	strTipoAcessoCadastroNotas = "ADM"
	intSemestre 			= Trim(Request("cmbSemestre"))
else
	strTipoAcessoCadastroNotas = "PROF"
	intCodColaboradorProfessor = rs("codigo")
	strExecutarSubmitDisciplinaDoProfessor = "S"
	strAnoLetivo = session("strAnoLetivo")
	intSemestre = session("strSemestre")

end if
rs.close

%>
<html>
<head>
<title><%=session("Titulo")%></title>
<link type="text/css" rel="stylesheet" href="../../Estilo/css.css"></head>
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
		
		var frm = document.getElementById("frm");
		var form = window.document.forms[0];
		var intContMarcado=0;
		var strAlunos='';
		var strEja='';
		
		if (frm.cmbSemestre.value == 0){
			alert("O Semestre deve ser informado!");
			frm.cmbSemestre.focus();
			return false;
		}
		
		<%if strTipoAcessoCadastroNotas = "ADM" then%>		
			
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
		
		<%elseif strTipoAcessoCadastroNotas = "PROF" then%>	
		
			if (frm.cmbTurmaProfessor.value == 0){
				alert("A turma deve ser informada!");
				frm.cmbTurmaProfessor.focus();
				return false;
			}		
			
			if (frm.cmbDisciplinaDoProfessor.value == 0){
				alert("A disciplina deve ser informada!");
				frm.cmbDisciplinaDoProfessor.focus();
				return false;
			}		
		<%end if%>
	
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
		
		frm.action = "NotasNovo_cad.asp";
		frm.submit();
		return true;	
	}
</script>
<%
strPaginaTitulo = "NotasNovo_con.asp"

strExecutarSubmitCurso	  = "S"
strExecutarSubmitPeriodo  = "S"
strExecutarSubmitSemestre = "S"
strExecutarSubmitTurno	  = "S"
strExecutarSubmitTurma	  = "S"

intCodCurso	 			= Trim(Request("cmbCurso"))
intCodPeriodo 			= Trim(Request("cmbPeriodo"))

intCodGrade				= Trim(Request("cmbGrade"))
intCodTurno		 		= Trim(Request("cmbTurno"))
intCodPlanoPagamento	= Trim(Request("cmbPlanoPagamento"))
strSala		 			= Trim(Request("txtSala"))
intAno		 			= Trim(Request("txtAno"))
intAnoLetivo 			= Trim(Request("txtAnoLetivo"))
intCodTipoLancamento    = trim(request("cmbTipoLancamento"))

strFalhaNotasFaltas	= Trim(Request.Form("txtFalhaNotasFaltas"))
ckFalhaNotasFaltas = ""
if strFalhaNotasFaltas = "S" then ckFalhaNotasFaltas = " checked "	

if strTipoAcessoCadastroNotas = "ADM" then
	intCodTurma 			= Trim(Request("cmbTurma"))
	intCodDisciplinaTurma	= trim(request("cmbDisciplinaTurma"))
	intCodDisciplina	   	= trim(request("cmbDisciplinaTurma"))
	intCodTurmaProfessor	= intCodTurma

	strBloqueia_NotasSecretaria = ""
	sql = " SELECT top 1 Bloqueia_NotasSecretaria "
	sql = sql & " FROM SEG_ENCERRAMENTOATIVIDADES "
	sql = sql & " Where cod_empresa = " & Session("CodEmpresa")
	rs.Open SQL, cnn
	if rs.EOF = false then								
		strBloqueia_NotasSecretaria  = trim(rs("Bloqueia_NotasSecretaria"))
	end if
	rs.close
	if strBloqueia_NotasSecretaria = "S" then
		%>
		<script>
			alert("Sistema Bloqueado para Lancamento, procure a Secretaria Geral.");
			window.history.back();
		</script>
		<%
	end if
	
end if

if strTipoAcessoCadastroNotas = "PROF" then
	intCodDisciplina  		= trim(request("cmbDisciplinaDoProfessor"))
	intCodDisciplinaTurma	= trim(request("cmbDisciplinaDoProfessor"))
	intCodTurma			 	= Trim(Request("cmbTurmaProfessor"))
	intCodTurmaProfessor	= intCodTurma
	
	' Verifica a liberação da secretaria para o professor lançar notsa
	strBloqueia_NotasDocente = ""
	sql = " SELECT top 1 Bloqueia_NotasDocente, Bloqueia_CampoAcumuladaFalta "
	sql = sql & " FROM SEG_ENCERRAMENTOATIVIDADES "
	sql = sql & " Where cod_empresa = " & Session("CodEmpresa")
	rs.Open SQL, cnn
	if rs.EOF = false then								
		strBloqueia_NotasDocente        = trim(rs("Bloqueia_NotasDocente"))
	end if
	rs.close
	if strBloqueia_NotasDocente = "S" then
		%>
		<script>
			alert("ATENÇÃO: \n\nAplicação Bloqueada para Lançamento, procure a Secretaria Geral.");
			window.history.back();
		</script>
		<%	
		response.End()
	end if	

end if
strAtivos               = trim(request("cmbativos"))

strFiltroSerie = "0"
strFiltroTurno = "0"

if intCodComp = "" then intCodComp = "0"
if intCodSerie = "" then intCodSerie = "0"
if intCodTurno = "" then intCodTurno = "0"
if intCodTurma = "" then intCodTurma = "0"
if intCodSemestre = "" then intCodSemestre = "0"
if intCodTipoLancamento = "" then intCodTipoLancamento = "0"
if intCodDisciplinaTurma = "" then intCodDisciplinaTurma = "0"

sql = "SELECT SCA_TURMA.cod_turma, SCA_TURMA.cod_Semestre , SCA_PERIODO.Cod_Curso, SCA_PERIODO.Cod_Periodo, SCA_TURMA.cod_turno, SCA_TURMA.Sala, SCA_TURMA.NomeTurma"
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
'controla os botões
strDesabilitaIncluir = "disabled"
strDesabilitaExcluir = "disabled"
strDesabilitaAlterar = ""
strDesabilitaLimpar = ""

%>
<form method="post" id="frm" action="NotasNovo_con.asp">
<input  name="cmbCurso" type="hidden" id="cmbCurso" value="<%=intCodCurso%>">
<input  name="cmbPeriodo" type="hidden" id="cmbPeriodo" value="<%=intCodPeriodo%>">

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
<%IF strTipoAcessoCadastroNotas = "ADM" then%>
<tr> 
    <td class="texto1">Turma: </td>
    <td colspan="2"><!--#include file="../includes/inc_cmdTurma.asp"--></td>
</tr>
<tr>
  <td class="texto1">Disciplina Turma: </td>
  <td colspan="2"><!--#include file="../includes/inc_cmbDisciplinaTurma.asp"--></td>
</tr>
<%end if%> 
<%IF strTipoAcessoCadastroNotas = "PROF" then%>
<tr> 
  <td class="texto1">Turma Professor: </td>
  <td colspan="2"><!--#include file="../includes/inc_cmdTurmaProfessor_NotasFaltas.asp"--></td>
</tr>

<tr>
  <td class="texto1">Disciplina Professor: </td>
  <td colspan="2"><!--#include file="../includes/inc_cmdDisciplinaDoProfessor.asp"--></td>
</tr>
<%end if%> 
<tr>
  <td class="texto1">Situa&ccedil;&otilde;es:</td>
  <td colspan="2"><!--#include file="../includes/inc_cmbAtivos.asp"--></td>
</tr>
<tr>
  <td class="texto1">Atualizar  Registro de Notas</td>
  <td colspan="2" class="texto1"><input <%=ckFalhaNotasFaltas%> name="txtFalhaNotasFaltas" id="txtFalhaNotasFaltas" type="checkbox"  onClick='submit()' value="S">
 - Marcar apenas quando aparecer a seguinte mensagem no nome do aluno - (N&atilde;o existe registro de notas)</td>
</tr>
<tr>
  <td colspan="3" class="texto1">&nbsp;</td>
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
     <td colspan="3"><input type="button" name="cmdCadastrar" value="Cadastrar<%=strMsnBotaoHistorico%>" class="botao" onClick="return cadastrarNotas()"> 
     <input type="button" name="cmdLimpar"  value="Limpar"  class="botao" <%=strDesabilitaLimpar%>  onClick="window.location='notasNovo_con.asp'"> 
     <input class="botao" type="button" value="Principal" name="BtnFechar" onClick="window.navigate('default.asp')">      </td>
     </tr>
     <tr> 
     <td colspan="3" class="texto1"> <br> <%
	 if intCodTurma    = "" then intCodTurma="0"
	 if intCodSemestre = "" then intCodSemestre="0"
	 if intCodTurma<>"0" and intCodDisciplinaTurma<>"0" then%> 
		<table class="tabela" width="98%" align="center" border="1" cellpadding="0" cellspacing="0">
        <tr class="CabecalhoConsulta"> 
        <td width="36" align="center" class="celula">&nbsp;&nbsp;
        <input type="checkbox" name="chkTodos" onClick="return MarcaTodos(this.checked)"></td><td width="48" class="celula"><strong>Ordem</strong></td>
        <td width="67" class="celula"><strong>Matr&iacute;cula</strong></td>
        <td width="583" class="celula"><strong>Nome</strong></td>
        <td width="88" align="center" class="celula"><strong>Situa&ccedil;&atilde;o</strong></td>
        <td width="124" align="center" class="celula"><strong>Visualizar Foto</strong></td>
        </tr>

        <%	
		'seleciona os alunos da turma através de sua disciplina
		Cont=0
		buscaHistorico = "N"
		if trim(intSemestre) = "3" then
		   if trim(strAnoLetivo) <> trim(session("strAnoLetivo"))  then
		      buscaHistorico = "S"
		   end if
		else
		   if trim(strAnoLetivo) <> trim(session("strAnoLetivo"))  or trim(intSemestre) <> trim(session("strSemestre")) then
		      buscaHistorico = "S"
		   end if	   
		end if
	    if buscaHistorico = "N" then
		   sql = " SELECT AD.CODIGO AS COD_ALUNO_DISCIPLINA, "
		   sql = sql & " AD.COD_ALUNO AS CODIGO, " 
		   sql = sql & " AD.COD_TURMA_REMANEJAMENTO AS COD_TURMA, "
		   sql = sql & " GCD.COD_DISCIPLINA, "
		   sql = sql & " ISNULL(GCD.Omitir_Criterio,'N') as Omitir_Criterio, "
		   sql = sql & " A.NOMEALUNO, "
		   sql = sql & " A.MATRICULA, "
		   sql = sql & " '' AS SEQUENCIA, "
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
		   sql = sql & " ORDER BY A.NOMEALUNO "
		else   
		   'seleciona os alunos pelo ano e semestres do histórico 			
		   sql = " select DISTINCT A.CODIGO, AT.COD_TURMA, HED.COD_DISCIPLINA, A.NOMEALUNO, A.MATRICULA,  '' AS SEQUENCIA, SA.DESC_SITUACAOALUNO, 'N' as Omitir_Criterio "
		   sql = sql & " from SCA_HISTORICO_ESCOLAR_DISCIPLINA HED "
		   sql = sql & " INNER JOIN SCA_HISTORICO_ESCOLAR HE ON HE.CODIGO = HED.COD_HISTORICO_ESCOLAR "
		   sql = sql & " INNER JOIN SCA_ALUNO A ON A.CODIGO = HE.COD_ALUNO AND A.COD_EMPRESA = HE.COD_EMPRESA "
		   sql = sql & " INNER JOIN SCA_SITUACAOALUNO SA ON SA.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO AND SA.COD_EMPRESA = A.COD_EMPRESA " 
		   sql = sql & " INNER JOIN SCA_ALUNO_TURMA AT ON  AT.COD_ALUNO=A.CODIGO AND AT.COD_EMPRESA = A.COD_EMPRESA "
		   sql = sql & " WHERE A.COD_EMPRESA = " & Session("CodEmpresa")
		   sql = sql & " AND AT.COD_TURMA = " & intCodTurma	
		   sql = sql & " AND HE.ANO_LETIVO = " & strAnoLetivo
		   sql = sql & " AND HE.SEMESTRE = " & intSemestre 
		   sql = sql & " AND HED.COD_DISCIPLINA= " & intCodDisciplinaTurma
		   sql = sql & " ORDER BY NOMEALUNO "
        end if
       	rs.open sql, cnn
		if rs.eof = false then
   		   while not rs.eof
		      
			  strCodAluno             = rs("CODIGO")
			  intCodEmp               = Session("CodEmpresa") 
			  strDesabilitaAluno 	  	= ""
			  strSituacaoAluno 		= ""
			  
			  if buscaHistorico = "N" and strFalhaNotasFaltas <>"S" then
			  
					'VERIFICA SE EXISTE REGISTRO DE NOTAS PARA O ALUNO 
					
					if strCodAlunoDisciplina <> "0" then
						strCodAlunoDisciplina  	= rs("COD_ALUNO_DISCIPLINA")
						strCriaNotas = "S"
						sql = "SELECT COD_ALUNO_DISCIPLINA "
						sql = sql & " FROM SCA_NOTAS_FALTAS "
						sql = sql & " WHERE	COD_ALUNO_DISCIPLINA = " & strCodAlunoDisciplina
						rsAux.open sql, cnn
						if rsAux.eof then
							strCriaNotas = "N"
							strDesabilitaAluno 	= " disabled "
							strSituacaoAluno	= " <strong>(Não existe registro de notas)</strong>"
						end if
						rsAux.close
					end if
			   end if
			  
			  
		      if buscaHistorico = "N" and strFalhaNotasFaltas ="S" then
			  
				sql = " select ad.codigo, ad.COD_DISCIPLINA from SCA_ALUNO_DISCIPLINA ad "
				sql = sql & " left join SCA_NOTAS_FALTAS nf on nf.cod_aluno_disciplina = ad.CODIGO "
				sql = sql & " where ad.COD_ALUNO = " & strCodAluno
				sql = sql & " and ISNULL(nf.codigo,'0') = '0' " 
				rs1.open sql, cnn
				if rs1.eof = false then
				  	while not rs1.eof
					
				  		strCodAlunoDisciplina  	= rs1("CODIGO")
						
				  		if strCodAlunoDisciplina <> "0" then
					 		'VERIFICA SE EXISTE REGISTRO DE NOTAS PARA O ALUNO 
					 		strCriaNotas = "S"
							sql = "SELECT COD_ALUNO_DISCIPLINA "
							sql = sql & " FROM SCA_NOTAS_FALTAS "
					 		sql = sql & " WHERE	COD_ALUNO_DISCIPLINA = " & strCodAlunoDisciplina
					 		rsAux.open sql, cnn
					 		if rsAux.eof then
								strCriaNotas = "N"
							end if
							rsAux.close
							
							if strCriaNotas = "N" then
							   strMarcaCriaNotas = "N"
							   SQL = "INSERT INTO SCA_NOTAS_FALTAS (cod_empresa, cod_aluno, cod_aluno_disciplina, cod_periodo, "
							   SQL = SQL & "ano_letivo, semestre, cod_disciplina, nota01, falta01, nota02, falta02, nota03, falta03, nota04, falta04, nota05, falta05, nota06, falta06, nota07, falta07, nota08, falta08, nota09, falta09, nota10, falta10, nota11, falta11, nota12, falta12, nota13, falta13, nota14, falta14, nota15, falta15, situacao, media )  VALUES ("
							   SQL = SQL & "" & intCodEmp & ","
							   SQL = SQL & "" & strCodAluno & ","
							   SQL = SQL & "" & strCodAlunoDisciplina & ","
							   SQL = SQL & "" & intCodPeriodo & ","
							   SQL = SQL & "" & strAnoLetivo & ","
							   SQL = SQL & "" & intSemestre & ","
							   SQL = SQL & "" & rs1("COD_DISCIPLINA") & ","
							   SQL = SQL & "null,"
							   SQL = SQL & "null,"
							   SQL = SQL & "null,"
							   SQL = SQL & "null,"
							   SQL = SQL & "null,"
							   SQL = SQL & "null,"
							   SQL = SQL & "null,"
							   SQL = SQL & "null,"
							   SQL = SQL & "null,"
							   SQL = SQL & "null,"
							   SQL = SQL & "null,"
							   SQL = SQL & "null,"
							   SQL = SQL & "null,"
							   SQL = SQL & "null,"
							   SQL = SQL & "null,"
							   SQL = SQL & "null,"
							   SQL = SQL & "null,"
							   SQL = SQL & "null,"
							   SQL = SQL & "null,"
							   SQL = SQL & "null,"
							   SQL = SQL & "null,"
							   SQL = SQL & "null,"
							   SQL = SQL & "null,"
							   SQL = SQL & "null,"
							   SQL = SQL & "null,"
							   SQL = SQL & "null,"
							   SQL = SQL & "null,"
							   SQL = SQL & "null,"
							   SQL = SQL & "null,"
							   SQL = SQL & "null,"
							   SQL = SQL & "null,"
							   SQL = SQL & "null)"
							   cnn.execute SQL
							   'GravarLog sql - Não é necessário porque o próprio sistema cria quando não tiver notas
							end if
						 end if
					 	rs1.movenext
		  			wend
				end if
				rs1.close
			 end if	
			 if rs("Omitir_Criterio") = "S" then
			 	strDesabilitaAluno 	= " disabled "
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
             <td class="celula"><%=rs("NOMEALUNO") & " " & strSituacaoAluno%></td>
             <td align="center" class="celula"><%=strDesc_SituacaoAluno%></td>
			 <td align="center" class="celula" onClick="AlunoFoto('<%=strCodAluno%>')"><a href="#"><img src="../../images/logo_camera.gif" width="22" height="18"></a></td>
             </tr>
             <%
			 rs.movenext
		  wend
	 	  if strMarcaCriaNotas = "N" then
	 	     %>
	 		 <script>
			    alert("ATENÇÃO! Arquivo de NOTAS e FALTAS  para essa disciplina acaba de ser criado, tente novamente.");
				//window.location.href = 'notasNovo_con.asp'
			 </script>
			 <%
		 end if	
	  else
 	     %>
         <tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"> 
         <td colspan="6" align="center" class="celula"><%=session("strMensagemNaoEncontrado")%></td>
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
