S3Uploader = require "s3-uploader"
policyEndpoint = "http://locohost:5000/root.json"
POLICY_KEY = "whimsy-rpg-S3Policy"

module.exports = ->

  fetchPolicy = ->
    console.log "Fetching policy from #{policyEndpoint}"
    Q($.getJSON(policyEndpoint))

  getS3Credentials = ->
    Q.fcall ->
      try
        policy = JSON.parse localStorage[POLICY_KEY]

      if policy
        expiration = JSON.parse(atob(policy.policy)).expiration

        if (Date.parse(expiration) - new Date) <= 30
          console.log "Policy expired"
          fetchPolicy()
        else
          return policy
      else
        fetchPolicy()
    .then (policy) ->
      console.log "Policy loaded"
      localStorage[POLICY_KEY] = JSON.stringify(policy)

      return policy
    .fail (e) ->
      throw e

  upload: (path, blob) ->
    getS3Credentials().then (policy) ->
      S3Uploader(policy).upload
        key: path
        blob: blob
        cacheControl: 0
