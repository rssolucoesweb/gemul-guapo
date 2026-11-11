<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=10, IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" />
    <link href="../css/bootstrap.css" rel="stylesheet" />
    <link href="../css/bootstrap-theme.min.css" rel="stylesheet" />
    <link href="../css/geral.css" rel="stylesheet" />
    <link href="../css/form-controle.css" rel="stylesheet" />
    <title>Cadastro de reserva de Senador Canedo</title>

    <!-- Global site tag (gtag.js) - Google Analytics -->
	<script async src="https://www.googletagmanager.com/gtag/js?id=UA-70820196-4"></script>
    <script>
      window.dataLayer = window.dataLayer || [];
      function gtag(){dataLayer.push(arguments);}
      gtag('js', new Date());
    
      gtag('config', 'UA-70820196-4');
    </script>
    
</head>
<body>
	<form id="frm" name="frm" method="post">

    <input type="hidden" id="descricao_curso" nome="descricao_curso" value="EDUCACAO_INFANTIL" />
    <!--input type="hidden" id="descricao_curso" nome="descricao_curso" value="ENSINO_FUNDAMENTAL" /-->
    <input type="hidden" id="txtHiddenIdade" value="" />
	<input type="hidden" id="txtMensagemValidaIdade" value="" />
    <input type="hidden" id="txtMensagemValidaIdadeParaMatricula" value="" />
    <input type="hidden" id="txtMensagemJaExiste" value="" />


    <div class="container-fluid topo">
            <div class="row" >
	            <div class="col-md-6 imgTopo">
                    <img id="logocanedo" src="../img/logomarca-topo-canedo.png" alt="Senador Canedo" vspace="15" style="margin:auto" />
                </div>
                <div class="col-md-6 imgTopo">
                    <img id="logoGemul" src="../img/logomarca-topo-gemul.png" alt="Gemul - Gestor de Municípios" vspace="15" style="margin:auto" />
                </div>
	        </div>
            <div class="row" style="background-color:#0984c6; height:4px" ></div>
    </div>

    <ol class="breadcrumb">
        <div class="container">
           <div class="row">
                <div class="col-lg-10">
                    <li><a href="../Index.html" class="active">&laquo;&nbsp;Escolher outro Curso</a></li>
                </div>
                <div class="col-lg-2 col-md-2 obrigatorio">
                    * campo obrigatório
                </div>
            </div>
        </div>
    </ol>
    
    <div class="container">
         <div class="box-categorias">
            <!-- Data de nascimento, Telefone contato, Celular pai, Celular mãe, Celular responsável -->
            <div class="row">
                <div class="row marginb5px">
                    <div class="passo-titulo"> 
                    <!-- trocar quando por outro curso-->
                        <h2><strong><font color="#990000">ATUALIZAÇÃO DO CADASTRO DE RESERVA PARA EDUCAÇÃO INFANTIL </font></strong></h2>
                        <h4><font color="#990000">Berçário e Agrupamentos de I a IV</font></h4>
                    <!-- -->
                    <!-- trocar quando por outro curso
                        <h2>&nbsp;&nbsp;<strong><font color="#990000">ENSINO FUNDAMENTAL</font></strong></h2>
                        <h4>&nbsp;&nbsp;<font color="#990000">1º ao 9º ano</font></h4>
                     -->
                    
                    </div>
                </div>    
            </div>
        </div>
        <div class="box-categorias dados-pessoais">
             <!-- Protocolo -->
            <div class="row">
                <div class="row marginb10px">
                    <div class="passo-titulo"> <h3> ACESSAR COM PROTOCOLO </h3></div>
                </div>
                <div class="col-md-12">
                    <div class="form-group">
                        <label for="Numero"><span class="obrigatorio">*</span>Número</label>
                        <input id="Numero" type="text" name="Numero" class="form-control" aria-describedby="helpAluno" maxlength="20" />
                        <span data-campo="Aluno" class="help-block"></span>
                    </div>
                </div>
            </div>
			<DIV align="center">
            <strong>OU</strong><BR><BR>
			</DIV>
           
            <!-- Aluno -->
            <div class="row">
                <div class="row marginb10px">
                    <div class="passo-titulo"> <h3> ACESSAR COM DADOS PESSOAIS </h3></div>
                </div>
                <div class="col-md-12">
                    <div class="form-group">
                        <label for="Aluno"><span class="obrigatorio">*</span>Nome do aluno</label>
                        <input id="Aluno" type="text" name="Aluno" class="form-control" aria-describedby="helpAluno" maxlength="100" />
                        <span data-campo="Aluno" class="help-block"></span>
                    </div>
                </div>
            </div>

            <!-- Mãe -->
            <div class="row">
                <div class="col-md-8">
                    <div class="form-group">
                        <label for="Mae"><span class="obrigatorio">*</span>Nome da mãe</label>
                        <input id="Mae" type="text" name="Mae" class="form-control" maxlength="100" />
                        <span data-campo="Mae" class="help-block"></span>
                    </div>
                </div>

				<div class="col-md-4">
                    <div class="form-group">
                        <label for="DataNascimento"><span class="obrigatorio">*</span>Data de nascimento</label>
                        <input id="DataNascimento" type="text" name="DataNascimento" class="form-control DataNascimento" />
                        <span id="helpDataNascimento" data-campo="DataNascimento" class="help-block"></span>
                    </div>
                </div>            
           </div>

        </div>

        <div class="row btn-ajuste marginb20px">
            <input type="button" name="btnSalvar" id="btnSalvar" value="Acessar Reverva" style="width:300px" class="btn btn-large btn-success" />
        </div>
    </div>

	</form>
    <script src="js/jquery-2.1.3.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <script src="js/jquery.mask.min.js"></script>
    <script src="js/consultaReserva.js"></script>
    <script src="js/jquery.blockUI.js"></script>
    <script src="js/bootbox.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            inscricao.inicialize();
        });
    </script>

</body>
</html>