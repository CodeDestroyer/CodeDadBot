# Description:
#   CodeDad Presents - CodeReviews and Deploys
#
# Dependencies:
#   None
#
# Commands:
#   codedad list-reviews - List all Code Reviews in flow.
#   codedad request-review <JIRA-TICKET> <REPO-LINK> <COMMENTS> - Request a review
#   codedad request-review <JIRA-TICKET> <REPO-LINK> - Request a review
#   codedad claim-review <JIRA-TICKET> - Assign a Code Review to yourself
#   codedad complete-review <JIRA-TICKET> <COMMENTS> - Complete a CodeReview
#   codedad complete-review <JIRA-TICKET> - Complete a CodeReview
#   codedad drop-review <JIRA-TICKET> - Unassign a CodeReiew from yourself
#   codedad deploy-add <JIRA-TICKET> - Add a ticket to be deployed
#   codedad deploy-staging <JIRA-TICKET> - Signal Staging Deployment - Code pushers only
#   codedad deploy-production <JIRA-TICKET> - Signal Production Deployment - Code pushers only
#   codedad validate-staging <JIRA-TICKET> - Signal that the ticket was reviewed in staging
#   codedad validate-production <JIRA-TICKET> - Signal that the ticket was reviewed in production
#   codedad block-deploy <JIRA-TICKET> <"COMMENTS">
#   codedad unblock-deploy <JIRA-TICKET>
#   codedad list-deploys - List Deploys for the Day
#
# Author:
#  patrick-cunningham
# needs to be refactored hard  could refactor down to a few methods.
dotenv = require('dotenv')
dotenv.load()
domain = process.env.DOMAIN
review = domain+"/reviews/request"
complete = domain+"/reviews/complete"
claim = domain+"/reviews/claim"
list = domain+"/reviews/list"
Drop = domain+"/reviews/drop"
DeployAdd = domain+"/deploy/request"
Stage = domain+"/deploy/stage"
Deploy = domain+"/deploy/deploy"
ValidStaging = domain+"/deploy/stagingValidate"
ValidProduction = domain+"/deploy/validate"
DeployList = domain+"/deploy/list"
blockDeploy = domain+"/deploy/block"
unblockDeploy = domain+"/deploy/unblock"

#List of reviews that are not completed
module.exports = (codeDad) ->
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

  #Drop a ticket
  codeDad.respond /drop-review (.*)/i, (msg) ->
    user = msg.message.user.name
    jira = msg.match[1].toUpperCase()
    data = {
      'completion_user': user,
      'jira_ticket': jira
    }
    msg.http(Drop).query(data).get() (err, res, body) ->
      msg.send JSON.parse(body)

  codeDad.respond /deploy-staging (.*)/i, (msg) ->
    jira = msg.match[1].toUpperCase()
    data = {
      'jira_ticket': jira
    }
    msg.http(Stage).query(data).get() (err, res, body) ->
      msg.send JSON.parse(body)


  codeDad.respond /validate-staging (.*)/i, (msg) ->
    jira = msg.match[1].toUpperCase()
    data = {
      'jira_ticket': jira,
    }
    msg.http(ValidStaging).query(data).get() (err, res, body) ->
      msg.send JSON.parse(body)

  codeDad.respond /deploy-production (.*)/i, (msg) ->
    jira = msg.match[1].toUpperCase()
    data = {
      'jira_ticket': jira,
    }
    msg.http(Deploy).query(data).get() (err, res, body) ->
      msg.send JSON.parse(body)


  codeDad.respond /validate-production (.*)/i, (msg) ->
    jira = msg.match[1].toUpperCase()
    data = {
      'jira_ticket': jira,
    }
    msg.http(ValidProduction).query(data).get() (err, res, body) ->
      msg.send JSON.parse(body)

  codeDad.respond /deploy-add (.*)/i, (msg) ->
    user = msg.message.user.name
    jira = msg.match[1].toUpperCase()
    data = {
      'user': user,
      'jira_ticket': jira
    }
    msg.http(DeployAdd).query(data).get() (err, res, body) ->
      msg.send JSON.parse(body)

  codeDad.respond /list-deploys/i, (msg) ->
    msg.http(DeployList).get() (err, res, body) ->
      msg.send JSON.parse(body)

  codeDad.respond /block-deploy (.*) ("[^\"]*")/i, (msg) ->
    jira = msg.match[1].toUpperCase()
    comment = msg.match[2].replace(/["']/g, "")
    data = {
      'jira_ticket': jira,
      'block_comment': comment
    }
    msg.http(blockDeploy).query(data).get() (err, res, body) ->
      msg.send JSON.parse(body)

  codeDad.respond /unblock-deploy (.*)/i, (msg) ->
    jira = msg.match[1].toUpperCase()
    data = {
      'jira_ticket': jira
    }
    msg.http(unblockDeploy).query(data).get() (err, res, body) ->
      msg.send JSON.parse(body)