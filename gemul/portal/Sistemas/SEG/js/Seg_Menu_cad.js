/*
	::	IMOB
	::	Data de Criação...: 24/11/2004
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto.barbosa@see.go.gov.br
	::	Objetivo Pagina...: Inclusão de Usuário em Grupo 
	::	Data Atualizacao..: 
	::	Motivo Atualizacao: 
*/	

	var intContMarcado=0;		

	function salvar(acao){
		var frm = document.getElementById("frm");
		
		if (frm.txtDescricao.value == ""){
			alert("O descrição deve ser informada!");
			frm.txtDescricao.focus();
			return false;
		}
		if (frm.txtOrdem.value == ""){
			alert("A ordem deve ser informada!");
			frm.txtOrdem.focus();
			return false;
		}		
		
		frm.action= "Seg_menu_cod.asp?acao=" + acao;
		frm.submit();
		return true;	 
	}
	
	function selMenu(codMenu, codModulo){
		frm.action="Seg_menu_cad.asp?acao=A&codMenu="+codMenu+"&codModulo="+codModulo;
		frm.submit();
	}	
	