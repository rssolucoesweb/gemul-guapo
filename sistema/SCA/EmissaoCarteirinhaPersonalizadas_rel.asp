<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 24/04/2009
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Emitir Carteirinhas
-->
<html>
<head>
<title><%=session("Titulo")%> - Emissão de Carteirinhas</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script>
<style type="text/css">
<!--
-->
</style>
</head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"--> 
<!--#include file="../../includes/inc_cnn.asp"--> 
<!--#include file="../../includes/inc_formatadata.asp"--> 
<!--#include file="../../includes/inc_Botoes_relatorio.asp"--> 
<!--#include file="../../includes/inc_aguarde.asp"--> 
<!--#include file="../../includes/inc_barcode.asp"--> 
<%
	strCod_empresa 				= Session("CodEmpresa")
	intAnoLetivoAtual	 		= Trim(Request.Form("txtAnoLetivo"))
	intSemestreAtual	 		= Trim(Request.Form("cmbSemestre"))
	
	intSemestreSession			= session("strSemestre")
	intAnoLetivoSession			= session("strAnoLetivo")	

	intCodTurma 				= Trim(Request.Form("cmbTurma"))
	strCodAluno					= Trim(Request("txtCodAluno"))
	intCodTurma 				= Trim(Request.Form("cmbTurma"))
	intPagina					= 1
	
	if strCodAluno = "" then
		strCodAluno			=	Trim(Request.form("chkAluno"))
	end if
	
	' Pega o Modelo da Carteirinha em Destaque	
	if trim(strCodAluno) <> "" then
	
		sql = "SELECT Codigo, cod_empresa, Descricao, Destaque, Modelo"
		sql = sql & " FROM SCA_ModeloCarteirinhas"
		sql = sql & " Where cod_empresa = " & strCod_empresa
		sql = sql & " And Destaque = 'S'"
		rs.open sql, cnn
	
		if rs.eof = false then
			intCodigo			= rs("Codigo")
			strDescricao		= rs("descricao")
			strModelo			= rs("Modelo")
		end if	
		rs.close				
	
	end if 
		
	if intCodTurma <> "" then 
	
		sql = "SELECT SCA_TURMA.cod_turma, SCA_TURMA.cod_Semestre , SCA_PERIODO.Cod_Curso, "
		sql = sql & " SCA_PERIODO.Cod_Periodo, SCA_TURMA.cod_turno, SCA_TURMA.Sala, SCA_TURMA.NomeTurma, SCA_CURSO.Descricao, SCA_TURNO.Desc_turno"
		sql = sql & " FROM SCA_TURMA "
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
		sql = sql & " INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo"
		sql = sql & " INNER JOIN SCA_CURSO ON SCA_PERIODO.Cod_Curso = SCA_CURSO.Cod_Curso "
		sql = sql & " INNER JOIN SCA_TURNO ON SCA_TURNO.cod_turno = SCA_TURMA.cod_turno AND SCA_TURNO.COD_EMPRESA = SCA_TURMA.COD_EMPRESA "
		SQL = SQL & " WHERE SCA_TURMA.cod_empresa=" & Session("CodEmpresa")
		sql = sql & " AND SCA_TURMA.Cod_Turma= " & intCodTurma
		RS.OPEN SQL, CNN
		IF not RS.EOF THEN
			intCodCurso 	= rs("cod_curso")
			intCodPeriodo 	= rs("cod_periodo")
			intCodTurno 	= rs("cod_turno")
			intSemestre 	= rs("cod_Semestre")
			strCurso		= left(rs("Descricao"),30) 
			strTurno		= left(rs("Desc_turno"),3)
		END IF
		rs.close
	
	end if
				
	if trim(strCodAluno) <> "" then

		sql = "SELECT S.Desc_SituacaoAluno, A.codigo, A.Dataingresso, A.Nomealuno, A.Matricula, A.Ctrviace"
		sql = sql & " FROM SCA_ALUNO A"
		sql = sql & " LEFT JOIN SCA_SITUACAOALUNO S ON S.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO AND S.COD_EMPRESA = A.COD_EMPRESA"
		sql = sql & " Where A.COD_EMPRESA = " & strCod_empresa
		sql = sql & " And 	A.codigo in (" & strCodAluno & ")"
		rs.open sql, cnn
		if rs.eof = false then
			
			intPagina = intPagina + 1
			
			while not rs.eof
				strMatricula        = ""
				intCodAluno			= rs("codigo")
				strDataingresso 	= formataDataAP(TRIM(rs("Dataingresso")))
				strNomealuno 		= TRIM(rs("Nomealuno"))
				strMatricula 		= TRIM(rs("Matricula"))
				
				if len(strmatricula) <> 9 then
			   		if len(strmatricula) = 5 then
			      		strmatricula = "0000" & strmatricula
			   		else 
			      		strmatricula = "000" & strmatricula
			   		end if	  	   
				end if   

				sql = "SELECT Arquivo "
				sql = sql & " FROM 	SCA_ALUNO_FOTO"
				sql = sql & " Where COD_EMPRESA = " & strCod_empresa
				sql = sql & " And 	codAluno = " & intCodAluno
				rsAux.open sql, cnn
				if rsAux.eof = false then
					strCaminhoFoto = session("strCaminhoRaiz") & "/fotoAluno/" & strCod_empresa & "/" & rsAux("arquivo")
					strFoto =  "<img src='" & strCaminhoFoto & "' width='87' height='109'>"
				end if
				rsAux.close
				%>
