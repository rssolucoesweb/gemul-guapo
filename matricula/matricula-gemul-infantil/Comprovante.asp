<!--#include file="../../includes/inc_smtp_config.asp"-->
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=10, IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" />
		<meta name="format-detection" content="telephone=no">
    <link href="../css/bootstrap.css" rel="stylesheet" />
    <link href="../css/bootstrap-theme.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="../css/estilo.css">    
    <link href="../css/impressao.css" rel="stylesheet" />
    <title>Matrícula</title>

    <style type='text/css'>
       
		@media print {
        #botoes_imprimir {
            display: none;
        }
        #botoes_imprimir_1 {
            display: none;
        }
    }

    tr.dif td {
	    background: #eee; /* Linhas com fundo cinza */
	    }
    </style>

   

</head>
<body>
<!--#include file="../includes/inc_formatadata.asp"-->
<!--#include file="../includes/inc_formataCPF.asp"-->
<%
strUsuarioCallcenter		= "S"
%>
<!--#include file="../includes/inc_cnn.asp"-->
<%
	strChave				= Trim(Request("cv"))

	strBolsaFamilia			= ""
	IF strChave <> "" THEN
		
		sql = "select a.codigo, m.codigo as codInscricao, a.NOMEALUNO, m.cpf, a.MATRICULA, a.DATANASCIMENTO , a.MAE , a.EMAIL, a.FONERESIDENCIAL, e.RAZAOSOCIAL, a.SEXOALUNO as sexo,"
		sql = sql & " e.ENDERECO, e.BAIRRO, e.MUNICIPIO, e.UF, e.CEP, e.TELEFONE, M.usuario_incl, CONVERT (VARCHAR, CONVERT(DATETIME, M.data_hora_incl, 103), 103) AS data_hora_incl, CONVERT(VARCHAR(5),CAST(M.data_hora_incl AS datetime), 108) as hora, m.cod_empresa, "
		sql = sql & " c.descricao as curso, p.descricao as serie, t.Desc_Turno as turno, m.bolsa_Familia, e.codtipoempresa, r.descricao as renda"
		sql = sql & " from sca_aluno a"
		sql = sql & " inner join mat_inscricao m on m.cod_aluno = a.codigo"
		sql = sql & " inner join seg_empresa e on e.codigo = m.Cod_empresa"
		sql = sql & " inner join sca_periodo p on p.cod_periodo = m.cod_periodo"
		sql = sql & " inner join sca_curso c on c.cod_curso = p.cod_curso"
		sql = sql & " inner join sca_turno t on t.cod_turno = m.cod_turno"
		sql = sql & " left join MAT_renda_familiar r on r.codigo = m.codigo_renda"
		sql = sql & " WHERE m.chave = '" & strChave & "'"
		RS.OPEN SQL, CNN
		IF NOT RS.EOF THEN
			intCodInscricao		= Trim(RS("codInscricao"))
			intCodigo			= Trim(RS("Codigo"))
			strNomealuno		= Trim(RS("NOMEALUNO"))
			strCPF				= formataCpfAP(Trim(RS("cpf")))
			strSexo				= Trim(RS("Sexo"))
			if strSexo = "M" then strSexo = "MASCULINO"
			if strSexo = "F" then strSexo = "FEMININO"
			strMATRICULA		= Trim(RS("MATRICULA"))
			strDATANASCIMENTO	= Trim(RS("DATANASCIMENTO"))
			strMAE				= Trim(RS("MAE"))
			strEMAIL			= Trim(RS("EMAIL"))
			strFONERESIDENCIAL	= Trim(RS("FONERESIDENCIAL"))
			strUsuario_incl		= Trim(RS("usuario_incl"))
'			strData_hora_incl	= formatadataAP(Trim(RS("data_hora_incl")))
			strData_hora_incl	= RS("data_hora_incl") & " " & RS("hora")
			'response.write len(strData_hora_incl)
			'if len(strData_hora_incl) = 9 then strData_hora_incl = "0" & RS("data_hora_incl")

