<html>
<head>
<title><%=session("Titulo")%></title>
<link type="text/css" rel="stylesheet" href="../../Estilo/css.css">
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script src="../../js/js_funcoes_gerais.js"></script>
<script type="text/javascript" src="../../js/js_dragdrop.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_formataCPF.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
<script>
	function DadosDoAluno(){
		var frm = document.getElementById("frm");
		if (frm.txtNomealuno.value==""){
			alert("O Nome do Aluno deve ser informado.")
			frm.txtNomealuno.focus()
			return false;
		}
		if (frm.txtDatanascimento.value==""){
			alert("A Data de Nascimento deve ser informada.")
			frm.txtDatanascimento.focus()
			return false;
		}
		if (frm.txtMae.value==""){
			alert("Nome da Mãe deve ser informada.")
			frm.txtMae.focus()
			return false;
		}
		document.frm.cmdConfirmar.disabled = true;
		document.frm.cmdConfirmar.value = "Aguarde, efetivação está sendo processada.";
		
		frm.action = "ConfirmacaoAluno_cod.asp?acao=I";
		frm.submit();
		return true;	
	}
	
	function cancelarSolicitacao(){
		var frm = document.getElementById("frm");
		if (!confirm('Deseja realmente cancelar essa solicitação?'))
			return false;
		else{
			frm.action = "ConfirmacaoAluno_cod.asp?acao=C";
			frm.submit();
			return true;	
		}
	}
	
</script>
<style>
.textVerde
{
    background : #E8E8E8;
	border-top : #999;
	border-right : #999;
	border-left : #999;
	border-bottom : #999;
	border : 1px solid #999;
	font-family: Verdana; font-size: 11px; color: #090;
}
</style>
<%
	Session("MatriculaInformatizada") 	=  "SIM"
		
	strRegraBolsaFamilia 	= "S"
	strBloqCampo			= "readonly"
	strClassCampo 			= "textDisabled"
	strMostraLinhaBolsa 	= "style='display:table-row'"
	
	strAlunoEncontrado		= ""
	pagina					= "EfetivacaoAluno_con.asp"
	
	strCod_empresa 		= Session("CodEmpresa")
	intCodAluno			= Trim(Request("txtCodAluno"))
	IF intCodAluno = "" THEN intCodAluno = "0"
	
	sql = "SELECT m.nome as nomeAluno, M.CPF, tu.anoLetivo as ano_letivo, m.data_nascimento as dataNascimento, m.Mae, m.codigo, m.COD_TURMA, m.cod_empresa, isnull(m.bolsa_familia,'') as bolsa_familia, c.sigla, upper(t.Desc_Turno) as turno, e.CodTipoEmpresa "
	sql = sql & " FROM SCA_ALUNO a "
	sql = sql & " inner join mat_inscricao m on m.cod_aluno = a.codigo "
	sql = sql & " inner join sca_turma tu on tu.cod_turma = m.cod_turma"
	sql = sql & " inner join sca_periodo p on p.cod_periodo = m.cod_periodo and p.Matricula='S' "
	sql = sql & " inner join sca_curso c on c.cod_curso = p.cod_curso "
	sql = sql & " inner join sca_turno t on t.cod_turno = m.cod_turno "
	sql = sql & " inner join seg_empresa e on e.codigo = m.cod_empresa	"	
	sql = sql & " Where m.cod_empresa = " & strCod_empresa
	sql = sql & " And 	a.CODIGO = " & intCodAluno
