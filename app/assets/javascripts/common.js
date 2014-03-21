function isDefined(variable) {
	return (typeof(variable) != 'undefined');
}
function isDefinedAndNonNull(variable) {
	return ((typeof(variable) != 'undefined') && (variable != null));
}
function resolveElement(element) {
	if (typeof(element) == 'object')
		return element;
	else if (typeof(element) == 'string')
		return document.getElementById(element);
	else
		throw "element must be a string or object type";
}
function roundNumber(number, places) {
	return Math.round(number * Math.pow(10,places)) / Math.pow(10, places);
}
function setPageInitFunction(init) {
	$(document).ready(init);
	$(document).on('page:load', init);
}