'			strData_hora_incl	= right(RS("data_hora_incl"),4) & mid(RS("data_hora_incl"),3,4) & left(RS("data_hora_incl"),2) & " " & RS("hora")
'	

			strEscola		= Trim(RS("RAZAOSOCIAL"))
			strEndereco		= Trim(RS("ENDERECO"))
			strBairro		= Trim(RS("BAIRRO"))
			strMunicipio	= Trim(RS("MUNICIPIO"))
			strUF			= Trim(RS("UF"))
			strCep			= Trim(RS("CEP"))
			strTelefone		= Trim(RS("TELEFONE"))

			strCurso		= Trim(RS("curso"))
			strSerie		= Trim(RS("serie"))
			strRenda		= Trim(RS("renda"))

			strTurno		= Trim(RS("turno"))

			strBolsaFamilia		= Trim(RS("bolsa_Familia"))
			if isnull(strBolsaFamilia) then strBolsaFamilia = ""
			intCodEmpresa = rs("cod_empresa")
		END IF
		RS.CLOSE
	END IF
	
	sql = "SELECT DADOS"
	sql = sql & " FROM Mat_Dados "
	sql = sql & " WHERE COD_GRUPO = " & intCodGrupo
	IF strCurso = "EDUCAÇÃO INFANTIL" THEN
		sql = sql & " AND codTipoEmpresa = 1"
	ELSE
		sql = sql & " AND codTipoEmpresa = 2" 'ENSINO FUNDAMENTAL
	END IF
	RS.OPEN SQL, CNN
	IF NOT RS.EOF THEN
		strDados		= Trim(RS("Dados"))
	END IF
	RS.CLOSE
	
	if strEMAIL <> "" and request.QueryString("m")="" then
		mensagemEmail = "Olá <strong>" & strNomealuno & "</strong> seja bem vindo, você acabou de solicitar a Reserva de Matrícula Informatizada de Guapó, seu Número de Inscrição é <strong>" & intCodigo & "</strong>." 
		mensagemEmail = mensagemEmail & "<br><br>Favor procurar a <strong>" & strEscola & "</strong>, " &  strEndereco & ", " & strBairro & ", " & strMunicipio & ", CEP: " &  strCep & ", telefone: " & strTelefone & ", para confirmar a matr&iacute;cula com os seguintes documentos:"
		mensagemEmail = mensagemEmail & "<br><br>" & strDados
		mensagemEmail = mensagemEmail & "<strong>Clique no link ao lado para imprimir seu comprovante:</strong><br> <a href='https://gemul-guapo.com.br/matricula/matricula-gemul-infantil/comprovante.asp?m=n&cv=" & strChave & "' target='_blank'>https://gemul-guapo.com.br/matricula/matricula-gemul-infantil/comprovante.asp?m=n&cv=" & strChave & "</a>"
	end if
%>

<div id="botoes_imprimir_1" style="text-align: center">
    <br />
                <input type="button" class="btn btn-success" style="width:150px" value="Imprimir" onClick="javascript: print();" >
				<input type="button" class="btn btn-default" value="Voltar" onClick="window.location='../index.html';" >
    <br /><br />
    
    </div>

<div style="background: #fff; padding: 25px; border: #000 0px solid; width: 700px; margin: 0 auto; color: #000;">
    <table width="100%">
    <tr>
        <td align="center"><img src="img/logo.png" alt="Prefeitura de Guapó" /></td>
      </tr>
  </table>
<br>
<div style="text-align: center;  font: bold 16px Arial, Helvetica, sans-serif;">
    	Matr&iacute;cula Informatizada - <%=strAnoLetivo%><br />
        Comprovante de Inscri&ccedil;&atilde;o<br />
    </div>
<table width="100%" bgcolor="#F3F3F3" style="border: #ccc 1px solid; margin-top: 5px; font: 12px Arial, Helvetica, sans-serif;">
      <tr>
        <td width="45%"  style="border-right: #ccc 1px solid; padding: 5px;"  >N&uacute;mero de Inscri&ccedil;&atilde;o: <strong><span class="texto1"><%=intCodigo%></span></strong></td>
        <td width="55%"  style="padding: 5px;" ><%if strBolsaFamilia<>"" then%>N&uacute;mero Cart&atilde;o Auxílio Brasil: <span class="texto1"><strong><%=strBolsaFamilia%></strong></span><%end if%>&nbsp;</td>
      </tr>
      <tr>
        <td  style="border-right: #ccc 1px solid; padding: 5px;"  >Data Inscri&ccedil;&atilde;o:&nbsp;<strong><%=strData_hora_incl%> </strong></td>
        <td  style="padding: 5px;" >&nbsp;</strong></td>
      </tr>
    </table>
