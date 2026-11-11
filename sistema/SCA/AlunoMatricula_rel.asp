<head>
<title><%=session("Titulo")%></title>
<link href="../../estilo/Estilo_Impressao.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
</head>
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_Botoes_relatorio.asp"--> 
<%
	strPaginaTitulo			= "Comprovante de Efetivação"
	intCodEmpresa			= Trim(Session("CodEmpresa"))
	intCodAluno				= Trim(Request("CodAluno"))
	intCodGrupo				= 7
	Session("MatriculaInformatizada") =  ""
		
	IF intCodAluno <> "" and intCodEmpresa <> "" THEN
		
		sql = "select a.codigo, a.nomealuno, a.datanascimento, a.matricula, e.RAZAOSOCIAL, e.ENDERECO, e.BAIRRO, e.MUNICIPIO, e.UF, e.CEP, e.TELEFONE, e.CodTipoEmpresa"
		sql = sql & " from sca_aluno a"
		sql = sql & " inner join seg_empresa e on e.codigo = a.cod_empresa"
		sql = sql & " WHERE a.COD_EMPRESA = " & intCodEmpresa 
		sql = sql & " And a.CODIGO = " & intCodAluno
		RS.OPEN SQL, CNN
		IF NOT RS.EOF THEN
			strCodAluno			= Trim(RS("codigo"))
			strNomealuno		= Trim(RS("NOMEALUNO"))
			strDataNascimento	= replace(formatadataAP(Trim(RS("datanascimento"))),"/","")
			strMATRICULA		= Trim(RS("MATRICULA"))
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
<table width="700" border="0"  align="center" class="CorFundo" cellpadding="0" cellspacing="0">
  <tr>
    <td align="center"><img src="../../images/LogoAparecida.jpg" width="225" height="88" /></td>
    <td align="center"><img src="../../images/logoAparecidadeGoiania.jpg" width="182" height="61" /></td>
  </tr>
</table>
<table width="700" border="0"  align="center" class="CorFundo" cellpadding="0" cellspacing="0">
  <tr >
    <td width="554" class="texto2">&nbsp;</td>
  </tr>
  <tr >
    <td class="texto2">&nbsp;</td>
  </tr>
  <tr >
    <td class="texto2">Certifico que foi efetivada a matr&iacute;cula do aluno(a)<strong> <%=strNomealuno%></strong> Turma <strong><%=strTurma%></strong> turno <strong><%=strTurno%></strong> na escola <strong><%=strEscola%></strong>, matrícula <strong><%=strMATRICULA%></strong>.</td>
  </tr>
  <tr >
    <td class="texto2">&nbsp;</td>
  </tr>
  <tr >
    <td class="texto2"><p align="justify">&nbsp;</p></td>
  </tr>
  <tr >
    <td class="texto2"><strong>Aparecida de Goi&acirc;nia, <%=day(date)%> de &nbsp;<%=monthName(month(date))%> de <%=year(date)%></strong></td>
  </tr>
  <tr >
    <td class="texto2">&nbsp;</td>
  </tr>
  <tr >
    <td class="texto2">&nbsp;</td>
  </tr>
  <tr >
    <td class="textoAtencao">&nbsp;</td>
  </tr>
  <tr >
    <td align="center" class="textoAtencao">________________________________________________</td>
  </tr>
  <tr >
    <td align="center" class="texto2"><strong>Assinatura do(a) Atendente</strong></td>
  </tr>
  <tr >
    <td height="41" class="textoAtencao">&nbsp;</td>
  </tr>
  <tr >
    <td class="textoAtencao"><span class="texto2">Para acompanhamento da vida escolar do aluno, acesse o site <strong>http://www.aparecida.go.gov.br</strong>  no Portal do Aluno com os dados abaixo:<br /><br />
      - Us&uacute;ario:&nbsp;<strong><%=strMATRICULA%></strong> <br />
      - Senha:&nbsp;<strong><%=strDataNascimento%></strong><br />
    - C&oacute;digo de Seguran&ccedil;a:&nbsp;<strong><%=strCodAluno%></strong></span></td>
  </tr>
</table>
<p>&nbsp;</p>
</body>
</html>
