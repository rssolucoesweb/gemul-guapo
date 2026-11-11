<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 29/07/2008
	::	Desenvolvedores...: Sergio Borges - Sergiob76@gmail.com
	::	Objetivo Pagina...: Cadastro de horario 
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../estilo/css.css" rel="stylesheet" type="text/css">
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script src="../../js/js_funcoes_gerais.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnnDocumento.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<script src="../ckeditor/ckeditor.js"></script>
<script src="../ckeditor/config.js"></script>
<script>
	
	function reload(){
		
		var frm = document.getElementById("frm");
		frm.submit();
	}
	
	function resultadoConsulta(intCodigo){
	
		var frm = document.getElementById("frm");
		
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}
	
	function blocTexto(valor, id)
	{
		quant = 500;
		total = valor.length;
		if(total <= quant)
		{
			resto = quant - total;
			document.getElementById('cont').innerHTML = resto;
		}
		else
		{
			document.getElementById('txtResposta_'+id).value = valor.substr(0,quant);
		}
	}
	
	
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.txtDescricao.value == "" && frm.cmbMes.value == "0" ) {
			alert("O Conteúdo deve ser informado !");
			frm.txtDescricao.focus();
			return false;
		}
		
		if (frm.txtDataInicial.value == "") {
			alert("A Data Inicial deve ser informada !");
			frm.txtDataInicial.focus();
			return false;
		}

        TestaDataFinal = "<%=strHabilitaPlanoEnsino%>"

        if (TestaDataFinal == "S") { 
			if (frm.txtDataFinal.value == "") {
				alert("A Data Final deve ser informada !");
				frm.txtDataFinal.focus();
				return false;
			}
	
			if (frm.txtDataFinal.value <  frm.txtDataInicial.value) {
				alert("Verifique a Data informada !");
				frm.txtDataInicial.focus();
				return false;
			}
	    }	

        if ( acao != "E" ) {
			if (frm.txtTotalAulasDia.value == "" || frm.txtTotalAulasDia.value == "0" ) {
				alert("O Total de Aulas deve ser informado !");
				frm.txtTotalAulasDia.focus();
				return false;
			}
		}

		if (frm.cmbSemestre.value == "0") {
			alert("O Semestre deve ser Informado !");
			frm.cmbSemestre.focus();
			return false;
		}

		if (frm.cmbProfessor.value == "0") {
			alert("O Professor deve ser informado !");
			frm.cmbProfessor.focus();
			return false;
		}

		if (frm.cmbTurmaProfessor.value == "0") {
			alert("A Turma do Professor deve ser Informada !");
			frm.cmbTurmaProfessor.focus();
			return false;
		}
		/*if (frm.cmbTurnoDoProfessor.value == "0") {
			alert("O turno do Professor deve ser Informado !");
			frm.cmbTurnoDoProfessor.focus();
			return false;
		}	*/
		if (frm.cmbDisciplinaDoProfessor.value == "0") {
			alert("A Disciplina do Professor deve ser Informada !");
			frm.cmbDisciplinaDoProfessor.focus();
			return false;
		}

		frm.action="ConteudoProfessor_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
