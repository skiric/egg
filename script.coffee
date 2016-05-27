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

i = 0
changeTime = (e) ->
	times = ['day', 'twilight', 'night', 'twilight']
	positions = ['0%', '50%', '100%', '50%']
	easing = ['easeInSine', 'easeOutSine']

	$('sky, ground, egg').switchClass(times[i % 4], times[(i + 1) % 4])
	i++
	
	options = {
		specialEasing: {
			top: easing[(i + 1) % 2]
			left: easing[i % 2]
		}
	}
	
	$('sun').animate({
			top: positions[i % 4]
			left: positions[(i + 1) % 4]
		}, options)
	$('moon').animate({
			top: positions[(i + 2) % 4]
			left: positions[(i + 3) % 4]
		}, options)


$('sun, moon').click changeTime
