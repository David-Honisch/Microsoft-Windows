<HTML>
<TITLE>Die Uhr</TITLE>
<HEAD>
<SCRIPT LANGUAGE="JavaScript">
<!--
function showFilled(Value) {
  return (Value > 9) ? "" + Value : "0" + Value;
}
function StartClock24() {
  TheTime = new Date;
  document.clock.showTime.value = showFilled(TheTime.getHours()) + ":" + showFilled(TheTime.getMinutes()) + ":" + showFilled(TheTime.getSeconds());
  setTimeout("StartClock24()",1000)
}
//-->
</script>
</head>
<BODY onLoad="StartClock24()">
<center>
  <form name=clock>
    <span class="small">Es ist jetzt gerade:</span><br>
    <input type=text name=showTime size=8 class=input>
  </form>
</center>
</body>
</html>
