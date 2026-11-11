<%
codAluno = Request.QueryString("cod_aluno")

' Exemplo: caminho da imagem (ajuste conforme seu sistema)

%>

<!DOCTYPE html>
<html>
<head>
<title>Foto do Aluno</title>

<script>
function ajustarJanela(img) {
    var largura = img.width + 50;  // margem
    var altura = img.height + 100; // margem (barra título)

    window.resizeTo(largura, altura);
}
</script>

<style>
body {
    margin: 10px;
    background: #000; /* opcional: fundo preto fica bonito */
    display: flex;
    align-items: center;
    justify-content: center;
}
img {
    display: block;
}
</style>

</head>
<!--#include file="includes/inc_cnn.asp"-->
<body>
<%
	strFotoAluno = "img/aluno-sem-foto.jpg"
	compl="width:120px; height:95px;"
	IF codAluno <>"" THEN
		SQL="SELECT BASE64 FROM SCA_ALUNO_FOTO WHERE COD_ALUNO=" & codAluno & " and base64<>'img/aluno-sem-foto.jpg'"
		RS.OPEN SQL, cnn
		IF RS.EOF = FALSE THEN
			strFotoAluno = RS("BASE64")
			compl="width:120px; height:170px;"
		END IF
		RS.CLOSE
	END IF
%>
	<img id="fotoAluno" src="<%=strFotoAluno %>" style="border:1px solid #999999; <%=compl%>"  onload="ajustarJanela(this)" />
</body>
</html>