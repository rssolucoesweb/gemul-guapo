<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
%>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_log.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="json/JSON_2.0.4.asp"-->
<!--#include file="json/JSON_UTIL_0.1.1.asp"-->
<%
acao = request("acao")
strCodGrupo = Session("CodGrupo") 
strCategoria = request("strCategoria")
strAnoLetivo = request("strAnoLetivo")
strTipoUnidadeEnsino = request("strTipoUnidadeEnsino")
strUnidadeEnsino = request("strUnidadeEnsino")

if acao = "porVinculo" then
	
	sql="select f.Desc_FormaNomeacao as vinculo, count(*) as qtde "
	sql=sql & " from SRH_COLABORADOR c"
	sql=sql & " inner join SRH_FORMANOMEACAOCOLABORADOR f on f.Cod_FormaNomeacao = c.codFormaNomeacao"
	sql=sql & " inner join seg_empresa e on e.codigo = c.codLotacao"
	sql=sql & " inner Join SRH_FUNCAOCOLABORADOR Fu on Fu.Cod_funcao = C.Codfuncao"
	sql=sql & " inner join SRH_CARGOCOLABORADOR CC on CC.Cod_Cargo = c.CodCargo "
	sql=sql & " inner join SRH_CARGOCATEGORIA ca on ca.Codigo = cc.CodCargoCategoria"
	sql=sql & " WHERE c.situacao = 'A'"
	sql=sql & " and e.cod_grupo = " & session("codGrupo")
	sql=sql & " and f.cod_grupo = " & session("codGrupo")
	sql=sql & " and e.bloqueio = 'N'"
	if strUnidadeEnsino <> "0" then
		sql=sql & " and c.codLotacao=" & strUnidadeEnsino
	end if
	if strTipoUnidadeEnsino <> "0" then
		sql=sql & " and e.codTipoEmpresa=" & strTipoUnidadeEnsino
	end if
	sql=sql & " and ca.Codigo = " & strCategoria
	sql=sql & " and c.codFormaNomeacao <> 261 "'--concursado
	sql=sql & " group by f.Desc_FormaNomeacao"
    QueryToJSON(cnn, sql).Flush

elseif acao = "qtdeServidor" then

    sql="exec SP_DAS_Quantitativo_Servidor_detalhe " & strCodGrupo & "," & strUnidadeEnsino& "," & strCategoria & "," & strTipoUnidadeEnsino
	QueryToJSON(cnn, sql).Flush

end if

%>