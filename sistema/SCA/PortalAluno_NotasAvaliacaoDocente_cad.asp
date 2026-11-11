<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 12/08/2008
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Relatorio - Avaliação Institucional
-->
<title><%=session("Titulo")%></title>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../../estilo/css.css" rel="stylesheet" type="text/css">
</head>
<script src="../../js/js_funcoes_gerais.js"></script>
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="topo.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<script>

	function blocTexto(valor)
	{
		quant = 200;
		total = valor.length;
		if(total <= quant)
		{
			resto = quant - total;
			document.getElementById('cont').innerHTML = resto;
		}
		else
		{
			document.getElementById('txtResposta').value = valor.substr(0,quant);
		}
	}

	function marcaTodos(valor){
		
		var form = document.getElementById("frm");
		var i;
		for (var i = 0; i < form.elements.length; i++) {
			//verifica todos os checkbox
			if (form.elements[i].type == "checkbox"){
				//verifica se o checkbox está marcado
				form.elements[i].checked=valor;
			}
		}
	}
	
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		var intContMarcado=0;
		
		if (frm.cmbAvaliacaoInstitucional.value == "0"){
			alert("A Avaliação deve ser informada.");
			frm.cmbAvaliacaoInstitucional.focus();
			return false;
		}
		
		frm.action = "PortalAluno_NotasAvaliacao_cod.asp?acao=" + acao;
		frm.submit();
		return true;	
	}
</script>
<%

	strExecutarSubmit					= "S"
	strPaginaTitulo 					= "PortalAluno_NotasAvaliacaoInstitucional_cad.asp"
	intCodAvaliacao				 	    = Trim(Request("a"))
	intCodAvaliacaoInstitucional   		= Trim(Request("a"))
	
	SQL=" SELECT TOP 1 "
	SQL=SQL & " T.COD_TURMA, "
	SQL=SQL & " T.NOMETURMA,"
	SQL=SQL & " A.MATRICULA "
	SQL=SQL & " FROM SCA_ALUNO A "
	SQL=SQL & " INNER JOIN SCA_ALUNO_TURMA AT ON AT.COD_ALUNO = A.CODIGO AND A.COD_EMPRESA = AT.COD_EMPRESA "
	SQL=SQL & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = AT.COD_TURMA AND T.COD_EMPRESA = AT.COD_EMPRESA "
	SQL=SQL & " WHERE A.CODIGO = " & trim(Session("CodSeguranca"))
	SQL=SQL & " Order BY AT.CODIGO DESC "
	rsAux.OPEN SQL, CNN
	if rsAux.EOF = FALSE THEN 
	   	intCodTurma 	= rsAux("COD_TURMA")
		strNomeTurma	= rsAux("NOMETURMA")
		strMatricula    = rsAux("MATRICULA")
	else
	 	%>
	  	<script>
			alert("A T E N Ç Ã O! Matrícula não Alocada, verifique junto a Secretaria.");
			window.history.back();
	 	</script>
	 	<%
	  	rsAux.close
	 	response.end
	end if   	   
	rsAux.close

	strAnoLetivo 						= session("strAnoLetivo")   	
	intSemestre 						= session("strSemestre")
	
	cont = 0
	if intCodAvaliacao 					= "" then intCodAvaliacao 	  = "0"
	if intCodTurma 						= "" then intCodTurma 		  = "0"
	if intCodSituacaoAluno 				= "" then intCodSituacaoAluno = "0"



	' Busca Tipo da Avalição
	if intCodAvaliacao <> 0 then 
		
		sql = "SELECT Codigo, Cod_empresa, Descricao, Ano_Letivo, Semestre, Tipo_Avaliacao, Tipo_Consulta"
		sql = sql & " FROM SAV_AVALIACAO_INSTITUCIONAL"
		sql = sql & " Where Codigo = " & intCodAvaliacao
		sql = sql & " And cod_empresa = " & Session("CodEmpresa")

		rs.open sql, cnn
		if rs.eof = false then
			intCodAvaliacao			= rs("Codigo")
			strNomeAvaliacao		= rs("Descricao")
			intAnoLetivo			= rs("Ano_Letivo")
			intSemestre				= rs("Semestre")
			intTipoAvaliacao		= trim(rs("Tipo_Avaliacao"))
			intTipoConsulta			= triM(rs("Tipo_Consulta"))
		end if 
		rs.close
	
       ' Busca Tipo da Avalição
	   sql = "SELECT CodAvaliacao, Cod_Turma, Cod_aluno"
	   sql = sql & " FROM SAV_AVALIACAO_PERGUNTA_NOTA"
	   sql = sql & " Where CodAvaliacao = " & intCodAvaliacao
	   sql = sql & " And Cod_Turma = " & intCodTurma
  	   sql = sql & " And Cod_aluno = " & trim(Session("CodSeguranca"))
	   rs.open sql, cnn
	   if rs.eof = false then
	
  		  %>
		  <script>
			alert("A T E N C A O!   Avaliação já realizada.");
			window.navigate('NotasAvaliacao_cad.asp');
		 </script>
		 <%
		 response.end
	   end if 
	   rs.close
    end if
		
	strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
	strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
	strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	
