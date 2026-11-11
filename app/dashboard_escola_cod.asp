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

    if acao = "escolas" then

        sql="select count(*) as escolas, upper(te.Descricao) as tipo_escola, te.CODIGO as cod_tipo_escola"
        sql=sql & " from SEG_EMPRESA e"
        sql=sql & " inner join SEG_TipoEmpresa te on te.CODIGO = e.CodTipoEmpresa and te.COD_GRUPO = e.COD_GRUPO"
        sql=sql & " where e.BLOQUEIO = 'N'"
        sql=sql & " and e.COD_GRUPO =" & session("CODGRUPO")
        sql=sql & " and te.codigo<>5"
        sql=sql & " group by te.Descricao, te.CODIGO"
        QueryToJSON(cnn, sql).Flush

    end if

%>