<table width="56%" height="266" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td height="266"><table width="651" height="263" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td width="33%" height="263" align="center"><p>&nbsp;</p>
              <p>&nbsp;</p>
          <p>&nbsp;</p>
          <p align="left">&nbsp;</p></td>
        <td width="67%" align="center"><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr valign="top">
            <td height="24">&nbsp;</td>
            <td class="texto3"><%=TRIM(strDataingresso)%></td>
          </tr>
          <tr valign="top">
            <td width="25%">&nbsp;</td>
            <td width="75%" class="texto3">&nbsp;</td>
          </tr>
        </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr valign="top">
                  <td width="2%">&nbsp;</td>
                  <td width="98%" class="texto3"><%=TRIM(strNomealuno)%></td>
                </tr>
              </table>
          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr valign="top">
                  <td>&nbsp;</td>
                  <td colspan="2">&nbsp;</td>
                </tr>
                <tr valign="top">
                  <td width="6%" height="21">&nbsp;</td>
                  <td colspan="2">&nbsp;</td>
                </tr>
                <tr valign="top">
                  <td height="19">&nbsp;</td>
                  <td width="23%" class="texto3"><%=TRIM(strMatricula)%></td>
                  <td width="71%" class="texto3"><%=TRIM(strTurno)%></td>
                </tr>
            </table>
          <table width="100%" height="69" border="0" cellpadding="0" cellspacing="0">
                <tr valign="top">
                  <td width="2%" height="19">&nbsp;</td>
                  <td width="98%">&nbsp;</td>
                </tr>
                <tr valign="top">
                  <td height="22">&nbsp;</td>
                  <td class="texto3"><%=TRIM(strCurso)%></td>
                </tr>
                <tr valign="top">
                  <td height="28">&nbsp;</td>
                  <td class="texto3">&nbsp;</td>
                </tr>
            </table>
         
            <%
					if rs("CTRVIACE") = "" or isnull(rs("CTRVIACE")) then
					   strCtrviace = "1"
					else 
					    strCtrviace = rs("CTRVIACE")
					end if	
					%>
            <div align="left">
          <table width="200" border="0">
                <tr>
                  <td width="145" height="51"><div align="center"><%=getCodigoBarras(strmatricula & strCtrviace)%></div></td>
                </tr>
              </table>
          </div></td>
      </tr>
    </table></td>
</table>
<p><%
				rs.movenext	
				if rs.eof = false  then
				
				'quantidade de registros da página
				if intPagina > 3 then
				   intPagina = 0
				 
				   %>
</p>
                   <pre></pre>
				   <%			
				end if	
				intPagina = intPagina + 1
				
				end if
			wend
		end if 
		rs.close
	else
		%>
		<script>
			alert("Aluno não foi encontrato, verifique.");
			window.history.back();
		</script>
		<%
		response.end
	end if 
	%>
		<script>
	aguarde.style.display="none";
</script>
</body>
</html>