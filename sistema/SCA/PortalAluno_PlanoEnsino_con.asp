<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../estilo/css.css" rel="stylesheet" type="text/css">
</head>
<body>
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="topo.asp"-->
<!--#include file="../includes/inc_cmdVerificaAvaliacao.asp"-->
<script src="../../js/js_funcoes_gerais.js"></script>
<script>
	function Descricao(tipo){
		if (document.all["mostraDescricao"+tipo].style.display =="none"){
			document.all["mostraDescricao"+tipo].style.display="block";
			document.all["imgDescricao"+tipo].src="../../images/minus.bmp";
		}
		else{
			document.all["mostraDescricao"+tipo].style.display="none";
			document.all["imgDescricao"+tipo].src="../../images/plus.bmp";
		}
	}
</script>
<%

		'aluno na turma
		sql = "select top 1 AT.COD_TURMA, T.Cod_GradeCurricular, AT.ANO_LETIVO, AT.SEMESTRE, T.NOMETURMA"
		sql = sql & " from SCA_ALUNO_TURMA AT"
		sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = AT.COD_TURMA AND T.COD_EMPRESA = AT.COD_EMPRESA "
		sql = sql & " AND AT.ANO_LETIVO = T.AnoLetivo AND AT.SEMESTRE = T.Cod_Semestre"
		sql = sql & " where AT.COD_EMPRESA = " &  Session("CodEmpresa")
		sql = sql & " and AT.COD_ALUNO = " &  trim(Session("CodSeguranca"))
		sql = sql & " order by AT.CODIGO desc"
		rs.open sql, cnn
		if not rs.eof then
			intCodTurma  		= rs("cod_Turma")
		end if
		rs.close



	strReloadDisciplinaQuadro = "S"
	intCodDisciplinaTurma   = Trim(Request.Form("cmbDisciplinaTurma"))
	if intCodDisciplinaTurma = "" then intCodDisciplinaTurma = "0"
%>

