
<div class="wrapper">
    <!--=== Header ===-->
    <div class="header">
    	<!-- Topbar -->
        <div class="topbar">
            <div class="container">
                <%if Session("mobile")<>"S" then%>

                <!-- Topbar Navigation -->
                <ul class="loginbar pull-right">
                    <!--  <li>
                    <i class="fa fa-globe"></i>
                    <a>Languages</a>
                    <ul class="languages">
                        <li class="active">
                            <a href="#">English <i class="fa fa-check"></i></a>
                        </li>
                        <li><a href="#">Spanish</a></li>
                        <li><a href="#">Russian</a></li>
                        <li><a href="#">German</a></li>
                    </ul>
                </li>
                <li class="topbar-devider"></li>
                <li><a href="Help.asp">Help</a></li>
                <li class="topbar-devider"></li>
                <li><a href="login.asp">Login</a></li>
            -->
            <li><a href="https://wa.me/556235872362" target="_blank"><strong><font color="#009933">Suporte por WhatsApp clique aqui</font><img src="../../assets/img/icone_zap.png"  width="24" height="24" /> 62 3587-2362</strong></a></li>
            <li class="topbar-devider"></li>
			<li><a href="Seg/UsuarioAlterar_senha_cad.asp">Alterar Senha</a></li>
            <li class="topbar-devider"></li>
            <li><a href="Help.asp?Cm=1">Help</a></li>
        </ul>
        <!-- End Topbar Navigation -->
            <%end if%>

    </div>
</div>
<!-- End Topbar -->

<!-- Navbar -->
<div class="navbar navbar-default mega-menu" role="navigation">
    <div class="container">
        <!-- Brand and toggle get grouped for better mobile display -->
        <div class="navbar-header">
            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-responsive-collapse">
                <span class="sr-only">Toggle navigation</span>
                <span class="fa fa-bars"></span>
            </button>
            <a class="navbar-brand" href="Default.asp">
                <%if Session("mobile")="S" then%>
                <img id="logo-header" src="../assets/img/logomobile.png" alt="Logo">
                <%else%>
                <img id="logo-header" src="../assets/img/logo.png" alt="Logo">
                <%end if%>
            </a>
        </div>
        <!-- Collect the nav links, forms, and other content for toggling -->
        <div class="collapse navbar-collapse navbar-responsive-collapse">
            <ul class="nav navbar-nav">
                <!-- Home -->
                <li class="dropdown active">
                    <li class="page-scroll">
						<%if Session("mobile") = "" then%>
                        <a href="../Default.asp">Sair do Portal</a>
                        <%else%>
                        <a href="../mobile">Sair</a>
                        <%end if%>
                    </li>
                </li>
                <!-- Search Block -->
                <!-- End Search Block -->
            </ul>
        </div><!--/navbar-collapse-->
    </div>
</div>
<!-- End Navbar -->
</div>
<!--=== End Header ===-->
