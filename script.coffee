DURATION = 240
WAIT = DURATION + 10

eggCrackSound = new Audio("crack.wav")
crackEgg = (e) ->
	egg = $ this
	if egg.find('crack').length < 6
		$ this
			.append '<crack />'
			.effect("shake", {
				duration: DURATION
				distance: 10
				times: 2
				})
		eggCrackSound.currentTime = 0
		eggCrackSound.play()
	else
		egg.hide()
		$('<img class="nugget" src="golden-nugget.png"/>').appendTo('ground')
		ga('send', 'event', 'Egg', 'nugget')

$('egg').click _.throttle crackEgg, WAIT, {trailing: false}

i = 0
changeTime = (e) ->
	times = ['day', 'twilight', 'night', 'twilight']
	positions = ['0%', '50%', '100%', '50%']
	easing = ['easeInSine', 'easeOutSine']

	$('sky, ground, egg, .egg').switchClass times[i % 4], times[(i + 1) % 4], DURATION
	i++
	
	options = {
		specialEasing: {
			top: easing[(i + 1) % 2]
			left: easing[i % 2]
		}
		duration: DURATION
	}
	
	$('sun').animate({
			top: positions[i % 4]
			left: positions[(i + 1) % 4]
		}, options)
	$('moon').animate({
			top: positions[(i + 2) % 4]
			left: positions[(i + 3) % 4]
		}, options)


$('sky').click _.throttle changeTime, WAIT
