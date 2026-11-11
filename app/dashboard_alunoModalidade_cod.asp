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

if acao="alunosPorSerie" then

    ' Montar os dados das séries
    Dim data
    data = "{" & _
        """labels"":[""1ª Série"",""2ª Série"",""3ª Série""]," & _
        """datasets"":[{" & _
            """label"":""Matriculados""," & _
            """data"":[50,60,55]," & _
            """backgroundColor"":""#90EE90""," & _
            """borderColor"":""#90EE90""," & _
            """borderWidth"":1" & _
        "},{" & _
            """label"":""Transferidos""," & _
            """data"":[5,8,7]," & _
            """backgroundColor"":""#FFC107""," & _
            """borderColor"":""#FFC107""," & _
            """borderWidth"":1" & _
        "},{" & _
            """label"":""Desistentes""," & _
            """data"":[3,4,6]," & _
            """backgroundColor"":""#F44336""," & _
            """borderColor"":""#F44336""," & _
            """borderWidth"":1" & _
        "}]" & _
    "}"

    ' Retornar o JSON
    Response.Write data    



end if

%>