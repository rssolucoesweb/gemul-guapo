// JavaScript Document

/********************************************************************************
 * DESCRIÇÃO: retorna um String contendo uma data no formato dd de mmmm de aaaa	*
 *******************************************************************************/
Date.prototype.longaDataBrasil = function(){
	var dia = this.getDate();
	var mes = this.getMonth() + 1;

	switch(mes){
		case 1:
			mes = "janeiro";
			break;
		case 2:
			mes = "fevereiro";
			break;
		case 3:
			mes = "março";
			break;
		case 4:
			mes = "abril";
			break;
		case 5:
			mes = "maio";
			break;
		case 6:
			mes = "junho";
			break;
		case 7:
			mes = "julho";
			break;
		case 8:
			mes = "agosto";
			break;
		case 9:
			mes = "setembro";
			break;
		case 10:
			mes = "outubro";
			break;
		case 11:
			mes = "novembro";
			break;
		case 12:
			mes = "dezembro";
			break;
	}
	var ano = this.getFullYear();
	
	return dia+" de "+mes+" de "+ano;
}