%>
<form method="post" id="frm" action="#">
	<table  height="355" border="0"  class="CorFundo" cellpadding="0" bgcolor="#FFFFFF" cellspacing="0">
	<tr valign="top">
	  <td align="center"><span class="tituloSistema"><strong>Notas Avalia&ccedil;&atilde;o</strong></span></td>
	  </tr>
	<tr valign="top">
	<td width="100%" align="center">
 	 <table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" bgcolor="#FFFFFF" class="Formulario">
    <tr> 
      <td height="12" colspan="3" align="center">&nbsp;</td>
      </tr>
    <tr>
      <td height="23" class="TextoForm">Matricula:</td>
      <td class="texto1"><input name="txtLogin" readonly ="false" type="text" class="text" id="txtLogin" size="10" maxlength="12"  value="<%=strMatricula%>" >      </td>
    </tr>
    <tr>
      <td width="11%" height="23" class="TextoForm">Turma : </td>
      <td width="89%" class="texto1">
        <input name="txtCodTurma" type="text" class="text" id="txtCodTurma" size="9" maxlength="9" value="<%=intCodTurma%>">
        <input name="txtTurma" type="text" class="text" id="txtTurma" readonly="false" size="12" maxlength="15" value="<%=trim(strNomeTurma)%>">        </td>
    </tr>
    <tr>
      <td height="23" class="TextoForm">Avalia&ccedil;&atilde;o : </td>
      <td colspan="2"><!--#include file="../includes/inc_cmdAvaliacaoInstitucionalEscolhida.asp" -->&nbsp;</td>
    </tr>
    <tr>
      <td colspan="3" class="texto1">&nbsp;</td>
    </tr>
    <tr>
      <td colspan="3" align="center" class="textoAtencao"><p>ATEN&Ccedil;&Atilde;O: Para finalizar a avalia&ccedil;&atilde;o,  clique  no bot&atilde;o  INCLUIR no final do question&aacute;rio.</p></td>
    </tr>
    <tr>
      <td colspan="3" class="texto1">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="3" class="texto1">
	  
	  	<table "91%" border="0" cellspacing="0" align="center" cellpadding="0">
        <tr>
          <td width="112" class="texto2" height="23" align="center">(<strong>A</strong>) Excelente</td>
          <td width="111" class="texto2" align="center">(<strong>B</strong>) Muito Bom</td>
          <td width="87"  class="texto2" align="center">(<strong>C</strong>) Bom </td>
          <td width="114" class="texto2" align="center">(<strong>D</strong>) Regular</td>
          <td width="111" class="texto2" align="center">(<strong>E</strong>) Insuficiente</td>
          
        </tr>
      	</table>        </td>
    </tr>
    <tr>
    <td colspan="3" class="texto1">&nbsp;
