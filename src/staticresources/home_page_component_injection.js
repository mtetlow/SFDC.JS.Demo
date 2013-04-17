<br>
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
<script type="text/javascript"> 
	$j=jQuery.noConflict();
	$j(document).ready(function(){ 
		function listener(event){
		  if(event.origin !== "https://c.na15.visual.force.com"){ return; }
		  $j('#opp7_ileinner').html(event.data);
		}

		if (window.addEventListener){
		  addEventListener("message", listener, false)
		} else {
		  attachEvent("onmessage", listener)
		}
	});
</script>