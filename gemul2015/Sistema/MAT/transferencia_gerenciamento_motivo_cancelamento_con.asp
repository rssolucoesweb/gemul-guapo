<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=10, IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" />
		<meta name="format-detection" content="telephone=no">
    <link href="../../css/bootstrap.css" rel="stylesheet" />
    <link href="../../css/bootstrap-theme.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="../css/estilo.css">    
    <link href="../../css/impressao.css" rel="stylesheet" />
	
    <title>Cancelamento da Transferência de Aparecida de Goiânia</title>
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
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_formataCPF.asp"-->
<%
strUsuarioCallcenter		= "S"
%>
<!--#include file="../../includes/inc_cnn.asp"-->
<%
	codTransferencia = Trim(Request("codTransferencia"))

	strBolsaFamilia			= ""
	IF codTransferencia <> "" THEN
		
		sql = "select a.codigo, m.matricula_transferencia, a.NOMEALUNO, a.MATRICULA, a.cpf, a.DATANASCIMENTO , a.MAE , a.EMAIL, a.FONERESIDENCIAL, e.RAZAOSOCIAL, a.SEXOALUNO as sexo,"
		sql = sql & " e.ENDERECO, e.BAIRRO, e.MUNICIPIO, e.UF, e.CEP, e.TELEFONE, M.usuario_incl, CONVERT (VARCHAR, CONVERT(DATETIME, M.data_situacao, 103), 103) AS data_hora_incl, CONVERT(VARCHAR(5),CAST(M.data_situacao AS datetime), 108) as hora, a.cod_empresa, "
		sql = sql & " replace(m.curso,'_',' ') AS CURSO, replace(m.periodo,'_',' ') as serie, m.turno, a.bolsa_Familia, e.codtipoempresa"
		sql = sql & " from sca_aluno a"
		sql = sql & " inner join mat_transferencia m on m.cod_aluno = a.codigo"
		sql = sql & " inner join seg_empresa e on e.codigo = m.cod_empresa"
		sql = sql & " where m.codigo = " & codTransferencia
		RS.OPEN SQL, CNN
		IF NOT RS.EOF THEN
			matricula_transferencia		= Trim(RS("matricula_transferencia"))
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
			strEscola		= Trim(RS("RAZAOSOCIAL"))
			strEndereco		= Trim(RS("ENDERECO"))
			strBairro		= Trim(RS("BAIRRO"))
			strMunicipio	= Trim(RS("MUNICIPIO"))
			strUF			= Trim(RS("UF"))
			strCep			= Trim(RS("CEP"))
			strTelefone		= Trim(RS("TELEFONE"))
			strData_hora_incl	= Trim(RS("data_hora_incl")) & " " & RS("hora")
			strCurso		= Trim(RS("curso"))
			strSerie		= Trim(RS("serie"))
			strTurno		= Trim(RS("turno"))
			strBolsaFamilia		= Trim(RS("bolsa_Familia"))
			if isnull(strBolsaFamilia) then strBolsaFamilia = ""
			intCodEmpresa = rs("cod_empresa")
		END IF
		RS.CLOSE
	END IF
	
	IF codTransferencia <> "" THEN
		motivo = "Não informado!"
		sql = "SELECT descricao, usuario_incl, CONVERT (VARCHAR, CONVERT(DATETIME, data_hora_incl, 103), 103) AS data_hora_incl, CONVERT(VARCHAR(5),CAST(data_hora_incl AS datetime), 108) as hora "
		sql = sql & " FROM mat_transferencia_cancelamento "
		sql = sql & " WHERE cod_Transferencia = " & codTransferencia
		RS.OPEN SQL, CNN
		IF NOT RS.EOF THEN
			motivo				= Trim(RS("descricao"))
			strUsuario_incl		= Trim(RS("usuario_incl"))
			strData_hora_incl	= Trim(RS("data_hora_incl")) & " " & RS("hora")
		END IF
		RS.CLOSE

	END IF
	
