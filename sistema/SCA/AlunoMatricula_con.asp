<html>
<head>
<title><%=session("Titulo")%></title>
<link type="text/css" rel="stylesheet" href="../../Estilo/css.css">
</head>
<body >
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<script src="../../js/js_funcoes_gerais.js"></script>
<script>
	function gerarComprovante(intCodEmpresa, intCodAluno){
		var caminho
		caminho = "AlunoMatricula_rel.asp?CodEmpresa=" + intCodEmpresa + "&CodAluno=" + intCodAluno
		window.open(caminho ,"","toolbar=no,status=no,location=no,scrollbars=yes,menubar=no,resizable=no,width=750,height=500,top=0,lef=0");
	}
	
	function voltar(intCodAluno){
		window.location='../MAT/EfetivacaoAluno_con.asp';
	}
</script>
<%
	strPaginaTitulo			= "Comprovante de Efetivação"
	intCodEmpresa			= Trim(Session("CodEmpresa"))
	intCodAluno				= Trim(Request("txtCodAluno"))
	intCodGrupo				= 7
		
	IF intCodAluno <> "" and intCodEmpresa <> "" THEN
		Session("MatriculaInformatizada") 	=  ""
		sql = "select a.codigo, a.datanascimento, a.nomealuno, a.matricula, e.RAZAOSOCIAL, e.ENDERECO, e.BAIRRO, e.MUNICIPIO, e.UF, e.CEP, e.TELEFONE, e.CodTipoEmpresa"
		sql = sql & " from sca_aluno a"
		sql = sql & " inner join seg_empresa e on e.codigo = a.cod_empresa"
		sql = sql & " WHERE a.COD_EMPRESA = " & intCodEmpresa 
		sql = sql & " And a.CODIGO = " & intCodAluno
		RS.OPEN SQL, CNN
		IF NOT RS.EOF THEN
			strCodAluno			= Trim(RS("codigo"))
			strNomealuno		= Trim(RS("NOMEALUNO"))
			strMATRICULA		= Trim(RS("MATRICULA"))
			strDataNascimento	= replace(formatadataAP(Trim(RS("datanascimento"))),"/","")
			strEscola			= Trim(RS("RAZAOSOCIAL"))
			strEndereco			= Trim(RS("ENDERECO"))
			strBairro			= Trim(RS("BAIRRO"))
			strMunicipio		= Trim(RS("MUNICIPIO"))
			strUF				= Trim(RS("UF"))
			strCep				= Trim(RS("CEP"))
			strTelefone			= Trim(RS("TELEFONE"))
			intCodTipoEmpresa	= Trim(RS("CodTipoEmpresa"))
		END IF
		RS.CLOSE
	END IF
	
	IF intCodAluno <> "" THEN
		
		sql = " select T.Desc_Turno "
		sql = sql & " from MAT_inscricao M"
		sql = sql & " inner join SCA_TURNO T on T.Cod_Turno = M.Cod_turno"
		sql = sql & " and cod_aluno = " & intCodAluno
		RS.OPEN SQL, CNN
		IF NOT RS.EOF THEN
			if intCodTipoEmpresa = "1" then
				strTurno		= "INTEGRAL"
			else
				strTurno		= Trim(RS("Desc_Turno"))
			end if
		END IF
		RS.CLOSE
	END IF
	
	IF intCodAluno <> "" THEN
	
		sql = "select top 1 AT.COD_TURMA, T.Cod_GradeCurricular, T.NomeTurma"
		sql = sql & " from SCA_ALUNO_TURMA AT"
		sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = AT.COD_TURMA AND T.COD_EMPRESA = AT.COD_EMPRESA "
		sql = sql & " AND AT.ANO_LETIVO = T.AnoLetivo "
		sql = sql & " where AT.COD_EMPRESA = " &  intCodEmpresa
		sql = sql & " and AT.COD_ALUNO = " &  intCodAluno
		sql = sql & " and AT.SITUACAO = 'A'"'ATIVA
		sql = sql & " order by AT.CODIGO desc"
		rs.open sql, cnn
		if not rs.eof then
			intCodTurma = rs("cod_Turma")
			strTurma = rs("NomeTurma")
		end if
		rs.close
	end if
	
	
%>
<form name="frm" method="post" id="frm" action="AtivaFinanceiro_cad.asp">
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
<tr valign="top">
<td  align="center" class="tituloSistema"><%=strPaginaTitulo%></td>
</tr>
<tr valign="top">
<td align="center"><table width="566">
  <tr >
    <td colspan="2" class="texto2">&nbsp;</td>
  </tr>
  <tr >
    <td colspan="2" class="texto2">&nbsp;</td>
  </tr>
  <tr >
    <td colspan="2" class="texto2">Certifico que foi efetivada a matr&iacute;cula do aluno(a)<strong> <%=strNomealuno%></strong> Turma <strong><%=strTurma%></strong> turno <strong><%=strTurno%></strong> na escola <strong><%=strEscola%></strong>, matr&iacute;cula <strong><%=strMATRICULA%></strong>.</td>
  </tr>
  <tr >
    <td height="30" colspan="2" class="texto2">&nbsp;</td>
  </tr>
  <tr >
    <td colspan="2" class="texto2"><strong>Aparecida de Goi&acirc;nia, <%=day(date)%> de <%=monthName(month(date))%> de <%=year(date)%></strong></td>
  </tr>
  <tr >
    <td colspan="2" class="texto2">&nbsp;</td>
  </tr>
  <tr >
    <td colspan="2" class="texto2">&nbsp;</td>
  </tr>
  <tr >
    <td colspan="2" class="textoAtencao">&nbsp;</td>
  </tr>
  <tr >
    <td colspan="2" align="center" class="textoAtencao">________________________________________________</td>
  </tr>
  <tr >
    <td colspan="2" align="center" class="texto2"><strong>Assinatura do(a) Atendente</strong></td>
  </tr>
  <tr >
    <td colspan="2" class="textoAtencao">&nbsp;</td>
  </tr>
  
   <tr >
    <td  colspan="2" ><span class="texto2">Para acompanhamento da vida escolar do aluno, acesse o site <strong>http://www.aparecida.go.gov.br</strong>  no Portal do Aluno com os dados abaixo:<br /><br />
      - Us&uacute;ario:&nbsp;<strong><%=strMATRICULA%></strong> <br />
      - Senha:&nbsp;<strong><%=strDataNascimento%></strong><br />
    - C&oacute;digo de Seguran&ccedil;a:&nbsp;<strong><%=strCodAluno%></strong></span></td>
  </tr>
 
    <tr >
    <td colspan="2" class="textoAtencao">&nbsp;</td>
  </tr>
  <tr >
    <td colspan="2" class="textoAtencao">&nbsp;</td>
  </tr>

  
  <tr >
    <td width="278" align="center"><a href="#"><img src="../../images/ImpressaoBoleto.jpg" width="206" height="49" border="0" onClick="gerarComprovante('<%=intCodEmpresa%>','<%=intCodAluno%>')"></a></td>
    <td width="276" align="center"><a href="#"><img src="../../images/voltar.jpg" width="206" height="49" border="0" onClick="voltar(<%=intCodAluno%>)" /></a></td>
    </tr>
</table></td>
</tr>
 </table>
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>