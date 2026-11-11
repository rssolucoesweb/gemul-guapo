<!--=== Footer Version 1 ===-->
<div class="footer-v1">
    <div class="footer">
        <div class="container">
            <div class="row">
                
                <!-- Address -->
                <div class="col-md-3 map-img md-margin-bottom-40">
                    <a href="index.html"><img id="logo-footer" class="footer-logo" src="../../assets/img/asced.png" alt=""></a>
                </div>
                <!-- End Address -->
                
                <!-- About -->
                <div class="col-md-5 md-margin-bottom-40">
                    <div class="headline"><h2>Acesso</h2></div> 
                    <p>
                        Usuário Logado: <%=session("UsuarioWeb")%> <br />
                        Ano Letivo: <%=Session("strAnoLetivo")%><br />
                        Unidade:&nbsp;<%=session("CodEmpresa")%>&nbsp-&nbsp<%=session("EmpresaWeb")%><br />
                        Telefone:&nbsp;<%=Session("strFone")%><br />
                        Diretor(a):&nbsp;<%=session("NomeDiretorEmpresaWeb")%><br />
                        Secretário(a) Geral:&nbsp;<%=session("NomeSecretariaEmpresaWeb")%><br />
                        Endereço:&nbsp;<%=session("EnderecoEmpresaWeb")%><br />
                        Cep:&nbsp;<%=session("CepEmpresaWeb")%><br />
                        Bairro:&nbsp;<%=session("BairroEmpresaWeb")%><br />
                        Cidade:&nbsp;<%=session("CidadeEmpresaWeb")%>-<%=session("UFEmpresaWeb")%>                     
                    </p>
                    
                </div>
                <!-- End About -->
                
                <!-- Address -->
                <div class="col-md-4 map-img md-margin-bottom-40">
                    <div class="headline"><h2>Contato</h2></div>                         
                    <address class="md-margin-bottom-40">
                        Segunda a Sexta Feira das 08:00 as 17:00hs<br />
                        Telefone: (62) 3587-2362  <br />
                        Email: <a href="mailto:suporte@gemul.com.br" class="">suporte@gemul.com.br</a><br />
                        Skype: suporte.gemul
						<li><a href="https://wa.me/556235872362" target="_blank"><strong><font color="#009933">Suporte Online</font><img src="../../assets/img/icone_zap.png"  width="24" height="24" /> 62 3587-2362</strong></a></li>
                   </address>
                </div><!--/col-md-3-->

        	</div>
    	</div> 
	</div>

    <!--/footer-->
        
     <div class="copyright">
        <div class="container">
            <div class="row">
             <%if Session("mobile")<>"S" then%>
                <div class="col-md-6">                     
                    <p>
                       Todos os direitos reservados. |
                       <a href="#">Produto do Grupo ASCED - Cursos e Assessoria Educacional </a>
                    </p>
                </div>
              <%end if%>
            </div>
        </div> 
	</div><!--/
<!--=== End Footer Version 1 ===-->
</div><!--/wrapper-->
