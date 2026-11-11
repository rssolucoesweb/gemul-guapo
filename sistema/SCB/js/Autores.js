// JavaScript Document
function Pesquisar(){
	
	var strAutores = document.getElementById('txtAutores').value
	var url = 'Autores_act.asp?'
	url = url + 'Autores=' + strAutores;
	//alert(url);
	ExecAjax('divRetorno',url,'','Buscando...');
	
}