eggCrack = new Audio("crack.wav")
$('egg').click (e) ->
	egg = $(this)
	if egg.find('crack').length < 6
		$(this).append('<crack />').finish().effect("shake", {duration: 240, distance: 10, times: 2})
		eggCrack.currentTime = 0
		eggCrack.play()
	else
		egg.fadeOut()
		$('<img class="nugget" src="golden-nugget.png"/>').appendTo('ground')
		ga('send', 'event', 'Egg', 'nugget')
