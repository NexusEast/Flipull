local SQLMethods = {}
local sqlite3 = require("lsqlite3")

--获取符合条件的行,返回值是一个(包含N个符合条件的行)表
--2:符合‘cond’条件的

SQLMethods.DEAFAULT_DATABASE = "dbmain.sqlite"

function SQLMethods.getValues(params)
    local db, tbl, key, cond = params.db, params.tbl, params.key or "*", params.cond
    local tblRet= {}

    local dbTarget, errorNumber, errorCode = sqlite3.open(db)
    if errorNumber then
        echoInfo("db=%s,dbTarget=%s,errorNumber=%s,errorCode=%s",tostring(db), tostring(dbTarget), tostring(errorNumber), tostring(errorCode))
    end
    if dbTarget then
        local cmd = "SELECT "..key.." FROM " .. tbl
        if cond then
            cmd = cmd.." where "..cond
        end
        echoInfo("SQLMethods.getValue cmd='%s'", tostring(cmd))

        for row in dbTarget:nrows(cmd) do
            table.insert(tblRet, row)
        end
       -- dump(tblRet)
        dbTarget:close()
        return tblRet
    end
    return tblRet
end

function SQLMethods.getKeyValues(params)
    local db, tbl, key, cond , tableKey = params.db, params.tbl, params.key or "*", params.cond , params.tableKey
    local tblRet= {}

    local dbTarget, errorNumber, errorCode = sqlite3.open(db)
    if errorNumber then
        echoInfo("db=%s,dbTarget=%s,errorNumber=%s,errorCode=%s",tostring(db), tostring(dbTarget), tostring(errorNumber), tostring(errorCode))
    end
    if dbTarget then
        local cmd = "SELECT "..key.." FROM " .. tbl
        if cond then
            cmd = cmd.." where "..cond
        end
        echoInfo("SQLMethods.getValue cmd='%s'", tostring(cmd))

        for row in dbTarget:nrows(cmd) do
            -- table.insert(tblRet, row)
            if row[tableKey] then
                tblRet[row[tableKey]] = row
            end
        end
       -- dump(tblRet)
        dbTarget:close()
        return tblRet
    end
    return tblRet
end

--执行相应命令cmd
function SQLMethods.execute(params)
    local db, cmd = params.db,params.cmd
    local nRet = -10000

    local dbTarget, errorNumber, errorCode = sqlite3.open(db)
    if errorNumber then
        echoInfo("db=%s,dbTarget=%s,errorNumber=%s,errorCode=%s",tostring(db), tostring(dbTarget), tostring(errorNumber), tostring(errorCode))
    end
    if dbTarget then
        echoInfo("SQLMethods.execute cmd='%s'", tostring(cmd))
--        for row in dbTarget:nrows(cmd) do
--            table.insert(tblRet, row)
--        end
        nRet = dbTarget:execute(cmd)
        echoInfo("nRet=%s",tostring(nRet))
        dbTarget:close()
        return nRet
    end
    echoInfo("nRet=%s SQLMethods.execute open error",tostring(nRet))
    return nRet
end


--add by wrl
function SQLMethods.getTableFromSQL(params)
    local db, cmd = params.db,params.cmd
    local tblRet= {}

    local dbTarget, errorNumber, errorCode = sqlite3.open(db)
    if errorNumber then
        echoInfo("db=%s,dbTarget=%s,errorNumber=%s,errorCode=%s",tostring(db), tostring(dbTarget), tostring(errorNumber), tostring(errorCode))
    end
    if dbTarget then

        echoInfo("SQLMethods.getTableFromSQL params.cmd='%s'", tostring(params.cmd))

        for row in dbTarget:nrows(cmd) do
            table.insert(tblRet, row)
        end
        dbTarget:close()
        return tblRet
    end
    return tblRet
end


return SQLMethods