</script>
<%


	strExecutarSubmitSemestre 					= "S"
	strExecutarSubmitTurma					 	= "S"
	strExecutarSubmitDisciplinaDoProfessor  	= "S"
	strExecutarSubmitProfessor					= "S"
	strPaginaTitulo        	 	= "conteudoProfessor_cad.asp"

	' Consulta a Categoria	
	sql = "select codigo "
	sql = sql & " from SRH_COLABORADOR"
	sql = sql & " where codigo_SEG_USUARIOS_SISTEMA = '" & trim(session("usuarioWeb")) & "'"
	sql = sql & " and CodCategoria = 1 "'professor
	sql = sql & " and Situacao = 'A'" 'Ativo
	rs.open sql, cnn
	if rs.EOF = false then	
		strVerificaTipolancamento = "Professor"
	else
		strVerificaTipolancamento = ""
	end if
	rs.close
	
	if Session("Seg_CodCategoria") = "1" then strVerificaTipolancamento = "Professor"
	
	strVerificaRegencia	= Trim(Request.Form("txtVerificaRegencia"))
	ckVerificaRegencia = ""
    if strVerificaRegencia = "S" then ckVerificaRegencia = " checked "	

	strHabilitaPlanoEnsino = "N"
	sql = " SELECT top 1 Habilitar_PlanoEnsino, Bloqueia_ConteudoProgramatico "
	sql = sql & " FROM SEG_ENCERRAMENTOATIVIDADES "
	sql = sql & " Where cod_empresa = " & Session("CodEmpresa")
	rs.Open SQL, cnn
	if rs.EOF = false then								
		strHabilitaPlanoEnsino = rs("Habilitar_PlanoEnsino")
		strBloqueiaConteudoProgramatico = rs("Bloqueia_ConteudoProgramatico")
		if isnull(strHabilitaPlanoEnsino) then strHabilitaPlanoEnsino = "N"
		if isnull(strBloqueiaConteudoProgramatico) then strBloqueiaConteudoProgramatico = "0"
	end if
	rs.close

	if Trim(Request.Form("txtAnoLetivo")) <> "" then
	   strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	else
	   strAnoLetivo = session("strAnoLetivo")   
	end if   

	if Trim(Request.Form("cmbSemestre")) <> "" then
		intSemestre 				= Trim(Request.Form("cmbSemestre"))
	else
		intSemestre 				= session("strSemestre")
    end if	
    strBloqueio = ""
	if trim(strBloqueiaConteudoProgramatico) <> "0" then
	   	strAnoLetivo 				= session("strAnoLetivo")   
		intSemestre 				= session("strSemestre")
		strBloqueio                 = " readonly "
	end if	

 	strOpcaoDesvinculaConteudo	= Trim(Request.Form("optOpcao"))
	intCodProfessor 	        = Trim(Request("cmbProfessor"))
	intCodColaboradorProfessor  = Trim(Request("cmbProfessor"))
	
	intCodTurno					= Trim(Request("cmbTurnoDoProfessor"))
	intCodTurnoCombo			= Trim(Request("cmbTurnoDoProfessor"))
	
	intCodTurmaProfessor 	    = Trim(Request("cmbTurmaProfessor"))
    intCodDisciplina		    = Trim(Request("cmbDisciplinaDoProfessor"))
	strDataFinal         		= formatadataAP(date)
    strMes		 	        	= Trim(Request("cmbMes"))
	intCodTurma					= intCodTurmaProfessor
	strSimouNaoTomarPosse 	    = Trim(Request("cmbSimouNaoTomarPosse"))
	
	if Trim(Request("txtDataInicial")) = "" then
	   strDataInicial    	= "" 'formatadataAP(date)
	else   
	   strDataInicial      	= formatadataAP(Trim(Request("txtDataInicial")))
	end if   

	if Trim(Request("txtDataInicial")) = "" then
	   strDataFinal   	 =  "" 'formatadataAP(date)
	else   
	   strDataFinal      = formatadataAP(Trim(Request("txtDataFinal")))
	end if   
 
    strTotalAulasDia     = Trim(Request("txtTotalAulasDia"))
	
	' Valida o ano da data de lançameto com ano Letivo
	if strDataInicial <> "" then 
		if trim(year(strDataInicial)) <> trim(strAnoLetivo) then
			%>
			<script>
				//alert("ATENÇÃO: \n\O Ano da Data de Lançamento deve ser igual ao Ano Letivo.");
			</script>
			<%	
			''strDataInicial = ""
		end if
	end if
	
	if intCodColaboradorProfessor = "" then intCodColaboradorProfessor = "0"
	if intCodProfessor = "" then intCodProfessor = "0"
	if intCodTurmaProfessor = "" then intCodTurmaProfessor = "0"
	if intCodDisciplina = "" then intCodDisciplina = "0"
	
	if intCodTurmaProfessor <> "0" then
		sql = "SELECT SCA_TURMA.cod_turma, SCA_TURMA.cod_Semestre , SCA_PERIODO.Cod_Curso, SCA_PERIODO.Cod_Periodo, SCA_TURMA.cod_turno, SCA_TURMA.Sala, SCA_TURMA.NomeTurma"
		sql = sql & " FROM SCA_TURMA "
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
		sql = sql & " INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo"
		SQL = SQL & " WHERE SCA_TURMA.cod_empresa=" & Session("CodEmpresa")
		sql = sql & " AND SCA_TURMA.Cod_Turma= " & intCodTurmaProfessor
		RS.OPEN SQL, CNN
		IF not RS.EOF THEN
			intCodCurso 	= rs("cod_curso")
			intCodPeriodo 	= rs("cod_periodo")
			intSemestre 	= rs("cod_Semestre")
			strSemestre 	= rs("cod_Semestre")
		END IF
	rs.close
	end if
	
	intCodigo 		= Trim(Request.Form("txtCodigo"))
	strDescricao 	= Trim(Request.Form("txtDescricao"))
	strDesabilitaEnvio = " disabled "
		
	if trim(intCodigo) <> "" then

		strDesabilitaEnvio = ""

		sql = "SELECT *"
		sql = sql & " FROM sca_conteudo"
		sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
		sql = sql & " and codigo = " & intCodigo
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodHorario	 		= rs("codigo")
			strDescricao			= rs("conteudo")
			strAnoLetivo	 		= rs("anoletivo")
			intSemestre				= rs("semestre")
			intCodTurmaProfessor	= rs("cod_turma")
			intCodDisciplina		= rs("cod_disciplina")
			if SESSION("CODGRUPO")="7" THEN
				intCodTurno				= rs("cod_turno")
			end if
			
			
			strDataInicial          = formatadataAP(rs("datainicial"))
	        strDataFinal            = rs("datafinal")
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir

		end if 
		rs.close
	else
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	end if 
	
	if intCodTurmaProfessor = "" then intCodTurmaProfessor = "0"
	

