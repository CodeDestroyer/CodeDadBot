# Description:
#   CodeDad Presents - CodeReviews and Deploys
#
# Dependencies:
#   None
#
# Commands:
#   codedad list-review - Lists reviews

#
# Author:
#   patrick-cunningham
devreview ="http://homestead.app/reviews/request"
prodreview = "http://ec2-52-0-112-141.compute-1.amazonaws.com/reviews/test"
devcomplete = "http://homestead.app/reviews/complete"
devclaim = "http://homestead.app/reviews/claim"
devlist = "http://homestead.app/reviews/list"
devDrop = "http://homestead.app/reviews/drop"
choose = "http://url.com/cards/choose"
show = "http://url.com/cards/show"

#List of reviews that are not completed
module.exports = (codeDad) ->
  codeDad.respond /list-reviews/i, (msg) ->
    msg.http(devlist)
    .get() (err, res, body) ->
      msg.send JSON.parse(body)

  #Claim a Review
  codeDad.respond /claim-review (.*)/i, (msg) ->
    user = msg.message.user.name
    jira = msg.match[1]
    data = {
      'completion_user': user,
      'jira_ticket': jira,
    }
    msg.http(devclaim).query(data).get() (err, res, body) ->
      msg.send JSON.parse(body)


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
    msg.http(devcomplete).query(data).get() (err, res, body) ->
      msg.send body

  codeDad.respond /complete-review (.*)/i, (msg) ->
    user = msg.message.user.name
    jira = msg.match[1]
    comments = "no comments:("
    data = {
      'completion_time': Date.now(),
      'completion_user': user,
      'jira_ticket': jira,
      'completion_comments': comments
    }
    msg.http(devcomplete).query(data).get() (err, res, body) ->
      msg.send JSON.parse(body)

#Request Code Review with comments
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
    msg.http(devreview).query(data).get() (err, res, body) ->
      msg.send JSON.parse(body)

  #Request Code Review with no comments
  codeDad.respond /request-review (.*) (.*)/i, (msg) ->
    user = msg.message.user.name
    jira = msg.match[1]
    repo = msg.match[2]
    comments = "No comment :("
    data = {
      'submitted': Date.now(),
      'request_user': user,
      'repo_link': repo,
      'jira_ticket': jira,
      'request_comments': comments
    }
    msg.http(devreview).query(data).get() (err, res, body) ->
      msg.send JSON.parse(body)

  #Drop a ticket
  codeDad.respond /drop-review (.*)/i, (msg) ->
    user = msg.message.user.name
    jira = msg.match[1]
    data = {
      'completion_user': user,
      'jira_ticket': jira
    }
    msg.http(devDrop).query(data).get() (err, res, body) ->
      msg.send JSON.parse(body)
