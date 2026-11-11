<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 28/07/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Horario de Aula
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link type="text/css" rel="stylesheet" href="../../Estilo/css.css">
</head>
<body >
<script src="../../js/js_funcoes_gerais.js"></script>
<script type="text/javascript" src="../../js/js_dragdrop.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
<!--#include file="../includes/inc_CompartilharDadosCadastrais.asp"-->
<script>
	
	function Sequencia(tipo){
		if (document.all["mostraSequencia"+tipo].style.display =="none"){
			document.all["mostraSequencia"+tipo].style.display="block";
		}
		else{
			document.all["mostraSequencia"+tipo].style.display="none";
		}
	}	
	
	function salvar(acao){
		
		if (frm.cmbTurma.value == 0){
			alert("Turma deve ser informada.");
			frm.cmbTurma.focus();
			return false;
		}
		
		if (frm.txtDataLancamento.value == ""){
			alert("A Data do lançamento deve ser informada.");
			frm.txtDataLancamento.focus();
			return false;
		}
		
		if (frm.cmbDisciplinaGrade.value == 0){
			alert("A Disciplina deve ser informada.");
			frm.cmbDisciplinaGrade.focus();
			return false;
		}
				
		frm.action="HorarioAulaExtra_cod.asp?acao="+acao;
		frm.submit();
		return true;
 	}
</script>
<%
	strPaginaTitulo 				= "HorarioAulaExtra_cad.asp"
	strCompartilharDados 			= "S"
	strExecutarSubmitSemestre 		= "S"
	strExecutarSubmitCurso	  		= "S"
	strExecutarSubmitTurma	  		= "S"
	strExecutarSubmitGradeCurricular= "S"
	strExcessaoPeriodoModulacao 	= "S"
	strDisciplina_Disabled    		= "onchange='submit()'"
	strExecutarSubmitProfessorGeral = ""

	intCodEmp				= Session("CodEmpresa")
	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	strDataLancamento 		= Trim(Request("txtDataLancamento"))
	intCodTurma 			= Trim(Request("cmbTurma"))
	intCodGrade 			= Trim(Request("cmbGrade"))
	intCodDisciplinaGrade	= Trim(Request.Form("cmbDisciplinaGrade"))
	intCodProfessor		 	= Trim(Request.Form("cmbProfessor"))
	intCodProfessorGeral	= Trim(Request.Form("cmbProfessorGeral"))
	intCodTurnoRH 			= Trim(Request("cmbTurnoHorario"))
	intCodTurmaJuncao 		= "Null"
	intDiaSemana 			= Trim(Request.Form("chkDiaSemana"))
	
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	if intSemestre = "" or intSemestre = "0" then 	intSemestre  = session("strSemestre")
	if intCodDisciplinaGrade = "" then intCodDisciplinaGrade = "0"
	
	if strDataLancamento <> "" then 
		intdiaSemana = weekday(strDataLancamento)
	else
		intdiaSemana = 0 
	end if
		
	strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
	strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
	strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	
	if intCodDisciplina <> "" or intCodDisciplina <>"0" then
		strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
	end if

	if intCodTurma 		= "" then intCodTurma 		= "0"
	
	if trim(intCodTurma) <> "0" then
	
		sql = "SELECT SCA_GRADECURRICULAR.Cod_GradeCurricular, SCA_TURMA.cod_turma, SCA_TURMA.cod_Semestre , "
		sql = sql & " SCA_PERIODO.Cod_Curso, SCA_PERIODO.Cod_Periodo, SCA_TURMA.cod_turno as cod_turno_SCA, TRH.Cod_turno , SCA_TURMA.Sala, SCA_TURMA.NomeTurma"
		sql = sql & " FROM SCA_TURMA "
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
		sql = sql & " INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo"
		sql = sql & " INNER JOIN SCA_TURNO TU ON TU.COD_TURNO = SCA_TURMA.COD_TURNO "
		sql = sql & " INNER JOIN SRH_TURNO TRH ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3) AND TRH.COD_GRUPO =" & session("codGrupo")
		sql = sql & " WHERE SCA_TURMA.cod_empresa=" & Session("CodEmpresa")
		sql = sql & " AND SCA_TURMA.Cod_Turma= " & intCodTurma
		RS.OPEN SQL, CNN
		IF not RS.EOF THEN
			intCodCurso 		= rs("cod_curso")
			intCodPeriodo 		= rs("cod_periodo")
			intCodTurno 		= rs("cod_turno_SCA")
			'intCodTurnoRH 		= rs("Cod_turno")
			
			if Trim(Request.Form("cmbGrade")) = "0" then
				intCodGrade = rs("Cod_GradeCurricular")
			end if	
		END IF
		rs.close
		
	
		
	end if
	
	if intCodProfessor 	= "" then intCodProfessor 	= "0"
	if intCodProfessorGeral 	= "" then intCodProfessorGeral 	= "0"

