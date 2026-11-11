<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=10, IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" />
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <link href="css/bootstrap.css" rel="stylesheet" />
    <link href="css/bootstrap-theme.min.css" rel="stylesheet" />
    <link href="css/geral.css" rel="stylesheet" />
    <title>Matrícula 2018 - Aparecida</title>

    <script>
		function gerar(){
			if (frm.chkRel[0].checked==false && frm.chkRel[1].checked==false && frm.chkRel[2].checked==false && frm.chkRel[3].checked==false && frm.chkRel[4].checked==false && frm.chkRel[5].checked==false && frm.chkRel[6].checked==false && frm.chkRel[7].checked==false){
				alert("Opção do realtório deve ser informado!");
				return false
			}
			var destino;
			if (frm.chkRel[0].checked==true) destino = "rel_resumo.asp";
			if (frm.chkRel[1].checked==true) destino = "rel_quantitativo_por_data.asp";
			if (frm.chkRel[2].checked==true) destino = "rel_vagas_oferecidas.asp";
			if (frm.chkRel[3].checked==true) destino = "rel_inscritos_por_curso.asp";
			if (frm.chkRel[4].checked==true) destino = "rel_cadastro_reserva.asp";
			if (frm.chkRel[5].checked==true) destino = "rel_cadastro_reserva_EF.asp";
			if (frm.chkRel[6].checked==true) destino = "rel_agrupamento.asp";
			if (frm.chkRel[7].checked==true) destino = "rel_inscritos_primeiro_dia.asp";
			
			frm.action=destino;
			frm.submit();
		}
	</script>
        <!-- Global site tag (gtag.js) - Google Analytics -->
    <script async src="https://www.googletagmanager.com/gtag/js?id=UA-70820196-3"></script>
    <script>
      window.dataLayer = window.dataLayer || [];
      function gtag(){dataLayer.push(arguments);}
      gtag('js', new Date());
    
      gtag('config', 'UA-70820196-3');
    </script>    

</head>
<body>

    <%
	if Session("UsuarioWebMatriculaGrafico") 	= "" then 
		response.Redirect("index.html")
		response.end
	end if
	%>
    
    
    <div class="container-fluid topo" style="background-color:#333d47" align="center">
            <div class="row" >
	            <div class="col-md-6 imgTopo">
                    <img id="logoAparecida" src="../img/logomarca-topo-aparecida.png" alt="Aparecida de Goiânia" vspace="15" style="margin:auto" />
                </div>
                <div class="col-md-6 imgTopo">
                    <img id="logoGemul" src="../img/logomarca-topo-gemul.png" alt="Gemul - Gestor de Municípios" vspace="15" style="margin:auto" />
                </div>
	        </div>
    </div>
    

    <div class="container box-msg">
        <div class="row">
            <div class="col-md-11">
				 <h4 align="center"> Usuário logado: <strong><%=Session("UsuarioWebMatriculaGrafico")%></strong> </h4>
            </div>
            <div class="col-md-1">
				<input type="button" class="btn btn-lg btn-danger" name="btnInscricao" id="btnSalvar" value="Sair" onclick="location.href='index.html'" />
            </div>
        </div>

    </div>
    <form action="" name="frm" id="frm" method="post">
        <div class="container box-msg">
            <div class="row">
                <div class="col-md-12">
                    <div class="alert alert-info alert-dismissible fade in" role="alert">
                    <h3 align="center"> <strong>Relatórios Estatísticos</strong> </h3>
                            <input name="chkRel" type="radio" value="0">&nbsp;Resumo 
                        <br><input name="chkRel" type="radio" value="1">&nbsp;Quantitativo por Data 
                        <br><input name="chkRel" type="radio" value="2">&nbsp;Vagas Oferecidas 
                        <br><input name="chkRel" type="radio" value="3">&nbsp;Inscritos por Curso
                        <br><input name="chkRel" type="radio" value="4">&nbsp;Cadastro de Reservas - EI
                        <br><input name="chkRel" type="radio" value="5">&nbsp;Cadastro de Reservas - EF
                        <br><input name="chkRel" type="radio" value="6">&nbsp;Cadastro de Reservas por Agrupamento
                        <br><input name="chkRel" type="radio" value="7">&nbsp;Inscrições no 1º Dia 
                         <div class="row btn-ajuste">
                         <input type="button" class="btn btn-lg btn-success" name="btnRel" id="btnSalvar" value="Gerar" onclick="gerar()" />
                         </div>
                    </div>
    
                </div>
            </div>
        </div>
    </form>
    <!--div class="container alterar-btn marginb20px">
        <h4> Em caso de dúvidas, ligue para o telefone <strong> xxx xxxx xx   </strong>  </h4>
    </div -->

    <script src="js/jquery-2.1.3.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <script src="js/index.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            index.inicialize();
        });
    </script>
</body>
</html>