# Description:
#   CodeDad Presents - CodeReviews and Deploys
#
# Dependencies:
#   None
#
# Commands:
#   Codedad review Jira Name - adds a Ticket to the review queue

#
# Author:
#   michael-hopkins
review = "http://ec2-52-0-112-141.compute-1.amazonaws.com/reviews/test"
quit = "http://url.com/cards/quit"
choose = "http://url.com/cards/choose"
show = "http://url.com/cards/show"

module.exports = (codeDad) ->

  codeDad.respond /review (.*)/i, (msg) ->
    user = msg.message.user.name
    message = msg.message.text
    room = msg.message.user.room
    cardId = msg.match[1]
    data = {'user_name': user,'message': message,'room': room,'directive': 1,'ticket': cardId}
    codeDad.http(review).query(data).get() (err, res, body) ->