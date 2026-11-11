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

	IF strChave <> "" THEN
		
		sql = "select Codigo, Inscricao, CodEmpresa, Ano, nome, data_nascimento, mae, cep, Logradouro, NumeroEndereco,  ComplementoEndereco, bairro, "
		sql = sql & " cidade, uf, email, Contato, Celular, FonePai, FoneMae, Sexo, cpf,"
		sql = sql & " periodo, Situacao, turno, usuario_incl, data_hora_incl"
		sql = sql & " from MAT_reserva "
		sql = sql & " WHERE chave = '" & strChave & "'"
		RS.OPEN SQL, CNN
		IF NOT RS.EOF THEN
			intInscricao		= Trim(RS("inscricao"))
			strNomealuno		= Trim(RS("nome"))
			strDATANASCIMENTO	= Trim(RS("data_nascimento"))
			strMAE				= Trim(RS("mae"))
			strCPF				= formataCpfAP(Trim(RS("cpf")))
			strFONERESIDENCIAL	= Trim(RS("Contato"))
			strEMAIL			= Trim(RS("email"))
			strSerie			= Trim(RS("periodo"))
			strTurno 			= Trim(RS("turno"))
			strCurso			= "ENSINO FUNDAMENTAL"
			strUsuario_incl		= Trim(RS("usuario_incl"))
			strData_hora_incl	= Trim(RS("Data_hora_incl"))
			strSexo				= Trim(RS("Sexo"))
			if strSexo = "M" then strSexo = "MASCULINO"
			if strSexo = "F" then strSexo = "FEMININO"
		END IF
		RS.CLOSE
	END IF
	


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
        <td align="center"><img src="img/logo.png" alt="Prefeitura de Abadia" /></td>
      </tr>
  </table>
<br>
<div style="text-align: center;  font: bold 16px Arial, Helvetica, sans-serif;">
    	Matr&iacute;cula Informatizada - <%=strAnoLetivo%><br />
        Comprovante de Cadastro de Reserva<br />
    </div>
<table width="100%" bgcolor="#F3F3F3" style="border: #ccc 1px solid; margin-top: 5px; font: 12px Arial, Helvetica, sans-serif;">
      <tr>
        <td width="45%"  style="border-right: #ccc 1px solid; padding: 5px;"  >N&uacute;mero de Reserva: <strong><span class="texto1"><%=intInscricao%></span></strong></td>
        <td width="55%"  style="padding: 5px;" >Data:&nbsp;<strong><%=strData_hora_incl%> </strong></td>
      </tr>
    </table>
<br>
<p class="titulo2"><strong>1. Dados do Aluno</strong></p>
            <table width="100%" bgcolor="#F3F3F3" style="border: #ccc 1px solid; margin-top: 5px; font: 12px Arial, Helvetica, sans-serif;">
                <tr>
                    <td width="17%"  style="border-right: #ccc 1px solid; padding: 5px;"  ><span class="texto1">N. Reserva</span></td>
                    <td style="padding: 5px;" ><strong><%=intInscricao%></strong></td>
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
            <br />
            <p class="titulo2"><strong>2. Curso / Serie / Turno Escolhidos</strong></p>
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
