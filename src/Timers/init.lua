--!strict
local makeTimerImpl = require(script.makeTimerImpl)
export type Timeout = makeTimerImpl.Timeout
return makeTimerImpl(delay)
