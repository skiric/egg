import React from 'react'

// moon ~= -1 so first day is a full moon
function init({ time = 0, season = 0, moon = -1 }) {
  return {
    time,
    season,
    egg: 0,
    moon
  }
}

function reducer(state, action) {
  switch (action) {
    case 'reset':
      return init(state)
    case 'time':
      return { ...state, time: (state.time + 1) % 4, moon: state.time === 0 ? (state.moon + 1) % 8 : state.moon }
    case 'season':
      return { ...state, season: (state.season + 1) % 4 }
    case 'egg':
      return state.egg < 7
        ? {
            ...state,
            egg: state.egg + 1,
            reward: state.egg === 6 ? REWARDS[SEASONS[state.season]][TIMES[state.time]] : undefined
          }
        : state
    default:
      break
  }
}

const PHASES = [
  'full',
  'waningGibbous',
  'thirdQuarter',
  'waningCrescent',
  'new',
  'waxingCrescent',
  'firstQuarter',
  'waxingGibbous'
]
const SEASONS = ['spring', 'summer', 'autumn', 'winter']
const TIMES = ['day', 'dusk', 'night', 'dawn']
const REWARDS = {
  spring: { day: 'chick', dawn: 'bunny', dusk: 'bunny', night: 'cricket' },
  summer: { day: 'beachball', dawn: 'sunglasses', dusk: 'sunglasses', night: 'firefly' },
  autumn: {
    day: 'pumpkin',
    dawn: 'scarecrow',
    dusk: 'scarecrow',
    night: 'ghost'
  },
  winter: {
    day: 'snowman',
    dawn: 'sled',
    dusk: 'sled',
    night: 'ice'
  }
}
/** @type {React.FunctionComponent} */
export function App() {
  const [state, dispatch] = React.useReducer(reducer, {}, init)
  React.useEffect(() => {
    if (state.egg === 0) {
      return
    }
    if (state.egg < 7) {
      new Audio(new URL('../audio/crack.wav', import.meta.url)).play()
    } else {
      switch (state.reward) {
        case 'chick':
          return
      }
    }
  }, [state.egg])
  const time = React.useCallback(
    _.throttle(() => dispatch('time'), 750, { trailing: false }),
    []
  )
  const season = React.useCallback(() => dispatch('season'), [])
  const egg = React.useCallback(() => dispatch('egg'), [])
  const reset = React.useCallback(() => dispatch('reset'), [])
  return (
    <>
      <div id="sky" className={TIMES[state.time]} onClick={time}>
        <div id="sun">
          <svg viewBox="-20 -20 40 40">
            <circle r="10" fill="orange" />
          </svg>
        </div>
        <div id="moon">
          <svg viewBox="-10 -10 20 20">
            <defs>
              <path id="crescentMoon" d="M 0 10 A 10,10 0 0,1 0,-10 A 10,12.5 0 0,0 0,10 z" />
              <path id="quarterMoon" d="M 0 10 A 10,10 0 0,1 0,-10 z" />
              <path id="gibbousMoon" d="M 0 10 A 10,10 0 0,1 0,-10 A 10,11.5 0 0,1 0,10 z" />
              <circle id="fullMoon" r="10" />
              <use id="waxingCrescentMoon" href="#crescentMoon" transform="scale(-1)" />
              <use id="firstQuarterMoon" href="#quarterMoon" transform="scale(-1)" />
              <use id="waxingGibbousMoon" href="#gibbousMoon" transform="scale(-1)" />
              <use id="waningCrescentMoon" href="#crescentMoon" />
              <use id="thirdQuarterMoon" href="#quarterMoon" />
              <use id="waningGibbousMoon" href="#gibbousMoon" />
            </defs>
            <use href={`#${PHASES[state.moon]}Moon`} />
          </svg>
        </div>
      </div>
      <div id="ground" className={SEASONS[state.season]} onClick={season}></div>
      <div id="egg" className={`${TIMES[state.time]} ${state.reward ? 'open' : 'closed'}`} onClick={egg}>
        {_.range(state.egg).map((i) => (
          <div key={`${i}`} className="crack" />
        ))}
      </div>
      {state.reward && (
        <div id="reward" onClick={reset}>
          <Reward reward={state.reward} />
        </div>
      )}
    </>
  )
}

const Reward = React.memo(function Reward({ reward }) {
  switch (reward) {
    case 'beachball':
      new Audio(new URL(`../audio/beachball.wav`, import.meta.url)).play()
      return (
        <svg viewBox="-10 -10 20 20">
          <circle r="10" fill="white" />
          <path id="part" d="M 0 10 A 10,10 0 0,1 0,-10 A 10,11.5 0 0,0 0,10 z" />
          <use href="#part" fill="red" />
          <use href="#part" transform="scale(-1)" fill="blue" />
        </svg>
      )
    case 'chick':
      new Audio(new URL(`../audio/chick.wav`, import.meta.url)).play()

      return (
        <svg viewBox="0 0 100 100">
          <defs>
            <g id="leg">
              <line x1="40" y1="80" x2="32.5" y2="95" stroke="black" />
              <polyline points="36.5,95 35,90 30,92.5" fill="none" stroke="black" />
            </g>
            <polyline id="wing" points="18,-8 5,-7 10,-3 2,0 10,3 5,7 18,8" fill="yellow" stroke="orange" />
            <circle id="eye" r="1" fill="black" />
          </defs>

          <ellipse id="body" cx="50" cy="50" rx="30" ry="35" fill="yellow" stroke="orange" />

          <use href="#wing" y="50" x="5" />
          <use href="#wing" y="50" x="5" transform="translate(100,0) scale(-1,1)" />

          <g transform="translate(-3,3)">
            <use href="#eye" x="50" y="30" />
            <use href="#eye" x="66" y="26" />
            <polyline
              id="beak"
              points="20,20 30,26 24,18 32,14 22,14"
              transform="translate(35,25) rotate(-10)"
              fill="none"
              stroke="orange"
            />
          </g>
          <use href="#leg" />
          <use href="#leg" transform="translate(100,0) scale(-1,1)" />
        </svg>
      )
    case 'pumpkin':
      return (
        <svg viewBox="-10 -10 20 20">
          <def>
            <circle id="pumpkin" r="6.5" cx="3" />
          </def>
          <g transform="translate(0,.5)">
            <path d="M 0 -6 a 2,2,0,0,1,2,-2" fill="none" stroke="brown" />
            <use href="#pumpkin" fill="orange" />
            <use href="#pumpkin" transform="scale(-1)" fill="orange" />
            <use href="#pumpkin" fill="none" stroke="brown" />
            <use href="#pumpkin" transform="scale(-1)" fill="none" stroke="brown" />
          </g>
        </svg>
      )
    case 'snowman':
      return (
        <svg viewBox="-10 -10 20 20">
          <g transform="translate(0,.5)">
            <line x1="-10" y1="-2" y2="2" stroke="black" />
            <line x1="10" y1="-2" y2="2" stroke="black" />
            <circle r="6" cy="3" fill="white" stroke="gray" />
            <circle r="4" cy="-6" fill="white" stroke="gray" />
            <circle r=".5" cx="-2" cy="-7" />
            <circle r=".5" cx="2" cy="-7" />
            <circle r=".5" cy="-5" fill="orange" />
            <circle r=".5" cy="0" />
            <circle r=".5" cy="3" />
          </g>
        </svg>
      )
    default:
      new Audio(new URL(`../audio/pig.wav`, import.meta.url)).play()

      return <img src={new URL(`../golden-nugget.png`, import.meta.url)} />
  }
})
