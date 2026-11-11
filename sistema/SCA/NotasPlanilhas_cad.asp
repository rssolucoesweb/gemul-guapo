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
<link type="text/css" rel="stylesheet" href="../../Estilo/css.css"></head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script src="../../js/js_funcoes_gerais.js"></script>
<script type="text/javascript" src="../../js/js_dragdrop.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_validaPermissaoPagina.asp"-->
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
	
	function AlunoFoto(codAluno){
		window.open("AlunoFoto_con.asp?codAluno="+codAluno,"consulta", "top=0,left=0,height=400,width=578,menubar=no,toolbar=no,scrollbars=yes,status=yes");
	}
	function cadastrarNotas(){
	
		var form = document.getElementById("frm");
		var intContMarcado=0;
		var strAlunos='';
		var strEja='';
		
		if (frm.cmbSemestre.value == 0){
			alert("O Semestre deve ser informado!");
			frm.cmbSemestre.focus();
			return false;
		}

		//*****verifica se o chkTipoNota foi selecionado
		intContMarcado==0
		for (var i = 0; i < form.elements.length; i++) {
			//verifica todos os checkbox
			if (form.elements[i].type == "radio"){
				if (form.elements[i].name == "chkTipoNota"){
					//verifica se o checkbox está marcado
					if (form.elements[i].checked){
						intContMarcado = intContMarcado + 1;
					}
				}
			}
		}
		
		if (intContMarcado==0){
			alert("A avaliação deve ser informada!");
			return false;
		}
		
		frm.action = "NotasPlanilhas_cod.asp";
		frm.submit();
		return true;	
	}
	
	function cadastrarNotasMedia(){
	
		var form = document.getElementById("frm");
		var intContMarcado=0;
		var strAlunos='';
		var strEja='';
		
		if (frm.cmbSemestre.value == 0){
			alert("O Semestre deve ser informado!");
			frm.cmbSemestre.focus();
			return false;
		}

		//*****verifica se o chkTipoNota foi selecionado
		intContMarcado==0
		for (var i = 0; i < form.elements.length; i++) {
			//verifica todos os checkbox
			if (form.elements[i].type == "radio"){
				if (form.elements[i].name == "chkTipoNota"){
					//verifica se o checkbox está marcado
					if (form.elements[i].checked){
						intContMarcado = intContMarcado + 1;
					}
				}
			}
		}
		
		if (intContMarcado==0){
			alert("A avaliação deve ser informada!");
			return false;
		}
		
		frm.action = "NotasPlanilhas_cod.asp?media=S";
		frm.submit();
		return true;	
	}
