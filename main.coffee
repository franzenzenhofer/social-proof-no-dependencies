#set window._DEBUG_ to true if you want to see debug messages
_DEBUG_ = window._DEBUG_ ? false

d = (m, debug = _DEBUG_) ->
  console.log(m) if debug

isInt = (value) ->
  !isNaN(value) and parseInt(Number(value)) == value and !isNaN(parseInt(value, 10))

getJsonP = (url, callback) ->
  ref = window.document.getElementsByTagName('script')[0]
  script = window.document.createElement('script')
  script.src = url + (if url.indexOf('?') + 1 then '&' else '?') + 'callback=' + callback
  ref.parentNode.insertBefore script, ref
  script.onload = ->
    @remove()
    return

getJsonPAfterEvent = (url, callback, event) ->
  window.addEventListener(event, fun = ((e)->
      getJsonP(url, callback);
      window.removeEventListener(event,fun)
      ), {'once':true})

#all social proof URLs need the URL parameter to get the proof for at the end
#note: alternate pinterest URL "https://api.pinterest.com/v1/urls/count.json?url="
#  "facebook": "https://api.facebook.com/restserver.php?format=json&method=links.getStats&urls="

proof_urls =
  "facebook": "https://graph.facebook.com/?id="

proof_urls_later =
  "pinterest": "https://widgets.pinterest.com/v1/urls/count.json?url="
  "linkedin": "https://www.linkedin.com/countserv/count/share?url="

gone_get_them_all = (data) ->
  d(data)
  r = 0
  if isInt(data)
    r = data
  else if data is null or data is undefined
    r = 0
  else
    r = (data?.total_count ? data?.count ? data?[0]?.total_count ? data?[0]?.count ? data?.share?.share_count ? 0)
  return r

#if no url is given we use the og:url or if not available the window.top.url
window.socialProof = socialProof  = (url = (document.querySelectorAll('meta[property="og:url"]')?[0]?.content ? document.querySelectorAll('link[rel=canonical]')?[0]?.href ? window.top.location.href), placeholder_class) ->
  counter = 0

  #update_factory = () ->
  #  return update(placeholder_class)

  update = (placeholder_class) ->
    if placeholder_class and counter isnt 0
      elements = document.getElementsByClassName(placeholder_class)
      for elem in elements
          elem.innerHTML = counter
    else
      console?.log(counter)

  window.collect_and_update = collect_and_update = (data) ->
    d(data)
    counter = counter + gone_get_them_all(data)
    d('counter:'+counter)
    update(placeholder_class)

  https_url = url.replace(/^http:\/\//i, 'https://');
  http_url = url.replace(/^https:\/\//i, 'http://');

  d('URL:'+url)
  https_url  = encodeURIComponent(https_url)
  http_url  = encodeURIComponent(http_url)
  d('encoded URL:'+url)
  for n, u of proof_urls
    getJsonP("#{u}#{http_url}", 'collect_and_update')
    getJsonP("#{u}#{https_url}", 'collect_and_update')

  for n, u of proof_urls_later
    getJsonPAfterEvent("#{u}#{http_url}", 'collect_and_update', 'scroll')
    getJsonPAfterEvent("#{u}#{https_url}", 'collect_and_update', 'scroll')

#socialProof('http://www.veganblatt.com/', 'counter')
#socialProof(null, 'counter')