'if session("usuarioWeb") = "sergio" or session("usuarioWeb") = "SERGIO" then'
'	response.write sql
'	response.End()
'end if
	
	rs.open sql, cnn
	if rs.eof = false then
		strAlunoEncontrado				= "S"
		strNomealuno 					= TRIM(rs("Nomealuno"))
		strAnoLetivo 					= TRIM(rs("ano_letivo"))
		strCPFAluno 					= TRIM(rs("cpf"))
		strDatanascimento 				= formataDataAP(TRIM(rs("Datanascimento")))
		strMae 							= TRIM(rs("Mae"))
		intCodInscricao					= TRIM(rs("codigo"))
		intCodTurma						= TRIM(rs("COD_TURMA"))
		intCodEmpresa					= TRIM(rs("cod_empresa"))
		strBolsaFamilia					= TRIM(rs("bolsa_familia"))
		strTurnoAluno					= TRIM(rs("turno"))
		if (TRIM(rs("CodTipoEmpresa")) <> "1" or strBolsaFamilia = "") and (trim(rs("sigla"))<>"EI") then
			'response.write "Ok"
			strRegraBolsaFamilia 	= "N"
				strBloqCampo 			= ""
				strClassCampo 			= "text"
				strMostraLinhaBolsa 	= "style='display:none'"
		end if
		if strTurnoAluno <> "INTEGRAL" then
			strMostraLinhaBolsa = "style='display:none'"
		end if
		strAlunoCarregado = "S"
	end if
	rs.close
	
	if strAlunoEncontrado = "" then
		%>
		<script>
			alert("Aluno não foi encontrado.");
			window.history.back();
		</script>
		<%
		response.End()
	end if

	'if strTurnoAluno = "INTEGRAL" then
	'	strUsuarioLiberadoParaMatricularDireto = ""
	'	sql = "SELECT CODIGO_SEG_USUARIOS_SISTEMA"
	'	sql = sql & " FROM SEG_USUARIOS_INCLUI_CADASTRO"
	'	sql = sql & " Where cod_grupo = " & Session("CodGrupo")
	'	sql = sql & " and upper(CODIGO_SEG_USUARIOS_SISTEMA) = '" & ucase(trim(session("usuarioWeb"))) & "'"
	'	rs.open sql, cnn
	'	if rs.eof = false then
	'		strUsuarioLiberadoParaMatricularDireto = ucase(trim(session("usuarioWeb")))
	'	end if 
	'	rs.close
	'
	'	if ucase(trim(session("usuarioWeb"))) <> strUsuarioLiberadoParaMatricularDireto then
			%>
			<!--script>
				//alert("ATENÇÃO: Para efetivação do aluno, junte a documentação necessária e compareça na SEMECT!");
				//window.location='EfetivacaoAluno_con.asp';
			</script-->
			<%
	
	'		response.end
	'	end if	
	'end if
	

	if request.Form("txtAlunoCarregado") <> "" then
		strNomealuno 			= request.Form("txtNomealuno")
		strDatanascimento 		= request.Form("txtDatanascimento")
		strBolsaFamilia 		= request.Form("txtBolsaFamilia")
	end if
	
	msnBolsa = ""
	'verifica se o aluno esta cadastrado no bolsa
	if strRegraBolsaFamilia 	= "S" then
		'sql = "SELECT codigo_bolsa as numero "
		'sql = sql & " FROM mat_bolsa_familia "
		'sql = sql & " Where data_nascimento = '" & formatadataBD(strDatanascimento) & "'"
		'sql = sql & " And 	nome = '" & strNomealuno & "'"
		'sql = sql & " And 	codigo_bolsa = '" & strBolsaFamilia & "'"
		'rs.open sql, cnn
		'if not rs.eof then
		'	msnBolsa = "Bolsa família válida!"
		'	classBolsa = "textVerde"
		'else
		'	msnBolsa = "Bolsa família não foi encontrado na base de dados!"
		'	classBolsa = "textVermelho"
		'end if
		'rs.close
	end if
	
%>
<form method="post" id="frm" name="frm" action="#">

