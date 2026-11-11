<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 14/09/2007
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Cadastro de Aluno 
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
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../../images/botao_verde_over.gif')">
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file=../../includes/inc_aguarde.asp-->
<script src="../../js/js_funcoes_gerais.js"></script>
<script>
	function AbreFecha(Linha,Figura){
		if (Linha.style.display == "block"){
			Linha.style.display = "none";
			Figura.src="<%=session("strCaminhoRaiz")%>/images/plus.bmp"
		}
		else{
			Linha.style.display = "block";
			Figura.src="<%=session("strCaminhoRaiz")%>/images/minus.bmp"
		}
	}	
	function carregaAluno(){
		if (frm.txtMatricula.value != ""){
			frm.action="RequerimentoMatricula_cad.asp"
			frm.submit();
		}
	}

	function resultadoConsulta(intCodigo){
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}

	function carregaTurma(){
		frm.action="RequerimentoMatricula_cad.asp"
		frm.submit();
	}
	
	function salvar(acao){
		if (frm.txtMatricula.value==""){
			alert("A matricula do aluno deve ser informada.")
			frm.txtMatricula.focus()
			return false;
		}

		if (frm.cmbTurma.value=="0"){
			alert("Turma de destino do aluno deve ser informada.")
			frm.cmbTurma.focus()
			return false;
		}
		
		frm.action="RequerimentoMatricula_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}

</script>
<%

	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"

	strPaginaTitulo 		= "RequerimentoMatricula_cad.asp"
	strMostraTodasTurmas 	= Request.Form("strMostraTodasTurmas")

	'chave da tabela
	strCod_empresa 			= Session("CodEmpresa")
	strSemestre 			= session("strSemestre")
	strAnoLetivo 			= session("strAnoLetivo")

	strNomeBotaoFoto		= "Incluir Foto"

	strCodAluno			= Trim(Request("txtCodAluno"))
	intCodAluno			= Trim(Request("txtCodAluno"))			
	strMatricula 		= Trim(Request("txtMatricula"))

	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	if intCodTurma = "" then intCodTurma = "0"
	intOcupada = "0"
	intCapacidade = "0"
	if intCodTurma <> "0" then
		'BUSCA CAPACIDADE DA TURMA	
		SQL = " select CAPACIDADE"
		SQL = SQL & " from SCA_TURMA"
		SQL = SQL & " where COD_TURMA = " & intCodTurma
		RS.OPEN SQL, CNN
		IF NOT RS.EOF THEN
			intCapacidade = RS("Capacidade")
		END IF
		RS.CLOSE
		
		'BUSCA QUANTIDADE DE ALUNOS MATRICULA NA TURMA	
		SQL = " select DISTINCT SCA_ALUNO.CODIGO"
		SQL = SQL & " from SCA_ALUNO_DISCIPLINA"
		SQL = SQL & " INNER JOIN SCA_ALUNO ON SCA_ALUNO.CODIGO = SCA_ALUNO_DISCIPLINA.COD_ALUNO AND SCA_ALUNO_DISCIPLINA.COD_EMPRESA = SCA_ALUNO.COD_EMPRESA"
		SQL = SQL & " INNER JOIN SCA_SITUACAOALUNO ON SCA_ALUNO.COD_SITUACAOALUNO = SCA_SITUACAOALUNO.COD_SITUACAOALUNO AND SCA_ALUNO_DISCIPLINA.COD_EMPRESA = SCA_ALUNO.COD_EMPRESA"
		SQL = SQL & " where SCA_ALUNO_DISCIPLINA.COD_TURMA_REMANEJAMENTO = " & intCodTurma
		SQL = SQL & " and SCA_SITUACAOALUNO.Desc_SituacaoAluno IN ('ATIVO','PRÉ-MATRÍCULA')"
		RS.OPEN SQL, CNN, 3, 1
		IF NOT RS.EOF THEN
			intOcupada = RS.RECORDCOUNT
		END IF
		RS.CLOSE

		'REGRA O ALUNO DA TURMA NÃO PODE SER IGUAL O DA SESSION
		SQL = " select ANOLETIVO, COD_SEMESTRE"
		SQL = SQL & " from SCA_TURMA"
		SQL = SQL & " where COD_TURMA = " & intCodTurma
		RS.OPEN SQL, CNN
		IF NOT RS.EOF THEN
			intAnoTurma = RS("Anoletivo")
			intSemTurma = RS("cod_Semestre")
		END IF
		RS.CLOSE
		if trim(intAnoTurma)=trim(strAnoLetivo) and trim(intSemTurma)=trim(strSemestre) then
			intCodTurma = 0
			%>
			<script>
				alert("ATENÇÃO: \nNão pode ser utilizado a renovação de matrícula para turma do mesmo ano/semestre corrente.");
			</script>
			<%	
		end if

	end if	
	
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intCodTurno		 		= Trim(Request.Form("cmbTurno"))

	if (trim(strCodAluno) <> "" or trim(strMatricula) <> "") then
	
		sql = "SELECT SCA_ALUNO_TURMA.CODIGO" 
		sql = sql & " 	FROM SCA_ALUNO_TURMA"
		sql = sql & " 	INNER JOIN SCA_ALUNO ON SCA_ALUNO.CODIGO=SCA_ALUNO_TURMA.COD_ALUNO AND SCA_ALUNO.COD_EMPRESA = SCA_ALUNO_TURMA.COD_EMPRESA"
		if strCodAluno <> "" then
			sql = sql & " WHERE	SCA_ALUNO.codigo = " & strCodAluno
		else
			sql = sql & " WHERE	SCA_ALUNO.matricula = " & strMatricula
		end if
		sql = sql & " and 		SCA_ALUNO_TURMA.COD_EMPRESA = " & strCod_empresa
		sql = sql & " AND		SCA_ALUNO_TURMA.SITUACAO = 'A'"
		'if cInt(strSemestre) = 3 then
		'	sql = sql & " AND ANO_LETIVO = " & strAnoLetivo-1
		'	sql = sql & " AND SEMESTRE = " & strSemestre
		'else
	    '		if cInt(strSemestre) = 1 then
		'		sql = sql & " AND ANO_LETIVO = " & strAnoLetivo-1
		'		sql = sql & " AND SEMESTRE = 2"
		'	elseif cInt(strSemestre) = 2 then
		'		sql = sql & " AND ANO_LETIVO = " & strAnoLetivo
		'		sql = sql & " AND SEMESTRE = 1"
		'	end if
		'end if
		
		response.write sql
		response.end
		
		rsAux.open sql, cnn
		if not rsAux.eof then		

			sql = "SELECT "
			sql = sql & " 	T.NOMETURMA, "
			sql = sql & " 	S.Desc_SituacaoAluno, "
			sql = sql & " 	C.DESCRICAO AS CURSO,"
			sql = sql & " 	P.DESCRICAO AS PERIODO,"
			sql = sql & " 	TU.DESC_TURNO AS TURNO, T.Cod_TURNO, T.Cod_TURNO, P.COD_CURSO, "
			sql = sql & " 	A.* "
			sql = sql & " FROM SCA_ALUNO A "
			sql = sql & " LEFT JOIN SCA_SITUACAOALUNO S ON S.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO AND S.COD_EMPRESA = A.COD_EMPRESA "
			sql = sql & " LEFT JOIN SCA_ALUNO_TURMA AT ON AT.COD_EMPRESA = A.COD_EMPRESA AND A.CODIGO = AT.COD_ALUNO"
			sql = sql & " LEFT JOIN SCA_TURMA T ON AT.COD_TURMA = T.Cod_Turma AND AT.COD_EMPRESA = T.COD_EMPRESA"
			sql = sql & " LEFT JOIN SCA_TURNO TU ON TU.COD_TURNO = T.Cod_TURNO AND TU.COD_EMPRESA = T.COD_EMPRESA"
			sql = sql & " LEFT JOIN SCA_GRADECURRICULAR G ON T.Cod_GradeCurricular = G.Cod_GradeCurricular AND T.COD_EMPRESA = G.COD_EMPRESA"
			sql = sql & " LEFT JOIN SCA_PERIODO P ON P.COD_EMPRESA = T.COD_EMPRESA AND P.COD_PERIODO = G.COD_PERIODO"
			sql = sql & " LEFT JOIN SCA_CURSO C ON C.COD_CURSO = P.COD_CURSO AND C.COD_EMPRESA = P.COD_EMPRESA"
			if cInt(strSemestre) = 3 then
				sql = sql & " WHERE T.ANOLETIVO = " & strAnoLetivo-1
				sql = sql & " AND T.COD_SEMESTRE = " & strSemestre
			else
				if cInt(strSemestre) = 1 then
					sql = sql & " WHERE T.ANOLETIVO = " & strAnoLetivo-1
					sql = sql & " AND T.COD_SEMESTRE = 2"
				elseif cInt(strSemestre) = 2 then
					sql = sql & " WHERE T.ANOLETIVO = " & strAnoLetivo
					sql = sql & " AND T.COD_SEMESTRE = 1"
				end if
			end if
			sql = sql & " AND A.COD_EMPRESA = " & strCod_empresa
			if strCodAluno <> "" then
				sql = sql & " And 	A.codigo = " & strCodAluno
			else
				sql = sql & " And 	A.matricula = " & strMatricula
			end if
		else

			sql = "SELECT "
			sql = sql & " 	'' as NOMETURMA, "
			sql = sql & " 	S.Desc_SituacaoAluno, "
			sql = sql & " 	'' AS CURSO,"
			sql = sql & " 	'' AS PERIODO,"
			sql = sql & " 	'' AS TURNO, '' as Cod_TURNO, '' as COD_CURSO, "
			sql = sql & " 	A.* "
			sql = sql & " FROM SCA_ALUNO A "
			sql = sql & " LEFT JOIN SCA_SITUACAOALUNO S ON S.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO AND S.COD_EMPRESA = A.COD_EMPRESA "
			sql = sql & " where A.COD_EMPRESA = " & strCod_empresa
			if strCodAluno <> "" then
				sql = sql & " And 	A.codigo = " & strCodAluno
			else
				sql = sql & " And 	A.matricula = " & strMatricula
			end if
		end if
		rsaux.close
		rs.open sql, cnn
		if rs.eof = false then
			strSituacaoAluno	= TRIM(rs("Desc_SituacaoAluno"))
			'dados pessoais
			strCodAluno			= TRIM(rs("Codigo"))
			intCodAluno			= TRIM(rs("Codigo"))
			strMatricula 		= TRIM(rs("Matricula"))
			strNomealuno 		= TRIM(rs("Nomealuno"))
			strDatamatricula 	= formataDataAP(TRIM(rs("Datamatricula")))
			strSexo		 		= TRIM(rs("SexoAluno"))
			strDatanascimento 	= formataDataAP(TRIM(rs("Datanascimento")))
			strCidadenascimento = TRIM(rs("Cidadenascimento"))
			strFoneResidencial 	= TRIM(rs("FoneResidencial"))
			strFonecomercial 	= TRIM(rs("Fonecomercial"))
			strFoneCelular	 	= TRIM(rs("Fonecelular"))
			strEmail 			= TRIM(rs("Email"))
			
			'Origem
			strCursoOrigem		= TRIM(rs("curso"))
			strPeriodoOrigem	= TRIM(rs("periodo"))
			strTurnoOrigem		= TRIM(rs("turno"))
			strTurmaOrigem		= TRIM(rs("NOMETURMA"))
			
			'endereço
			strLogradouro 		= TRIM(rs("Logradouro"))
			strNumero_endereco 	= TRIM(rs("Numero_endereco"))
			strComp_endereco 	= TRIM(rs("Comp_endereco"))
			strBairroaluno 		= TRIM(rs("Bairroaluno"))
			strCidaderesidencia	= TRIM(rs("Cidaderesidencia"))
			strUfresidencia 	= TRIM(rs("Ufresidencia"))
			strCepresidencia 	= TRIM(rs("Cepresidencia"))
			
			
			strFiltroSerie 			= "0"
			strFiltroTurno 			= "0"
			
			if intCodSerie 		= "" then intCodSerie 		= "0"
			if intCodTurno 		= "" then intCodTurno 		= "0"
			if intCodTurma 		= "" then intCodTurma 		= "0"

			
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			if intCodTurma <> "0" then
				strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
			end if
			strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
			rs.close

			'VERIFICAÇÃO DE BLOQUEIO
			%>
			<!--#include file="../includes/inc_VerificaBloqueio.asp"-->
			<%

			strCaminhoFoto = session("strCaminhoRaiz") & "/fotoAluno/semFotoAtivo.gif"
			strFoto =  "<img src='" & strCaminhoFoto & "' width='100' height='110'>"
	
			sql = "SELECT arquivo "
			sql = sql & " FROM 	SCA_ALUNO_FOTO"
			sql = sql & " Where COD_EMPRESA = " & strCod_empresa
			sql = sql & " And 	codAluno = " & strCodAluno
			rs.open sql, cnn
			if rs.eof = false then
				strCaminhoFoto = session("strCaminhoRaiz") & "/fotoAluno/" & strCod_empresa & "/" & rs("arquivo")
				strFoto =  "<img src='" & strCaminhoFoto & "' width='100' height='110'>"
				strNomeBotaoFoto	= "Alterar Foto"
			end if
			rs.close
			
			'REGRA PARA NÃO DEIXAR DUPLICAR O REQUERIMENTO DE MATRICULA
			sql = "select s.Desc_SituacaoAluno"
			sql = sql & " from sca_aluno a"
			sql = sql & " inner join sca_situacaoaluno s on s.Cod_SituacaoAluno=a.COD_SITUACAOALUNO and s.Cod_Empresa=a.cod_empresa"
			sql = sql & " where replace(replace(s.Desc_SituacaoAluno,'É','E'),'Í','I') = 'PRE-MATRICULA'"
			sql = sql & " and a.codigo = "&strCodAluno
			rs.open sql, cnn,3,3
			if not rs.eof then
				rs.close
				%>
				<script>
					alert("ATENÇÃO: \nEsse aluno já foi efetuada a renovação da matrícula.");
					window.history.back();
				</script>
				<%	
				response.End()
			end if
			rs.close						
			
		else
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir

			strCaminhoFoto = session("strCaminhoRaiz") & "/fotoAluno/semFoto.gif"
			strFoto =  "<img src='" & strCaminhoFoto & "' width='100' height='110'>"

			rs.close
		end if 
	else
		strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
		strCaminhoFoto = session("strCaminhoRaiz") & "/fotoAluno/semFoto.gif"
		strFoto =  "<img src='" & strCaminhoFoto & "' width='100' height='110'>"
	end if 
%>
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td>
	<table width="751"  height="325" border="0" cellspacing="0" cellpadding="0">
      <tr valign="top">
        <td colspan="2" align="center">
		<form id="frm" method="post" action="RequerimentoMatricula_cad.asp">
		  <table width="708" border="0" cellpadding="0" cellspacing="0">

            <tr valign="top">
              <td width="700" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
          </table>
		  <br>
		  <%
		  	'parametro para a lista de ocorrencias
			'1 -  intCodAluno
			'2 - intCodEmpresa
			'colocar a função 	function AbreFecha(Linha,Figura)
			intCodAluno	  = strCodAluno
			intCodEmpresa = strCod_empresa
		  %>
		  <table width="790" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td colspan="2"><hr size="1" color="#999999"><input name="txtCodAluno" type="hidden" id="txtCodAluno" class="text" size="10" value="<%=strCodAluno%>" maxlength="10"></td>
          </tr>
          <tr>
            <td width="457" height="20" bgcolor="#EEEEEE" class="texto1" >&nbsp;&nbsp;<strong>Dados Pessoais</strong></td>
            <td width="246" height="20" bgcolor="#EEEEEE" class="texto1"  align="left">
			&nbsp;Situa&ccedil;&atilde;o:
		 	<strong><%=strSituacaoAluno%></strong>&nbsp;&nbsp;
          </tr>
          <tr>
            <td colspan="2" class="texto1" >
				<!-- INICIO CAMPO - DADOS PESSOAIS-->
				<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#F5F5F5" id="mostraDadosPessoais">
				  <tr>
					<td width="18%" class="texto1">&nbsp;Matr&iacute;cula: </td>
					<td width="47%" class="texto1"><input name="txtMatricula" type="text" class="text" id="txtMatricula" size="20" maxlength="9" value="<%=strMatricula%>"  onKeyPress="return formataCampo(this, 2, 9)" onBlur="carregaAluno()">
					  <a  href="#" onClick="return abreConsulta('Aluno_con.asp')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image7','','<%=session("strCaminhoRaiz")%>/images/botao_verde_over.gif',1)"><img alt="Clique para consultar o aluno" src="<%=session("strCaminhoRaiz")%>/images/botao_verde_normal.gif" name="Image7" width="26" height="26" border="0"  align="absmiddle" >*</a></td>
					<td rowspan="7" align="center" class="texto1">&nbsp;</td>
					<td rowspan="7" align="center" class="texto1">
					<table width="120" height="130" border="0" cellpadding="0" cellspacing="0">
                      <tr>
                        <td bgcolor="#FFFFFF" align="center" class="text"><%=strFoto%></td>
                      </tr>
                    </table>					
					</td>
				  </tr>
				  <tr>
					<td class="texto1">&nbsp;Nome Completo: </td>
					<td class="texto1"><input disabled="disabled" name="txtNomealuno" type="text" class="text" id="txtNomealuno" size="50" maxlength="50" value="<%=strNomealuno%>"  onKeyPress="return formataCampo(this, 1, 50)"></td>
					</tr>
				  <tr>
					<td class="texto1">&nbsp;Data Nascimento: </td>
					<td class="texto1"><input disabled="disabled" name="txtDatanascimento" type="text" class="text" id="txtDatanascimento" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDatanascimento%>"></td>
					</tr>
				  <tr>
				    <td class="texto1">&nbsp;Fone Residencial: </td>
				    <td class="texto1"><input  name="txtFoneResidencial" type="text" class="text" id="txtFoneResidencial" onKeyPress="mascara(this,telefone)"  size="20" maxlength="14" value="<%=strFoneResidencial%>"></td>
				    </tr>
				  <tr>
				    <td class="texto1">&nbsp;Celular: </td>
				    <td class="texto1"><input  name="txtFonecelular" type="text" class="text" id="txtFonecelular" onKeyPress="mascara(this,telefone)"  size="20" maxlength="14" value="<%=strFonecelular%>"></td>
				    </tr>
				  <tr>
				    <td class="texto1">&nbsp;Fone Comercial : </td>
				    <td class="texto1"><input  name="txtFoneComercial" type="text" class="text" id="txtFoneComercial" onKeyPress="mascara(this,telefone)"  size="20" maxlength="14" value="<%=strFoneComercial%>"></td>
				    </tr>
				  <tr>
					<td class="texto1">&nbsp;e-mail: </td>
					<td class="texto1"><input  name="txtEmail" type="text" class="text" id="txtEmail" size="50" maxlength="100" value="<%=strEmail%>"></td>
					</tr>
				</table>
				<!-- FIM CAMPO - DADOS PESSOAIS-->			</td>
          </tr>
          <tr>
            <td colspan="2"><hr size="1" color="#999999"></td>
          </tr>
<tr>
            <td height="20" colspan="2" bgcolor="#EEEEEE" class="texto1" style="cursor:hand" onClick="return dadosEndereco()">&nbsp;&nbsp;<strong>Endereço</strong></td>
            </tr>
          <tr>
            <td colspan="2" class="texto1" >
				<!-- INICIO CAMPO - DADOS ENDEREÇO-->
				<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#F5F5F5" id="mostraDadosEndereco">
				  <tr>
					<td width="18%" class="texto1">&nbsp;Logradouro: </td>
					<td width="47%" class="texto1"><input name="txtLogradouro" type="text" class="text" id="txtLogradouro" size="40" maxlength="60" value="<%=strLogradouro%>"></td>
					<td width="16%" class="texto1">&nbsp;N&uacute;mero:</td>
					<td width="19%" class="texto1"><input name="txtNumero_endereco" type="text" class="text" id="txtNumero_endereco" size="20" maxlength="5" value="<%=strNumero_endereco%>"></td>
				  </tr>
				  <tr>
					<td class="texto1"> &nbsp;Complemento:</td>
					<td class="texto1"><input name="txtComp_endereco" type="text" class="text" id="txtComp_endereco" size="40" maxlength="20" value="<%=strComp_endereco%>" ></td>
					<td class="texto1">&nbsp;CEP:</td>
					<td class="texto1"><input name="txtCepresidencia" type="text" class="text" id="txtCepresidencia" size="9" maxlength="9" value="<%=strCepresidencia%>" onKeyPress="mascara(this,cep)" ></td>
				  </tr>
				  <tr>
				    <td class="texto1">&nbsp;Bairro:</td>
				    <td class="texto1"><input name="txtBairroaluno" type="text" class="text" id="txtBairroaluno" size="40" maxlength="40" value="<%=strBairroaluno%>" onKeyPress="return formataCampo(this, 1, 40)"></td>
				    <td class="texto1">&nbsp;</td>
				    <td class="texto1">&nbsp;</td>
				    </tr>
				  <tr>
					<td class="texto1">&nbsp;Munic&iacute;pio:</td>
					<td class="texto1"><input name="txtCidaderesidencia" type="text" class="text" id="txtCidaderesidencia" size="40" maxlength="40" value="<%=strCidaderesidencia%>" onKeyPress="return formataCampo(this, 1, 40)"></td>
					<td class="texto1">&nbsp;UF:</td>
					<td class="texto1"><!--#include file="../includes/inc_cmdUFResidencia.asp" --></td>
				  </tr>
				</table>
				<!-- FIM CAMPO - DADOS ENDEREÇO-->			</td>
          </tr>
          <tr>
            <td colspan="2"><hr size="1" color="#999999"></td>
          </tr>		  
          <tr>
            <td width="457" height="20" bgcolor="#EEEEEE" class="texto1" >&nbsp;&nbsp;<strong>Dados de Origem </strong></td>
            <td width="246" height="20" bgcolor="#EEEEEE" class="texto1"  align="left">
			</tr>
          <tr>
            <td colspan="2" class="texto1" >
				<!-- INICIO CAMPO - DADOS PESSOAIS-->
				<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#F5F5F5" id="mostraDadosPessoais">
				  <tr>
					<td width="18%" class="texto1">&nbsp;Curso: </td>
					<td width="82%" class="texto1"><input disabled="disabled" name="txtCursoOrigem" type="text" class="text" id="txtCursoOrigem" size="50" maxlength="50" value="<%=strCursoOrigem%>"  onKeyPress="return formataCampo(this, 1, 50)"></td>
					</tr>
				  <tr>
					<td class="texto1">&nbsp;Per&iacute;odo: </td>
					<td class="texto1"><input disabled="disabled" name="txtPeriodoOrigem" type="text" class="text" id="txtPeriodoOrigem" size="50" maxlength="50" value="<%=strPeriodoOrigem%>"  onKeyPress="return formataCampo(this, 1, 50)"></td>
					</tr>
				  <tr>
					<td class="texto1">&nbsp;Turno: </td>
					<td class="texto1"><input disabled="disabled" name="txtNomealuno3" type="text" class="text" id="txtNomealuno3" size="50" maxlength="50" value="<%=strTurnoOrigem%>"  onKeyPress="return formataCampo(this, 1, 50)"></td>
				  </tr>
				  <tr>
					<td class="texto1">&nbsp;Turma: </td>
					<td class="texto1"><input disabled="disabled" name="txtTurmaOrigem" type="text" class="text" id="txtTurmaOrigem" size="50" maxlength="50" value="<%=strTurmaOrigem%>"  onKeyPress="return formataCampo(this, 1, 50)"></td>
					</tr>
				</table>
				<!-- FIM CAMPO - DADOS PESSOAIS-->			</td>
          </tr>
          <tr>
            <td colspan="2"><hr size="1" color="#999999"></td>
          </tr>
          <tr>
            <td width="457" height="20" bgcolor="#EEEEEE" class="texto1" >&nbsp;&nbsp;<strong>Dados de Destino <%=strAnoLetivo%></strong></td>
            <td width="246" height="20" bgcolor="#EEEEEE" class="texto1"  align="left">
			</tr>
          <tr>
            <td colspan="2" class="texto1" >
				<!-- INICIO CAMPO - DADOS PESSOAIS-->
				<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#F5F5F5" id="mostraDadosPessoais">
				  <tr>
					<td width="8%" class="texto1">&nbsp;Turma: </td>
					<td width="39%" class="texto1"><!--#include file="../includes/inc_cmdTurmaPromocao.asp"--></td>
				    <td width="26%" class="texto1">Capacidade:
				      <input disabled name="txtCapacidade" type="text" class="text" id="txtCapacidade"  value="<%=intCapacidade%>" size="3" maxlength="2" onKeyPress="return formataCampo(this,2,2)"></td>
				    <td width="27%" class="texto1">Ocupada:
				      <input disabled name="txtOcupada" type="text" class="text" id="txtOcupada"  value="<%=intOcupada%>" size="3" maxlength="2" onKeyPress="return formataCampo(this,2,2)"></td>
				  </tr>
				</table>
				<!-- FIM CAMPO - DADOS PESSOAIS-->			</td>
          </tr>
          <tr>
            <td colspan="2"><hr size="1" color="#999999"></td>
          </tr>
          <tr>
            <td colspan="2" class="texto">* Somente para alunos da casa.<br>
<br>
</td>
          </tr>
          <tr>
            <td colspan="2"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
        </table>
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