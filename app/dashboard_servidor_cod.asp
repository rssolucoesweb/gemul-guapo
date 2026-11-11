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
strAnoLetivo = request("strAnoLetivo")
strUnidadeEnsino = request("strUnidadeEnsino")
strTipoUnidadeEnsino = request("strTipoUnidadeEnsino")

if acao = "porCargo" then

    sql="select ca.Desc_Cargo as cargo, count(*) as qtde"
    sql=sql & " from SRH_COLABORADOR c"
    sql=sql & " inner join SRH_CARGOCOLABORADOR ca on ca.Cod_Cargo = c.codCargo"
	sql=sql & " inner join SEG_EMPRESA E on E.CODIGO = c.codLotacao"
    sql=sql & " where ca.situacao = 'A' and c.Situacao = 'A' and ca.CodCargoCategoria = 1"
    if strUnidadeEnsino <> "0" then
        sql=sql & " and c.codLotacao=" & strUnidadeEnsino
    end if
	if strTipoUnidadeEnsino <> "0" then
        sql=sql & " and E.codTipoEmpresa=" & strTipoUnidadeEnsino
    end if
    sql=sql & " group by ca.Desc_Cargo"
    QueryToJSON(cnn, sql).Flush

elseif acao = "diretorSecretario" then

    sql="select" 

    sql=sql & " ("
    sql=sql & "     select count(*) as qtde"
    sql=sql & "     from SRH_COLABORADOR c"
    sql=sql & "     inner join SRH_FUNCAOCOLABORADOR f on f.Cod_Funcao = c.codFuncao"
    sql=sql & " 	inner join SEG_EMPRESA E on E.CODIGO = c.codLotacao"
    sql=sql & "     where f.situacao = 'A'"
    sql=sql & "     and c.Situacao = 'A'"
    if strUnidadeEnsino <> "0" then
        sql=sql & "     and c.codLotacao=" & strUnidadeEnsino
    end if   
	if strTipoUnidadeEnsino <> "0" then
        sql=sql & " and E.codTipoEmpresa=" & strTipoUnidadeEnsino
    end if	
    sql=sql & "     and f.Cod_Funcao in (65)" 
    sql=sql & " ) as diretor,"

    sql=sql & " ("
    sql=sql & "     select count(*) as qtde"
    sql=sql & "     from SRH_COLABORADOR c"
    sql=sql & "     inner join SRH_FUNCAOCOLABORADOR f on f.Cod_Funcao = c.codFuncao"
    sql=sql & " 	inner join SEG_EMPRESA E on E.CODIGO = c.codLotacao"
    sql=sql & "     where f.situacao = 'A'"
    sql=sql & "     and c.Situacao = 'A'"
    if strUnidadeEnsino <> "0" then
        sql=sql & "     and c.codLotacao=" & strUnidadeEnsino
    end if   
	if strTipoUnidadeEnsino <> "0" then
        sql=sql & " and E.codTipoEmpresa=" & strTipoUnidadeEnsino
    end if
    sql=sql & "     and f.Cod_Funcao in (155)" 
    sql=sql & " ) as secretario"
    QueryToJSON(cnn, sql).Flush

elseif acao = "qtdeServidor" then

    sql="exec SP_DAS_Quantitativo_Servidor " & strCodGrupo & "," & strUnidadeEnsino & "," & strTipoUnidadeEnsino
	'response.write sql
    QueryToJSON(cnn, sql).Flush

end if

%>