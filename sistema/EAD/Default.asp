<!--#include file="../ConfigModulo.asp"-->
	<%
	Session("strNomeSistema") 	= "EAD"
	Session("strSistema") 		= "EAD"
	Session("strModulo")		= "EAD" 
	Session("CodModulo") 		= "22" ' Codigo fixo da tabela SEG_MODULO
	%>
    <!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../menuModulos.asp"-->  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
     <%if Session("mobile")<>"S" then%>
        <div class="container">
            <h1 class="pull-left">Modulo Ensino a Distância</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="../Default.asp">Home</a></li>
                <li class="active">EAD - Sistema de Ensino a Distância</li>
            </ul>
        </div><!--/container-->
      <%end if%>
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->

     <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
          <h3 class="panel-title"><i class="fa fa-tasks"></i>EAD - Sistema de Ensino a Distância</h3>
            </div>
            <div class="panel-body">
              <p>&nbsp;</p>
              <p>&nbsp;</p>
              <p align="center">EAD - Sistema de Ensino a Distância</p>
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