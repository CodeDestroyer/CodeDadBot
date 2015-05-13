# Description:
#   CodeDad Presents - CodeReviews and Deploys
#
# Dependencies:
#   None
#
# Commands:
#   codedad list-reviews - List all Code Reviews in flow.
#   codedad request-review <JIRA-TICKET> <REPO-LINK> - Request a review
#   codedad claim-review <JIRA-TICKET> - Assign a Code Review to yourself
#   codedad complete-review <JIRA-TICKET> <COMMENTS> - Complete a code review
#   codedad complete-review <JIRA-TICKET> - Complete a code review
#   codedad verbose-list-reviews - List reviews with links
#   codedad review-details <JIRA-TICKET> - Get the details of a specific ticket.
#   codedad drop-review <JIRA-Ticket> - drop an assigned code review
#   codedad remove-review <JIRA-Ticket> - delete a code review
#   codedad reopen-review <JIRA-TICKET> - reopens an existing review (sets the review back to request stage, unclaimed)
#
# Author:
#  patrick-cunningham
# needs to be refactored hard  could refactor down to a few methods.

dotenv = require('dotenv')
dotenv.load()
domain = process.env.DOMAIN
review = domain + "/reviews/request"
complete = domain + "/reviews/complete"
claim = domain + "/reviews/claim"
list = domain + "/reviews/list"
drop = domain + "/reviews/dropResponsibility"
details = domain + "/reviews/details"
remove = domain + "/reviews/dropTicket"
reopen = domain + "/reviews/reopen"

module.exports = (codeDad) ->
  codeDad.respond /verbose-list-reviews/i, (msg) ->
    data = {
      'verbose': true
    }
    msg.http(list).query(data)
    .get() (err, res, body) ->
      msg.send JSON.parse(body)

  codeDad.respond /list-reviews/i, (msg) ->
    data = {
      'verbose': false
    }
    msg.http(list).query(data)
    .get() (err, res, body) ->
      msg.send JSON.parse(body)

  #Claim a Review
  codeDad.respond /claim-review (.*)/i, (msg) ->
    user = msg.message.user.name
    jira = msg.match[1].toUpperCase()
    data = {
      'completion_user': user,
      'jira_ticket': jira,
    }
    msg.http(claim).query(data).get() (err, res, body) ->
      msg.send JSON.parse(body)

  codeDad.respond /complete-review (.*)/i, (msg) ->
    user = msg.message.user.name
    jira = msg.match[1].toUpperCase()
    comments = "no comments:("
    data = {
      'completion_time': Date.now(),
      'completion_user': user,
      'jira_ticket': jira
    }
    msg.http(complete).query(data).get() (err, res, body) ->
      msg.send JSON.parse(body)

  codeDad.respond /request-review (.*) (.*)/i, (msg) ->
    user = msg.message.user.name
    jira = msg.match[1].toUpperCase()
    repo = msg.match[2]
    data = {
      'submitted': Date.now(),
      'request_user': user,
      'repo_link': repo,
      'jira_ticket': jira
    }
    msg.http(review).query(data).get() (err, res, body) ->
      msg.send JSON.parse(body)


  codeDad.respond /drop-review (.*)/i, (msg) ->
    user = msg.message.user.name
    jira = msg.match[1].toUpperCase()
    data = {
      'completion_user': user,
      'jira_ticket': jira
    }
    msg.http(drop).query(data).get() (err, res, body) ->
      msg.send JSON.parse(body)

  codeDad.respond /review-details (.*)/i, (msg) ->
    jira = msg.match[1].toUpperCase()
    data = {
      'jira_ticket': jira
    }
    msg.http(details).query(data).get() (err, res, body) ->
      msg.send JSON.parse(body)

  codeDad.respond /remove-review (.*)/i, (msg) ->
    jira = msg.match[1].toUpperCase()
    data = {
      'jira_ticket': jira
    }
    msg.http(remove).query(data).get() (err, res, body) ->
      msg.send JSON.parse(body)

  codeDad.respond /reopen-review (.*)/i, (msg) ->
    user = msg.message.user.name
    jira = msg.match[1].toUpperCase()
    data = {
      'submitted': Date.now(),
      'request_user': user,
      'jira_ticket': jira
    }
    msg.http(reopen).query(data).get() (err, res, body) ->
      msg.send JSON.parse(body)
