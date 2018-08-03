function formatSQL(fecha) {
  var temp = fecha.split("-");
  return temp[2] +'-'+ temp[1] +'-'+ temp[0];
}

function formatNumber(n) {
  return Number(n.toString().match(/^\d+(?:\.\d{0,2})?/))
}
