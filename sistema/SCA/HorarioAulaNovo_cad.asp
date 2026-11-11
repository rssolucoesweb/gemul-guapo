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
<body>
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

		frm.action="HorarioAulaNovo_cod.asp?acao="+acao;
		frm.submit();
		return true;
 	}
</script>
<%
	strPaginaTitulo 				= "HorarioAulaNovo_cad.asp"
	strCompartilharDados 			= "S"
	strExecutarSubmitSemestre 		= "S"
	strExecutarSubmitCurso	  		= "S"
	strExecutarSubmitTurma	  		= "S"
	strExecutarSubmitGradeCurricular= "S"
	strDisciplina_Disabled    		= "onchange='submit()'"
	strExecutarSubmitProfessorGeral = ""

	intCodEmp				= Session("CodEmpresa")
	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	intCodTurma 			= Trim(Request("cmbTurma"))
	intCodGrade 			= Trim(Request("cmbGrade"))
	intCodDisciplinaGrade	= Trim(Request.Form("cmbDisciplinaGrade"))
	intCodProfessor		 	= Trim(Request.Form("cmbProfessor"))
	intCodTurnoRH 			= Trim(Request("cmbTurnoHorario"))
	intCodTurmaJuncao 		= "Null"
	intDiaSemana 			= Trim(Request.Form("chkDiaSemana"))
	
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	if intSemestre = "" or intSemestre = "0" then 	intSemestre  = session("strSemestre")
	if intCodDisciplinaGrade = "" then intCodDisciplinaGrade = "0"
		
	strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
	strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
	strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	
	if intCodDisciplina <> "" or intCodDisciplina <>"0" then
		strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
	end if

	if intCodTurma 		= "" then intCodTurma 		= "0"
	
'	if trim(intCodTurma) <> "0" then
'	
'		sql = "SELECT SCA_GRADECURRICULAR.Cod_GradeCurricular, SCA_TURMA.cod_turma, SCA_TURMA.cod_Semestre , "
'		sql = sql & " SCA_PERIODO.Cod_Curso, SCA_PERIODO.Cod_Periodo, SCA_TURMA.cod_turno as cod_turno_SCA, TRH.Cod_turno , SCA_TURMA.Sala, SCA_TURMA.NomeTurma"
'		sql = sql & " FROM SCA_TURMA "
'		sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
'		sql = sql & " INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo"
'		sql = sql & " INNER JOIN SCA_TURNO TU ON TU.COD_TURNO = SCA_TURMA.COD_TURNO "
'		sql = sql & " INNER JOIN SRH_TURNO TRH ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3) AND TRH.COD_GRUPO =" & session("codGrupo")
'		sql = sql & " WHERE SCA_TURMA.cod_empresa=" & Session("CodEmpresa")
'		sql = sql & " AND SCA_TURMA.Cod_Turma= " & intCodTurma
'		RS.OPEN SQL, CNN
'		IF not RS.EOF THEN
'			intCodCurso 		= rs("cod_curso")
'			intCodPeriodo 		= rs("cod_periodo")
'			intCodTurno			= rs("cod_turno_SCA")
'			if Trim(Request.Form("cmbGrade")) = "0" then
'				intCodGrade = rs("Cod_GradeCurricular")
'			end if	
'		END IF
'		rs.close
'	end if
		
	if intCodProfessor 	= "" then intCodProfessor 	= "0"
	'if intCodProfessorGeral 	= "" then intCodProfessorGeral 	= "0"
	if intCodTurno = "" then intCodTurno = "0"

%>
<form method="post" id="frm" action="HorarioAulaNovo_cad.asp">
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
   	 	<span class="textoAltSenha">&nbsp;Turno informado deverá ser o da modulação.&nbsp; </span>
    	</td>
    </tr>   
    <%else%>
    	<input name="cmbTurnoHorario" type="hidden" id="cmbTurnoHorario" value="<%=intCodTurno%>">
    <%end if%>
    <tr>
      <td class="texto1">Disciplina:</td>
      <td class="texto1"><!--#include file="../includes/inc_cmdDisciplinaGradeHorarioLancamento.asp"-->