<br>
<p class="titulo2"><strong>1. Dados do Aluno</strong></p>
            <table width="100%" bgcolor="#F3F3F3" style="border: #ccc 1px solid; margin-top: 5px; font: 12px Arial, Helvetica, sans-serif;">
                <tr>
                    <td width="17%"  style="border-right: #ccc 1px solid; padding: 5px;"  ><span class="texto1">N. Inscrição</span></td>
                    <td style="padding: 5px;" ><strong><%=intCodigo%></strong></td>
					<td width="13%"  style="border-left: #ccc 1px solid;border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  >CPF</td>
                    <td width="37%"  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=strCPF%></strong></td>
              </tr>
                <tr>
                    <td width="17%"  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">Nome</span></td>
                    <td colspan="3"  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=strNomealuno%></strong></td>
                </tr>
                <tr>
                    <td width="17%"  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">Data de Nasc.</span></td>
                    <td width="33%"  style="padding: 5px; border-top: #ccc 1px solid" ><strong><%=formatadataAP(strDATANASCIMENTO)%></strong></td>
                    <td width="13%"  style="border-left: #ccc 1px solid;border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  >Sexo</td>
                    <td width="37%"  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=strSexo%></strong></td>
                </tr>
                <tr>
                  <td  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">Nome da m&atilde;e</span></td>
                  <td colspan="3"  style="padding: 5px; border-top: #ccc 1px solid" ><strong><%=strMAE%></strong></td>
                </tr>
                <tr>
                  <td  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">Renda Familiar</span></td>
                  <td colspan="3"  style="padding: 5px; border-top: #ccc 1px solid" ><strong><%=strRenda%></strong></td>
                </tr>
                <tr>
                  <td  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">Telefones</span></td>
                  <td colspan="3"  style="padding: 5px; border-top: #ccc 1px solid" ><strong><%=strFONERESIDENCIAL%></strong></td>
                </tr>
                <%if strEMAIL <> "" then%>
                <tr>
                  <td  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">Email</span></td>
                  <td colspan="3"  style="padding: 5px; border-top: #ccc 1px solid" ><strong><%=strEMAIL%></strong></td>
                </tr>
                <%end if%>
			  </table>
   			<%
			idsubTitulo = 2
			sql = "SELECT e.Desc_NecEspecial, e.tipo "
			sql = sql & " FROM MAT_inscricao_deficiencia r"
			sql = sql & " inner join sca_necessidadeespecial e on e.Cod_NecEspecial = r.Cod_NecEspecial"
			sql = sql & " WHERE r.cod_inscricao = " & intCodInscricao
			sql = sql & " order by e.tipo"
			'response.write sql
			RS.OPEN SQL, CNN
			IF NOT RS.EOF THEN
				idsubTitulo = 3
			%>
            <br />
            <p class="titulo2"><strong>2. Necessidade Especial </strong></p>
            <table width="100%" bgcolor="#F3F3F3" style="border: #ccc 1px solid; margin-top: 5px; font: 12px Arial, Helvetica, sans-serif;">
            <%
			while not rs.eof
				if tipo <> rs("tipo") then
				%>
                <tr>
                    <td style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"><span class="texto1"><strong><%=rs("tipo")%></strong></span></td>
              	</tr>
                <%end if%>
                <tr>
                    <td style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"><span class="texto1">&raquo;&nbsp;<%=rs("Desc_NecEspecial")%></span></td>
              	</tr>
    	        <%
				tipo = rs("tipo")
				rs.movenext
			wend
			%>
  			</table>
            <%
			end if
			rs.close
			%>
            <br />
            <p class="titulo2"><strong><%=idsubTitulo%>. Curso / Serie / Turno Escolhidos</strong></p>
            <table width="100%" bgcolor="#F3F3F3" style="border: #ccc 1px solid; margin-top: 5px; font: 12px Arial, Helvetica, sans-serif;">
                <tr>
                    <td width="17%"  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">Curso</span></td>
                    <td width="83%"  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=strCurso%></strong></td>
              </tr>
                <tr>
                    <td width="17%"  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">S&eacute;rie</span></td>
                    <td width="83%"  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=strSerie%></strong></td>
                </tr>
                <tr>
                    <td width="17%"  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">Turno</span></td>
                    <td width="83%"  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=strTurno%></strong></td>
                </tr>
  </table>
            
             <br />
  <p class="titulo2"><strong><%=idsubTitulo+1%>. Escola escolhida</strong></p>
  <table width="100%" bgcolor="#F3F3F3" style="border: #ccc 1px solid; margin-top: 5px; font: 12px Arial, Helvetica, sans-serif;">
    <tr>
      <td  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">Escola</span></td>
      <td  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=strEscola%></strong></td>
      <td  style="border-left: #ccc 1px solid;border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  >Cep</td>
      <td  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=strCep%></strong></td>
    </tr>
    <tr>
      <td width="17%"  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">Endere&ccedil;o</span></td>
      <td colspan="3"  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=strEndereco%></strong></td>
    </tr>
    <tr>
      <td  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">Bairro</span></td>
      <td width="38%"  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=strBairro%></strong></td>
      <td width="11%"  style="border-left: #ccc 1px solid;border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  >Munic&iacute;pio</td>
      <td width="34%"  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=strMunicipio%>-<%=strUF%></strong></td>
    </tr>
    <tr>
      <td  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">Telefone</span></td>
      <td colspan="3"  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=strTelefone%></strong></td>
    </tr>
  </table>
  <br />
  <p class="titulo2"><strong><%=idsubTitulo+2%>. Observa&ccedil;&otilde;es Importantes</strong></p>
 <table width="650px" bgcolor="#F3F3F3" style="border: #ccc 1px solid; margin-top: 5px; font: 11px Arial, Helvetica, sans-serif;">
    <!--tr>
        <td width="100%"  style="border-right: #ccc 1px solid; padding: 5px; text-align:justify;"><span class="texto1"> Favor procurar a <strong><%=strEscola%></strong>, endereço: <%=strEndereco%>, bairro: <%=strBairro%>, cidade: <%=strMunicipio%>, CEP: <%=strCep%>, telefone: <%=strTelefone%>, para confirmar a matr&iacute;cula com os seguintes documentos:</span></td>
    </tr-->
    <tr>
        <td width="650px"  style="border-right: #ccc 1px solid; padding: 5px; text-align: left;"><span class="texto2"><%=strDados%></span></td>
    </tr>
   </table>