</script>
<%
	strPaginaTitulo 			= "NotasPlanilhas_cad.asp"
	strExecutarSubmitTurma	  	= "S"
	strReloadDisciplinaQuadro 	= "S"
	strExecutarSubmitDisciplinaDoProfessor = "S"
	strExecutarSubmitSemestre = "S"
	
	if intCodComp = "" then intCodComp = "0"
	if intCodSerie = "" then intCodSerie = "0"
	if intCodTurno = "" then intCodTurno = "0"
	if intCodTurma = "" then intCodTurma = "0"
	if intCodSemestre = "" then intCodSemestre = "0"
	
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
	
	' Consulta a Categoria	
	sql = "select codigo "
	sql = sql & " from SRH_COLABORADOR"
	sql = sql & " where codigo_SEG_USUARIOS_SISTEMA = '" & trim(session("usuarioWeb")) & "'"
	sql = sql & " and codLotacao = " & Session("CodEmpresa")
	sql = sql & " and (CodCategoria = 1)"'professor
	sql = sql & " and Situacao = 'A'" 'Ativo
	rs.open sql, cnn
	if rs.EOF = false then	
		strVerificaCategoria 		= "Professor"
		intCodColaboradorProfessor 	= trim(rs("codigo"))
		intcategoria="1"
	else
		intcategoria="0"
		strVerificaCategoria = ""
	end if
	rs.close
	
	if strVerificaCategoria  = "Professor" then
	   if trim(Session("codGrupo")) <> "7" then
			 %>
			<script>
				//alert("Sistema Bloqueado para Lancamento, procure a Secretaria Geral.");
				//window.history.back();
			</script>
			<%
		end if
	end if	
	
	strAnoLetivo			= request.Form("txtAnoLetivo")
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	
	if strVerificaCategoria <> "Professor" then
		intCodTurma				= Trim(Request.Form("cmbTurma"))
	else
		intCodTurmaProfessor	= Trim(Request.Form("cmbTurmaProfessor"))
		intCodTurma  = intCodTurmaProfessor
	end if
	
	if strVerificaCategoria <> "Professor" then
		intCodDisciplinaTurma	= Trim(Request.Form("cmbDisciplinaTurma"))
	else
		intCodDisciplina	= Trim(Request.Form("cmbDisciplinaDoProfessor"))
		intCodDisciplinaTurma = intCodDisciplina
	end if
	
	strAtivos               = trim(request.Form("cmbativos"))
	strTipoNota             = trim(request.Form("chkTipoNota"))
	strAluno         	    = trim(request.Form("chkAluno"))
	
	
	if strAnoLetivo = "" then strAnoLetivo = session("strAnoLetivo")
	
	if trim(intCodTurma) <> "" then
	
		sql = "SELECT SCA_TURMA.cod_turma, SCA_TURMA.cod_Semestre , SCA_PERIODO.Cod_Curso, SCA_PERIODO.Cod_Periodo, SCA_TURMA.cod_turno, SCA_TURMA.Sala, SCA_TURMA.NomeTurma"
		sql = sql & " FROM SCA_TURMA "
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
		sql = sql & " INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo"
		SQL = SQL & " WHERE SCA_TURMA.cod_empresa=" & Session("CodEmpresa")
		sql = sql & " AND SCA_TURMA.Cod_Turma= " & intCodTurma
		RS.OPEN SQL, CNN
		IF not RS.EOF THEN
			intCodCurso 	= rs("cod_curso")
			intCodPeriodo 	= rs("cod_periodo")
			intCodTurno 	= rs("cod_turno")
			intSemestre 	= rs("cod_Semestre")
		END IF
		rs.close
	end if
	
	strSemestre = intSemestre
	
	IF intCodCurso <> "" and strTipoNota <> ""  THEN 
	
		'carrega campos
		sql = "SELECT  posicao, descricao, formula, digitar, bimestre as tipo "
		sql = sql & " FROM SCA_TIPO_AVALIACAO_Planilha "
		sql = sql & " WHERE	COD_EMPRESA = " & Session("CodEmpresa") 
		sql = sql & " AND 	COD_CURSO = " & intCodCurso
		sql = sql & " AND tipo_bimestre = " & strTipoNota
		sql = sql & " order by posicao"
		vetCampo = null
		rs.open sql, cnn
		if not rs.eof then
			vetCampo = rs.getRows
			strCriterio = "SIM"
		else
			strCriterio = "NAO"
		end if
		rs.close
	
	END IF

	if strCriterio = "NAO" then
		%>
		<script>
			alert("Não existe Criterio de Avaliação - Planilha para essa Turma");
			window.location='NotasPlanilhas_cad.asp';
		</script>
		<%
		response.end
	end if
	'controla os botões
	strDesabilitaIncluir = "disabled"
	strDesabilitaExcluir = "disabled"
	strDesabilitaAlterar = ""
	strDesabilitaLimpar = ""