%>

<div id="botoes_imprimir_1" style="text-align: center">
    <br />
				<input type="button" class="btn btn-default" value="Fechar" onClick="window.close();" >
    <br /><br />
    
    </div>


<div style="text-align: center;  font: bold 16px Arial, Helvetica, sans-serif;">
        Cancelamento de Transferência<br />
    </div>
<table width="100%" bgcolor="#F3F3F3" style="border: #ccc 1px solid; margin-top: 5px; font: 12px Arial, Helvetica, sans-serif;">
      <tr>
        <td width="55%"  style="padding: 5px;" >Data: <strong><%=strData_hora_incl%></strong></td>
        <td  style="padding: 5px;" >Via: <strong><%=strUsuario_incl %></strong></td>
      </tr>
    </table>

<p class="titulo2"><strong>1. Dados do Aluno</strong></p>
            <table width="100%" bgcolor="#F3F3F3" style="border: #ccc 1px solid; margin-top: 5px; font: 12px Arial, Helvetica, sans-serif;">
                <tr>
                    <td width="17%"  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">Nome do Aluno</span></td>
                    <td width="33%"  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=strNomealuno%></strong></td>
                    <td width="8%"   style="border-left: #ccc 1px solid;border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  >CPF</td>
                    <td width="12%"  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=strCPF%></strong></td>
                </tr>
                <tr>
                    <td width="17%"  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">Data de Nasc.</span></td>
                    <td width="33%"  style="padding: 5px; border-top: #ccc 1px solid" ><strong><%=formatadataAP(strDATANASCIMENTO)%></strong></td>
                    <td width="8%"   style="border-left: #ccc 1px solid;border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  >Sexo</td>
                    <td width="12%"  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=strSexo%></strong></td>
                </tr>
                <tr>
                  <td  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">Nome da m&atilde;e</span></td>
                  <td colspan="3"  style="padding: 5px; border-top: #ccc 1px solid" ><strong><%=strMAE%></strong></td>
                </tr>
                <tr>
                  <td  style="border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  ><span class="texto1">Telefones</span></td>
                  <td colspan="3"  style="padding: 5px; border-top: #ccc 1px solid" ><strong><%=strFONERESIDENCIAL%></strong></td>
                </tr>
               
			  </table>
           
            
            <p class="titulo2"><strong>2. Dados Escolares</strong></p>
            <table width="100%" bgcolor="#F3F3F3" style="border: #ccc 1px solid; margin-top: 5px; font: 12px Arial, Helvetica, sans-serif;">
                <tr>
                    <td width="5%"   style="border-left: #ccc 1px solid;border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  >Curso</td>
                    <td width="40%"  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=strCurso%></strong></td>
                    <td width="5%"   style="border-left: #ccc 1px solid;border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  >S&eacute;rie</td>
                    <td width="25%"  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=strSerie%></strong></td>
                    <td width="5%"   style="border-left: #ccc 1px solid;border-right: #ccc 1px solid; border-top: #ccc 1px solid; padding: 5px;"  >Turno</td>
                    <td width="20%"  style="padding: 5px; border-top: #ccc 1px solid;" ><strong><%=strTurno%></strong></td>
                </tr>
			  </table>
             <br />
  
  
  <p class="titulo2"><strong>3. Motivo do cancelamento</strong></p>
 <table width="100%" bgcolor="#F3F3F3" style="border: #ccc 1px solid; margin-top: 5px; font: 11px Arial, Helvetica, sans-serif;">
   
    <tr>
        <td width="100%"  style="border-right: #ccc 1px solid; padding: 5px; text-align:justify;"><span class="texto2"><%=motivo%></span></td>
    </tr>
</table>
</div>
<div id="botoes_imprimir" style="text-align: center">
    <br />
				<input type="button" class="btn btn-default" value="Fechar" onClick="window.close();" >
    <br />
    <br />
    </div>

</body>
</html>
