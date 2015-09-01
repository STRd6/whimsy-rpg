S3Uploader = require "s3-uploader"
policyEndpoint = "http://locohost:5000/root.json"
POLICY_KEY = "whimsy-rpg-S3Policy"

module.exports = (I={}) ->
  defaults I,
    base: "http://whimsy.space/whimsy-rpg/"

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

  self = 
    upload: (path, blob) ->
      getS3Credentials().then (policy) ->
        S3Uploader(policy).upload
          key: path
          blob: blob
          cacheControl: 0

    getImage: (path) ->
      # Using getBuffer so we can get progress events and
      # CORS shiz

      self.getBuffer(path)
      .then (buffer) ->
        deferred = Q.defer()

        blob = new Blob([buffer])

        img = new Image
        img.src = window.URL.createObjectURL(blob)

        img.onload = ->
          deferred.resolve img
        img.onerror = deferred.reject

        deferred.promise

    getBuffer: (path) ->
      deferred = Q.defer()
  
      xhr = new XMLHttpRequest()
      xhr.open('GET', "#{I.base}#{path}", true)
      xhr.responseType = 'arraybuffer'
  
      xhr.onload = (e) ->
        if (200 <= this.status < 300) or this.status is 304
          deferred.resolve this.response
        else
          deferred.reject e
      xhr.onprogress = deferred.notify
      xhr.onerror = deferred.reject
      xhr.send()
  
      deferred.promise
