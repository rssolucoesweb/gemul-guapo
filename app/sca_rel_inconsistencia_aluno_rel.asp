<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
response.Expires=0
Server.ScriptTimeOut = 5000
response.Buffer = false
%>
<html>
<head>
<title>GEMUL - Inconsistencia do Cadastro do Aluno</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet" href="css_rel/Estilo_Impressao.css">
<body>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="includes/inc_Botoes_relatorio.asp"-->	
<!--#include file="includes/inc_aguarde.asp"-->	
<br>
<%
	dim intPagina

	strTituloRelatorio  			= "Inconsistencia de Cadastro do Aluno"
	intCodEmpresaGrupo				= Trim(Request.Form("cmbEmpresaGrupo"))
	intCodSituacaoAluno	 			= Trim(Request.Form("cmbSituacaoAluno"))
	strAnoLetivo	 				= Trim(Request.Form("txtAnoLetivo"))

	nomealuno	 					= Trim(Request.Form("nomealuno"))
	datamatricula	 				= Trim(Request.Form("datamatricula"))
	datanascimento	 				= Trim(Request.Form("datanascimento"))
	sexo	 						= Trim(Request.Form("sexo"))
	Naturalidade	 				= Trim(Request.Form("Naturalidade"))
	ufNaturalidade	 				= Trim(Request.Form("ufNaturalidade"))
	etnia	 						= Trim(Request.Form("etnia"))
	logradouro	 					= Trim(Request.Form("logradouro"))
	nomemae	 						= Trim(Request.Form("nomemae"))

	intTotalAluno					= 0

	sql = "select distinct s.Desc_SituacaoAluno, e.razaosocial, a.matricula, a.nomealuno, A.DATANASCIMENTO, A.SEXOALUNO, A.CIDADENASCIMENTO, "
	sql = sql & " A.nacionalidade, ET.descricao AS ETNIA, U.SIGLA, a.LOGRADOURO, a.MAE"
	sql = sql & " from sca_aluno a "
	sql = sql & " inner join SCA_aluno_turma at on at.COD_ALUNO = a.codigo "
	sql = sql & " inner join seg_empresa e on e.codigo=at.cod_empresa "
	sql = sql & " inner join SCA_TURMA t on t.cod_turma = at.cod_turma "
	sql = sql & " inner join SCA_SITUACAOALUNO s on s.Cod_SituacaoAluno = a.Cod_SituacaoAluno "
	sql = sql & " LEFT join SCA_ETNIAS ET on ET.CODIGO = a.COD_ETNIA "
	sql = sql & " LEFT join SCF_UF U on U.CODIGO = a.ufnascimento "
	sql = sql & " where 1=1"
	if strAnoLetivo <> "" then
		sql = sql & " and t.anoletivo = " & strAnoLetivo
	end if
	if intCodEmpresaGrupo <> "0" then
		sql = sql & " and at.cod_empresa = " & intCodEmpresaGrupo
	end if
	sql = sql & " and at.situacao = 'A' "
	sql = sql & " and s.Desc_SituacaoAluno like '%ATIVO%' "
	sql = sql & " and "
	sql = sql & " ( "
	sql = sql & " 	(a.matricula is null or a.matricula = '') "

	if nomealuno<>"" then
		sql = sql & " or (a.nomealuno is null or a.nomealuno = '') "
	end if
	if datamatricula<>"" then
		sql = sql & " or (a.datamatricula is null or a.datamatricula = '') "
	end if
	if datanascimento<>"" then
		sql = sql & " or (a.DATANASCIMENTO is null or a.DATANASCIMENTO = '') "
	end if
	if sexo<>"" then
		sql = sql & " or (a.SEXOALUNO is null or a.SEXOALUNO = '') "
	end if
	if naturalidade<>"" then
		sql = sql & " or (a.CIDADENASCIMENTO is null or a.CIDADENASCIMENTO = '') "
	end if
	if nacionalidade<>"" then
		sql = sql & " or (a.nacionalidade is null or a.nacionalidade = '')"
	end if
	if ufnaturalidade<>"" then
		sql = sql & " or (a.ufnascimento is null or a.ufnascimento = '') "
	end if
	if etnia<>"" then
		sql = sql & " or (a.COD_ETNIA is null or a.COD_ETNIA = '') "
	end if
	if logradouro<>"" then
		sql = sql & " or (a.LOGRADOURO is null or a.LOGRADOURO = '')  "
	end if
	if nomemae<>"" then
		sql = sql & " or (a.MAE is null or a.MAE = '') "
	end if		
	sql = sql & " ) "
	
	sql = sql & " ORDER BY e.razaosocial , a.nomealuno "
	rs.open sql, cnn
	
	if rs.eof = false then
			%>
			<!--#include file="includes/inc_cabecalhoRelatorio.asp"-->
           
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
              <tr>
                <td class="celula">Unidade</td>
                <td class="celula">Situação</td>
                <td class="celula">Matrícula</td>
                <td class="celula">Aluno</td>
                <td class="celula">Dt.Nascimento</td>
                <td class="celula">Sexo</td>
                <td class="celula">Naturalidade</td>
                <td class="celula">UF</td>
                <td class="celula">Nacionalidade</td>
                <td class="celula">Etnia</td>
                <td class="celula">Endereço</td>
                <td class="celula">Nome da Mãe</td>
              </tr>            
            <%
			While not rs.eof 
				intTotalAluno = intTotalAluno + 1
				%>
                  <tr>
                    <td class="celula"><%=rs("razaosocial")%>&nbsp;</td>
                    <td class="celula"><%=rs("Desc_SituacaoAluno")%>&nbsp;</td>
                    <td class="celula"><%=rs("matricula")%>&nbsp;</td>
                    <td class="celula"><%=rs("nomealuno")%>&nbsp;</td>
                    <td class="celula"><%=rs("DATANASCIMENTO")%>&nbsp;</td>
                    <td class="celula"><%=rs("SEXOALUNO")%>&nbsp;</td>
                    <td class="celula"><%=rs("CIDADENASCIMENTO")%>&nbsp;</td>
                    <td class="celula"><%=rs("SIGLA")%>&nbsp;</td>
                    <td class="celula"><%=rs("nacionalidade")%>&nbsp;</td>
                    <td class="celula"><%=rs("ETNIA")%>&nbsp;</td>
                    <td class="celula"><%=rs("LOGRADOURO")%>&nbsp;</td>
                    <td class="celula"><%=rs("MAE")%>&nbsp;</td>
                  </tr>
                <%
				rs.movenext
			wend
			%>
            </table>
<%
		end if 
		rs.close
		%>
            <br>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="8%" align="justify" class="texto"><strong>Total de Alunos:</strong></td>
			    <td width="92%" align="justify" class="texto"><strong><%=intTotalAluno%></strong></td>
		      </tr>
			  <tr>
			    <td colspan="2" align="justify" class="texto">&nbsp;</td>
		      </tr>
			</table>
			
	        <script>
		aguarde.style.display="none";
	</script>
</body>
</html>