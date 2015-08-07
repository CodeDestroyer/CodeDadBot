# Description:
#   CodeDad Presents - CodeReviews and Deploys
#
# Dependencies:
#   None
#
# Commands:
#   codedad deploy-add <JIRA-TICKET> - Add a ticket to be deployed (da)
#   codedad deploy-staging <JIRA-TICKET> - Signal Staging Deployment - Code pushers only (ds)
#   codedad deploy-production <JIRA-TICKET> - Signal Production Deployment - Code pushers only (dp)
#   codedad validate-staging <JIRA-TICKET> - Signal that the ticket was reviewed in staging (vs)
#   codedad validate-production <JIRA-TICKET> - Signal that the ticket was reviewed in production (vp)
#   codedad block-deploy <JIRA-TICKET> <"COMMENTS"> (bd)
#   codedad unblock-deploy <JIRA-TICKET> (ud)
#   codedad remove-deploy <JIRA-TICKET> (rm -d)
#   codedad list-deploys - List Deploys for the Day (ls -d)

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
  codeDad.respond /(?:deploy-staging|ds) ([a-z]+-[0-9]+)$/i, (msg) ->
    jira = msg.match[1].toUpperCase()
    data = {
      'step': 'isStaged',
      'jira_ticket': jira
    }
    msg.http(toggle).query(data).get() (err, res, body) ->
      msg.send JSON.parse(body)


  codeDad.respond /(?:validate-staging|vs) ([a-z]+-[0-9]+)$/i, (msg) ->
    jira = msg.match[1].toUpperCase()
    data = {
      'step': 'isValidatedStaging',
      'jira_ticket': jira
    }
    msg.http(toggle).query(data).get() (err, res, body) ->
      msg.send JSON.parse(body)

  codeDad.respond /(?:deploy-production|dp) ([a-z]+-[0-9]+)$/i, (msg) ->
    jira = msg.match[1].toUpperCase()
    data = {
      'step': 'isDeployed',
      'jira_ticket': jira,
    }
    msg.http(toggle).query(data).get() (err, res, body) ->
      msg.send JSON.parse(body)


  codeDad.respond /(?:validate-production|vp) ([a-z]+-[0-9]+)$/i, (msg) ->
    jira = msg.match[1].toUpperCase()
    data = {
      'step':'isValidated',
      'jira_ticket': jira
    }
    msg.http(toggle).query(data).get() (err, res, body) ->
      msg.send JSON.parse(body)

  codeDad.respond /(?:deploy-add|da) ([a-z]+-[0-9]+)$/i, (msg) ->
    user = msg.message.user.name
    jira = msg.match[1].toUpperCase()
    data = {
      'user': user,
      'jira_ticket': jira
    }
    msg.http(DeployAdd).query(data).get() (err, res, body) ->
      msg.send JSON.parse(body)

  codeDad.respond /list-deploys|ls -d/i, (msg) ->
    msg.http(DeployList).get() (err, res, body) ->
      msg.send JSON.parse(body)

  codeDad.respond /(?:block-deploy|bd) (.*) ("[^\"]*")/i, (msg) ->
    jira = msg.match[1].toUpperCase()
    comment = msg.match[2].replace(/["']/g, "")
    data = {
      'jira_ticket': jira,
      'block_comment': comment
    }
    msg.http(blockDeploy).query(data).get() (err, res, body) ->
      msg.send JSON.parse(body)

  codeDad.respond /(?:unblock-deploy|ud) ([a-z]+-[0-9]+)$/i, (msg) ->
    jira = msg.match[1].toUpperCase()
    data = {
      'jira_ticket': jira
    }
    msg.http(unblockDeploy).query(data).get() (err, res, body) ->
      msg.send JSON.parse(body)

  codeDad.respond /(?:remove-deploy|rm -d) ([a-z]+-[0-9]+)$/i, (msg) ->
    jira = msg.match[1].toUpperCase()
    data = {
      'jira_ticket': jira
    }
    msg.http(deleteDeploy).query(data).get() (err, res, body) ->
      msg.send JSON.parse(body)