<!--#include file="../ConfigModulo.asp"-->
<body>
	<%
	Session("strNomeSistema") 	= "HELP"
	Session("strSistema") 		= "HELP"
	Session("strModulo")		= "HELP" 
	Session("CodModulo") 		= "17" ' Codigo fixo da tabela SEG_MODULO
	%>
    <!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../menuModulos.asp"-->  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Help</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="../Default.asp">Home</a></li>
                <li class="active">Help - Controle de Help</li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->

     <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
          <h3 class="panel-title"><i class="fa fa-tasks"></i>Help - Controle de Help</h3>
            </div>
            <div class="panel-body">
              <p>&nbsp;</p>
              <p>&nbsp;</p>
              <p align="center">Help - Controle de Help</p>
              <p>&nbsp;</p>
              <p>&nbsp;</p>
              <p>&nbsp;</p>
          </div>
      </div>
        <!-- End Grey Panel -->     
    </div>
    <!--/container-->		
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 