%>
<form method="post" id="frm" action="NotasPlanilhas_cad.asp">
<input  name="txtCurso" type="hidden" id="txtCurso" value="<%=intCodCurso%>">
<input  name="txtPeriodo" type="hidden" id="txtPeriodo" value="<%=intCodPeriodo%>">
<table width="100%" border="0" cellpadding="0" bgcolor="#FFFFFF" cellspacing="0">
<tr valign="top">
<td  align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
</tr>
</table>
<table width="100%" border="0" bgcolor="#FFFFFF" align="center">
  <tr>
    <td>
    
    <table width="90%" border="0" align="center" cellpadding="0" cellspacing="2" bgcolor="#FFFFFF">
        <tr>
        <td width="12%" class="texto1">Ano Letivo:</td>
        <td width="88%" colspan="2"><input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
        </tr>
        <tr>
        <td class="texto1">Semestre:</td>
        <td colspan="2"><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
        </tr>
            <tr>
              <td width="14%" class="texto1">Turma</td>
                <td>
                  <% if strVerificaCategoria <> "Professor" then %>
                     <!--#include file="../includes/inc_cmdTurma.asp"-->
                  <% else %>	 
                     <!--#include file="../includes/inc_cmdTurmaProfessor.asp"-->
                  <% end if %>                 </td>
            </tr>
            <tr>
              <td class="texto1">Disciplina</td>
                <td>
                  <% if strVerificaCategoria <> "Professor" then %>
                        <!--#include file="../includes/inc_cmbDisciplinaTurma.asp"-->
                  <% else %>
                        <!--#include file="../includes/inc_cmdDisciplinaDoProfessor.asp"-->			  
                  <% end if %>                 </td>
            </tr>
        <tr>
          <td class="texto1">Situa&ccedil;&otilde;es:</td>
          <td colspan="2"><!--#include file="../includes/inc_cmbAtivos.asp"--></td>
        </tr>
        <tr align="left"> 
        <td colspan="3" class="texto1">
        <br>
        <%IF intCodCurso = "" THEN intCodCurso = 0
		
             sql="SELECT DISTINCT TA.BIMESTRE, TAA.DESCRICAO AS AGRUPAMENTO"
             sql=sql & " FROM SCA_TIPO_AVALIACAO_Planilha TA"
             sql=sql & " INNER JOIN SCA_TIPO_AVALIACAO_AGRUPAMENTO TAA ON TAA.CODIGO = TA.BIMESTRE"
             sql=sql & " WHERE	TA.COD_EMPRESA = " & Session("CodEmpresa") 
             sql=sql & " AND	TA.COD_CURSO = " & intCodCurso
             sql=sql & " AND	TA.digitar = 'S'"
             sql=sql & " ORDER BY TA.BIMESTRE"
		     rs.open sql, cnn
             intCont = 0
             if rs.eof = false then
                %>
                <table width="50%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                <td class="texto1"><strong>Bimestre</strong></td>
                <td class="texto1"><strong>Avaliação</strong></td>
                </tr>
                <%
                while not rs.eof
                   if trim(rs("bimestre")) = "1" or trim(rs("bimestre")) = "2" or trim(rs("bimestre")) = "3" or trim(rs("bimestre")) = "4" then
                      strBim = trim(rs("bimestre")) & "º Bimestre"
                   else
                      strBim = trim(rs("AGRUPAMENTO"))
                   end if
                %>
                <tr>
                <td class="texto1"><%=strBim%></td>
                <td class="texto1"><input type="radio" name="chkTipoNota" value="<%=rs("bimestre")%>" <%if strTipoNota = trim(rs("bimestre")) then response.Write("checked")%> onClick="submit()"><%=rs("AGRUPAMENTO")%></td>
                </tr>
                <%					
                rs.movenext
                wend
                %>
                </table>
                <%
             end if
             rs.close
             %>	 </td>
             </tr>
             <tr align="center"> 
             <td colspan="3" class="texto1"></td>
             </tr>
             <tr> 
             <td colspan="3"><hr size="1" color="#CCCCCC"></td>
             </tr>
             <tr> 
             <td colspan="3">
             <input type="button" name="cmdCadastrar" value="Salvar Notas" class="botao" onClick="return cadastrarNotas()"> 
			 <input type="button" name="cmdCadastrar" value="Enviar Média" class="botao" onClick="return cadastrarNotasMedia()"> 
             <input type="button" name="cmdLimpar"  value="Limpar"  class="botao" <%=strDesabilitaLimpar%>  onClick="window.location='NotasPlanilhas_cad.asp'"> 
             <input class="botao" type="button" value="Principal" name="BtnFechar" onClick="window.location='Default.asp')">             
			 
			 </td>
             </tr>
             <tr> 
             <td colspan="3" class="texto1"> <br> <%
             if intCodTurma    = "" then intCodTurma="0"
             if intCodSemestre = "" then intCodSemestre="0"
             if intCodTurma<>"0" and intCodDisciplinaTurma<>"0" then%> 
             <%if strCriterio = "SIM" then %>
                <table class="tabela" width="98%" align="center" border="1" cellpadding="0" cellspacing="0">
                <tr class="CabecalhoConsulta"> 
                <td width="80" class="celula"><strong>Matr&iacute;cula</strong></td>
                <td width="765" class="celula"><strong>Nome</strong></td>
    			<%
				 	for i=0 to ubound(vetCampo,2)
					%>
						<td class="celula" align="center" width="10%"><strong><%=ucase(vetCampo(1,i))%></strong></td>
					<%
					next
					%>
				<td width="187" align="center" class="celula"><strong>Visualizar Foto</strong></td>
                </tr>
        
                <%	
               sql = "  SELECT AD.CODIGO AS COD_ALUNO_DISCIPLINA, "
			   sql = sql & " AD.COD_ALUNO, "
			   sql = sql & " NF.CODIGO, " 
			   sql = sql & " AD.COD_TURMA_REMANEJAMENTO AS COD_TURMA, "
			   sql = sql & " GCD.COD_DISCIPLINA, "
			   sql = sql & " A.NOMEALUNO, "
			   sql = sql & " A.MATRICULA, "
			   sql = sql & " '' AS SEQUENCIA, "
			   for n=1 to 30
					strComplemento = "0"	
					if cInt(n)>9 then strComplemento = ""
					sql = sql & " NF.nota" & strComplemento & n & ", "
				next
				
			   sql = sql & " SA.DESC_SITUACAOALUNO "
			   sql = sql & " FROM SCA_ALUNO_DISCIPLINA AD INNER JOIN " 
			   sql = sql & " SCA_ALUNO A ON A.CODIGO = AD.COD_ALUNO  INNER JOIN "
			   sql = sql & " SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = A.COD_SITUACAOALUNO AND SA.Cod_Empresa = A.COD_EMPRESA INNER JOIN "
			   sql = sql & " SCA_GRADECURRICULARDISCIPLINA GCD ON GCD.Cod_GradeCurricularDisciplina = AD.COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO"
			   sql = sql & " LEFT JOIN SCA_NOTAS_PLANILHA NF ON NF.cod_aluno_disciplina = AD.CODIGO "
			   sql = sql & " WHERE AD.COD_EMPRESA = " & Session("CodEmpresa") 
			   sql = sql & " AND GCD.COD_DISCIPLINA= " & intCodDisciplinaTurma
			   sql = sql & " AND AD.COD_TURMA_REMANEJAMENTO= " & intCodTurma
			   if strAtivos = "A" then	
				  sql = sql & "AND (SA.Desc_SituacaoAluno = 'ATIVO' OR SA.Desc_SituacaoAluno = 'PRÉ-MATRÍCULA') " 
			   end if	  
			   sql = sql & " ORDER BY A.NOMEALUNO "
		       rs.open sql, cnn
			   if rs.eof = false then
                   while not rs.eof
					  contLanc 				= contLanc + 1
					  strCodAlunoNota		= RS("CODIGO")
					  strCodAluno 			= RS("COD_ALUNO")
					  strCodAlunoZeros 		= ZeroLeft(RS("COD_ALUNO"),10)  
                      intCodEmp             = Session("CodEmpresa") 
                      strSituacaoAluno 		= ""
                      
					  strCodAlunoDisciplina  	= rs("COD_ALUNO_DISCIPLINA")
					  if strCodAlunoDisciplina <> "0" then
						 'VERIFICA SE EXISTE REGISTRO DE NOTAS PARA O ALUNO 
						 strCriaNotas = "S"
						 sql = "SELECT COD_ALUNO_DISCIPLINA "
						 sql = sql & " FROM SCA_NOTAS_PLANILHA "
						 sql = sql & " WHERE	COD_ALUNO_DISCIPLINA = " & strCodAlunoDisciplina
						 rsAux.open sql, cnn
						 if rsAux.eof then
							strCriaNotas = "N"
						end if
						rsAux.close
                     end if	 
					 
                     strMatricula		          = rs("MATRICULA")
                     strDesc_SituacaoAluno		  = rs("Desc_SituacaoAluno")
                     'Função que verifica a siuação do aluno
                     strSituacaoPromocao = "" 'Não é necessário mostrar a situação promoção nesta tela
                     %>
                     <tr> 
                     <td class="celula"><%=strMatricula%>
					 <input type="hidden" value="<%=strCodAlunoDisciplina%>" name="txtCodAlunoDisciplina_<%=contLanc%>">
					 <input type="hidden" name="txtCodAlunoNota_<%=contLanc%>" value="<%=rs("CODIGO")%>">
					 <input type="hidden" name="txtCodAluno_<%=contLanc%>" value="<%=strCodAluno%>">
					 </td>
                     <td class="celula">
					 <%=rs("NOMEALUNO") & " " & strSituacaoAluno%></td>
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
						
						%>
						<td class="celula" align="center">
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
							%>
						</td>
						<%   
						   
					 next	
						%>
                     
					
					 <td align="center" class="celula" onClick="AlunoFoto('<%=strCodAluno%>')"><a href="#"><img src="../../images/logo_camera.gif" width="22" height="18"></a></td>
                     </tr>
                     <%
					 if strCriaNotas = "N" then
						   strMarcaCriaNotas = "N"
						   SQL = "INSERT INTO SCA_NOTAS_PLANILHA (cod_empresa,cod_aluno,cod_aluno_disciplina,ano_letivo,semestre,cod_periodo,cod_disciplina,nota01,nota02,nota03,nota04,nota05,nota06,nota07,nota08,nota09,nota10,nota11,nota12,nota13,nota14,nota15,nota16,nota17,nota18,nota19,nota20,nota21,nota22,nota23,nota24,nota25,nota26,nota27,nota28,nota29,nota30,media )  VALUES ("
						   SQL = SQL & "" & intCodEmp & ","
						   SQL = SQL & "" & strCodAluno & ","
						   SQL = SQL & "" & strCodAlunoDisciplina & ","
						   SQL = SQL & "" & intCodPeriodo & ","
						   SQL = SQL & "" & strAnoLetivo & ","
						   SQL = SQL & "" & intSemestre & ","
						   SQL = SQL & "" & intCodDisciplinaTurma & ","
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
                     rs.movenext
                  wend
				  if strMarcaCriaNotas = "N" then
					 %>
					 <script>
						alert("ATENÇÃO! Planilha de NOTAS para essa disciplina acaba de ser criado.");
						frm.submit();
					 </script>
					 <%
				 end if	
              else
                 %>
                 <tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"> 
                 <td colspan="8" align="center" class="celula"><%=session("strMensagemNaoEncontrado")%></td>
                 </tr>
                 <%
              end if
              rs.close
           end if
           %>
           </table>
		   <br>
		   <%if strTipoNota<>"" then%>
			<input type="button" name="cmdCadastrar" value="Salvar Notas" class="botao" onClick="return cadastrarNotas()"> 
  		    <input type="button" name="cmdCadastrar" value="Enviar Média" class="botao" onClick="return cadastrarNotasMedia()"> 
			<input type="button" name="cmdLimpar"  value="Limpar"  class="botao" <%=strDesabilitaLimpar%>  onClick="window.location='NotasPlanilhas_cad.asp'"> 
			<input class="botao" type="button" value="Principal" name="BtnFechar" onClick="window.location='Default.asp')">             
			 <br><br>
			 <%end if%>
           <%end if%>
           </td>
           </tr>
           </table>
		<input type="hidden" name="qtdeAluno" value="<%=contLanc%>">
    </td>
  </tr>
</table>

</form>
<!--#include file="../rodape.asp"-->
<script>
	aguarde.style.display="none";
</script>
</body>
</html>
