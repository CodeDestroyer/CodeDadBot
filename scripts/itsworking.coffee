# Description:
#   Praise the lord, it's working
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   it's working or its working - link to youtube videos
#
# Author:
#   Dan Stark

itsworking = [
    'https://www.youtube.com/watch?v=CxKm_ZJfofA#t=155',
    'https://www.youtube.com/watch?v=1T4waYQskek',
    'https://www.youtube.com/watch?v=FzzIge9yV-s',
    'https://www.youtube.com/watch?v=sfhcZY5d8zY',
    'https://www.youtube.com/watch?v=K4jWvIcL0YU',
    'https://www.youtube.com/watch?v=qzGDoqhgVP0#t=12',
    'https://www.youtube.com/watch?v=AXwGVXD7qEQ',
    'https://www.youtube.com/watch?feature=player_detailpage&v=JyaDTiXH3R4#t=148'
]

module.exports = (robot) ->
  robot.hear /it's|it’s|its working/i, (msg) ->
    msg.send msg.random itsworking