%>
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td>
	<table width="100%"  height="325" border="0" cellspacing="0" cellpadding="0">
      <tr valign="top">
        <td colspan="2" align="center">
		<form id="frm" method="post" action="conteudoProfessor_cad.asp">
		<input name="txtCodigo" value="<%=intCodigo%>" type="hidden">
		  <table  width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr valign="top">
              <td align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
          </table>
		  <br>
		  <table width="100%" border="0" cellspacing="0" cellpadding="0">
          
          <% if strVerificaTipolancamento = "" then 
		        if strOpcaoDesvinculaConteudo = "" then strOpcaoDesvinculaConteudo = "0"
		  		%>
              <tr>
                <td height="27" class="texto1">Tipo Lan&ccedil;amento:</td>
                <td class="texto1"><strong><input <% if strOpcaoDesvinculaConteudo = "0" then response.Write("checked")%> name="optOpcao" type="radio" value="0" onclick='submit()'>Verifica hor&aacute;rio de aula.&nbsp; <br>
    			<input <% if strOpcaoDesvinculaConteudo = "1" then response.Write("checked")%> name="optOpcao" type="radio" value="1" onclick='submit()'>N&atilde;o verifica hor&aacute;rio de aula.</strong></td>
              </tr>
          <% end if %>    
          <tr>
            <td height="27" class="texto1">Ano Letivo:</td>
            <td><input <%=strBloqueio%> name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
          </tr>
          <tr>
            <td height="24" class="texto1">Semestre:</td>
            <td><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
          </tr>
          <tr>
            <td height="24" class="texto1">Professor:</td>
            <td><!--#include file="../includes/inc_cmdProfessor.asp" --></td>
          </tr>
          <tr>
            <td width="169" height="29" class="texto1">Data do Lan&ccedil;amento:</td>
            <td width="534"><span class="texto1">
            <% if strDesabilitaEnvio = "" then  
				strBloqueiaData = " readonly "
			  else  
				strBloqueiaData = " "
			  end if 
			 %>
             <input <%=strBloqueiaData%> name="txtDataInicial" type="text" class="text" id="txtDataInicial" onBlur="submit();" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataInicial%>" >
              <% if strHabilitaPlanoEnsino = "N" then %>
                    a
                    <input name="txtDataFinal" type="text" class="text" id="txtDataFinal" onBlur="return validaData(this); submit();" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataFinal%>" >
              <% end if %>      
            </span></td>
          </tr>
          <tr>
            <td height="26" class="texto1">Turma: <%'response.write "intCodTurno2:" & intCodTurno%></td>
            <td><!--#include file="../includes/inc_cmdTurmaProfessorConteudo.asp"-->
            <%'response.write "intCodTurno3:" & intCodTurno%>
            </td>
          </tr>
          <%IF SESSION("CODGRUPO")="7" THEN%>
          <tr>
            <td height="25" class="texto1">Turno:</td>
            <td><!--#include file="../includes/inc_cmdTurnoDoProfessorConteudo.asp"-->
            <%'response.write "intCodTurno:" & intCodTurno%>
          </td>
          </tr>
          <%END IF%>
          <tr>
            <td height="25" class="texto1">Disciplina:</td>
            <td><!--#include file="../includes/inc_cmdDisciplinaDoProfessorConteudo.asp"--><font size="-2" color="#FF0000">Ao selecionar a disciplina os lan&ccedil;amento cadastrados serão listado abaixo.</font></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Verificar Reg&ecirc;ncia:</td>
            <td class="texto1"> <span class="texto1">
              <input <%=ckVerificaRegencia%> name="txtVerificaRegencia" id="txtVerificaRegencia" type="checkbox"  onClick='submit()' value="S">
            </span>- Mostra se existem conte&uacute;do lan&ccedil;ando por outros colaboradores para essa disciplina. / Opcional</td>
          </tr>
          <tr>
            <td colspan="2" class="texto1" >&nbsp;</td>
          </tr>
          <% if strHabilitaPlanoEnsino = "S" then %>
              <tr>
               <td colspan="2" class="tituloSistema"><div align="left"><strong>Conte&uacute;do Program&aacute;tico</strong></div></td>
              </tr>
           <% end if %>   
          <tr>
            <td class="texto1" ><%
			 if strHabilitaPlanoEnsino = "S" then
			 
			    strConteudo = ""
				sql = "select conteudo_programatico from sca_turma t "
				sql = sql & " inner join sca_gradecurricular gc on t.cod_gradecurricular = gc.cod_gradecurricular "
				sql = sql & " inner join sca_gradecurriculardisciplina gcd on gcd.cod_gradecurricular = gc.cod_gradecurricular and T.situacao='A' "
				sql = sql & " inner join sca_planoensino pe on pe.cod_gradecurricular = gc.cod_gradecurricular and pe.cod_gradecurriculardisciplina = gcd.cod_disciplina and pe.cod_empresa=gc.cod_empresa "
				sql = sql & " where t.cod_empresa = " & Session("CodEmpresa")	
				sql = sql & " and gcd.cod_disciplina = " & intCodDisciplina
				sql = sql & " and t.cod_turma = " & intCodTurmaProfessor
				rs.open sql, cnn
				if rs.eof = false then
					strConteudo	 		= rs("conteudo_programatico")
					if isnull(strConteudo) then strConteudo = ""
				end if 
				rs.close
			end if	
          %>
          <p class="text-justify">&nbsp;</p>          </td>
            <td class="texto1" ><span class="text-justify"><%=strConteudo%></span></td>
          </tr>
           <% if strHabilitaPlanoEnsino = "S" then %>
              <tr>
                 <% if strConteudo <> "" then %>
                     <td colspan="2" class="texto1"> Obs: O quadro acima &eacute; apenas para visualiza&ccedil;&atilde;o, toda inclus&atilde;o dever&aacute; ser feita no cronograma.</td>
                  <% else %>   
                      <td width="617" colspan="2" class="texto1">&nbsp;</td>
                   <% end if %>
              </tr>
          <% end if %>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <%
		  	if strDataInicial <> "" and intCodTurmaProfessor <> "0" and intCodDisciplina <> "0" then 
	   			
				sql = " select SCA_HORARIO_AULA.diaSemana, isnull(SCA_HORARIO.numero_aula,'1'), isnull(SCA_HORARIO.numero_aula,'1') * COUNT(SCA_HORARIO_AULA.cod_disciplina) as total_aulas  "
				sql = sql & " from SCA_HORARIO_AULA "
				sql = sql & " inner join SCA_HORARIO on SCA_HORARIO.codigo=SCA_HORARIO_AULA.Cod_Horario " 
				IF SESSION("CODGRUPO")="7" THEN
					SQL = SQL & " INNER JOIN SCA_TURNO TU ON TU.Cod_Turno = SCA_HORARIO.CodTurno " 
					SQL = SQL & " INNER JOIN SRH_TURNO TRH ON SUBSTRING(TRH.Desc_Turno,1,3) = SUBSTRING(TU.Desc_Turno,1,3) "				
				END IF
				sql = sql & " where SCA_HORARIO_AULA.cod_empresa = " & Session("CodEmpresa")
				sql = sql & " and SCA_HORARIO_AULA.anoletivo = " & strAnoLetivo 
				sql = sql & " and SCA_HORARIO_AULA.cod_turma = " & intCodTurmaProfessor  
				sql = sql & " and SCA_HORARIO_AULA.cod_disciplina = " & intCodDisciplina 
				sql = sql & " and SCA_HORARIO_AULA.diaSemana = " & weekday(strDataInicial) 
				IF SESSION("CODGRUPO")="7" THEN
					sql = sql & " and TRH.cod_turno = " & intCodTurno
				END IF
				sql = sql & " group by SCA_HORARIO_AULA.diaSemana, SCA_HORARIO.numero_aula "
	
				if strDataInicial <> "" then
					sql = sql & " UNION "
					sql = sql & " select DATEPART(DW, SCA_HORARIO_AULA_EXTRA.DataLancamento) AS diaSemana, isnull(SCA_HORARIO.numero_aula,'1'), isnull(SCA_HORARIO.numero_aula,'1') * COUNT(SCA_HORARIO_AULA_EXTRA.cod_disciplina) as total_aulas  "
					sql = sql & " from SCA_HORARIO_AULA_EXTRA "
					sql = sql & " inner join SCA_HORARIO on SCA_HORARIO.codigo=SCA_HORARIO_AULA_EXTRA.Cod_Horario " 
					IF SESSION("CODGRUPO")="7" THEN
						sql = sql & " inner join SCA_TURNO on SCA_TURNO.Cod_Turno = SCA_HORARIO.CodTurno"
						sql = sql & " inner join SRH_TURNO on left(SRH_TURNO.Desc_Turno,3) = left(SCA_TURNO.Desc_Turno,3)	"				
					END IF
					sql = sql & " where SCA_HORARIO_AULA_EXTRA.cod_empresa = " & Session("CodEmpresa")
					sql = sql & " and SCA_HORARIO_AULA_EXTRA.anoletivo = " & strAnoLetivo 
					sql = sql & " and SCA_HORARIO_AULA_EXTRA.cod_turma = " & intCodTurmaProfessor  
					sql = sql & " and SCA_HORARIO_AULA_EXTRA.cod_disciplina = " & intCodDisciplina 
					sql = sql & " and SCA_HORARIO_AULA_EXTRA.DataLancamento = '" & formatadataBD(strDataInicial) & "'" 
					IF SESSION("CODGRUPO")="7" THEN
						sql = sql & " and SRH_TURNO.cod_turno = " & intCodTurno
					END IF
					sql = sql & " group by SCA_HORARIO_AULA_EXTRA.DataLancamento, SCA_HORARIO.numero_aula "
				end if
				if ucase(session("usuarioweb")) = "SERGIO" then 
				'	response.write intCodTurno
					'response.write sql
				end if
				RSAUX.OPEN SQL, CNN
				IF NOT RSAUX.EOF THEN
					if isnull(RSAUX("total_aulas")) then
					   TotalAulaDiaria = 0
					else   
					   TotalAulaDiaria = RSAUX("total_aulas") 
					end if 
				else
					TotalAulaDiaria = 0
				end if
				RSAUX.close
				if TotalAulaDiaria <> 0 then 
				   strTotalAulasDia = TotalAulaDiaria
				end if
				if session("CodGrupo") = "2" then
				   soLeitura = " "
				else
				   soLeitura = " readonly "
				end if   
				%> 
                <tr>
                    <td height="29" class="texto1">Total de Aulas:</td>
                    <td class="texto1"><input <%=soLeitura%> name="txtTotalAulasDia" type="text" class="text" id="txtTotalAulasDia" value="<%=strTotalAulasDia%>" size="2" maxlength="2" > 
                    - Hor&aacute;rio de Aulas</td>
                </tr>
           <% end if  %> 
          <tr>
           <% if strHabilitaPlanoEnsino = "N" then %>
                 <td class="texto1">Conte&uacute;do:              </td>
           <% else %> 
                 <td class="texto1">Cronograma:              </td>
           <% end if %>          
            <td class="texto1"><label> 
                    <textarea  onkeyup="blocTexto(this.value,'<%=cont%>')"  name="txtDescricao" cols="100" rows="4" class="text" id="txtDescricao"><%=strDescricao%></textarea>
				<font color="#FF0000">(caracteres restantes: <span id="cont">500</span>)</font>			  
                    
                          
            </label></td>
          </tr>
          <tr>
            <td height="26">&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td height="45" colspan="2" class="texto1"><div align="left">Caso seja informado o m&ecirc;s na op&ccedil;&atilde;o abaixo <strong>&lt; Enviar Programa&ccedil;&atilde;o Did&aacute;tica &gt;</strong>, o mesmo per&iacute;odo e a disciplina ser&aacute; Bloqueado confirmando o <strong>Envio</strong> a Secretaria/Coordena&ccedil;&atilde;o.</div></td>
          </tr>
          <tr>
            <td height="44" class="texto1"><strong>Tomar Posse:</strong></td>
            <td class="texto1"><select name="cmbSimouNaoTomarPosse" class="combo" id="cmbSimouNaoTomarPosse"  style="width:70pt" onchange='submit()' >
              <option value="N" <%if strSimouNaoTomarPosse = "N" then response.Write("selected") %>>NAO</option>
              <option value="S" <%if strSimouNaoTomarPosse = "S" then response.Write("selected") %>>SIM</option>
            </select> 
              - Transfere conte&uacute;do de um professor para outro conforme mudan&ccedil;a no hor&aacute;rio e aula.</td>
          </tr>
          <tr>
            <td height="44"><span class="texto1"><strong>Enviar Programa&ccedil;&atilde;o Did&aacute;tica: </strong></span></td>
            <td><!--#include file="../includes/inc_cmbMes.asp"--></td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
          </tr>
          <tr>
            <td colspan="2"><br>
			<%
			if intCodColaboradorProfessor <> "0" and  intCodColaboradorProfessor <> "" then
			if intCodDisciplina<>"0" then

				cont =0
				if intSemestre = "" then intSemestre = session("strSemestre")
				if intCodTurno = "" then intCodTurno = 0
				sql = "SELECT c.Total_Aulas, c.codigo, c.Fechamento, c.datainicial, c.datafinal, c.conteudo, t.nometurma, d.Desc_Disciplina, cc.nome"
				sql = sql & " FROM SCA_Conteudo c"
				sql = sql & " inner join sca_turma t on t.cod_turma = c.cod_turma and t.cod_empresa = c.cod_empresa"
				sql = sql & " inner join sca_disciplina d on d.Cod_Disciplina = c.Cod_Disciplina and d.cod_empresa = c.cod_empresa"
				sql = sql & " left join SRH_COLABORADOR cc on cc.codigo = c.cod_colaborador"
				sql = sql & " where c.cod_empresa = " & Session("CodEmpresa")			
				sql = sql & " and c.anoletivo = " & strAnoLetivo		
				sql = sql & " and c.semestre in (" & intSemestre & ")"
				if strVerificaRegencia <> "S" then
					'sql = sql & " and c.cod_colaborador in (select codigo From SRH_COLABORADOR WHERE cpf = '" & strCpfTurmaProfessor &"')"
					if intCodColaboradorProfessor = "" then intCodColaboradorProfessor = 0
					sql = sql & " and c.cod_colaborador = " & intCodColaboradorProfessor
				end if
				if intCodTurno <> "0" AND SESSION("CODGRUPO")="7" then
					sql = sql & " and c.cod_turno = " & intCodTurno
				end if	
				if intCodTurmaProfessor <> "0" then
					sql = sql & " and c.cod_turma = " & intCodTurmaProfessor
				end if	
				if intCodDisciplina <> "0" then
					sql = sql & " and c.Cod_Disciplina = " & intCodDisciplina
				end if	
				sql = sql & " Order by c.anoletivo, c.semestre, t.nometurma, d.Desc_Disciplina, c.datainicial desc"
				
				if ucase(trim(session("usuarioweb"))) = "SERGIO" then 
					'response.write sql
				end if
				rs.open sql, cnn
				if rs.eof = false then
				%>
					<table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
					  <tr bgcolor="#E5E5E5">
						<td width="13%" class="celula"><strong>Turma</strong></td>
						<td width="11%" class="celula"><strong><strong>Disciplina</strong></strong></td>
						<td width="12%" class="celula"><strong>Professor</strong></td>
						<td width="13%" height="21" class="celula"><strong>Data<span class="TextoForm">/Per&iacute;odo</span></strong></td>
						<td width="5%" class="celula"><strong>Aulas</strong></td>
						<td width="30%" class="celula"><strong>Conte&uacute;do</strong></td>
						<td width="8%" class="celula"><strong>Status</strong></td>
					  </tr>
					  <%
					while not rs.eof
						cont = cont + 1	
						TotalAulas = TotalAulas + rs("Total_Aulas")	
							
						if strSimouNaoTomarPosse  = "S" and intCodDisciplina <> "0" and intCodColaboradorProfessor <> "0" then
							sql = "UPDATE SCA_CONTEUDO SET Cod_Colaborador = " & intCodColaboradorProfessor
							sql = sql & " WHERE codigo = " & rs("codigo")
							cnn.execute sql
						end if	
	
						if trim(rs("Fechamento")) <> "S" then
						   %>
						   <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("codigo")%>')">
							   <td class="celula"><%=rs("nometurma")%>&nbsp;</td>
							   <td class="celula"><%=rs("Desc_Disciplina")%></td>
							   <td class="celula">&nbsp;<%=rs("nome")%></td>
							   <td height="20" class="celula"><%=trim(formatadataAP(rs("datainicial")))%>&nbsp;&nbsp;a&nbsp;&nbsp;<%=trim(formatadataAP(rs("datafinal")))%></td>
							   <td class="celula"><div align="center"><%=rs("Total_Aulas")%>&nbsp;</div></td>
							   <td height="20" class="celula"><%=trim(rs("conteudo"))%>&nbsp;</td>
							  <%
							   if trim(rs("Fechamento")) = "S" then
								  %>
								  <td height="20" class="celula"><strong><font color='#FF0000'>Enviada</font></strong></td>
								  <%
							   else
								  %>
								  <td width="8%" height="20" class="celula"><strong>Edi&ccedil;&atilde;o</strong></td>
								 <%
							   end if 
							   %>  
						   </tr>
						   <%
						else
						   %>
						   <tr>
							   <td class="celula"><%=rs("nometurma")%></td>
							   <td class="celula"><%=rs("Desc_Disciplina")%></td>
							   <td class="celula">&nbsp;<%=rs("nome")%></td>
							   <td height="20" class="celula"><%=trim(formatadataAP(rs("datainicial")))%>&nbsp;&nbsp;a&nbsp;&nbsp;<%=trim(formatadataAP(rs("datafinal")))%></td>
							   <td class="celula"><div align="center"><%=rs("Total_Aulas")%>&nbsp;</div></td>
							   <td height="20" class="celula"><%=trim(rs("conteudo"))%></td>
							   <%
							   if trim(rs("Fechamento")) = "S" then
								  %>
								  <td height="20" class="celula"><strong><font color='#FF0000'>Enviada</font></strong></td>
								  <%
							   else
								  %>
								  <td height="20" class="celula"><strong>Edi&ccedil;&atilde;o</strong></td>
								  <%
							   end if 
							   %>  
						   </tr>
						   <%
						end if 
						rs.movenext
						wend
					  %>
					  <tr bgcolor="#CCCCCC">
						  <td height="21" class="celula"><strong>Total Registros : <%=cont%></strong></td>
						  <td height="21" class="celula">&nbsp;</td>
						  <td height="21" class="celula">&nbsp;</td>
						  <td height="21" class="celula"><strong>Total Aulas:</strong></td>
						  <td height="21" class="celula"><strong><%=TotalAulas%></strong></td>
						  <td height="21" class="celula">&nbsp;</td>
						  <td height="21" class="celula">&nbsp;</td>
					  </table>
				  <%
				  end if
				  rs.close
			 end if 
			  
			if strSimouNaoTomarPosse  = "S" and intCodDisciplina <> "0" and intCodColaboradorProfessor <> "0" then
				%>
				<script>
					alert("ATENÇÃO: Transfêrencia de conteúdo realizada com sucesso.");
					window.location='ConteudoProfessor_cad.asp';
				</script>
				<%
			end if	

			end if  
			  
			  %></td>
          </tr>
        </table>
        <br>
		</form>
		</td>
      </tr>
    </table>
	</td>
  </tr>
</table>
<!--#include file="../rodape.asp"-->
</body>
</html>