</div>
<div id="botoes_imprimir" style="text-align: center">
    <br />
                <input type="button" class="btn btn-success" style="width:150px" value="Imprimir" onClick="javascript: print();" >
				<input type="button" class="btn btn-default" value="Voltar" onClick="window.location='../index.html';" >
    <br />
    <br />
    </div>

<script src="js/jquery-2.1.3.min.js"></script>
<script src="js/bootstrap.min.js"></script>

</body>
</html>
<%

if strEMAIL <> "" and request.QueryString("m")="" then
  
   '****** CONFIGURAÇÃO DE EMAIL *****************
   
   '****** SENDBLUE *****************
    'servidorSMTP = "smtp-relay.sendinblue.com"
    'usuarioSMTP  =  "suporte@gemul.com.br" 
    'senhaSMTP    = "" 
    'NomeSMTP     = "GEMUL"
	
	'****** LOCAWEB *****************	
	servidorSMTP = "smtplw.com.br"
    usuarioSMTP  = "suportegemul" 
    senhaSMTP    = SMTP_LW_SENHA 
    NomeSMTP     = "Matrícula " & strAnoLetivo
    '***********************

	nomeDestinatario=strNomealuno
	emailDestinatario=strEMAIL
	nomeRemetente="Secretaria Municipal de Guapó"
	emailRemetente="suporte@gemul.com.br" 'O endereço de e-mail deve ser preenchido com uma conta existente em seu próprio domínio.
	'emailRetorno="suporte@gemul.com.br"
	'responderPara="coordenadoriasupervisaoescolar@gmail.com"
	strAssunto="Comprovante de Inscrição"
	mensagem=mensagemEmail

	strEmailInvalido = "N"
	if not instr(strEMAIL,"@") > 0 then
		strEmailInvalido = "S"
	end if
	
	if strEmailInvalido = "N" then
		
		strDadosEmail = mensagemEmail
				
		erro = ""

		Set Mail = CreateObject("CDO.Message")
		
		'This section provides the configuration information for the remote SMTP server.
		
		'Send the message using the network (SMTP over the network).
		Mail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
		
		Mail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserver") = servidorSMTP
		Mail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 587
		
		'Use SSL for the connection (True or False)
		Mail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = False
		
		Mail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout") = 60
		
		'If your server requires outgoing authentication, uncomment the lines below and use a valid email address and password.
		'Basic (clear-text) authentication
		Mail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1
		'Your UserID on the SMTP server
		Mail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendusername") = usuarioSMTP
		Mail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendpassword") = senhaSMTP
		
		Mail.Configuration.Fields.Update
			
		Mail.Subject=strAssunto
		Mail.From=emailRemetente
		Mail.To=emailDestinatario
'			Mail.To="sergio@rssolucoesweb.com.br"
		Mail.HtmlBody="<html> <head><meta http-equiv=""Content-Type"" content=""text/html;charset=ISO-8859-1""></head><body>" & mensagem & "</body></html>" 
		
		Mail.Send
		
		Set Mail = Nothing
		
	end if
end if

%>

