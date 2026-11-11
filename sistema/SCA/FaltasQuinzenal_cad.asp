<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
server.ScriptTimeout = 6000
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


	function resultadoConsulta(intCodigo){
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}
	
	function salvar(acao){
		frm.action="FaltasQuinzenal_cod.asp?acao=" + acao;
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
	strMes		 		= Trim(Request("cmbMes"))	
	strQuinzena		 	= Trim(Request("cmbQuinzena"))	
	
	if strMes = "12" then
	   qtdeDiasMes  = "31"
	   if strQuinzena = "1" then
	       qtdeDiasMes  = "15"
	   end if   
	else   
		aux=Cdate("01/" & cInt(ZEROLEFT(strMes,2))+1 & "/" & cInt(strAnoLetivo)) - 1
		if strQuinzena = "1" then
			aux=Cdate("16/" & cInt(ZEROLEFT(strMes,2))+1 & "/" & cInt(strAnoLetivo)) - 1
		end if	
	    qtdeDiasMes = day(aux)
	end if	
	
	'GRAVANDO NO ARQUIVO DE NOTAS
	strGravarOnde = "NOTA"
	msnHistorico  = ""
		
	if  Trim(Request("cmbTurma")) <> "" then
		intCodTurma 			= Trim(Request("cmbTurma"))
		intCodTurmaProfessor	= Trim(Request("cmbTurma"))
	else
		intCodTurma				= Trim(Request("cmbTurmaProfessor"))
		intCodTurmaProfessor	= Trim(Request("cmbTurmaProfessor"))
	end if
	
	if  Trim(Request("cmbDisciplinaTurma")) <> "" then
		intCodDisciplina			= Trim(Request("cmbDisciplinaTurma"))
		intCodDisciplinaTurma		= Trim(Request("cmbDisciplinaTurma"))
	else
		intCodDisciplina			 = Trim(Request("cmbDisciplinaDoProfessor"))
		intCodDisciplinaTurma		 = Trim(Request("cmbDisciplinaDoProfessor"))
	end if
	if intCodTurma = "" then intCodTurma = "0"
	if intCodTurmaProfessor = "" then intCodTurmaProfessor = "0"
	if intCodDisciplina = "" then intCodDisciplina = "0"
	if intCodDisciplinaTurma = "" then intCodDisciplinaTurma = "0"
	
	intCodCurso	 				= Trim(Request("cmbCurso"))
	intCodPeriodo 				= Trim(Request("cmbPeriodo"))
	intSemestre 				= Trim(Request("cmbSemestre"))
	
	intCodTurno		 			= Trim(Request("cmbTurno"))
	strAlunos      				= Trim(Request("chkAluno"))
	intCodTipoNota				= Trim(Request("chkTipoNota"))
	intCodTipoLancamento		= Trim(Request("cmbTipoLancamento")) '"0" '-->Nota e Falta | "1" '-->Somente Nota	| "2" '-->Somente Falta		
	strNomeNota 		= ""
	strNomeTipoBimestre = ""
	strPosicao 			= ""
	
	strNomedisciplina = ""
	sql = "SELECT DESC_DISCIPLINA FROM SCA_DISCIPLINA"
	sql = sql & " WHERE	COD_EMPRESA = " & Session("CodEmpresa") 
	sql = sql & " AND	COD_DISCIPLINA = " & intCodDisciplina
	rs.open sql, cnn
	if not rs.eof then
		strNomedisciplina = rs("DESC_DISCIPLINA")
	end if
	rs.close
	
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
	
	sql = " select SCA_HORARIO_AULA.diaSemana, SCA_HORARIO_AULA.cod_disciplina, isnull(SCA_HORARIO.numero_aula,'1'), isnull(SCA_HORARIO.numero_aula,'1') * COUNT(SCA_HORARIO_AULA.cod_disciplina) as total_aulas, SCA_HORARIO_AULA.sequencia "
	sql = sql & " from SCA_HORARIO_AULA "
	sql = sql & " inner join SCA_HORARIO on SCA_HORARIO.codigo=SCA_HORARIO_AULA.Cod_Horario "
	sql = sql & " where SCA_HORARIO_AULA.cod_empresa = " & Session("CodEmpresa")
	sql = sql & " and SCA_HORARIO_AULA.anoletivo = " & strAnoLetivo
	sql = sql & " and SCA_HORARIO_AULA.cod_turma = " & intCodTurma
	'será usada o dia da semana no horario somente quando for lançada a grade completa sem a disciplina
	if intCodDisciplinaTurma <> "0" then
		sql = sql & " and SCA_HORARIO_AULA.cod_disciplina = " & intCodDisciplina
	end if
	sql = sql & " group by SCA_HORARIO_AULA.diaSemana, SCA_HORARIO_AULA.cod_disciplina, SCA_HORARIO.numero_aula, SCA_HORARIO_AULA.sequencia "
	rsAux1.open sql, cnn, 3, 3
	if not rsAux1.eof then
		vetAux1 = rsAux1.getRows
	end if
	rsAux1.close
	
%>
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td>
	<table width="98%"  height="328" border="0" cellspacing="0" cellpadding="0">
      <tr valign="top">
        <td height="328" colspan="2" align="center">
		<form id="frm" method="post">
		<input type="hidden" name="txtPosicao" value="<%=strPosicao%>">
        <input type="hidden" name="cmbQtdeFaltas" value="<%=strQtdeFaltas%>">
		<input type="HIDDEN" name="txtBimestreAtual" value="<%=strCodBimestre%>">
		<input type="HIDDEN" name="txtData" value="<%=strData%>">
		  <table width="100%" border="0" cellpadding="0" cellspacing="0">

            <tr valign="top">
              <td width="100%" align="center" class="tituloSistema">Cadastro de Faltas pelo Horário de Aula</td>
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
		  <table width="99%" border="0" cellspacing="0" cellpadding="0" class="tabela">
            <tr bgcolor="#E5E5E5">
              <td width="6%" height="24" class="celula">&nbsp;<strong>Turma:</strong></td>
              <td width="12%" class="celula">&nbsp;<%=RS("NOMETURMA")%></td>
              <td width="7%" class="celula">&nbsp;<strong>Disciplina:</strong></td>
              <td width="23%" class="celula"><%if strNomedisciplina="" then%>Todas do Horário<%else%><%=strNomedisciplina%><%end if%>&nbsp;</td>
              <td width="12%" class="celula">&nbsp;<strong>Turno:</strong></td>
              <td width="12%" class="celula">&nbsp;<%=RS("DESC_TURNO")%></td>
              <td class="celula"><strong>&nbsp;</strong></td>
             </tr>
            <tr bgcolor="#E5E5E5">
              <td height="24" colspan="7" class="celula">&nbsp;</td>
              </tr>
          </table>
		  <%
		  end if
		  rs.close
		  %>
		  <br>
			<%		 
			'**** SELECIONA OS ALUNOS REGULARES E NOTAS E FALTAS
			
			sql = " SELECT distinct "
			sql = sql & " AD.CODIGO AS COD_ALUNODISCIPLINA, " 
			sql = sql & " AD.COD_ALUNO AS CODIGO, " 
			sql = sql & " AD.COD_TURMA_REMANEJAMENTO AS COD_TURMA, "
			sql = sql & " A.NOMEALUNO, "
			sql = sql & " A.MATRICULA, "
			sql = sql & " SA.DESC_SITUACAOALUNO "
			sql = sql & " FROM SCA_ALUNO_DISCIPLINA AD INNER JOIN " 
			sql = sql & " SCA_ALUNO A ON A.CODIGO = AD.COD_ALUNO  INNER JOIN "
			sql = sql & " SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = A.COD_SITUACAOALUNO AND SA.Cod_Empresa = A.COD_EMPRESA "
			sql = sql & " WHERE AD.COD_EMPRESA = " & Session("CodEmpresa")
			if trim(intCodTurma) <> "0" then
				sql = sql & " AND AD.COD_TURMA_REMANEJAMENTO = " & intCodTurma	
			end if
			if trim(intCodDisciplina) <> "0" then
				sql = sql & " AND  AD.COD_DISCIPLINA = " & intCodDisciplina
			end if
					
			sql = sql & " AND AD.COD_ALUNO in (" & strAlunos & ") "
			'sql = sql & " AND (SA.Desc_SituacaoAluno = 'ATIVO' OR SA.Desc_SituacaoAluno = 'PRÉ-MATRÍCULA') " 
			sql = sql & " ORDER BY A.NOMEALUNO "
			rs.open sql, cnn
			%>		  
		  <table width="99%" border="0" cellspacing="0" cellpadding="0" class="tabela">
          <tr bgcolor="#E5E5E5">
            <td colspan="2" rowspan="2" align="center" class="celula"><strong><%=ucase(monthName(strMes))%></strong></td>
            <td height="24"  colspan="31" align="center" class="celula"><strong><%=ucase(strNomeTipoBimestre)%></strong></td>
            </tr>
          <tr bgcolor="#E5E5E5">
            <td height="24" colspan="31" align="center" class="celula"><strong>FALTA&nbsp;<%=strNomeNota%></strong></td>
          </tr>
          <tr bgcolor="#E5E5E5">
            <td class="celula">&nbsp;<strong>Matrícula</strong></td>
            <td class="celula">&nbsp;<strong>Aluno</strong></td>
            <% 
            if intCodDisciplinaTurma <> "0" then
			    intMarcaQuinzena = 1	
			    if strQuinzena = "2" then intMarcaQuinzena = 16		
				for i = intMarcaQuinzena to qtdeDiasMes
					strData = strAnoLetivo & "/" & ZeroLeft(strMes,2) & "/" & ZeroLeft(i,2)
					diaSemana = weekday(strData)
					strQtdeFaltasHorario = "0"
	
					if isArray(vetAux1) then
						for j=0 to ubound(vetAux1,2)
	
							diaSemanaHorario = vetAux1(0,j) 
							sequenciaHorario = vetAux1(4,j) 
							strQtdeFaltasHorario = vetAux1(3,j) 
							strQtdeFaltasDia = 0
							
							if diaSemanaHorario = diaSemana then
								%>
								<td height="24" align="center" class="celula"><strong><%=ZeroLeft(i,2)%></strong></td>
								<%
							end if
						next		
					end if		
				next
			else
			    intMarcaQuinzena = 1	
			    if strQuinzena = "2" then intMarcaQuinzena = 16		
				for i = intMarcaQuinzena to qtdeDiasMes %>
           			<td class="celula" align="center"><strong><%=ZeroLeft(i,2)%></strong></td>
           		<%next
			end if	
	
			%>
            </tr>
		  	<%

		  contLanc = 0
		  while not rs.eof
		  		contLanc = contLanc + 1
				strCodAluno = RS("CODIGO")
				strAlunoDisciplina = RS("COD_ALUNODISCIPLINA")
				
				  %>
				  <tr  onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)">
					<td class="celula" width="12%">&nbsp;<%=rs("MATRICULA")%><input type="hidden" name="txtCodAluno_<%=contLanc%>" value="<%=rs("CODIGO")%>"></td>
					<td class="celula" width="72%">&nbsp;<%=rs("NOMEALUNO")%></td>
                    <%

					if intCodDisciplinaTurma <> "0" then
						intMarcaQuinzena = 1	
						if strQuinzena = "2" then intMarcaQuinzena = 16		
						for i = intMarcaQuinzena to qtdeDiasMes
							strData = strAnoLetivo & "/" & ZeroLeft(strMes,2) & "/" & ZeroLeft(i,2)
							strDataCampo = strAnoLetivo & "-" & ZeroLeft(strMes,2) & "-" & ZeroLeft(i,2)

							diaSemana = weekday(strData)
							if diaSemana = 1 then
							   cor = "bgcolor='#FF0000'" 
							   habilitaCampo = " disabled "
							elseif diaSemana = 7 then 
							   cor = "bgcolor='#FFFF00'"
							   habilitaCampo = " disabled "
							else   
							   cor = ""
							   habilitaCampo = ""
							end if 
							
							
							strQtdeFaltasHorario = "0"
							
							if isArray(vetAux1) then
								for j=0 to ubound(vetAux1,2)
			
									diaSemanaHorario = vetAux1(0,j) 
							
									if diaSemanaHorario = diaSemana then

										sequenciaHorario = vetAux1(4,j) 
										strQtdeFaltasHorario = vetAux1(3,j) 
										selecionado = ""
										SQL = "SELECT FALTA FROM SCA_FALTAS_DIARIA "
										SQL = SQL & " WHERE cod_empresa = " & Session("CodEmpresa")
										SQL = SQL & " AND cod_aluno = " & strCodAluno
										SQL = SQL & " AND cod_aluno_disciplina = "& strAlunoDisciplina
										SQL = SQL & " AND ano_letivo = " & strAnoLetivo
										SQL = SQL & " AND semestre = " & intSemestre
										SQL = SQL & " AND cod_disciplina = " & intCodDisciplina
										SQL = SQL & " AND data = '" & strData & "'"
										SQL = SQL & " AND sequencia = " & sequenciaHorario
										rs1.open sql, cnn
										if not rs1.eof then
											selecionado = "checked"
										end if
  										rs1.close
										%>
										<td align="left" class="celula" <%=cor%>><div align="center">
										<input <%=selecionado%> type="checkbox" name="txtFaltas_<%=strCodAluno%>_<%=strData%>_<%=sequenciaHorario%>" id="txtFaltas_<%=strCodAluno%>_<%=strData%>_<%=sequenciaHorario%>" value="<%=strQtdeFaltasHorario%>"></div></td>
										<%
									end if
								next		
							end if		
						 next
					else
						intMarcaQuinzena = 1	
						if strQuinzena = "2" then intMarcaQuinzena = 16		
						for i = intMarcaQuinzena to qtdeDiasMes
							strData = strAnoLetivo & "/" & ZeroLeft(strMes,2) & "/" & ZeroLeft(i,2)
							strDataCampo = strAnoLetivo & "-" & ZeroLeft(strMes,2) & "-" & ZeroLeft(i,2)

							selecionado = ""
							if strData <> "" then
								selecionado = "checked"
							end if
							
							diaSemana = weekday(strData)
							if diaSemana = 1 then
							   cor = "bgcolor='#FF0000'" 
							elseif diaSemana = 7 then 
							   cor = "bgcolor='#FFFF00'"
							else   
							   cor = ""
							end if   
							
							%>
							<td <%=cor%> class="celula" width="1%" align="left"><input  <%=selecionado%> type="checkbox" name="txtFaltas_<%=strCodAluno%>_<%=strData%>_<%=sequenciaHorario%>" id="txtFaltas_<%=strCodAluno%>_<%=strData%>_<%=sequenciaHorario%>" value="<%=strData%>"></td>
							<%
						next
					end if
					%>
                </tr>
			  <%
		  		rs.movenext
		  wend
		  rs.close
		  cnn.close
		  %>
          <tr bgcolor="#E5E5E5">
            <td height="24" class="celula">&nbsp;<strong>Matrícula</strong></td>
            <td class="celula">&nbsp;<strong>Aluno</strong></td>
            
            <% 
            if intCodDisciplinaTurma <> "0" then			
			    intMarcaQuinzena = 1	
			    if strQuinzena = "2" then intMarcaQuinzena = 16		
				for i = intMarcaQuinzena to qtdeDiasMes
					strData = strAnoLetivo & "/" & ZeroLeft(strMes,2) & "/" & ZeroLeft(i,2)
					diaSemana = weekday(strData)
					strQtdeFaltasHorario = "0"
	
					if isArray(vetAux1) then
						for j=0 to ubound(vetAux1,2)
	
							diaSemanaHorario = vetAux1(0,j) 
							strQtdeFaltasHorario = vetAux1(2,j) 
							strQtdeFaltasDia = 0
							
							if diaSemanaHorario = diaSemana then
								%>
								<td height="24" align="center" class="celula"><strong><%=ZeroLeft(i,2)%></strong></td>
								<%
							end if
						next		
					end if		
				next
			else
			    intMarcaQuinzena = 1	
			    if strQuinzena = "2" then intMarcaQuinzena = 16		
				for i = intMarcaQuinzena to qtdeDiasMes%>
           			<td class="celula" align="center"><strong><%=ZeroLeft(i,2)%></strong></td>
           		<%next
			end if	
			%>
            </tr>
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
        <input type="hidden" name="txtQtdeDias" value="<%=qtdeDiasMes%>">
        <input type="hidden" name="txtQuinzena" value="<%=strQuinzena%>">
        <input type="hidden" name="cmbMes" value="<%=strMes%>">	
		<%
		
			strParametro = "FaltasQuinzenal_con.asp?cmbPeriodo="&intCodPeriodo
			strParametro = strParametro & "&cmbSemestre="&intSemestre
			strParametro = strParametro & "&chkTipoNota="&intCodTipoNota
			strParametro = strParametro & "&cmbTurma="&intCodTurma
			strParametro = strParametro & "&cmbTurmaProfessor="&intCodTurma
			strParametro = strParametro & "&chkAluno="&strAlunos
			strParametro = strParametro & "&cmbTurno="&intCodTurno
			strParametro = strParametro & "&cmbTipoLancamento="&intCodTipoLancamento	
			strParametro = strParametro & "&cmbCurso="&intCodCurso	
			strParametro = strParametro & "&cmbMes="&strMes
			strParametro = strParametro & "&cmbDisciplinaTurma="&intCodDisciplinaTurma
			strParametro = strParametro & "&cmbDisciplinaDoProfessor="&intCodDisciplinaTurma
			
		
		%>
		<br>
		<div align="center">
		  <p>
		<% if session("UsuarioWeb") <> "USUARIO.TESTE" then %>
        	<input onClick="salvar('I')" name="btnSalvar" value=" Salvar Faltas" type="button" class="botao">
        <% end if %>

		   
		    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		      <input onClick="window.location='<%=strParametro%>'" name="btnVoltar" value="<< Voltar " type="button" class="botao">

		  <table width="188" border="1" cellpadding="1" cellspacing="1">
              <tr>
                <td width="18" height="22" align="center" bgcolor="#FFFF00" class="TextoForm">&nbsp;</td>
                <td width="157" class="texto">&nbsp;S&aacute;bado</td>
              </tr>
              <tr>
                <td height="22" align="center" bgcolor="#FF0000" class="TextoForm">&nbsp;</td>
                <td class="texto">&nbsp;Domingo</td>
              </tr>
            </table> 
		</div>
		  <input type="hidden" name="txtAnoLetivo" value="<%=strAnoLetivo%>">
		  <input type="hidden" name="txtSemestre" value="<%=intSemestre%>">
          <input type="hidden" name="txtPaginaRetorno" value="FALTASPROF">
		</form>
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