<table width="100%" height="359" border="0"  class="CorFundo" cellpadding="2" cellspacing="5">
<tr valign="top">
		  <td height="54" colspan="2" align="center" class="tituloSistema">Matr&iacute;cula <%=Session("MatriculaInformatizadaAnoEfetivacao")%><br>
      CONFIRMA&Ccedil;&Atilde;O E CORREÇÃO DE DADOS</td>
		</tr>
		<tr valign="top">
		  <td height="26" colspan="2" align="center" valign="middle" bgcolor="#CCCCCC"  class="titulo"><strong>&#8226;&nbsp;Conferir os dados abaixo com a documenta&ccedil;&atilde;o do aluno para Efetiva&ccedil;&atilde;o</strong></td>
    </tr>
		<tr valign="top">
		  <td height="40" colspan="2" align="center" valign="middle"  class="texto"><span class="tituloSistema"><font color="#FF0000" class="tituloSuporte"><strong>Atenção: Não será permitida alteração de Nome durante a efetivação. O nome poderá ser apenas corrigido</strong></font></span><strong><font color="#FF0000">.</font></strong></td>
    </tr>
		<tr valign="top">
		  <td width="34%" height="24" align="right" valign="middle"  class="TextoForm">CPF DO ALUNO:</td>
		  <td width="66%" align="left" valign="middle">
              <span class="texto1">
                <input disabled name="txtCPF" type="text" class="text" id="txtCPF" size="20" maxlength="50" value="<%=formatacpfAP(strCPFAluno)%>"  >
              </span>
          </td>
    </tr><tr valign="top">
		  <td width="34%" height="24" align="right" valign="middle"  class="TextoForm">NOME COMPLETO DO ALUNO:</td>
		  <td width="66%" align="left" valign="middle">
              <span class="texto1">
                <input name="txtNomealuno" type="text" class="text" id="txtNomealuno" size="50" maxlength="50" value="<%=strNomealuno%>"  onKeyPress="return formataCampo(this, 1, 50)" onBlur="submit()">
              </span>
          </td>
    </tr>
		<tr valign="top">
		  <td height="24" align="right" class="TextoForm" valign="middle">DATA DE NASCIMENTO DO ALUNO:</td>
		  <td align="left" valign="middle"><span class="texto1">
		    <input name="txtDatanascimento" <%=strBloqCampo%> type="text" class="<%=strClassCampo%>" id="txtDatanascimento" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDatanascimento%>">
		  </span></td>
    </tr>
		<tr valign="top">
		  <td height="24" align="right" class="TextoForm" valign="middle">NOME COMPLETO DA M&Atilde;E:</td>
		  <td align="left" valign="middle"><span class="texto1">
		    <input name="txtMae" type="text" class="text" id="txtMae" size="50" maxlength="50" value="<%=strMae%>" onKeyPress="return formataCampo(this, 1, 50)">
		  </span></td>
    </tr>
		<tr valign="top" <%=strMostralinhaBolsa%>>
		  <td height="24" align="right" class="TextoForm" valign="middle">NÚMERO DA BOLSA FAMÍLIA:</td>
		  <td align="left" valign="middle">
		    <input name="txtBolsaFamilia" type="text" class="text" id="txtBolsaFamilia" size="15" maxlength="11" value="<%=strBolsaFamilia%>" onKeyPress="return formataCampo(this, 2, 11)"  onBlur="submit()"> <span class="<%=classBolsa%>"><%=msnBolsa%> </span></td>
    </tr>
    
		<tr valign="top">
		  <td height="50" colspan="2" align="center" valign="middle"><span class="texto1">
		    <input type="button" name="cmdConfirmar" id="cmdConfirmar" style="cursor:hand" value="  Confirmar Dados para Efetiva&ccedil;&atilde;o  " class="botaoConfirmar" <%=strDesabilitaIncluir%> onClick="return DadosDoAluno('<%=intCodAluno%>')">
            &nbsp;&nbsp;&nbsp;
            <input type="button" name="cmdConfirmar2" id="cmdConfirmar2" style="cursor:hand" value="    Cancelar Inscrição    " class="botaoConfirmar" <%=strDesabilitaIncluir%> onClick="return cancelarSolicitacao('<%=intCodAluno%>')">
            &nbsp;&nbsp;&nbsp;&nbsp;
          <input type="button" name="cmdLimpar"  value="   Voltar   " class="botao" <%=strDesabilitaLimpar%> onClick="window.location='EfetivacaoAluno_con.asp'">
          </span></td>
    </tr>
		<tr valign="top">
		  <td height="40" colspan="2" align="center" valign="middle">&nbsp;</td>
    </tr>
  </table>
<input name="txtCodAluno" 			type="hidden" id="txtCodAluno" 			value="<%=intCodAluno%>">
<input name="txtCPFAluno" 			type="hidden" id="txtCPFAluno" 			value="<%=strCPFAluno%>">
<input name="txtCodigoInscricao" 	type="hidden" id="txtCodigoInscricao" 	value="<%=intCodInscricao%>">
<input name="txtCodigoTurma" 		type="hidden" id="txtCodigoTurma" 		value="<%=intCodTurma%>">
<input name="txtCodigoEmpresa" 		type="hidden" id="txtCodigoEmpresa" 		value="<%=intCodEmpresa%>">
<input name="txtAnoLetivo" 			type="hidden" id="txtAnoLetivo" 			value="<%=strAnoLetivo%>">
<input name="txtRegraBolsaFamilia" 	type="hidden" id="txtRegraBolsaFamilia" value="<%=strRegraBolsaFamilia%>">
<input name="txtAlunoCarregado" 	type="hidden" id="txtAlunoCarregado" 	value="<%=strAlunoCarregado%>">
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>
