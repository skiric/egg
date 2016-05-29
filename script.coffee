DURATION = 240

eggCrackSound = new Audio("audio/crack.wav")
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
		reward = getReward()
		$ "<img class='nugget' src='svg/#{reward}.svg'/>"
			.appendTo 'ground'
			.addClass TIMES[time % 4]
			.addClass SEASONS[season % 4]
		new Audio("audio/#{reward}.wav").play()
		ga('send', 'event', 'Reward', '#{reward}')

$('egg').click _.throttle crackEgg, DURATION, {trailing: false}

TIMES = ['day', 'twilight', 'night', 'twilight']
POSITIONS = ['0%', '50%', '100%', '50%']
EASINGS = ['easeInSine', 'easeOutSine']
time = 0
phase = 0
changeTime = (e) ->

	$('sky, ground, egg, .egg').switchClass TIMES[time % 4], TIMES[(time + 1) % 4], DURATION
	time++
	
	options = {
		specialEasing: {
			top: EASINGS[(time + 1) % 2]
			left: EASINGS[time % 2]
		}
		duration: DURATION
	}
	
	$('sun').animate({
			top: POSITIONS[time % 4]
			left: POSITIONS[(time + 1) % 4]
		}, options)
	options.complete = checkPhase
	$('moon').animate({
			top: POSITIONS[(time + 2) % 4]
			left: POSITIONS[(time + 3) % 4]
		}, options)

# phases go from 6 decreasing to 0, then increasing to 6
checkPhase = () ->
	if(time % 4 == 0)
		phase++
		nextPhase = Math.abs((phase%13) - 6)
		$('#moon').attr 'href', "svg/moon.svg#phase#{nextPhase}"

$('sky').click _.throttle changeTime, DURATION, {trailing: false}

SEASONS = ['spring', 'summer', 'autumn', 'winter']
season = 0
changeSeason = (e) ->
	ground = $ this
	if (e.target == this)
		groundTransition = $ '<ground />';
		groundTransition
			.hide()
			.addClass SEASONS[(season + 1) % 4]
			.addClass TIMES[time % 4]
		ground.prepend(groundTransition)
		ground.switchClass SEASONS[season % 4], SEASONS[(season + 1) % 4], DURATION
		groundTransition.toggle 'slide', 2 * DURATION, () ->
			groundTransition.remove()
			season++

$('ground').click _.throttle changeSeason, 2 * DURATION, {trailing: false}

REWARDS = {
	spring: {
		day: 'chick'
		twilight: 'bunny'
		night: 'cricket'
	}
	summer: {
		day: 'beachball'
		twilight: 'sunglasses'
		night: 'firefly'
	}
	autumn: {
		day: 'pumpkin'
		twilight: 'scarecrow'
		night: 'ghost'
	}
	winter: {
		day: 'snowman'
		twilight: 'sled'
		night: 'ice'
	}
}

getReward = () -> 'chick'
