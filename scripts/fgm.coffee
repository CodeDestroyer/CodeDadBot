# Description:
#   Feels good man
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   'feels good man' or 'fgm' - prepare for feels
#
# Author:
#   Dan Stark

thefeels = [
    'http://i.imgur.com/lebVlGT.jpg',
    'http://i.imgur.com/PoiBvXy.jpg',
    'http://i.imgur.com/uAqbECp.jpg',
    'http://i.imgur.com/szShWNi.jpg',
    'http://i.imgur.com/rT0GyH5.jpg',
    'http://i.imgur.com/yEN9M9m.gif',
    'http://i.imgur.com/Dg5yueF.jpg',
    'http://i.imgur.com/RaxsmS9.jpg',
    'http://i.imgur.com/MFkKkBz.jpg',
    'http://i.imgur.com/zInqJn9.jpg',
    'http://i.imgur.com/RaW1qup.jpg'
]

module.exports = (robot) ->
  robot.hear /feels good man|fgm/i, (msg) ->
    msg.send msg.random thefeels