&nbsp;*</td>
    </tr>
    <tr>
      <td class="texto1">Professor(a): </td>
      <td class="texto1"><!--#include file="../includes/inc_cmdProfessorAtivo.asp"-->
        &nbsp;*</td>
    </tr>
    <% if session("CodGrupo") = "2" then %>
        <tr>
          <td class="texto1"> Buscar Professor de Outras Unidades?</td>
          <td class="texto1"><!--#include file="../includes/inc_cmdProfessorGeral.asp"--></td>
        </tr>
    <% end if %>
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
	if intCodTurma = "" then intCodTurma = 0
	if intCodDisciplinaGrade = "" then intCodDisciplinaGrade = 0
	if intCodTurnoRH = "" then intCodTurnoRH = 0
	if intCodTurnoRH <> "0" then
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
		  
		  for i=1 to 7
			
			if trim(intCodTurma) <> "0" then
				
				sql = "  SELECT distinct HA.DIASEMANA"
				sql = sql & " FROM  SCA_HORARIO_AULA HA "
				sql = sql & " INNER JOIN SCA_TURMA T ON  T.COD_EMPRESA = HA.COD_EMPRESA AND T.COD_TURMA = HA.COD_TURMA"
				sql = sql & " WHERE T.COD_TURMA = " & intCodTurma
				sql = sql & " AND ha.DiaSemana = " & cint(i)
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
              <td height="30" align="center" class="celula">
                <%
				' O padrão aqui e strSemestre, foi alterado para atender o cadastramento da Fanap

				if session("CodGrupo") = "7" then 
					sql = " SELECT H.Codigo, H.cod_empresa, H.anoLetivo, H.semestre, H.horario, H.Sequencia_Aulas, H.Tempo "
					sql = sql & " FROM SCA_HORARIO H"
					sql = sql & " INNER JOIN SCA_TURNO TU ON TU.COD_TURNO = H.CodTurno"
					sql = sql & " INNER JOIN SRH_TURNO TRH ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3) "
					sql = sql & " where H.Cod_empresa = " & Session("CodEmpresa") 
					sql = sql & " and H.AnoLetivo = " & strAnoLetivo 
					sql = sql & " and H.Semestre = " & intSemestre 
					if intCodTurno <> "0" then
						sql = sql & " and TRH.Cod_Turno = " & intCodTurnoRH
					end if
					sql = sql & " Order by H.horario, H.Tempo"
				else
					sql = " SELECT H.Codigo, H.cod_empresa, H.anoLetivo, H.semestre, H.horario, H.Sequencia_Aulas, H.Tempo "
					sql = sql & " FROM SCA_HORARIO H"
					sql = sql & " INNER JOIN SCA_TURNO TU ON TU.COD_TURNO = H.CodTurno"
					sql = sql & " where H.Cod_empresa = " & Session("CodEmpresa") 
					sql = sql & " and H.AnoLetivo = " & strAnoLetivo 
					sql = sql & " and H.Semestre = " & intSemestre 
					if intCodTurno <> "0" then
						sql = sql & " and TU.Cod_Turno = " & intCodTurnoRH
					end if
					sql = sql & " Order by H.horario, H.Tempo"
				end if
				
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
					
					sql = "  SELECT H.horario, HA.COD_DISCIPLINA, D.Desc_Disciplina"
					sql = sql & " FROM  SCA_HORARIO_AULA HA "
					sql = sql & " INNER JOIN SCA_TURMA T ON  T.COD_EMPRESA = HA.COD_EMPRESA AND T.COD_TURMA = HA.COD_TURMA"
					sql = sql & " INNER JOIN SCA_HORARIO H ON H.COD_EMPRESA=HA.COD_EMPRESA AND H.CODIGO=HA.COD_HORARIO"
					sql = sql & " LEFT JOIN SCA_DISCIPLINA D ON D.COD_EMPRESA=HA.COD_EMPRESA AND D.Cod_Disciplina=HA.COD_DISCIPLINA"
					sql = sql & " WHERE T.COD_TURMA = " & intCodTurma
					sql = sql & " AND HA.ANOLETIVO	= " & strAnoLetivo
					sql = sql & " AND ha.DiaSemana = " & cint(i)
					sql = sql & " AND H.codigo =  " & rs("Codigo")
					
					RSAUX.OPEN SQL, CNN
					IF not RSAUX.EOF THEN
						
						selecionaHorario = "checked"
						selecionaInativa = "SIM"
						strDisciplina = trim(RSAUX("Desc_Disciplina"))
						
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
                   	 <input <%=selecionaHorario%> name="chkSequenciaAula<%=i%>" type="checkbox" value="<%=rs("Codigo")%>"><%=rs("horario")%> - <%=rs("Sequencia_Aulas")%>&ordf; Aula
					<%else %>
					 &nbsp;&nbsp;&nbsp;<%=rs("horario")%> - <%=rs("Sequencia_Aulas")%>&ordf; Aula - <%=strDisciplina%>
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
          <% next%>
        </table></td>
      </tr>
    <tr class="texto1">
      <td colspan="2" class="texto1">&nbsp;</td>
      </tr>
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
    <%
	end if
	%>
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
		
		<% IF intCodTurma<> "0" then
			cont =0
			sql = "SELECT distinct	HA.CODIGO, P.DESCRICAO AS PERIODO, T.NOMETURMA, H.HORARIO, HA.TEMPO, HA.DIASEMANA, HA.SEQUENCIA, C.NOME AS PROFESSOR, "
			sql = sql & " D.DESC_DISCIPLINA, TJ.NOMETURMA AS TURMAJUNCAO, HA.TipoHorario"
			sql = sql & " FROM	SCA_HORARIO_AULA HA"
			sql = sql & " INNER JOIN SCA_HORARIO H ON H.COD_EMPRESA=HA.COD_EMPRESA AND H.CODIGO=HA.COD_HORARIO"
			sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_EMPRESA=HA.COD_EMPRESA AND T.COD_TURMA=HA.COD_TURMA"
			sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.COD_EMPRESA=T.COD_EMPRESA AND G.COD_GRADECURRICULAR=T.COD_GRADECURRICULAR"
			sql = sql & " INNER JOIN SCA_PERIODO P ON P.COD_EMPRESA=T.COD_EMPRESA AND P.COD_PERIODO=G.COD_PERIODO"
			sql = sql & " LEFT JOIN SRH_MODULACAO_DISCIPLINAR_DOCENTE M ON M.Cod_Colaborador = HA.COD_COLABORADOR AND HA.ANOLETIVO = M.ANO_LETIVO"
			if strCompartilharDados = "S" then
			   sql = sql & " LEFT JOIN SRH_COLABORADOR C ON C.CODIGO=HA.COD_COLABORADOR"
			else   
			   sql = sql & " LEFT JOIN SRH_COLABORADOR C ON C.COD_EMPRESA = HA.COD_EMPRESA AND C.CODIGO=HA.COD_COLABORADOR"
			end if   
			
			sql = sql & " LEFT  JOIN SCA_DISCIPLINA D ON D.COD_EMPRESA=HA.COD_EMPRESA AND D.COD_DISCIPLINA=HA.COD_DISCIPLINA"
			sql = sql & " LEFT JOIN SCA_TURMA TJ ON TJ.COD_EMPRESA=HA.COD_EMPRESA AND TJ.COD_TURMA=HA.TURMA_JUNCAO"
			sql = sql & " WHERE	1=1 "
			if session("CodGrupo") = "7" then 
				if intCodTurnoRH <> "0" then
					sql = sql & " AND M.Cod_Turno = " & intCodTurnoRH
				end if
			end if
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
			
			sql = sql & " Order by DESCRICAO, NOMETURMA, DIASEMANA, horario "

			rs.open sql, cnn
			if rs.eof = false then
			%>
                <table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                  <tr bgcolor="#E5E5E5">
                    <td width="7%" class="celula"><strong>Per&iacute;odo  </strong></td>
                    <td width="5%" class="celula"><strong><strong>Turma</strong></strong></td>
                    <td width="10%" height="21" class="celula"><strong>Hor&aacute;rio<span class="TextoForm"></span></strong></td>
                    <td width="8%" class="celula"><strong>Sequencia</strong></td>
                    <td width="6%" class="celula"><strong>Tempo<span class="TextoForm"></span></strong></td>
                    <td width="10%" class="celula"><strong>Dia Semana <span class="TextoForm"></span></strong></td>
                    <td width="22%" class="celula"><strong>Disciplina</strong></td>
                    <td class="celula"><strong>Professor(a)<span class="TextoForm"></span></strong></td>
                  </tr>
                  <%
				while not rs.eof
					cont = cont + 1	
					
					strCorLinha = ""
					
					if ucase(trim(rs("diasemana"))) = 1 then
						strCorLinha = "bgcolor='#FDA29F'"
					end if
					
					if ucase(trim(rs("diasemana"))) = 2 then
						strCorLinha = "bgcolor='#FFFFCC'"
					end if
					
					if ucase(trim(rs("diasemana"))) = 3 then
						strCorLinha = "bgcolor='#CAFEB4'"
					end if
					
					if ucase(trim(rs("diasemana"))) = 4 then
						strCorLinha = "bgcolor='#D8D8D8'"
					end if
					
					if ucase(trim(rs("diasemana"))) = 5 then
						strCorLinha = "bgcolor='#C2CAFC'"
					end if
					
					if ucase(trim(rs("diasemana"))) = 6 then
						strCorLinha = "bgcolor='#CCE6E6'"
					end if
					
					if ucase(trim(rs("diasemana"))) = 7 then
						strCorLinha = "bgcolor='#FDA29F'"
					end if
				
					%>
                  <tr <%=strCorLinha%>>
                    <td class="celula"><%=rs("periodo")%></td>
                    <td class="celula"><%=rs("nometurma")%></td>
                    <td height="20" class="celula"><%=trim(rs("horario"))%></td>
                    <td class="celula"><%=trim(rs("sequencia"))%>&ordf; Aula </td>
                    <td class="celula"><%=trim(rs("tempo"))%>&deg;</td>
                    <td class="celula"><%=WeekDayName(trim(rs("diasemana")))%></td>
                    <% if isnull(rs("DESC_DISCIPLINA")) or trim(rs("DESC_DISCIPLINA")) = "" then %>
                    	<td class="celula"> ** Planejamento **</td>
                    <% else %>    
                    	<td class="celula"><%=trim(rs("DESC_DISCIPLINA"))%>&nbsp;</td>
                    <% end if %>    
                    <% if isnull(rs("PROFESSOR")) then %>
                    	<td class="celula"> ** Deficit **</td>
                    <% else %>    
                    	<td class="celula"><%=trim(rs("PROFESSOR"))%>&nbsp;</td>
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