<table width="100%" height="355" border="0" cellpadding="0" cellspacing="0"  bgcolor="#FFFFFF">
  <tr valign="top">
    <td align="center">
	<form method="post" id="frm">
    <table width="96%" border="0" cellpadding="0" cellspacing="0" >
      <tr valign="top">
        <td align="center" class="tituloPrincipal"><strong>PLANO DE ENSINO</strong></td>
      </tr>
      <tr valign="top">
        <td align="left" ><!-- inicio tabela de cadastro de funcionario -->
          <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td width="86" height="23" class="TextoForm">&nbsp;</td>
              <td width="1141" class="TextoForm">&nbsp;</td>
            </tr>
            <tr>
              <td class="TextoForm"><span class="texto1">Disciplinas:</span></td>
              <td class="TextoForm"><!--#include file="../includes/inc_cmbDisciplinaTurma.asp" --></td>
              </tr>
            <tr>
              <td height="23" colspan="2" class="TextoForm">&nbsp;</td>
              </tr>
            <tr>
              <td height="23" colspan="2" align="center" class="TextoForm">
                <%if intCodDisciplinaTurma <> "0" then %>
                
                <table width="100%"  border="0" cellpadding="0" ce5llspacing="0">
                  <tr bgcolor="#CCCCCC">
                    <td height="19" colspan="2" align="center" class="texto1"><strong>Turma: <%=Session("NomeTurma")%></strong></td>
                    </tr>
                  
                  <%
			
			sql = "SELECT con.codigo, cur.descricao as Curso, per.descricao as periodo, dis.desc_disciplina, Objetivos, Ementa, Conteudo_Programatico, Metodologia,Bibliografia_Basica, Bibliografia_Complementar " 
			sql = sql & " FROM sca_planoensino con "
			sql = sql & " inner join sca_curso cur on cur.cod_curso = con.cod_curso "
			sql = sql & " inner join sca_periodo per on per.cod_periodo = con.cod_periodo "
 			sql = sql & " inner join sca_disciplina dis on dis.cod_disciplina = con.cod_gradecurricularDisciplina "
			sql = sql & " where con.cod_empresa = " & Session("CodEmpresa")
			sql = sql & " and con.Cod_GradeCurricularDisciplina = " & intCodDisciplinaTurma
			sql = sql & " order by cur.descricao, per.descricao, dis.desc_disciplina " 	
			rs.open sql,cnn
			if rs.eof = false then

			 while not rs.eof 
		 %>
                  <tr bgcolor="#CCCCCC">
                    <td width="4%" height="22" align="center" style="cursor:hand" onClick="return Descricao('<%=rs("codigo")%>')"><img id="imgDescricao<%=rs("codigo")%>" src="../../images/plus.bmp"></td>
                    <td width="96%" class="textoAtencao"><strong> <%=rs("Curso")%>- <strong><%=rs("desc_disciplina")%></strong></strong></td>
                    </tr>
                  <tr id="mostraDescricao<%=rs("codigo")%>" style="display:none">
                    <td height="72" colspan="2" align="center" bgcolor="#FFFF99" >
                      <%
			
			sql = "SELECT * "
			sql = sql & " FROM SCA_PLANOENSINO "
			sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
			sql = sql & " and codigo = " & rs("codigo")	
			rsAux.open sql,cnn
			if rsAux.eof = false then
				
				while not rsAux.eof
					
					strObjetivos						= rs("Objetivos")
					strEmenta							= rs("Ementa")
					strConteudoProgramatico				= rs("Conteudo_Programatico")
					strMetodologia						= rs("Metodologia")
					strBibliografiaBasica				= rs("Bibliografia_Basica")
					strBibliografiaComplementar			= rs("Bibliografia_Complementar")

	   			%>
                      <table width="97%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <td height="18" class="texto1">&nbsp;</td>
                          <td class="texto">&nbsp;</td>
                        </tr>
                        <tr>
                          <td height="41" class="texto1"><strong>OBJETIVOS:</strong></td>
                          <td class="texto"><%=strObjetivos%>&nbsp;</td>
                        </tr>
                        <tr>
                           <td class="texto">&nbsp;</td>
                        </tr>
                        <tr>
                          <td height="41" class="texto1"><strong>EMENTA:</strong></td>
                          <td class="texto"><%=strEmenta%></td>
                        </tr>
                        <tr>
                           <td class="texto">&nbsp;</td>
                        </tr>
                        <tr>
                          <td height="41" class="texto1"><strong>CONTE&Uacute;DO PROGRAM&Aacute;TICO:</strong></td>
                          <td class="texto"><%=strConteudoProgramatico%>&nbsp;</td>
                        </tr>
                        <tr>
                           <td class="texto">&nbsp;</td>
                        </tr>
                        <tr>
                          <td height="41" class="texto1"><strong>METODOLOGIA DE AVALIA&Ccedil;&Atilde;O:</strong></td>
                          <td class="texto"><%=strMetodologia%>&nbsp;</td>
                        </tr>
                         <tr>
                           <td class="texto">&nbsp;</td>
                        </tr>
                       <tr>
                          <td height="41" class="texto1"><strong>BIBLIOGRAFIA B&Aacute;SICA:</strong></td>
                          <td class="texto"><%=strBibliografiaBasica%>&nbsp;</td>
                        </tr>
                         <tr>
                           <td class="texto">&nbsp;</td>
                        </tr>
                       <tr>
                          <td width="20%" height="41" class="texto1"><strong>BIBLIOGRAFIA COMPLEMENTAR:</strong></td>
                          <td width="80%" class="texto"><%=strBibliografiaComplementar%>&nbsp;</td>
                        </tr>
                        <tr>
                           <td class="texto">&nbsp;</td>
                        </tr>
                        </table>
                      <br>
                      <%  				
				rsAux.movenext
				wend
			end if
			rsAux.close
			%></td>
                    </tr>
                  <%
			rs.movenext
			wend
		end if
		
		
		
		%>
                  </table>
                <%end if%>
                </td>
            </tr>
            <tr>
              <td height="23" colspan="2" class="TextoForm">&nbsp;</td>
            </tr>
          </table>
          <!-- fim tabela de cadastro de funcionario --></td>
      </tr>
    </table>
    <br>
	  
	</form>
	</td>
  </tr>
</table>
</body>
</html>