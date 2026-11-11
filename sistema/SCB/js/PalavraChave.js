// JavaScript Document
function Pesquisar(){
	
	var strPalavra = document.getElementById('txtPalavra').value
	var url = 'PalavraChave_act.asp?'
	url = url + 'Palavra=' + strPalavra;
	
	//alert(url);
	ExecAjax('divRetorno',url,'','Buscando...');
	
}