# Description:
#   CodeDad Presents - CodeReviews and Deploys
#
# Dependencies:
#   None
#
# Commands:
#   codedad drop-review <JIRA-TICKET> - Unassign a CodeReiew from yourself
#   codedad deploy-add <JIRA-TICKET> - Add a ticket to be deployed
#   codedad deploy-staging <JIRA-TICKET> - Signal Staging Deployment - Code pushers only
#   codedad deploy-production <JIRA-TICKET> - Signal Production Deployment - Code pushers only
#   codedad validate-staging <JIRA-TICKET> - Signal that the ticket was reviewed in staging
#   codedad validate-production <JIRA-TICKET> - Signal that the ticket was reviewed in production
#   codedad block-deploy <JIRA-TICKET> <"COMMENTS">
#   codedad unblock-deploy <JIRA-TICKET>
#   codedad remove-deploy <JIRA-TICKET>
#   codedad list-deploys - List Deploys for the Day

#
# Author:
#  patrick-cunningham
# needs to be refactored hard  could refactor down to a few methods.
dotenv = require('dotenv')
dotenv.load()
domain = process.env.DOMAIN

DeployAdd = domain+"/deploy/request"
toggle = domain+"/deploy/toggleStep"
Deploy = domain+"/deploy/deploy"
ValidStaging = domain+"/deploy/stagingValidate"
ValidProduction = domain+"/deploy/validate"
DeployList = domain+"/deploy/list"
blockDeploy = domain+"/deploy/block"
unblockDeploy = domain+"/deploy/unblock"
deleteDeploy = domain+ "/deploy/delete"
#List of reviews that are not completed
module.exports = (codeDad) ->
  codeDad.respond /deploy-staging (.*)/i, (msg) ->
    jira = msg.match[1].toUpperCase()
    data = {
      'step': 'isStaged',
      'jira_ticket': jira
    }
    msg.http(toggle).query(data).get() (err, res, body) ->
      msg.send JSON.parse(body)


  codeDad.respond /validate-staging (.*)/i, (msg) ->
    jira = msg.match[1].toUpperCase()
    data = {
      'step': 'isValidatedStaging',
      'jira_ticket': jira
    }
    msg.http(toggle).query(data).get() (err, res, body) ->
      msg.send JSON.parse(body)

  codeDad.respond /deploy-production (.*)/i, (msg) ->
    jira = msg.match[1].toUpperCase()
    data = {
      'step': 'isDeployed',
      'jira_ticket': jira,
    }
    msg.http(toggle).query(data).get() (err, res, body) ->
      msg.send JSON.parse(body)


  codeDad.respond /validate-production (.*)/i, (msg) ->
    jira = msg.match[1].toUpperCase()
    data = {
      'step':'isValidated',
      'jira_ticket': jira
    }
    msg.http(toggle).query(data).get() (err, res, body) ->
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

  codeDad.respond /remove-deployment (.*)/i, (msg) ->
    jira = msg.match[1].toUpperCase()
    data = {
      'jira_ticket': jira
    }
    msg.http(deleteDeploy).query(data).get() (err, res, body) ->
      msg.send JSON.parse(body)