# Description:
#   CodeDad Presents - CodeReviews and Deploys
#
# Dependencies:
#   None
#
# Commands:
#   codedad review Jira Name - adds a Ticket to the review queue

#
# Author:
#   patrick-cunningham
devreview ="http://homestead.app/reviews/request"
prodreview = "http://ec2-52-0-112-141.compute-1.amazonaws.com/reviews/test"
devcomplete = "http://homestead.app/reviews/complete"
devclaim = "http://homestead.app/reviews/claim"
devlist = "http://homestead.app/reviews/list"
choose = "http://url.com/cards/choose"
show = "http://url.com/cards/show"


module.exports = (codeDad) ->
  codeDad.respond /list-reviews/i, (msg) ->
    user = msg.message.user.name
    data = {
      'user': user,
    }
    codeDad.http(devlist).query(data).get() (err, res, body) ->

  codeDad.respond /claim-review (.*)/i, (msg) ->
    user = msg.message.user.name
    jira = msg.match[1]
    data = {
      'completion_user': user,
      'jira_ticket': jira,
    }
    codeDad.http(devclaim).query(data).get() (err, res, body) ->


  codeDad.respond /complete-review (.*) ("[^\"]*")/i, (msg) ->
    user = msg.message.user.name
    jira = msg.match[1]
    comments = msg.match[2].replace(/["']/g, "")
    data = {
      'completion_time': Date.now(),
      'completion_user': user,
      'jira_ticket': jira,
      'completion_comments': comments
    }
    codeDad.http(devcomplete).query(data).get() (err, res, body) ->

  codeDad.respond /request-review (.*) (.*) ("[^\"]*")/i, (msg) ->
    user = msg.message.user.name
    jira = msg.match[1]
    repo = msg.match[2]
    comments = msg.match[3].replace(/["']/g, "")
    data = {
      'submitted': Date.now(),
      'request_user': user,
      'repo_link': repo,
      'jira_ticket': jira,
      'request_comments': comments
    }
    codeDad.http(devreview).query(data).get() (err, res, body) ->
