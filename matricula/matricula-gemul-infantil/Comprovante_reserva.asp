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
		intCodigoReserva = 0
		sql = "select Codigo, Inscricao, CodEmpresa, Ano, nome, cpf, data_nascimento, mae, cep, Logradouro, NumeroEndereco,  ComplementoEndereco, bairro, "
		sql = sql & " cidade, uf, email, Contato, Celular, FonePai, FoneMae, Sexo, "
		sql = sql & " curso, periodo, turno, Situacao, codigo_renda, usuario_incl, CONVERT (VARCHAR, CONVERT(DATETIME, data_hora_incl, 103), 103) AS data_hora_incl, CONVERT(VARCHAR(5),CAST(data_hora_incl AS datetime), 108) as hora"
		sql = sql & " from MAT_reserva "
		sql = sql & " WHERE chave = '" & strChave & "'"
		RS.OPEN SQL, CNN
		IF NOT RS.EOF THEN
			intCodigoReserva	= Trim(RS("Codigo"))
			intInscricao		= Trim(RS("inscricao"))
			strNomealuno		= Trim(RS("nome"))
			strCPF				= formataCpfAP(Trim(RS("cpf")))
			strDATANASCIMENTO	= Trim(RS("data_nascimento"))
			strMAE				= Trim(RS("mae"))
			strFONERESIDENCIAL	= Trim(RS("Contato"))
			strEMAIL			= Trim(RS("email"))
			
			strEndereco			= Trim(RS("Logradouro"))
			strNumeroEndereco	= Trim(RS("NumeroEndereco"))
			strCepEndereco		= Trim(RS("cep"))
			strComplementoEndereco	= Trim(RS("ComplementoEndereco"))
			strBairro			= Trim(RS("bairro"))
			strCidade			= Trim(RS("cidade")) & "/" & rs("UF")
			
			strSerie			= Trim(RS("periodo"))
			strRenda			= ""
			if Trim(RS("codigo_renda")) = "1" then strRenda = "Renda de até 1 salário mínimo"
			if Trim(RS("codigo_renda")) = "2" then strRenda = "Renda de 1 a 2 salários mínimos"
			if Trim(RS("codigo_renda")) = "3" then strRenda = "Renda de 2 a 3 salários mínimos"
			if Trim(RS("codigo_renda")) = "4" then strRenda = "Renda acima de 3 salários mínimos"
			strTurno 			= Trim(RS("turno"))
			strCurso			= Trim(RS("curso"))
			strUsuario_incl		= Trim(RS("usuario_incl"))
			strData_hora_incl	= Trim(RS("Data_hora_incl")) & " " & Trim(RS("hora"))
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
        <td width="55%"  style="padding: 5px;" >Data:&nbsp;<strong><%=strData_hora_incl%> </td>
      </tr>
    </table>
<br>
<p class="titulo2"><strong>1. Dados do Aluno</strong></p>
            <table width="100%" bgcolor="#F3F3F3" style="border: #ccc 1px solid; margin-top: 5px; font: 12px Arial, Helvetica, sans-serif;">
                <tr>
                    <td width="17%"  style="border-right: #ccc 1px solid; padding: 5px;"  ><span class="texto1">N. Reserva</span></td>
                    <td colspan="3"  style="padding: 5px;" ><strong><%=intInscricao%></strong></td>
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
                  <td  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">Renda Familiar</span></td>
                  <td colspan="3"  style="padding: 5px; border-top: #ccc 1px solid" ><strong><%=strRenda%></strong></td>
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
            <p class="titulo2"><strong>2. Dados de Endereço</strong></p>
			<table width="100%" bgcolor="#F3F3F3" style="border: #ccc 1px solid; margin-top: 5px; font: 12px Arial, Helvetica, sans-serif;">
				 <tr>
                  <td  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">CEP</span></td>
                  <td colspan="3"  style="padding: 5px; border-top: #ccc 1px solid" ><strong><%=strCepEndereco%></strong></td>
                </tr>
				<tr>
                  <td  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">Endereço</span></td>
                  <td colspan="3"  style="padding: 5px; border-top: #ccc 1px solid" ><strong><%=strEndereco%></strong></td>
                </tr>
				<tr>
                    <td width="17%"  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">Número</span></td>
                    <td width="33%"  style="padding: 5px; border-top: #ccc 1px solid" ><strong><%=strNumeroEndereco%></strong></td>
                    <td width="13%"  style="border-left: #ccc 1px solid;border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  >Complemento</td>
                    <td width="37%"  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=strComplementoEndereco%></strong></td>
                </tr>
				<tr>
                    <td width="17%"  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">Bairro</span></td>
                    <td width="33%"  style="padding: 5px; border-top: #ccc 1px solid" ><strong><%=strBairro%></strong></td>
                    <td width="13%"  style="border-left: #ccc 1px solid;border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  >Cidade/UF</td>
                    <td width="37%"  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=strCidade%></strong></td>
                </tr>
			  </table>
            <br />
            <p class="titulo2"><strong>3. Curso / Serie / Turno Escolhidos</strong></p>
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
    			<%
			sql = "SELECT e.Desc_NecEspecial, e.tipo "
			sql = sql & " FROM MAT_reserva_deficiencia r"
			sql = sql & " inner join sca_necessidadeespecial e on e.Cod_NecEspecial = r.Cod_NecEspecial"
			sql = sql & " WHERE r.cod_reserva = " & intCodigoReserva
			sql = sql & " order by e.tipo"
			'response.write sql
			RS.OPEN SQL, CNN
			IF NOT RS.EOF THEN
			%>
            <br />
            <p class="titulo2"><strong>3. Necessidade Especial </strong></p>
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
