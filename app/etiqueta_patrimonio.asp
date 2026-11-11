<%
' ============================================================
' ETIQUETA DE PATRIMÔNIO (impressão)
' Recebe ?num=2026000123 e monta a etiqueta com QR Code
' O QR aponta para a página de consulta do bem
' ============================================================
%>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<%
Dim numPatrimonio, rsBem, sql
numPatrimonio = Request.QueryString("num")

sql = "SELECT numero_patrimonio, descricao, marca, modelo " & _
      "FROM PAT_PATRIMONIO WHERE numero_patrimonio = '" & Replace(numPatrimonio, "'", "''") & "'"

Set rsBem = Server.CreateObject("ADODB.Recordset")
rsBem.Open sql, cnn

If rsBem.EOF Then
    Response.Write "Bem não encontrado."
    Response.End
End If

Dim urlConsulta
urlConsulta = "https://" & Request.ServerVariables("SERVER_NAME") & _
              "/app/pat_patrimonio.asp?txtNumeroPatrimonio=" & numPatrimonio
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Etiqueta de Patrimônio</title>
    <script src="/app/js/qrcode.min.js"></script>
    <!-- biblioteca qrcode.js: https://github.com/davidshimjs/qrcodejs -->
    <style>
        .etiqueta {
            width: 6cm; height: 3cm;
            border: 1px solid #000;
            padding: 4px;
            display: flex;
            align-items: center;
            font-family: Arial, sans-serif;
            font-size: 10px;
        }
        .etiqueta .info { flex: 1; padding-left: 6px; }
        .etiqueta .numero { font-weight: bold; font-size: 12px; }
        @media print {
            body { margin: 0; }
        }
    </style>
</head>
<body>

<div class="etiqueta">
    <div id="qrcode"></div>
    <div class="info">
        <div class="numero"><%= rsBem("numero_patrimonio") %></div>
        <div><%= rsBem("descricao") %></div>
        <div><%= rsBem("marca") %> <%= rsBem("modelo") %></div>
    </div>
</div>

<script>
    new QRCode(document.getElementById("qrcode"), {
        text: "<%= urlConsulta %>",
        width: 70,
        height: 70
    });
    // Dispara a impressão automaticamente (opcional)
    // window.onload = function() { window.print(); };
</script>

</body>
</html>
<%
rsBem.Close
Set rsBem = Nothing
%>
