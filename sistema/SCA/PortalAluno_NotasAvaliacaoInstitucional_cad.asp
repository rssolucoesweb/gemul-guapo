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

	function blocTexto(valor, id)
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
			document.getElementById('txtResposta_'+id).value = valor.substr(0,quant);
		}
	}

	function marcaTodos(valor){
		
		var frm = document.getElementById("frm");
		var form = window.document.forms[0];
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
		var form = window.document.forms[0];
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
	intCodAvaliacao				 	    = Trim(Request.form("cmbAvaliacaoInstitucional"))
	intCodAvaliacaoInstitucional   		= Trim(Request.form("cmbAvaliacaoInstitucional"))
	
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
			alert("A T E N Ç Ã O! Avaliação já realizada.");
			window.location = 'default.asp';
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
	<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" bgcolor="#FFFFFF" cellspacing="0">
	<tr valign="top">
	  <td align="center"><span class="tituloSistema"><strong>Notas Avalia&ccedil;&atilde;o</strong></span></td>
	  </tr>
	<tr valign="top">
	<td width="700" align="center">
 	 <table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" bgcolor="#FFFFFF" class="Formulario">
    <tr> 
      <td height="12" colspan="3" align="center">&nbsp;</td>
      </tr>
    <tr>
      <td height="23" class="TextoForm">Matricula:</td>
      <td class="texto1"><input name="txtLogin" readonly ="false" type="text" class="text" id="txtLogin" size="10" maxlength="12"  value="<%=trim(strMatricula)%>" >      </td>
    </tr>
    <tr>
      <td width="11%" height="23" class="TextoForm">Turma : </td>
      <td width="89%" class="texto1">
        <input name="txtCodTurma" type="hidden" class="text" id="txtCodTurma" size="9" maxlength="9" value="<%=intCodTurma%>">
        <input name="txtTurma" type="text" class="text" id="txtTurma" readonly="false" size="12" maxlength="15" value="<%=trim(strNomeTurma)%>">        </td>
    </tr>
    <tr>
      <td height="23" class="TextoForm">Avalia&ccedil;&atilde;o : </td>
      <td colspan="2"><!--#include file="../includes/inc_cmdAvaliacaoInstitucionalPortal.asp" -->&nbsp;</td>
    </tr>
    <tr>
      <td colspan="3" class="texto1">&nbsp;</td>
    </tr>
    <tr>
      <td colspan="3" align="center" class="textoAtencao"><p>ATEN&Ccedil;&Atilde;O: Para finalizar a avalia&ccedil;&atilde;o,  clque  no bot&atilde;o  INCLUIR no final do question&aacute;rio.</p></td>
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

	if intTipoAvaliacao =  1 and intTipoConsulta = 1 then
		response.Redirect("PortalAluno_NotasAvaliacaoDocente_cad.asp?a=" & intCodAvaliacao)
		response.End()
		
		
		sql = " SELECT SCA_DISCIPLINA.Cod_Disciplina, SCA_DISCIPLINA.Desc_Disciplina as DISCIPLINA, "
		sql = sql & " SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricularDisciplina, "
		sql = sql & " SCA_TURMA.Cod_Turma, SCA_TURMA.NomeTurma"
		sql = sql & " FROM  SCA_TURMA "
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
		sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA ON SCA_GRADECURRICULAR.Cod_GradeCurricular = SCA_GRADECURRICULARDISCIPLINA.Cod_GradeCurricular "
		sql = sql & " INNER JOIN SCA_DISCIPLINA ON SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = SCA_DISCIPLINA.Cod_Disciplina"
		sql = sql & " WHERE 1=1"
		sql = sql & " AND SCA_TURMA.Cod_Empresa= " & session("CodEmpresa")
		sql = sql & " AND SCA_TURMA.Cod_Turma = " & intCodTurma
		sql = sql & " ORDER BY Desc_Disciplina"
	end if
	
	' 2 - Não Curricular	-->> 1 - Aluno 
	' Busca todos os alunos pela turma informada
	
	if intTipoAvaliacao =  2 and intTipoConsulta = 1 then
		
		sql = "select top 1 AT.COD_TURMA, T.NOMETURMA, AT.COD_ALUNO "
		sql = sql & " from SCA_ALUNO_TURMA AT"
		sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = AT.COD_TURMA AND T.COD_EMPRESA = AT.COD_EMPRESA "
		sql = sql & " INNER JOIN SCA_ALUNO AL ON AL.COD_EMPRESA = AT.COD_EMPRESA AND AL.CODIGO = AT.COD_ALUNO"
		sql = sql & " AND AT.ANO_LETIVO = T.AnoLetivo AND AT.SEMESTRE = T.Cod_Semestre"
		sql = sql & " where AT.COD_EMPRESA = " &  Session("CodEmpresa")
		sql = sql & " and AT.COD_ALUNO = " & trim(Session("CodSeguranca"))
		sql = sql & " order by AT.CODIGO desc"


		'sql = " SELECT TOP 1 T.COD_TURMA, T.NOMETURMA, AT.COD_ALUNO, AL.COD_SITUACAOALUNO "
		'sql = sql & " FROM SCA_TURMA T "
		'sql = sql & " INNER JOIN SCA_ALUNO_TURMA AT ON AT.COD_EMPRESA = T.COD_EMPRESA AND T.COD_TURMA = AT.COD_TURMA"
		'sql = sql & " INNER JOIN SCA_ALUNO AL ON AL.COD_EMPRESA = AL.COD_EMPRESA AND AL.CODIGO = AT.COD_ALUNO"
		'sql = sql & " WHERE T.COD_EMPRESA = " & session("CodEmpresa")
		'sql = sql & " AND T.ANOLETIVO = " & Session("AnoLetivo")
		'sql = sql & " AND T.COD_SEMESTRE = " & Session("Semestre") 
		'sql = sql & " AND T.COD_TURMA = " & intCodTurma
		'sql = sql & " AND AT.SITUACAO = 'A'"
		'sql = sql & " AND AT.COD_ALUNO = " & Session("CodAluno") 
		
		'if intCodSituacaoAluno <> 0 then
		'	sql = sql & " AND AL.COD_SITUACAOALUNO = " & intCodSituacaoAluno
		'end if

		'sql = sql & " ORDER BY AT.COD_ALUNO"
	end if
	
	' 2 - Não Curricular	-->> 2 - Colaborador
	' Busca todos os colaboradores, com situacao Ativo
	if intTipoAvaliacao =  2 and intTipoConsulta = 2 then
		
		sql = "SELECT Codigo, cod_empresa, Nome From SRH_COLABORADOR" 
		sql = sql & " 	Where cod_empresa = " & session("CodEmpresa")
		sql = sql & " 	And Situacao = 'A'"
		
		if intCodCategoria <> 0 then
			sql = sql & " 	And CodCategoria = " & intCodCategoria
		end if

	end if

	rs.open sql, cnn
	if not rs.eof then 
			
	While not rs.eof 
		
		' Busca todos os alunos pela turma informada, gerendo uma avaliação por disciplina	
		if intTipoAvaliacao =  1 and intTipoConsulta = 1 then
			
			strCodTurma			= rs("Cod_Turma") 
			strTurma			= rs("NomeTurma")
			intCodDisciplina 	= rs("Cod_Disciplina")
			strDisciplina 		= rs("DISCIPLINA")
			intCodAluno 		= trim(Session("CodSeguranca"))
			
			sql = " SELECT C.CODIGO, C.NOME FROM SCA_HORARIO_AULA HA"
			sql = sql & " INNER JOIN SRH_COLABORADOR C ON C.COD_EMPRESA = HA.COD_EMPRESA AND C.CODIGO = HA.Cod_Colaborador"
			sql = sql & " WHERE HA.COD_EMPRESA = " & session("CodEmpresa")
			sql = sql & " AND HA.ANOLETIVO = " &  strAnoLetivo
			sql = sql & " AND HA.SEMESTRE = " & intSemestre
			sql = sql & " AND HA.cod_Turma = " & strCodTurma
			sql = sql & " and HA.Cod_Disciplina = " & intCodDisciplina
			rsAux.open sql, cnn
	
			if not rsAux.eof then 
				strNome = rsAux("NOME")	
			else
				strNome = ""
			end if 	
			rsAux.close		
			
		end if
	
		if intTipoAvaliacao =  2 and intTipoConsulta = 1 then
			strCodTurma			= rs("COD_TURMA") 
			strTurma			= rs("NOMETURMA")
			intCodAluno 		= rs("COD_ALUNO")
		end if
		
		if intTipoAvaliacao =  2 and intTipoConsulta = 2 then
			strDisciplina 	= ""
			strNome 		= rs("Nome")	
			intCodAluno 	= rs("Codigo")
			strCurso		= ""
			strTurma		= ""
		end if
		
  	    sql = "SELECT Codigo, Cod_Avaliacao_Institucional, Descricao, Tipo_Pergunta, Subtitulo"
		sql = sql & " FROM SAV_AVALIACAO_PERGUNTA"
		sql = sql & " Where Cod_Avaliacao_Institucional = " & intCodAvaliacao
		sql = sql & " And cod_empresa = " & Session("CodEmpresa")
		rsAux.open sql, cnn
	
		if not rsAux.eof then 
	
		 if intTipoAvaliacao =  1 and intTipoConsulta = 1 or intTipoAvaliacao =  2 and intTipoConsulta = 1 then
		    %>
            <table width = "98%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
            <tr bgcolor="#E5E5E5">
            <td width="11%" height="21" class="celula"><strong>TURMA: </strong></td>
            <td width="21%" height="21" class="celula"><%=strTurma%></td>
            <td width="25%" height="21" class="celula"><strong>PROFESSOR(A) : </strong></td>
            <td height="21" colspan="7" class="celula"><%=strNome%>&nbsp;</td>
            </tr>
            <tr bgcolor="#E5E5E5">
            <td height="21" class="celula"><strong>DISCIPLINA</strong>:</td>
            <td height="21" colspan="9" class="celula"><%=strDisciplina%>&nbsp;</td>
            </tr>
		    <%
		 end if
		 %>
		 <tr bgcolor="#E5E5E5">
		 <td height="21" colspan="4" class="celula">&nbsp;</td>
		 <td colspan="6" align="center" class="celula"><strong>Conceito</strong></td>
		 </tr>
		 <tr bgcolor="#E5E5E5">
		 <td height="21" colspan="4" class="celula">&nbsp;&nbsp;</td>
		 <td width="4%" align="center" class="celula"><strong>A</strong></td>
		 <td width="4%" align="center" class="celula"><strong>B</strong></td>
		 <td width="3%" align="center" class="celula"><strong>C</strong></td>
		 <td width="4%" align="center" class="celula"><strong>D</strong></td>
		 <td width="4%" align="center" class="celula"><strong>E</strong></td>
		 </tr>
		 <%
		while not rsAux.eof
				
			intCodItemAvaliacao = rsAux("codigo")
			strTipo_pergunta 	= rsAux("Tipo_Pergunta")

			if trim(rsAux("Subtitulo")) <> "" then
		   	   %>
		 	   <tr bgcolor="#E5E5E5">
			   <td height="21" colspan="10" class="celula"><strong><%=trim(rsAux("Subtitulo"))%></strong></td>
		 	   </tr>
			   <%
			end if 
			if strTipo_pergunta = "O" then
			   %>
			   <tr>
               <td height="21" colspan="4" class="celula">
               <input name="chkAvaliacao" type="hidden" id="chkAvaliacao" value="<%=intCodItemAvaliacao%>" checked <%=strDesabilitaAluno%> >
			   <input name="txtCodAluno_<%=cont%>" value="<%=intCodAluno%>"  type="hidden" class="text" id="txtCodAluno" size="5">
			   <input name="txtCodDisciplina_<%=cont%>" value="<%=intCodDisciplina%>"  type="hidden" class="text" id="txtCodDisciplina" size="5"><%=trim(rsAux("Descricao"))%>			   </td>
			   <td height="21" align="center" class="celula"><input name="optConceito_<%=cont%>" type="radio" value="A" <%=strMarcaA%>></td>
			   <td height="21" align="center" class="celula"><input name="optConceito_<%=cont%>" type="radio" value="B" <%=strMarcaB%>></td>
			   <td height="21" align="center" class="celula"><input name="optConceito_<%=cont%>" type="radio" value="C" <%=strMarcaC%>></td>
			   <td height="21" align="center" class="celula"><input name="optConceito_<%=cont%>" type="radio" value="D" <%=strMarcaD%>></td>
			   <td height="21" align="center" class="celula"><input name="optConceito_<%=cont%>" type="radio" value="E" <%=strMarcaE%>></td>
			   </tr>
			   <%
			else
			   %>
			   <tr>
			   <td height="21" colspan="10" class="celula">
               <input name="chkAvaliacao" type="hidden" id="chkAvaliacao" value="<%=intCodItemAvaliacao%>" checked <%=strDesabilitaAluno%> >
			   <input name="txtCodAluno_<%=cont%>" value="<%=intCodAluno%>"  type="hidden" class="text" id="txtCodAluno" size="5">
               <input name="txtCodDisciplina_<%=cont%>" value="<%=intCodDisciplina%>"  type="hidden" class="text" id="txtCodDisciplina" size="5"><%=trim(rsAux("Descricao"))%>               </td>
			   </tr>
			   <tr>
			   <td height="30" colspan="10" class="celula">
			   <textarea  onkeyup="blocTexto(this.value,'<%=cont%>')"  name="txtResposta_<%=cont%>" cols="100" rows="2" class="text" id="txtResposta_<%=cont%>"><%=strResposta%></textarea>
				<font color="#FF0000">(caracteres restantes: <span id="cont">200</span>)</font>			   </td>
			   </tr>
               <%
			  
			end if
			cont = cont + 1				
			rsAux.movenext
			wend
		end if
		rsAux.close
		%>
        
    	<br>
    	<%
		rs.movenext
		wend
	end if
	%>
    </table>	</td>
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
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>