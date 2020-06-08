local urlApi = 'https://jira.zaouter.com/rest/api/2/search?jql=project%20=%20income%20AND%20assignee%20=%20minchao%20AND%20status%20in%20(OPEN,OPENED,ASSIGNED,SUBMITTED,POSTPONED)%20ORDER%20BY%20%22Start%20date%20(WBSGantt)%22%20DESC'
local menubar = hs.menubar.new()
local menuData = {}

local emoji = {
    Open = '🔛',
    Opened = '🔛',
    Assigned = '🔜',
    Submitted = '🔜',
    Postponed = '🔙'
 }

function updateMenubar()
	menubar:setTooltip("Jira Info")
    menubar:setMenu(menuData)
end

function getJira()
   headers = {}
   headers["Authorization"] = "Basic bWluY2hhbzpXb2t1YWk3NCE"
   headers["Content-Type"] = "application/json; charset=utf-8"
   hs.http.doAsyncRequest(urlApi, "GET", nil, headers, function(code, content, htable)
      if code ~= 200 then
         print('get jira error:'..code)
         return
      end
      rawjson = hs.json.decode(content)
      menuData = {}
      for k, v in pairs(rawjson.issues) do
        key = v.key
        -- fixVersions = v.fields.fixVersions[0].name
        -- labels = v.fields.labels[0]
        status = v.fields.status.name
        summary = v.fields.summary
        -- titlestr = string.format("[%s] {%s} (%s) <%s> %s", key, status, lables, fixVersions, summary)
        titlestr = string.format("%s [%s] {%s} %s", emoji[status], key, status, summary)
        item = { title = titlestr }
        table.insert(menuData, item)
      end
      updateMenubar()
   end)
end

menubar:setTitle('❗️')
getJira()
updateMenubar()
hs.timer.doEvery(3600, getJira)