%>
<form method="post" id="frm" action="HorarioAulaExtra_cad.asp">
<input name="txtCodigo" type="hidden" id="txtCodigo" value="<%=intCodigo%>">
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
            <tr valign="top">
              <td  align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
		<tr valign="top">
		  <td align="center">
  <table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
    <tr>
      <td height="12"><span class="texto1">Ano Letivo:</span></td>
      <td width="81%"><input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
    </tr>
    <tr> 
      <td width="19%" height="12"><span class="texto1">Semestre:</span></td>
      <td><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
    </tr>
    <tr>
      <td class="texto1">Turma: </td>
      <td><!--#include file="../includes/inc_cmdTurmaHorarioMatriz.asp"--></td>
    </tr>
    <tr>
      <td class="texto1">Matriz: </td>
      <td><!--#include file="../includes/inc_cmdGradeCurricularHorarioMatriz.asp"--></td>
    </tr>
    
 	<%if session("codGrupo") = "7" then%>
    <tr>
        <td height="12" class="texto1">Turno:
        <td ><%strExecutarSubmitTurno="S"%><!--#include file="../includes/inc_cmbTurnoModulacaoHorarioMatriz.asp" --> 
   	 	<span class="textoAltSenha">&nbsp;Turno informado dever&aacute; ser o da modula&ccedil;&atilde;o.&nbsp; </span>
    	</td>
    </tr>   
    <%else%>
    	<input name="cmbTurnoHorario" type="hidden" id="cmbTurnoHorario" value="<%=intCodTurno%>">
    <%end if%>   
    <tr>
      <td class="texto1">Data Lan&ccedil;amento:</td>
      <td> <!--#include file="../includes/inc_cmbExcessaoPeriodoModulacao.asp"--></td>
    </tr>
    <tr>
      <td class="texto1">Disciplina:</td>
      <td class="texto1"><!--#include file="../includes/inc_cmdDisciplinaGrade.asp"--> &nbsp;*</td>
    </tr>
    <tr>
      <td class="texto1">Professor(a): </td>
      <td class="texto1"><!--#include file="../includes/inc_cmdProfessorAtivo.asp"--> &nbsp;*</td>
    </tr>
    <tr>
      <td class="texto1"><span class="texto1">Buscar Professor de Outras Unidades?</span></td>
      <td class="texto1"><!--#include file="../includes/inc_cmdProfessorGeral.asp"--></td>
    </tr>
    <tr>
      <td colspan="2" class="texto1">&nbsp;</td>
    </tr>
    <tr>
      <td colspan="2" class="texto1"><!--#include file="../../includes/inc_botoes_cadastro.asp"-->&nbsp;</td>
    </tr>
    <tr>
      <td colspan="2" class="texto1">&nbsp;</td>
      </tr>
    
    <%
	if trim(intCodTurma) <> "0" and  trim(intCodDisciplinaGrade) <> "0" then
		sql = " SELECT count(cod_turma) as total from SCA_HORARIO_AULA "
		sql = sql & " where cod_empresa = " & Session("CodEmpresa")
		sql = sql & " and cod_turma = " & intCodTurma
		sql = sql & " and anoLetivo = " & strAnoLetivo
		sql = sql & " and semestre = " & intSemestre
		sql = sql & " and Cod_Disciplina = " & intCodDisciplinaGrade
		sql = sql & " GROUP BY cod_turma "
		RSAUX.OPEN SQL, CNN
		IF NOT RSAUX.EOF THEN
			TotalHorario = RSAUX("total")
			if isnull(RSAUX("total")) then
			   TotalHorario = "0"
			end if   
		END IF
		RSAUX.CLOSE
		
		'BUSCA SE A TURMA POSSUI MATRIZ CADASTRADA
		Matriz = "NÃO"
		sql = " SELECT "
		sql = sql & " SUM(GD.Ch_Semanal) as total "
		sql = sql & " FROM SCA_TURMA T "
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.Cod_GRADECURRICULAR = T.COD_GRADECURRICULAR AND G.SITUACAO = 'A' "
		sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GD ON GD.Cod_GradeCurricular = G.Cod_GRADECURRICULAR "
		sql = sql & " WHERE T.COD_EMPRESA = " & Session("CodEmpresa")
		sql = sql & " AND COD_TURMA = " & intCodTurma
		sql = sql & " and Cod_Disciplina = " & intCodDisciplinaGrade
		RSAUX.OPEN SQL, CNN
		IF NOT RSAUX.EOF THEN
			TotalMatriz = RSAUX("total")
			if isnull(RSAUX("total")) then
			   TotalMatriz = "0"
			end if   
		END IF
		RSAUX.CLOSE
		SaldoAulas =  TotalHorario - TotalMatriz
		if SaldoAulas < 0 then StatusSaldo = "** Incompleto **"
		if SaldoAulas = 0 then StatusSaldo = "** OK! **"
		if SaldoAulas > 0 then StatusSaldo = "** Carga Horaria Execedida, Verifique! **"
		
	else	
		if SaldoAulas = "" then StatusSaldo = ""
	end if
	
	if intCodDiaSemana = "" then intCodDiaSemana = 0
	
	%>
    <tr>
      <td height="20" colspan="2" bgcolor="#CCCCCC" class="texto1">Dia da Semana:      </td>
    </tr>
    <tr class="texto1">
      <td colspan="2" class="texto1"><br>
        
        <table class="tabela" width="98%" align="center" border="1" cellpadding="0" cellspacing="0">
          
          <tr bgcolor="#CCCCCC" class="CabecalhoConsulta">
            <td height="19" colspan="2" class="celula"><strong>Dia da Semana / Sequencia</strong></td>
              </tr>
          <% 
		  strAtiva = "none"
		  if intdiaSemana <> "0" then 
		  
		  for i=intdiaSemana to intdiaSemana
			
			if trim(intCodTurma) <> "0" then
				
				sql = "  SELECT distinct HA.DataLancamento"
				sql = sql & " FROM  SCA_HORARIO_AULA_EXTRA HA "
				sql = sql & " INNER JOIN SCA_TURMA T ON  T.COD_EMPRESA = HA.COD_EMPRESA AND T.COD_TURMA = HA.COD_TURMA"
				sql = sql & " WHERE T.COD_TURMA = " & intCodTurma
				sql = sql & " AND ha.DataLancamento = '" &  formataDataBD(Trim(strDataLancamento)) & "'"
				sql = sql & " AND HA.ANOLETIVO	= " & strAnoLetivo
				RS.OPEN SQL, CNN
				IF not RS.EOF THEN
					seleciona = "checked"
					strAtiva = "block" 
				else
					seleciona = ""
					strAtiva = "none"
				END IF
				rs.close
				
			end if
		  %>		
          <tr>
            <td width="66" height="30" align="center" class="celula"><input  <%=seleciona%> name="chkDiaSemana" onClick="return Sequencia('<%=i%>')" type="checkbox" id="chkDiaSemana" value="<%=i%>" ></td>
              <td width="1001" class="celula"><%=WeekDayName(i)%></td>
              </tr>
          <tr >
            <td height="30" align="center" class="celula">&nbsp;</td>
              <td height="30" align="center" class="celula">&nbsp;
                <%
				' O padrão aqui e strSemestre, foi alterado para atender o cadastramento da Fanap
				sql = "SELECT H.Codigo, H.cod_empresa, H.anoLetivo, H.semestre, H.horario, H.Sequencia_Aulas, H.Tempo "
				sql = sql & " FROM SCA_HORARIO H"
				sql = sql & " INNER JOIN SCA_TURNO T ON T.COD_TURNO = H.CODTURNO"
				sql = sql & " INNER JOIN SRH_TURNO T_RH ON LEFT(T_RH.Desc_Turno,3) = LEFT(T.Desc_Turno,3) AND T_RH.COD_GRUPO="&SESSION("CODGRUPO")
				sql = sql & " where H.Cod_empresa = " & Session("CodEmpresa")
				sql = sql & " AND T_RH.COD_TURNO = " & intCodTurnoRH
				sql = sql & " and H.AnoLetivo = " & strAnoLetivo
				sql = sql & " and H.Semestre = " & intSemestre
				sql = sql & " Order by H.horario, H.Tempo "
				
				'response.write sql
				
				rs.open sql, cnn
				if not rs.eof then  
					%>
                    <div align="center"  id="mostraSequencia<%=i%>" style="display:<%=strAtiva%>">
                	<table width="98%" border="0" cellspacing="0" cellpadding="0">
                  	<tr>
                    <%	
					cont = 0
					contador = 0
					while not rs.eof
					
					sql = "  SELECT H.horario, HA.COD_DISCIPLINA"
					sql = sql & " FROM  SCA_HORARIO_AULA_EXTRA HA "
					sql = sql & " INNER JOIN SCA_TURMA TU ON  TU.COD_EMPRESA = HA.COD_EMPRESA AND TU.COD_TURMA = HA.COD_TURMA"
					sql = sql & " INNER JOIN SCA_HORARIO H ON H.COD_EMPRESA=HA.COD_EMPRESA AND H.CODIGO=HA.COD_HORARIO"
					sql = sql & " WHERE TU.COD_TURMA = " & intCodTurma
					sql = sql & " AND HA.ANOLETIVO	= " & strAnoLetivo
					sql = sql & " AND ha.DataLancamento = '" &  formataDataBD(Trim(strDataLancamento)) & "'"
					sql = sql & " AND H.codigo =  " & rs("Codigo")
					RSAUX.OPEN SQL, CNN
					IF not RSAUX.EOF THEN
						
						selecionaHorario = "checked"
						selecionaInativa = "SIM"
						
						if intCodDisciplinaGrade = trim(RSAUX("COD_DISCIPLINA")) then
							selecionaCor	= "#FB5424"
							selecionaInativa = ""
						else
							selecionaCor	= "#FFFFCC"
						end if
						
						'if trim(RSAUX("TipoHorario")) = "E" then 'Horario Extra
						'	selecionaCor	= "#C4E1FF"
						'	selecionaHorario = ""
						'	selecionaInativa = "SIM"
						'end if
						
					else
						selecionaHorario = ""
						selecionaCor = ""
						selecionaInativa =""
					END IF
					RSAUX.close
				
				 
					if cint(cont) = 3 then 
						%>
                    <tr>
                      <%
					end if
					
					if isnull(rs("Tempo")) or rs("Tempo") = "" then
						strMensagem = "Verifique o cadastro de faixa de horario. Campo Tempo invalido!"
						%>
						<script>
							alert("<%=strMensagem%>");
							window.location.href ='Default.asp'
						</script>
						<%
						response.end
					end if	
					%>
                    <td width="33%" class="TextoForm" bgcolor="<%=selecionaCor%>" >
                    <%if selecionaInativa = "" then %>
                   	 <input <%=selecionaHorario%> name="chkSequenciaAula<%=i%>" type="checkbox" value="<%=rs("Codigo")%>"><%=rs("horario")%> - <%=rs("Tempo")%>&deg; Tempo
					<%else %>
					 &nbsp;&nbsp;&nbsp;<%=rs("horario")%> - <%=rs("Tempo")%>&deg; Tempo
                  	<%End if %>                    </td>
                      <%
					cont = cont + 1
					contador = contador + 1
					if cint(cont) = 3 then 
						%>
                    </tr>
                  	<tr>
                    <%
						cont  = 0
					end if
					rs.movenext
				wend
				%>
                    </tr>
                  </table>
                  </div>
                <%
			else	
			    strMensagem = "Faixa de horario ainda nao cadastrada para esse Ano/Semestre. Verifique!"
				%>
				<script>
					alert("<%=strMensagem%>");
					window.location.href ='Default.asp'
				</script>
				<%
				response.end
				
			end if
			rs.close				  
			%></td>
             </tr>
          <% next
		  end if
		  %>
        </table></td>
      </tr>
    <tr class="texto1">
      <td colspan="2" class="texto1">&nbsp;</td>
      </tr>
    <%if intCodProfessorGeral = 0 then%>
    <%end if%>
    
    <%
	
			if strCompartilharDados = "S" then %>
              <%if intCodProfessor = 0 then	  
			  %>
			<%
			end if
			end if
	
	%>
    <tr bgcolor="#E5E5E5" class="celula">
      <td colspan="2" class="texto1"><div align="center"><strong>Status do Lan&ccedil;amento</strong> ( Matriz Curricular:&nbsp;<span class="texto1"><strong><%=TotalMatriz%></strong></span>&nbsp;-&nbsp; Hor&aacute;rio de Aula:&nbsp;<span class="texto1"><strong><%=TotalHorario%></strong></span>&nbsp;) = Saldo:&nbsp;<span class="texto1"><strong><%=SaldoAulas%></strong></span>&nbsp; - <span class="texto1"><strong><%=StatusSaldo%></strong></span>&nbsp;</div></td>
      </tr>
    <tr>
      <td class="texto1">&nbsp;</td>
      <td class="texto1">&nbsp;</td>
    </tr>
    <tr> 
      <td class="texto1">&nbsp;</td>
      <td class="texto1">Obs: Todos campos marcados com (*) permitir&aacute; altera&ccedil;&atilde;o durante a manuten&ccedil;&atilde;o do hor&aacute;rio. </td>
    </tr>
    <tr> 
      <td colspan="2" class="texto1"><hr size="1" color="#CCCCCC"></td>
    </tr>
    <tr> 
      <td colspan="2" class="texto1"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
    </tr>
    <tr>
      <td colspan="2" class="texto1">&nbsp;</td>
    </tr>
    <tr> 
       	<td colspan="2" class="texto1">
		
		<% IF intCodCurso<> "0" OR intCodTurma<> "0" then
			cont =0
			sql = "SELECT	HA.CODIGO, P.DESCRICAO AS PERIODO, T.NOMETURMA, H.HORARIO, HA.TEMPO, HA.DataLancamento, HA.SEQUENCIA, C.NOME AS PROFESSOR, "
			sql = sql & " D.DESC_DISCIPLINA, TJ.NOMETURMA AS TURMAJUNCAO, HA.TipoHorario"
			sql = sql & " FROM	SCA_HORARIO_AULA_EXTRA HA"
			sql = sql & " INNER JOIN SCA_HORARIO H ON H.COD_EMPRESA=HA.COD_EMPRESA AND H.CODIGO=HA.COD_HORARIO"
			sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_EMPRESA=HA.COD_EMPRESA AND T.COD_TURMA=HA.COD_TURMA"
			sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.COD_EMPRESA=T.COD_EMPRESA AND G.COD_GRADECURRICULAR=T.COD_GRADECURRICULAR"
			sql = sql & " INNER JOIN SCA_PERIODO P ON P.COD_EMPRESA=T.COD_EMPRESA AND P.COD_PERIODO=G.COD_PERIODO"
			
			if strCompartilharDados = "S" then
			   sql = sql & " LEFT JOIN SRH_COLABORADOR C ON C.CODIGO=HA.COD_COLABORADOR"
			else   
			   sql = sql & " LEFT JOIN SRH_COLABORADOR C ON C.COD_EMPRESA = HA.COD_EMPRESA AND C.CODIGO=HA.COD_COLABORADOR"
			end if   
			
			sql = sql & " LEFT  JOIN SCA_DISCIPLINA D ON D.COD_EMPRESA=HA.COD_EMPRESA AND D.COD_DISCIPLINA=HA.COD_DISCIPLINA"
			sql = sql & " LEFT JOIN SCA_TURMA TJ ON TJ.COD_EMPRESA=HA.COD_EMPRESA AND TJ.COD_TURMA=HA.TURMA_JUNCAO"
			sql = sql & " WHERE	1=1"
			
			if strCompartilharDados = "S" then
				sql = sql & " AND	HA.COD_EMPRESA	= " & Session("CodEmpresa")
			end if   
			
			sql = sql & " AND		HA.ANOLETIVO	= " & strAnoLetivo
			sql = sql & " AND		HA.SEMESTRE		in (" & intSemestre & ")"
			sql = sql & " AND		P.COD_CURSO		= " & intCodCurso
			
			if intCodDisciplinaGrade <> "0" then
				sql = sql & " AND		D.COD_DISCIPLINA		= " & intCodDisciplinaGrade
			end if
			
			if intCodTurno <> "0" then
				sql = sql & " AND		T.COD_TURNO		= " & intCodTurno
			end if
			
			if intcodPeriodo <> "0" then
				sql = sql & " AND		G.COD_PERIODO	= " & intcodPeriodo
			end if
			
			if intCodTurma <> "0" then
				sql = sql & " AND		T.COD_TURMA		= " & intCodTurma
			end if
			
			sql = sql & " Order by HA.ANOletivo, HA.semestre, P.DESCRICAO, T.NOMETURMA, HA.DataLancamento, H.horario "
			
			rs.open sql, cnn
			if rs.eof = false then
			%>
                <table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                  <tr bgcolor="#E5E5E5">
                    <td width="9%" class="celula"><strong>Per&iacute;odo  </strong></td>
                    <td width="10%" class="celula"><strong><strong>Turma</strong></strong></td>
                    <td width="15%" height="21" class="celula"><strong>Hor&aacute;rio<span class="TextoForm"></span></strong></td>
                    <td width="8%" class="celula"><strong>Sequencia</strong></td>
                    <td width="8%" class="celula"><strong>Tempo<span class="TextoForm"></span></strong></td>
                    <td width="12%" class="celula"><strong>Data Lan&ccedil;amento <span class="TextoForm"></span></strong></td>
                    <td width="15%" class="celula"><strong>Disciplina</strong></td>
                    <td width="12%" class="celula"><strong>Professor(a)<span class="TextoForm"></span></strong></td>
                  </tr>
                  <%
				while not rs.eof
					cont = cont + 1	
					
					if trim(rs("TipoHorario")) = "E" then 'Horario Extra
						strCor =  "#C4E1FF"
					else
						strCor =  ""
					end if
				
					%>
                  <tr bgcolor="<%=strCor%>">
                    <td class="celula"><%=rs("periodo")%></td>
                    <td class="celula"><%=rs("nometurma")%></td>
                    <td height="20" class="celula"><%=trim(rs("horario"))%></td>
                    <td class="celula"><%=trim(rs("sequencia"))%>&ordf; Aula </td>
                    <td class="celula"><%=trim(rs("tempo"))%>&deg;</td>
                    <td class="celula"><%=formataDataAP(trim(rs("DataLancamento")))%></td>
                    <td class="celula"><%=trim(rs("DESC_DISCIPLINA"))%>&nbsp;</td>
                    <% if isnull(rs("PROFESSOR")) then %>
                    	<td class="celula"> ** Deficit **</td>
                    <% else %>    
                    	<td width="11%" class="celula"><%=trim(rs("PROFESSOR"))%>&nbsp;</td>
                    <% end if %>    
                  </tr>
                  <%				
					rs.movenext
					wend
				  %>
                  <tr>
                    <td height="21" colspan="8" class="celula">Total Registros : <%=cont%></td>
                  </table>
              <%
			  end if
			  rs.close
			  
			end if%>		</td>
    </tr>
  </table>
  		  </td>
		</tr>
  </table>
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>