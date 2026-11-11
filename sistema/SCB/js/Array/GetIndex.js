// JavaScript Document

Array.prototype.getIndex = function(value){	
	var index;
	for (var i = 0; i < this.length; i++){
		if(this[i] == value){
			return i;
		}
	}
}