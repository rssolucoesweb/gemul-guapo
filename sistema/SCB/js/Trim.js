// JavaScript Document
/*
*Adiciona os métodos trim, lTrim e rTrim aos objetos do tipo String
*/
String.prototype.trim = function lTrim(){
	return this.replace(/^\s*/,'');
}
String.prototype.rTrim = function rTrim(str){
	return this.replace(/\s*$/,'');
}
String.prototype.lTrim = function trim(){
	return this.replace(/^\s*/,'').replace(/\s*$/,'');
}