<%
		
	' Tipo Avaliação: 
	' 1 - Curricular     ---> Buscao consulta do aluno
	' 2 - Não Curricular 
	
	' Tipo Consulta: 
	' 1 - Curricular  		-->> 1 - Aluno
	' 2 - Não Curricular	-->> 1 - Aluno ou 2 - Colaborador
	
	' 1 - Curricular	-->> 1 - Aluno 
	' Busca todos os alunos pela turma informada, gerendo uma avaliação por disciplina

		intCodAluno 		= Session("CodAluno")
		
		intColunas = 0
		'busca pela grade da turma
		'sql = "SELECT DISTINCT dbo.SCA_DISCIPLINA.Cod_Disciplina, dbo.SCA_DISCIPLINA.Desc_Disciplina AS DISCIPLINA, dbo.SRH_COLABORADOR.nome as professor"
		'sql = sql & " FROM dbo.SCA_TURMA INNER JOIN dbo.SCA_GRADECURRICULAR ON dbo.SCA_TURMA.Cod_GradeCurricular = dbo.SCA_GRADECURRICULAR.Cod_GradeCurricular AND "		
		'sql = sql & " dbo.SCA_TURMA.Cod_Empresa = dbo.SCA_GRADECURRICULAR.Cod_Empresa INNER JOIN dbo.SCA_GRADECURRICULARDISCIPLINA ON dbo.SCA_GRADECURRICULAR.Cod_GradeCurricular = dbo.SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricular INNER JOIN 						  dbo.SCA_DISCIPLINA ON dbo.SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = dbo.SCA_DISCIPLINA.Cod_Disciplina INNER JOIN"
		'sql = sql & " dbo.SCA_HORARIO_AULA ON dbo.SCA_TURMA.Cod_Turma = dbo.SCA_HORARIO_AULA.Cod_turma AND 	dbo.SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = dbo.SCA_HORARIO_AULA.Cod_Disciplina AND "
		'sql = sql & " dbo.SCA_DISCIPLINA.Cod_Disciplina = dbo.SCA_HORARIO_AULA.Cod_Disciplina AND dbo.SCA_GRADECURRICULAR.Cod_Empresa = dbo.SCA_HORARIO_AULA.Cod_Empresa INNER JOIN"
		'sql = sql & " dbo.SRH_COLABORADOR ON dbo.SCA_HORARIO_AULA.Cod_Colaborador = dbo.SRH_COLABORADOR.codigo AND dbo.SCA_HORARIO_AULA.Cod_Empresa = dbo.SRH_COLABORADOR.cod_empresa"
		'sql = sql & " AND SCA_TURMA.Cod_Empresa= " & session("CodEmpresa")
		'sql = sql & " AND SCA_TURMA.Cod_Turma = " & intCodTurma
		'sql = sql & " ORDER BY Desc_Disciplina,SCA_DISCIPLINA.Cod_Disciplina"
		
		'busca pela grade do aluno (aluno_discplina)
		sql = "SELECT DISTINCT dbo.SCA_DISCIPLINA.Cod_Disciplina, dbo.SCA_DISCIPLINA.Desc_Disciplina AS DISCIPLINA, dbo.SRH_COLABORADOR.nome as professor,  dbo.SCA_TURMA.Cod_Turma,  dbo.SCA_TURMA.NomeTurma"
		sql = sql & " FROM dbo.SCA_TURMA INNER JOIN"
		sql = sql & " dbo.SCA_GRADECURRICULAR ON dbo.SCA_TURMA.Cod_GradeCurricular = dbo.SCA_GRADECURRICULAR.Cod_GradeCurricular AND "
		sql = sql & " dbo.SCA_TURMA.Cod_Empresa = dbo.SCA_GRADECURRICULAR.Cod_Empresa INNER JOIN"
		sql = sql & " dbo.SCA_GRADECURRICULARDISCIPLINA ON "
		sql = sql & " dbo.SCA_GRADECURRICULAR.Cod_GradeCurricular = dbo.SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricular INNER JOIN"
		sql = sql & " dbo.SCA_DISCIPLINA ON dbo.SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = dbo.SCA_DISCIPLINA.Cod_Disciplina INNER JOIN"
		sql = sql & " dbo.SCA_HORARIO_AULA ON dbo.SCA_TURMA.Cod_Turma = dbo.SCA_HORARIO_AULA.Cod_turma AND "
		sql = sql & " dbo.SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = dbo.SCA_HORARIO_AULA.Cod_Disciplina AND "
		sql = sql & " dbo.SCA_DISCIPLINA.Cod_Disciplina = dbo.SCA_HORARIO_AULA.Cod_Disciplina AND "
		sql = sql & " dbo.SCA_GRADECURRICULAR.Cod_Empresa = dbo.SCA_HORARIO_AULA.Cod_Empresa INNER JOIN"
		sql = sql & " dbo.SRH_COLABORADOR ON dbo.SCA_HORARIO_AULA.Cod_Colaborador = dbo.SRH_COLABORADOR.codigo AND "
		sql = sql & " dbo.SCA_HORARIO_AULA.Cod_Empresa = dbo.SRH_COLABORADOR.cod_empresa INNER JOIN"
		sql = sql & " dbo.SCA_ALUNO_DISCIPLINA ON dbo.SCA_TURMA.Cod_Turma = dbo.SCA_ALUNO_DISCIPLINA.COD_TURMA_REMANEJAMENTO AND "
		sql = sql & " dbo.SCA_TURMA.Cod_Turma = dbo.SCA_ALUNO_DISCIPLINA.COD_TURMA AND "
		sql = sql & " dbo.SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricularDisciplina = dbo.SCA_ALUNO_DISCIPLINA.COD_GRADECURRICULARDISCIPLINA AND "
		sql = sql & " dbo.SCA_DISCIPLINA.Cod_Disciplina = dbo.SCA_ALUNO_DISCIPLINA.COD_DISCIPLINA AND "
		sql = sql & " dbo.SCA_TURMA.Cod_Empresa = dbo.SCA_ALUNO_DISCIPLINA.COD_EMPRESA"
		sql = sql & " WHERE SCA_TURMA.Cod_Empresa= " & session("CodEmpresa")
		sql = sql & " AND SCA_ALUNO_DISCIPLINA.COD_ALUNO = " & trim(Session("CodSeguranca"))	
		'sql = sql & " AND SCA_TURMA.Cod_Turma = " & intCodTurma
		sql = sql & " ORDER BY Desc_Disciplina,SCA_DISCIPLINA.Cod_Disciplina"
		vetDisc = null
		rs.open sql, cnn
		if not rs.eof then
			vetDisc = rs.getRows
			intColunas = ubound(vetDisc,2)+1
		else
			 %>
			  <script>
				alert("A T E N Ç Ã O!   Aluno não esta vinculado a nenhuma grade.");
				window.location='NotasAvaliacao_cad.asp';
			 </script>
			 <%
			 response.end		
		end if
		rs.close
					
  	    sql = "SELECT Codigo, Cod_Avaliacao_Institucional, Descricao, Tipo_Pergunta, Subtitulo"
		sql = sql & " FROM SAV_AVALIACAO_PERGUNTA"
		sql = sql & " Where Cod_Avaliacao_Institucional = " & intCodAvaliacao
		sql = sql & " And cod_empresa = " & Session("CodEmpresa")
		rsAux.open sql, cnn

		if not rsAux.eof then 
		%>	<table border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
		    <tr>
		      <td bgcolor="#F0F0F0" height="21" align="center" class="celula"><strong>Disciplina</strong></td>
              <%for i=1 to intColunas
				 	If i MOD 2=0 Then
						strCorColuna = " bgcolor='#FFFFCC' "
					Else
						strCorColuna = ""
					End if					
			  %>
		      <td  <%=strCorColuna%>  colspan="5" align="center" class="celula"><strong>&nbsp;<%=vetDisc(1,i-1)%></strong></td>
              <%next%>
		      </tr>
		    <tr>
		      <td bgcolor="#F0F0F0" height="21" align="center" class="celula"><strong>Professor</strong></td>
              <%for i=1 to intColunas
				 	If i MOD 2=0 Then
						strCorColuna = " bgcolor='#FFFFCC' "
					Else
						strCorColuna = ""
					End if					
			  %>
		      <td  <%=strCorColuna%>  colspan="5" align="center" class="celula"><strong>&nbsp;<%=vetDisc(2,i-1)%>&nbsp;-&nbsp;<%=vetDisc(4,i-1)%></strong></td>
              <%next%>
		      </tr>
		    <tr>
		 <td rowspan="2"  bgcolor="#F0F0F0" align="center" class="celula"><strong>TURMA: </strong><%=trim(strNomeTurma)%>&nbsp;&nbsp;</td>
         <%for i=1 to intColunas
				 	If i MOD 2=0 Then
						strCorColuna = " bgcolor='#FFFFCC' "
					Else
						strCorColuna = ""
					End if					
			  %>
		 <td height="21" colspan="5" align="center" class="celula"><strong>Conceito</strong></td>
         <%next%>
		 </tr>
		 <tr>
		 <%for i=1 to intColunas
				 	If i MOD 2=0 Then
						strCorColuna = " bgcolor='#FFFFCC' "
					Else
						strCorColuna = ""
					End if					
			  %>
		 <td  <%=strCorColuna%>  width="25" height="21" align="center" class="celula"><strong>A</strong></td>
		 <td <%=strCorColuna%>  width="25" align="center" class="celula"><strong>B</strong></td>
		 <td <%=strCorColuna%>  width="25" align="center" class="celula"><strong>C</strong></td>
		 <td <%=strCorColuna%>  width="25" align="center" class="celula"><strong>D</strong></td>
		 <td <%=strCorColuna%>  width="25" align="center" class="celula"><strong>E</strong></td>
         <%next%>
		 </tr>
		 <%
		while not rsAux.eof
				
			intCodItemAvaliacao = rsAux("codigo")
			strTipo_pergunta 	= rsAux("Tipo_Pergunta")

			if trim(rsAux("Subtitulo")) <> "" then
		   	   %>
		 	   <tr bgcolor="#F0F0F0">
			   <td height="21" colspan="<%=(intColunas*5)+1%>" class="celula"><strong><%=trim(rsAux("Subtitulo"))%></strong></td>
		 	   </tr>
			   <%
			end if 
			
			if strTipo_pergunta = "O" then
			   %>
			   <tr>
               <td height="35" class="celula">
               <input name="chkAvaliacao" type="hidden" id="chkAvaliacao" value="<%=intCodItemAvaliacao%>" checked <%=strDesabilitaAluno%> >
			   <input name="txtCodAluno_<%=cont%>" value="<%=intCodAluno%>"  type="hidden" class="text" id="txtCodAluno" size="5">
			   <%=trim(rsAux("Descricao"))%>			   </td>
               <%for i=1 to intColunas
				 	If i MOD 2=0 Then
						strCorColuna = " bgcolor='#FFFFCC' "
					Else
						strCorColuna = ""
					End if					
			  %>
			   <td <%=strCorColuna%>  align="center" class="celula"><input name="optConceito_<%=cont%>_<%=i%>" type="radio" value="A" <%=strMarcaA%>></td>
			   <td <%=strCorColuna%>  align="center" class="celula"><input name="optConceito_<%=cont%>_<%=i%>" type="radio" value="B" <%=strMarcaB%>></td>
			   <td <%=strCorColuna%>  align="center" class="celula"><input name="optConceito_<%=cont%>_<%=i%>" type="radio" value="C" <%=strMarcaC%>></td>
			   <td <%=strCorColuna%>  align="center" class="celula"><input name="optConceito_<%=cont%>_<%=i%>" type="radio" value="D" <%=strMarcaD%>></td>
			   <td <%=strCorColuna%>  align="center" class="celula"><input name="optConceito_<%=cont%>_<%=i%>" type="radio" value="E" <%=strMarcaE%>>
               <input name="txtCodDisciplina_<%=cont%>_<%=i%>" value="<%=vetDisc(0,i-1)%>"  type="hidden" id="txtCodDisciplina_<%=cont%>_<%=i%>"></td>
               
			   <%next%>
			   </tr>
			   <%
			else
			   %>
			   <tr>
			   <td height="21" colspan="<%=(intColunas*5)+1%>" class="celula">
               <input name="chkAvaliacao" type="hidden" id="chkAvaliacao" value="<%=intCodItemAvaliacao%>" checked <%=strDesabilitaAluno%> >
			   <input name="txtCodAluno_<%=cont%>" value="<%=intCodAluno%>"  type="hidden" class="text" id="txtCodAluno" size="5">
               <input name="txtCodDisciplina_<%=cont%>" value="<%=intCodDisciplina%>"  type="hidden" class="text" id="txtCodDisciplina" size="5"><%=trim(rsAux("Descricao"))%>               </td>
			   </tr>
			   <tr>
               
			   <td height="30" colspan="<%=(intColunas*5)+1%>" class="celula">
			   <textarea  onkeyup="blocTexto(this.value)"  name="txtResposta" cols="100" rows="2" class="text" id="txtResposta"><%=strResposta%></textarea>
				<font color="#FF0000">(caracteres restantes: <span id="cont">200</span>)</font>			   </td>
               
			   </tr>
               <%
			end if
			cont = cont + 1				
			rsAux.movenext
			wend
			%>
			 </table>
			<%
		end if
		rsAux.close
		%></td>
    </tr>
    <tr>
      <td colspan="3" class="texto1">&nbsp;</td>
    </tr>
    <tr>
      <td colspan="3" class="texto1">
	  <%if intCodAvaliacao <> 0 then %>
	  <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
	  <%end if%>	  </td>
    </tr>
    <tr>
      <td colspan="3" class="texto1">&nbsp;</td>
    </tr>
  </table>  </td>
  </tr>
  </table>
  <input type="hidden" value="<%=intColunas%>" id="txtColunas" name="txtColunas"/>
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>