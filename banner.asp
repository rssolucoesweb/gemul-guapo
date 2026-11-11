<!--=== Slider ===-->
<%

		session("BG") = "assets/img/bg-green.png"
		banner = "banner1.jpg"
%>
        
<style>
	.da-slider{
	width: 100%;
	height: 100%;
	position: relative;
	margin: 0 auto;
	overflow: hidden;
	background: transparent url(<%=session("BG")%>) repeat 0% 0%;
	box-shadow: 0px 1px 1px rgba(0,0,0,0.2), 0px -2px 1px #fff;
	-webkit-transition: background-position 1.4s ease-in-out 0.3s;
	-moz-transition: background-position 1.4s ease-in-out 0.3s;
	-o-transition: background-position 1.4s ease-in-out 0.3s;
	-ms-transition: background-position 1.4s ease-in-out 0.3s;
	transition: background-position 1.4s ease-in-out 0.3s;
}
</style>
<div class="slider-inner">
    <div id="da-slider" class="da-slider">
    	
        
        <!--div class="da-slide"-->
            <!--h2><i>GEMUL </i> <br /> <i>Gestor de Munic&iacute;pio</i></i></h2>
            <p><i>Totalmente na nuvem,</i> <br /> <i> dispon&iacute;vel 24 horas por dia,</i> <br /> <i>7 dias por semana.</i></p-->
            <div class="da-img" align="center"><img class="img-responsive" src="banners/banner1.jpg" alt=""></div>
        <!--/div-->
        <!--div class="da-slide">
            <h2><i>Bem Vindo ao Gemul</i></i></h2>
            <p><i>Professores e alunos podem interagir</i><br /><i>de seus tablets e celulares</i></p-->
            <!--div class="da-img"><img src="banners/banner2.jpg" alt="image01" /></div-->
        <!--/div-->
        
        <div class="da-arrows">
            <span class="da-arrows-prev"></span>
            <span class="da-arrows-next"></span>
        </div>
    <nav class="da-dots"></nav></div>
</div>
<!--/slider-->
<!--=== End Slider ===-->

